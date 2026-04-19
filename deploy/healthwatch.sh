#!/bin/bash
# =========================================================
# healthwatch.sh - Heartopia 런타임 헬스체크 & 자동 복구
# crontab: */5 * * * * /bin/bash ~/heartopia-life/deploy/healthwatch.sh
# =========================================================

COMPOSE_FILE=~/heartopia-life/deploy/docker-compose.yml
LOG_FILE=~/heartopia-life/deploy/logs/healthwatch.log
CHECK_URL="http://localhost/"
MAX_LOG_LINES=500

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

# ── 현재 활성 컨테이너 판별 ──────────────────────────────
if docker ps --format '{{.Names}}' | grep -q 'app-blue'; then
    ACTIVE=blue
elif docker ps --format '{{.Names}}' | grep -q 'app-green'; then
    ACTIVE=green
else
    echo "[$(timestamp)] [CRITICAL] app-blue, app-green 모두 실행 중이 아님! 재시작 시도..." >> "$LOG_FILE"
    # 마지막으로 실행된 컨테이너(blue/green) 재시작 시도
    docker compose -f "$COMPOSE_FILE" up -d app-blue
    echo "[$(timestamp)] [RECOVERY] app-blue 강제 기동 완료" >> "$LOG_FILE"
    exit 0
fi

# ── HTTP 상태코드 체크 ────────────────────────────────────
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$CHECK_URL")

if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "302" ] || [ "$HTTP_CODE" == "301" ]; then
    # 정상 - 로그 기록 안 함 (로그 파일 쓸데없이 커지는 것 방지)
    exit 0
fi

# ── 비정상 감지 → 자동 복구 ──────────────────────────────
echo "[$(timestamp)] [WARNING] HTTP $HTTP_CODE 감지 (활성: app-$ACTIVE). 자동 복구 시작..." >> "$LOG_FILE"

# 컨테이너 상태 스냅샷 기록
echo "[$(timestamp)] [INFO] docker ps 스냅샷:" >> "$LOG_FILE"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" >> "$LOG_FILE" 2>&1

# 앱 컨테이너 재시작
docker compose -f "$COMPOSE_FILE" restart app-$ACTIVE
sleep 15

# ── 재시작 후 재확인 ──────────────────────────────────────
HTTP_CODE_AFTER=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 "$CHECK_URL")

if [ "$HTTP_CODE_AFTER" == "200" ] || [ "$HTTP_CODE_AFTER" == "302" ] || [ "$HTTP_CODE_AFTER" == "301" ]; then
    echo "[$(timestamp)] [RECOVERED] 자동 복구 성공! (HTTP $HTTP_CODE_AFTER)" >> "$LOG_FILE"
else
    echo "[$(timestamp)] [CRITICAL] 자동 복구 실패! (HTTP $HTTP_CODE_AFTER) - 수동 확인 필요" >> "$LOG_FILE"
    # nginx도 재시작 시도
    docker compose -f "$COMPOSE_FILE" restart nginx
    echo "[$(timestamp)] [INFO] Nginx 재시작 완료" >> "$LOG_FILE"
fi
