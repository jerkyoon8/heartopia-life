#!/bin/bash
# =========================================================
# healthwatch.sh - Heartopia 런타임 헬스체크 & 자동 복구
# crontab: */5 * * * * /bin/bash ~/heartopia-life/deploy/healthwatch.sh
# =========================================================

COMPOSE_FILE=~/heartopia-life/deploy/docker-compose.yml
NGINX_CONF=~/heartopia-life/deploy/nginx/nginx.conf
LOG_FILE=~/heartopia-life/deploy/logs/healthwatch.log
CHECK_URL="http://localhost/"
MAX_LOG_LINES=500
DISCORD_WEBHOOK="https://discord.com/api/webhooks/1495793414577328149/N-E15acRD0QVwMYQRXwyyQecf_lmCo1KZHNsh5U9ulGsIbdkwuam39Y8VLhkFt9RbCUB"

# ── 로그 디렉토리 생성 ──────────────────────────────────
mkdir -p ~/heartopia-life/deploy/logs

# ── 로그 파일 크기 제한 (너무 커지지 않게) ───────────────
if [ -f "$LOG_FILE" ]; then
    LINE_COUNT=$(wc -l < "$LOG_FILE")
    if [ "$LINE_COUNT" -gt "$MAX_LOG_LINES" ]; then
        tail -n $MAX_LOG_LINES "$LOG_FILE" > "${LOG_FILE}.tmp"
        mv "${LOG_FILE}.tmp" "$LOG_FILE"
    fi
fi

timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

discord_alert() {
    curl -s -X POST "$DISCORD_WEBHOOK" \
        -H "Content-Type: application/json" \
        -d "{\"content\": \"$1\"}" > /dev/null 2>&1
}

# ── 현재 활성 컨테이너 판별 ──────────────────────────────
if docker ps --format '{{.Names}}' | grep -q 'app-blue'; then
    ACTIVE=blue
elif docker ps --format '{{.Names}}' | grep -q 'app-green'; then
    ACTIVE=green
else
    # nginx.conf에서 현재 가리키는 컨테이너를 읽어 복구 대상 결정
    if grep -q 'app-green' "$NGINX_CONF"; then
        RESTART_TARGET=green
    else
        RESTART_TARGET=blue
    fi
    echo "[$(timestamp)] [CRITICAL] app-blue, app-green 모두 실행 중이 아님! app-$RESTART_TARGET 재시작 시도..." >> "$LOG_FILE"
    discord_alert "🚨 [Heartopia] 앱 컨테이너 전체 다운! app-$RESTART_TARGET 재시작 시도 중..."
    docker compose -f "$COMPOSE_FILE" up -d app-$RESTART_TARGET
    echo "[$(timestamp)] [RECOVERY] app-$RESTART_TARGET 강제 기동 완료" >> "$LOG_FILE"
    exit 0
fi

# ── HTTP 상태코드 체크 ────────────────────────────────────
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$CHECK_URL")

if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "302" ] || [ "$HTTP_CODE" == "301" ]; then
    exit 0
fi

# ── 비정상 감지 → 자동 복구 ──────────────────────────────
echo "[$(timestamp)] [WARNING] HTTP $HTTP_CODE 감지 (활성: app-$ACTIVE). 자동 복구 시작..." >> "$LOG_FILE"

# 컨테이너 상태 스냅샷 기록
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" >> "$LOG_FILE" 2>&1

# 앱 컨테이너 재시작
docker compose -f "$COMPOSE_FILE" restart app-$ACTIVE

# ── Spring Boot 기동 대기 (10초 간격 × 6회 = 최대 60초) ──
RECOVERED=false
for i in 1 2 3 4 5 6; do
    sleep 10
    HTTP_CODE_AFTER=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 "$CHECK_URL")
    if [ "$HTTP_CODE_AFTER" == "200" ] || [ "$HTTP_CODE_AFTER" == "302" ] || [ "$HTTP_CODE_AFTER" == "301" ]; then
        RECOVERED=true
        break
    fi
    echo "[$(timestamp)] [INFO] 복구 대기 중... ($i/6, HTTP $HTTP_CODE_AFTER)" >> "$LOG_FILE"
done

# ── 복구 결과 처리 ────────────────────────────────────────
if [ "$RECOVERED" == "true" ]; then
    echo "[$(timestamp)] [RECOVERED] 자동 복구 성공! (HTTP $HTTP_CODE_AFTER)" >> "$LOG_FILE"
else
    echo "[$(timestamp)] [CRITICAL] 자동 복구 실패! (HTTP $HTTP_CODE_AFTER) - Nginx 재시작 시도..." >> "$LOG_FILE"
    docker compose -f "$COMPOSE_FILE" restart nginx
    echo "[$(timestamp)] [INFO] Nginx 재시작 완료" >> "$LOG_FILE"
    discord_alert "🚨 [Heartopia] 서버 자동 복구 실패! (HTTP $HTTP_CODE_AFTER) 수동 확인이 필요합니다."
fi
