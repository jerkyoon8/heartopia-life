# 하토피아 위키 (Heartopia Wiki)

**평일 DAU 630 / 주말 DAU 1,100+ | 오픈 4일째 GA4 기준 | 1인 개발 · 운영**

Heartopia 게임 종합 도감 웹서비스 — 주민, 컬렉션, 인터랙티브 지도, 기프트코드

🌐 [heartopia-life.me](https://heartopia-life.me)

---

## 운영 현황

오픈 직후 실측 DAU (GA4 기준):

| 날짜 | 요일 | DAU |
|------|------|-----|
| 2026-04-19 | 일 | **1,100** |
| 2026-04-20 | 월 | 630 |
| 2026-04-21 | 화 | 680 |

1인 개발 · 운영 중. 외부 유입으로 자연 성장.

---

## 아키텍처

```
[사용자]
   ↓
[Cloudflare CDN · DDoS 방어]
   ↓
[Ubuntu Server]
  ├── Nginx  (리버스 프록시 · Rate Limiting · SSL · 악성 경로 차단)
  │     ↓ Blue-Green 포트 전환
  ├── Docker: app-blue (8080)  ←→  app-green (8080)
  └── Docker: MySQL 8
```

**CI/CD 파이프라인**: `git push origin main` → GitHub Actions (Self-Hosted Runner) → `deploy.sh` 자동 실행 → 무중단 전환

---

## 실운영 트러블슈팅

### 1. Blue-Green 무중단 배포 — Docker Inode 캐싱 버그 해결

**배경**: `sed -i`로 `nginx.conf`를 수정하면 Linux가 파일의 Inode를 새로 발급합니다.
Docker 바인드 마운트는 Inode 기준으로 파일을 추적하기 때문에 변경된 내용을 인식하지 못하는 버그가 있습니다. Nginx 설정을 바꿔도 재시작 후 이전 설정이 그대로 적용되는 문제.

**해결**: `/tmp`에 복사 후 `cp`로 원본 덮어씌기. Inode는 유지되면서 내용만 교체.

```bash
# deploy.sh 핵심 로직
cp nginx.conf /tmp/nginx.conf.tmp
sed -i "s/app-blue/app-green/g" /tmp/nginx.conf.tmp
cp /tmp/nginx.conf.tmp nginx.conf   # Inode 유지 → Docker가 변경 감지
docker compose restart nginx
```

헬스체크: 신규 컨테이너가 Spring Boot를 완전히 로딩하기 전에 트래픽을 넘기면 502가 발생합니다. `curl`로 2초 간격 최대 30회(60초) 폴링하여 HTTP 200 확인 후 전환.

### 2. SQL Injection 공격 탐지 및 차단 (2026-04-19)

DAU 1,100을 기록한 당일, 단일 외부 IP에서 **9,996건의 요청**이 단시간에 집중됐습니다.
Nginx 로그를 IP별로 집계해 공격을 탐지하고 직접 대응했습니다.

```bash
# 탐지 명령
docker logs deploy-nginx-1 2>&1 | awk '{print $1}' | sort | uniq -c | sort -rn | head -20
```

**공격 패턴** — HTTP Referer 헤더에 SQL 페이로드 삽입:
```
"if(now()=sysdate(),sleep(15),0)"       ← Time-based Blind SQLi
"SELECT 463 FROM PG_SLEEP(15))--"       ← Time-based Blind SQLi
"-1 OR 2+878-878-1=0+0+0+1 --"         ← Boolean-based SQLi
```

**장애 메커니즘**: 대량 요청 → Tomcat 스레드 풀(200개) 고갈 → 큐 적체 → 502 Bad Gateway

추가로 ThinkPHP RCE 익스플로잇, `.git/config` 탈취 시도 등 다수의 봇 스캔도 앱 로그에서 확인했습니다.
Docker 볼륨 마운트 덕분에 컨테이너 재시작 후에도 로그가 보존되어 사고 분석이 가능했습니다.

**대응 조치**:
```nginx
# nginx.conf
limit_req_zone $binary_remote_addr zone=req_limit:10m rate=20r/s;

server {
    server_tokens off;                          # Nginx 버전 정보 숨김

    limit_req zone=req_limit burst=30 nodelay;  # 초당 20개 제한, burst 30
    limit_req_status 429;

    location ~* "\.php$" { return 444; }        # PHP 스캔 차단 (Java 서버)
    location ~* "/\.git"  { return 444; }       # Git 설정 탈취 차단

    proxy_connect_timeout 10s;
    proxy_read_timeout    60s;
}
```

> `444`: Nginx 전용 응답 코드. 응답 본문 없이 연결을 즉시 끊어 공격 도구에 아무 정보도 제공하지 않음.

### 3. Nginx restart vs reload — 504/502 이슈

**문제**: 배포 중 `docker compose restart nginx` 사용 시, Cloudflare와 맺어진 keepalive 연결을
구 worker가 끊기 전에 트래픽을 받아 502를 리턴하는 현상.

**해결**: `nginx -s reload` + 30초 drain 대기. reload는 신규 요청은 새 worker가 받고,
기존 연결은 구 worker가 정상 처리 후 종료.

> 관련 커밋: `a3ff7fa`, `9110802`

### 4. healthwatch.sh — 5분 주기 무인 자동 복구

장애 초기에는 3번 모두 수동 복구. 자동화 이후 야간 장애도 5분 이내 무인 복구.

```bash
# crontab: */5 * * * * /bin/bash ~/heartopia-life/deploy/healthwatch.sh

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://heartopia-life.me)
if [[ "$HTTP_STATUS" != "200" && "$HTTP_STATUS" != "301" && "$HTTP_STATUS" != "302" ]]; then
    docker compose restart app-$ACTIVE
    # 재확인 후 실패 시 nginx도 재시작
fi
# 모든 이벤트를 deploy/logs/healthwatch.log에 기록
```

### 5. MapController 병목 제거 — 1051ms → 205ms (81% 개선)

코드에 미리 심어둔 AOP 성능 모니터링(`PerformanceLoggingAspect`)이 경고를 포착했습니다.

```
[SLOW] MapController.getPins 실행 시간: 1051ms (임계값 1000ms 초과!)
```

**원인**: 지도 핀 약 430개를 조회할 때, 각 핀마다 도감 전체 리스트를 선형 탐색 (`Stream.filter`)하는 O(N × M) 구조.
430개 핀 × 도감 100개 = **43,000번 반복 스캔**.

```java
// Before: O(N × M) — 매 핀마다 전체 리스트 재스캔
pins.forEach(pin ->
    collectionService.getAllFish().stream()
        .filter(f -> f.getName().equals(pin.getName()))
        ...
);

// After: O(N + M) — 1번만 로드 후 HashMap 즉시 색인
Map<String, FishCollection> fishMap = collectionService.getAllFish().stream()
    .collect(Collectors.toMap(FishCollection::getName, f -> f));

pins.forEach(pin -> {
    if (fishMap.containsKey(pin.getName())) {
        FishCollection f = fishMap.get(pin.getName());  // O(1)
        ...
    }
});
```

Redis 같은 외부 캐시 없이 순수 Java 자료구조 최적화만으로 해결.

### 6. Blue-Green Health Check — 302 오진 롤백 버그

배포 스크립트가 신규 컨테이너 정상 기동 후에도 "비정상"으로 판정하여 자동 롤백하는 현상.

**원인**: Spring Security가 Root(`/`) 요청을 `/wiki`로 302 리다이렉트하는데, Health Check가 `200`만 정상으로 인식.

**해결**: 조건문에 `302`를 정상 상태로 편입.

```bash
if [[ "$HTTP_CODE" == "200" || "$HTTP_CODE" == "302" ]]; then
    # healthy — 트래픽 전환 진행
fi
```

---

## 코드 설계 포인트

### Application-level Aggregation (DB 부하 분산)

인터랙티브 지도 마커와 도감 데이터를 DB JOIN 대신 Java Stream API로 Application 레이어에서 병합.
서로 다른 테이블 간 무거운 JOIN을 피하고 DB 부하를 분산.

```java
markers.forEach(marker ->
    items.stream()
        .filter(item -> item.getId().equals(marker.getItemId()))
        .findFirst()
        .ifPresent(marker::setItemDetail)
);
```

### AOP 전역 예외 처리 + 성능 모니터링

`@ControllerAdvice`로 중앙 집중 예외 처리. `Accept` 헤더 분석으로 비동기 요청(JSON 응답)과
페이지 요청(error.html 리다이렉트)을 분기. `NoResourceFoundException`(이미지 404)은 로그 레벨을
낮춰 모니터링 노이즈 제거.

별도로 `PerformanceLoggingAspect`를 구성해 임계값(1000ms) 초과 시 `[SLOW]` 경고를 남겨
사전에 병목을 탐지. MapController 1051ms 이슈가 이 모니터링으로 발견됐습니다.

### CSRF 토큰 — Fetch API 연동

Spring Security CSRF 활성화 상태에서 ES6 Fetch API로 POST 요청 시
HTML `<meta>` 태그의 `_csrf` 토큰을 읽어 HTTP Header에 직접 주입.

### JVM + HikariCP 튜닝

```
-Xms256m -Xmx1g -XX:+ExitOnOutOfMemoryError
```

OOM 발생 시 즉시 종료 → Docker restart 정책으로 빠른 재기동. HikariCP 커넥션 풀 20 고정.
Gzip 압축으로 네트워크 전송량 **70% 절감** (텍스트 중심 도감 데이터 특성상 압축 효율 높음).
정적 리소스에 1년 브라우저 캐시 + Content Hash 전략 적용 — 파일 변경 시 즉시 새 캐시 발급.

---

## 기술 스택

| 영역 | 기술 |
|------|------|
| Backend | Spring Boot 3.4.2, Java 17 |
| ORM | MyBatis |
| DB | MySQL 8.0 |
| Frontend | Thymeleaf, Vanilla JS, Vue.js (부분) |
| 인프라 | Docker Compose, Nginx, Cloudflare |
| CI/CD | GitHub Actions Self-Hosted Runner |
| 인증 | Spring Security Form Login (Admin) + Google OAuth 2.0 |
| 모니터링 | GA4, healthwatch.sh (cron), Docker 볼륨 로그 보존 |

---

## 주요 기능

- **주민 도감** — 전체 주민 정보, 선물 취향, 역할
- **컬렉션 도감** — 물고기, 곤충, 새, 채집물, 동물
- **아이템** — 요리, 작물, 꽃
- **기프트코드** — 쿠폰 목록 + 관리자 등록/관리
- **인터랙티브 지도** — 핀 기반 커스텀 마커, 비동기 CRUD
- **관리자 페이지** — Spring Security 기반 어드민 전용 데이터 관리

---

## 로컬 실행

```bash
# 1. MySQL 데이터베이스 생성
mysql -u root -p -e "CREATE DATABASE heartopia_db;"

# 2. 환경변수 파일 생성
# heartopia-wiki/src/main/resources/application-secret.properties
echo "DB_PASSWORD=비밀번호" > heartopia-wiki/src/main/resources/application-secret.properties

# 3. 실행
cd heartopia-wiki
./gradlew bootRun
```

---

*1인 개발 · 운영. 제3자 게임 팬사이트로 공식 Heartopia와 무관합니다.*
