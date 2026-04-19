#!/bin/bash

# 0. Nginx 및 DB 상태 보장 (최초 실행 시 꺼져있는 것 방지)
echo "Ensuring foundation services (db, nginx) are running..."
docker compose -f ~/heartopia-life/deploy/docker-compose.yml up -d db nginx

# 1. 현재 구동 중인 앱 판별
if docker ps | grep -q 'app-blue'; then
    CURRENT=blue
    TARGET=green
else
    CURRENT=green
    TARGET=blue
fi

echo "Current active container is app-$CURRENT."
echo "Targeting deployment to app-$TARGET..."

# 2. 타겟 컨테이너 단독 빌드 및 기동
docker compose -f ~/heartopia-life/deploy/docker-compose.yml up -d --build app-$TARGET

# 3. Health Check
echo "Waiting for app-$TARGET to be healthy..."
for i in {1..30}; do
    # Nginx 컨테이너 내부에서 타겟을 찔러보는 방식이 가장 확실 (로컬 포트 포워딩 불필요)
    HTTP_CODE=$(docker compose -f ~/heartopia-life/deploy/docker-compose.yml exec -T nginx curl -s -o /dev/null -w "%{http_code}" http://app-$TARGET:8080/)
    
    if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "302" ]; then
        echo "Health check passed for app-$TARGET!"
        break
    fi
    
    echo "Attempt $i/30: HTTP Status $HTTP_CODE. Waiting 2s..."
    sleep 2
done

# 만약 30번(약 60초) 넘게 응답이 없다면 배포를 중단(Rollback)
if [ "$HTTP_CODE" != "200" ] && [ "$HTTP_CODE" != "302" ]; then
    echo "Health check failed after 60 seconds."
    echo "Rolling back (stopping app-$TARGET)..."
    docker compose -f ~/heartopia-life/deploy/docker-compose.yml stop app-$TARGET
    exit 1
fi

# 4. Nginx 스위칭
echo "Switching Nginx routing to app-$TARGET..."
NGINX_CONF=~/heartopia-life/deploy/nginx/nginx.conf
sed -E "s/proxy_pass http:\/\/app(-blue|-green|):8080/proxy_pass http:\/\/app-$TARGET:8080/g" "$NGINX_CONF" > /tmp/nginx.conf.tmp
cp /tmp/nginx.conf.tmp "$NGINX_CONF"
rm -f /tmp/nginx.conf.tmp

# 5. Nginx graceful reload (기존 연결 유지하며 설정만 교체 → 무중단)
docker exec deploy-nginx-1 nginx -s reload
echo "Nginx reloaded successfully (zero-downtime)!"

# 6. 기존 컨테이너 종료 (선택적)
if [ "$CURRENT" != "$TARGET" ]; then
    echo "Stopping previous container app-$CURRENT..."
    docker compose -f ~/heartopia-life/deploy/docker-compose.yml stop app-$CURRENT
fi

echo "Zero-downtime deployment to app-$TARGET completed successfully."
