# 🍃 하토피아 위키 (Heartopia Wiki)

[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.4.2-6DB33F?logo=springboot&logoColor=white)](#)
[![Java 17](https://img.shields.io/badge/Java-17-007396?logo=java&logoColor=white)](#)
[![MySQL 8.0](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white)](#)
[![MyBatis](https://img.shields.io/badge/MyBatis-3.0.3-black?logo=data&logoColor=white)](#)

> 게임 '하토피아(Heartopia)' 유저들의 편의를 위한 반응형 종합 도감 및 인터랙티브 지도 웹 서비스입니다.  
> **개발 기간**: 202X.0X ~ 202X.0X  
> **배포 주소**: [https://본인도메인/](https://본인도메인/) (선택)

---

## 🎯 설계 철학 (Architecture Focus)

이 프로젝트는 단순한 정보 나열을 넘어 **서버 렌더링(SSR) 최적화**, **직관적인 비동기 통신**, **방어적인 보안 설계**, 그리고 **유연한 데이터 결합(Aggregation)**이라는 실무적 가치를 담아내는 데 집중했습니다.

## 🛠 기술 스택

* **Backend**: Java 17, Spring Boot 3.4.2
* **Database**: MySQL 8.0, MyBatis (SQL 중심 최적화 제어)
* **Frontend**: Thymeleaf, Vanilla JS (Fetch API)
* **Security & Infra**: Spring Security, HikariCP

---

## 🔥 핵심 엔지니어링 및 문제 해결 (Trouble Shooting)

### 1. Application 계층 자바 스트림(Stream) 병합을 통한 DB JOIN 오버헤드 해소
인터랙티브 지도 기능 구현 시, 각기 다른 테이블(어종, 동물, 요리 등)에 퍼져 있는 상세 정보를 마커(Pin) 정보와 결합해야 했습니다. 
이를 RDBMS에서 무거운 `JOIN` 쿼리로 해결할 경우 시스템 병목이 예상되어, 각 데이터를 단건 조회 후 백엔드 서버(Java) 메모리에 올려 **Java 8 Stream API(`filter`, `ifPresent`)로 Application 레벨에서 병합(Aggregation)**하여 DB 부하를 분산하고 조작 유연성을 극대화했습니다.

### 2. AOP 기반 스마트 전역 예외 처리 체계 구축
사용자 경험(UX)과 시스템 모니터링 노이즈를 제어하기 위해 `@ControllerAdvice`를 활용한 중앙집중형 예외 처리 로직을 구현했습니다.
* **라우팅 분기**: HTTP Header의 `Accept` 타입을 분석하여 API(비동기) 통신 중 에러 시 `JSON` 폼으로 리턴하여 프론트가 다운되지 않도록 보호하고, 일반 페이지 서핑 중 에러는 전용 `error.html` 사이트로 리다이렉션했습니다.
* **로그 최적화**: 잦은 빈도로 발생하는 이미지 리소스 404(`NoResourceFoundException`)는 Error 로그 상에서 `ignoring` 처리하여 모니터링 노이즈를 제거했습니다.

### 3. Fetch API 비동기 마커 모듈 통신과 CSRF 방어
지도의 핀을 등록/수정/삭제하는 RESTful API를 구현하고, 프론트 단을 jQuery가 아닌 ES6 `async / await` 기반의 모듈 패턴(`window.MapApp`)으로 고도화했습니다. 이때 변경 메서드(POST/PUT)가 Spring Security의 CSRF 방어를 통과할 수 있도록 HTML `<meta>` 태그의 `_csrf` 보안 토큰을 자바스크립트가 직접 읽어 HTTP Header에 주입하는 보호 로직을 탑재했습니다.

### 4. 무중단 실서비스급 성능 최적화 (Properties 튜닝)
단순 구현에 그치지 않고 배포/운영 시나리오를 대비한 인프라 튜닝을 적용했습니다.
* **Gzip & 캐싱**: `server.compression.enabled=true`를 통한 자원 전송량 50~70% 감축 및 **Content-Hash 알고리즘**을 통한 정적 브라우저 캐시 무효화 제어
* **Connection Pool**: 대량 조회를 대비하여 `HikariCP` 커넥션 풀을 20으로 한정하고 릴리스 시간을 고정하여 DB 메모리 누수 사전 차단

---

## 📷 주요 화면 및 기능 (Features)

*(이곳에 서비스의 핵심 로직이 돌아가는 GIF 화면이나 고해상도 이미지를 2~3장 첨부하세요)*

* **실시간 도감 검색**: 사용자의 응답 속도를 높이기 위해 `@ResponseBody`를 통해 입력 즉시 추천 키워드가 뜨는 실시간 AJAX 검색 API 구현.
* **커스텀 인터랙티브 맵**: JS와 JSON 통신을 통해 화면 새로고침 없이 유저가 자원 마커를 커스텀하고 움직일 수 있는 기능 개발.

---

## 🚀 로컬 환경 실행 가이드 (Getting Started)

```bash
# 1. 저장소 클론
$ git clone https://github.com/본인계정/heartopia-wiki-project.git
$ cd heartopia-wiki

# 2. Database 세팅 (MySQL)
$ mysql -u root -p -e "CREATE DATABASE heartopia_db;"

# 3. 비밀번호 환경변수 주입
# src/main/resources 폴더에 application-secret.properties 생성 후 아래 작성
# DB_PASSWORD=본인DB비번

# 4. 앱 실행
$ ./gradlew bootRun
```
