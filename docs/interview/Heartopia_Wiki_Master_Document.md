# 🍃 하토피아 위키 (Heartopia Wiki) - 통합 마스터 가이드

이 단일 문서(MD)는 하토피아 위키 프로젝트의 **모든 폴더, 모든 핵심 클래스, 모든 기술 스택, 모든 최적화/예외 처리 로직, 그리고 면접 예상 질문**을 단 하나도 빠짐없이 총망라한 '최종 아키텍처 및 면접 방어 백서'입니다. 

기타 다른 문서들을 보실 필요 없이 **오직 이 문서 하나만 처음부터 끝까지 정독하시면 프로젝트의 100%를 파악할 수 있습니다.**

---

## 🏗️ 1. 프로젝트 개요 및 기술 스택 총괄
프로젝트는 모던 웹 생태계에서 가장 안정적이라 평가받는 **SSR(Server-Side Rendering) 방식의 Spring MVC 패턴**으로 구현되어 있습니다.

- **Backend**: Java 17, Spring Boot 3.4.2
- **Database**: MySQL 8.0, MyBatis 3.0.3, HikariCP 커넥션 풀
- **Security**: Spring Security (BCrypt, CSRF 방어, Role 기반 인증)
- **Frontend**: HTML5, CSS3, Vanilla JS (ES6 Fetch API 비동기), Thymeleaf 템플릿 엔진
- **Infra/Tuning**: Gzip 데이터 압축, 정적 리소스 해시 캐싱 라우팅 지원

---

## 📂 2. 전체 디렉터리 아키텍처 및 역할 매핑

```text
c:\Users\k\Documents\heartopia-wiki-project\heartopia-wiki\
├── src/main/java/com/heartopia/wiki/
│   ├── advice/        👉 [전역 에러 제어탑] GlobalExceptionHandler (에러 발생 시 분기 처리)
│   ├── config/        👉 [보안 제어탑] SecurityConfig (관리자 로그인, 페이지 보호 설정)
│   ├── controller/    👉 [사용자 요청 접수] HTTP Request를 받아 처리 후 HTML이나 JSON으로 반환
│   ├── dto/           👉 [데이터 전달 배달부] DB의 민감한 원본(Entity)을 가공해서 화면에 넘기는 객체들
│   ├── entity(model)/ 👉 [데이터 껍데기] DB 테이블의 컬럼들과 1:1로 매칭되는 순수 자바 객체
│   ├── exception/     👉 [서버 오류 라벨링] 커스텀 에러 클래스들
│   ├── mapper/        👉 [DB 통신 인터페이스] SQL XML 파일들과 1:1로 짝지어지는 자바 인터페이스
│   └── service/       👉 [비즈니스 심장] 실질적인 로직(데이터 가공, 필터링 연산 등)을 수행하는 곳
│
└── src/main/resources/
    ├── application.properties 👉 [전역 환경 설정] 최적화 튜닝 및 DB 주소/비밀번호 관리
    ├── mapper/            👉 [실제 SQL 집합소] "SELECT * FROM..." 쿼리문들이 작성된 XML 폴더
    └── templates/ & static/ 👉 [화면 및 자원] Thymeleaf HTML 파일과 CSS/JS, 폰트, 이미지
```

---

## 🧠 3. 백엔드(Backend) 클래스별 완벽 해부

이 프로젝트에는 총 6개의 컨트롤러와 각 대응되는 서비스가 존재하며, 다음과 같은 역할을 수행합니다.

### ① 메인 도감 시스템 (`WikiController` & `CollectionService`)
- **역할**: 동물, 물고기, 벌레, 작물 등 위키의 메인 콘텐츠를 보여주고 검색하게 해줍니다.
- **특징 (DTO 패턴)**: DB에서 조회한 객체(Entity)를 Client로 직접 던지지 않고 `FishDto`, `BugDto` 등 화면용 DTO 객체로 `.stream().map()` 하여 변환하여 반환합니다. (보안과 결합도 최소화를 위함)
- **특징 (실시간 검색 AJAX)**: `@ResponseBody`를 활용해 검색창에서 글자 입력 즉시 도감 10가지를 추천해주는 JSON 기반 REST API(`/search/suggest`)가 내장되어 있습니다.

### ② 지도 기반 마커 시스템 (`MapController` & `MapPinService`)
- **역할**: 하토피아 맵의 자원 위치를 표시하는 마커(핀)를 관리합니다.
- **특징 (Application 레벨 조인)**: 핀 데이터와 어종/곤충 정보를 DB 레벨에서 복잡하게 무거운 `JOIN` 쿼리로 묶지 않습니다. 서버(Java)로 데이터를 모두 불러와서 `Java 8 Stream API`를 사용해 메모리에서 조립(`enrichPinDetails`)하여 DB 부하를 분산시켰습니다.

### ③ 유저 소통 영역 (`NoticeController`, `ReportController`, `GiftCodeController`)
- **역할**: 관리자 공지사항(`Notice`), 유저 제보(`WikiReport`), 게임 쿠폰코드 모음(`GiftCode`)을 운영합니다.
- **특징**: 단순 CRUD(쓰기,읽기,수정,삭제) 기능으로 구성되어 있으며, 모든 게시판(List) 기능은 MyBatis에서 페이징과 정렬을 위임하여 처리합니다.

---

## 🗄️ 4. 데이터베이스 및 SQL (MyBatis Mapper)

JPA를 쓰지 않고 **MyBatis**를 채택했기 때문에 면접관이 무조건 SQL 코드에 대해 질문합니다. 이 프로젝트의 SQL은 3가지 고급 기술을 사용했습니다.

### ① `<sql>` 스니펫 활용 (DRY 원칙 준수)
- `CollectionMapper.xml`을 보면 단순 반복되는 컬럼 조회명(`location, sub_location, name, level...`)들을 `<sql id="fishColumns">`로 모듈화해 두었습니다.
- SELECT 시 `<include refid="fishColumns"/>`하여 유지보수성을 극대화시켜 SQL 코딩의 정석을 따릅니다.

### ② 동적 서브쿼리를 탑재한 `CASE WHEN`
- 하나의 요리를 만들기 위해 물고기, 곤충, 작물 등 종류별로 이미지 출처 테이블이 다릅니다. 이 문제를 억지로 JOIN으로 풀지 않고 SQL에 `CASE WHEN item_type = 'fish' THEN (SELECT...)` 서브쿼리를 사용해 우아하게 꺼내옵니다.

### ③ SQL 튜닝 및 로그 제어
- `application.properties` 에서 `logging.level.com.heartopia.wiki.mapper=WARN`을 통해 정상적인 단순 SELECT 로그가 서버 터미널에 쏟아지는 것을 차단했습니다. I/O 부하를 최적화 한 사례입니다.

---

## ⚙️ 5. 시스템 설정 및 최적화 아키텍처

AI가 짜둔 `application.properties`에는 대고객 서비스를 위한 무시무시한 운영(Production) 전략들이 적용되어 있습니다.

- **Gzip 데이터 압축 전송**: `server.compression.enabled=true` 옵션을 켜서 사용자가 다운로드하는 텍스트/HTML 용량을 절반 이하로 줄여 인터넷 속도를 높였습니다.
- **HikariCP 커넥션 풀 강제 튜닝**: DB 접속 터널(Connection Pool)의 개수를 안정적으로 20개로 할당하고 커넥션 타임아웃을 명시해 DB 과부하를 막았습니다.
- **정적파일 캐시 & Content-Hash 적용**: `spring.web.resources.chain.strategy...` 코드를 통해 브라우저 캐시에 파일을 박아 속도를 높이고, 나중에 CSS를 업데이트해도 유저 화면이 깨지지 않도록 파일 용량 기반 자동 새로고침(Hash) 무효화 전략을 구현했습니다.

---

## 🔒 6. 전역 예외 처리 체계 및 보안망

### ① AOP 기반의 전역 에러 핸들링 (`GlobalExceptionHandler`)
컨트롤러 곳곳에 무식하게 try-catch를 달지 않았습니다.
- `@ControllerAdvice`로 에러를 중앙 통제관이 가로챕니다.
- 만약 화면이 아니라 자바스크립트로 몰래 통신(Fetch) 중 퍼진 에러라면(로딩중) `{success:false}` JSON만 떨어뜨리고,
- 사용자가 인터넷 주소창으로 돌아다니다 난 에러라면 `error.html` 예쁜 전용 페이지로 이동시킵니다.
    
### ② Spring Security 및 CSRF 방어 구축 (`SecurityConfig`)
- **경계망**: 지도의 내용 수정(POST/DELETE)과 관리자 주소(`/wiki/admin/**`)는 인증된 `ADMIN` 사용자만 통과하도록 `AntPathMatcher`를 설정했습니다.
- **CSRF 차단**: HTML 헤더에 심어둔 `csrfToken`을 자바스크립트 모듈(`map-api.js`)이 뽑아내서 데이터 수정 통신마다 보내도록 처리하여 해킹을 방지했습니다.

---

## 🎯 7. 면접 무적 방어 Q&A (자가 진단표)

어떤 면접관이 들어오더라도 다음의 질문들 안에서 나옵니다.

* **Q. "그 많은 도감 테이블들, 정보를 보여줄 때 SQL 최적화는 어떻게 하셨습니까?"**
  * **A:** "반복되는 SELECT 컬럼 리스트는 MyBatis의 `<sql>` 태그를 이용해 스니펫 변수로 만들어 분리해 중복 코드를 줄였습니다. 또한 이종 데이터끼리 묶여있는 요리 재료 테이블은 조인을 남발하면 복잡해져서, `CASE WHEN` 속에서 각각 동적 서브쿼리를 타게 해 가독성과 성능을 분리 확보했습니다."

* **Q. "지도 핀 정보랑 개별 어종 정보를 같이 어떻게 불러왔나요? DB에서 JOIN 쿼리를 썼나요?"**
  * **A:** "아닙니다. JOIN을 남발하면 병목이 온다고 판단했습니다. `MapController.enrichPinDetails()` 에서 보실 수 있듯, 핀 데이터와 어종 데이터를 각기 가져와서 앱 서버단에서 **Java 8 Stream의 `.filter().findFirst()`**를 활용해 매핑했습니다. DB 부하를 자바 서버의 메모리로 치환한 사례입니다."

* **Q. "오류 처리는 어떤 식으로 설계했습니까?"**
  * **A:** "`@ControllerAdvice`를 사용했는데요, 가장 큰 특징은 클라이언트 요청을 스니핑해서 **API 통신이면 JSON 에러를, 일반 웹페이지면 Thymeleaf 기반 error.html를 반환하게 분기 처리** 했다는 점입니다. 또 브라우저가 사진을 못 찾아서 내는 쓸데없는 404 NoResource 에러는 로그 서버 폭주를 막기 위해 의도적으로 예외 무시(Ignoring) 처리를 했습니다."

* **Q. "어드민 권한/보안 처리는 어떻게 하셨나요?"**
  * **A:** "`SecurityConfig`에서 `authorizeHttpRequests` 룰을 정의해 POST나 PUT 같은 CUD(생성/수정/삭제) 로직과 관리자 페이지 라우팅에 `hasRole("ADMIN")`을 걸어 철저히 보호하고, 비밀번호는 `BCrypt` 암호화 처리했습니다. 프론트엔드 비동기 통신을 할 땐 제가 직접 Fetch API 헤더에 CSRF 토큰을 주입하도록 JS 모듈 패턴(`window.MapApp`)을 설계했습니다."

* **Q. "이 프로젝트에서 가장 자랑하고 싶은 성능 최적화 옵션 1개가 있다면요?"**
  * **A:** "`application.properties` 에서 정적 자원에 적용한 **Content-Hash 기반 캐싱 전략**입니다. 1년 기간 캐싱을 먹여서 사이트 로딩 속도를 극한으로 높이면서도, CSS/JS 파일이 업데이트됐을 때는 쿼리 파라미터가 자동으로 변경돼 사용자 캐시가 무효화되도록 설계해 사용자 경험(UX)과 성능을 동시에 잡았습니다."
