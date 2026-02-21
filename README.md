# Heartopia Wiki

Heartopia 게임의 위키 사이트입니다.

## 기술 스택

- **Backend:** Spring Boot 3.4.2
- **Language:** Java 17
- **Template Engine:** Thymeleaf
- **Database:** MySQL 8
- **ORM:** MyBatis

## 주요 기능

- 🏠 **주민 도감** — 전체 주민 정보, 선물 취향, 역할
- 🐟 **컬렉션 도감** — 물고기, 곤충, 새, 채집물, 동물
- 🍳 **아이템** — 요리, 작물, 꽃
- 🎁 **기프트코드** — 쿠폰 코드 목록
- 🗺️ **인터랙티브 지도** — 핀 기반 위치 정보

## 로컬 실행

```bash
# 1. MySQL에 데이터베이스 생성
mysql -u root -p -e "CREATE DATABASE heartopia_db;"

# 2. application-secret.properties 생성
echo "DB_PASSWORD=your_password" > heartopia-wiki/src/main/resources/application-secret.properties

# 3. 실행
cd heartopia-wiki
./gradlew bootRun
```

## 라이선스

This project is not affiliated with the official Heartopia game.
