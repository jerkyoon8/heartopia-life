# Tasks: 아시아 서버 참여형 시간·날씨 헤더

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 기존 헤더, OAuth 사용자, 권한, CSRF, MyBatis와 배치 upsert 패턴을 조사한다.
  Files: `src/main/resources/templates/fragments/header.html`, `src/main/java/com/heartopia/wiki/config/SecurityConfig.java`, `src/main/java/com/heartopia/wiki/dto/oauth2/CustomOAuth2User.java`, `src/main/resources/mapper/UserChecklistMapper.xml`
  Verify: 구현 결정과 영향 파일이 `plan.md`에 기록되어 있다.

- [x] T002 사용자와 서버 범위, 예보 구간, 날씨 종류, 인증, 가중치, 동점, 보관, 제출 방식을 확정한다.
  Files: `specs/015-community-weather-header/prd.md`, `specs/015-community-weather-header/spec.md`
  Verify: Open Questions가 없고 Clarifications에 결정이 기록되어 있다.

## Phase 2: Tests

- [x] T003 서비스 단위 테스트를 먼저 작성한다.
  Files: `src/test/java/com/heartopia/wiki/service/WeatherForecastServiceTest.java`
  Verify: 구현 전 컴파일 또는 테스트 실패로 필요한 서비스 인터페이스가 드러난다.

- [x] T004 헤더·아이콘 정적 회귀 테스트를 먼저 작성한다.
  Files: `src/test/java/com/heartopia/wiki/template/HeaderWeatherTemplateTest.java`
  Verify: 구현 전 날씨 마크업·JS·아이콘 부재와 메뉴 잔존으로 실패한다.

## Phase 3: Implementation

- [x] T005 날씨 투표와 7일 변경 이력 SQL을 작성한다.
  Files: `src/main/resources/sql/weather-voting.sql`
  Verify: MySQL 8.0 문법, FK, UNIQUE, 집계·정리 인덱스를 검토한다.

- [x] T006 모델, DTO, 매퍼 인터페이스와 XML을 구현한다.
  Files: `src/main/java/com/heartopia/wiki/model/WeatherVote.java`, `src/main/java/com/heartopia/wiki/model/WeatherVoteTally.java`, `src/main/java/com/heartopia/wiki/dto/weather/*.java`, `src/main/java/com/heartopia/wiki/mapper/WeatherVoteMapper.java`, `src/main/resources/mapper/WeatherVoteMapper.xml`
  Verify: `compileJava` 성공 및 매퍼 메서드/SQL ID 일치

- [x] T007 시간 구간·합의·대체·배치 수정·정리를 구현한다.
  Files: `src/main/java/com/heartopia/wiki/service/WeatherForecastService.java`
  Verify: T003 서비스 테스트 통과

- [x] T008 공개 조회와 로그인 제출 API 및 보안 규칙을 구현한다.
  Files: `src/main/java/com/heartopia/wiki/controller/WeatherForecastController.java`, `src/main/java/com/heartopia/wiki/config/SecurityConfig.java`
  Verify: GET 공개, POST 인증 필수 및 서버 계산 가중치 확인

- [x] T009 날씨 아이콘 5종만 프로젝트에 복사한다.
  Files: `src/main/resources/static/images/weather/*.webp`
  Verify: 합계 30KB 이하, 참나무·형광석 미포함

- [x] T010 헤더 메뉴와 시간·날씨 패널·제보 오버레이 마크업을 구현한다.
  Files: `src/main/resources/templates/fragments/header.html`
  Verify: T004 템플릿 테스트 통과

- [x] T011 시계·조회·합의 표시·배치 입력·제출 동작을 구현한다.
  Files: `src/main/resources/static/js/header-weather.js`
  Verify: 6시간 경계 재조회, CSRF POST, 선택하지 않은 칸 미제출

- [x] T012 밝은/어두운 테마와 데스크톱·모바일 반응형 스타일을 구현하고 캐시 버전을 갱신한다.
  Files: `src/main/resources/static/css/common.css`, `src/main/resources/templates/fragments/common-head.html`
  Verify: 390px에서 가로 오버플로 없음

## Phase 4: Polish

- [x] T013 전체 테스트와 정적 검사를 실행한다.
  Files: 전체 변경 파일
  Verify: `gradlew.bat test` 성공, 금지 메뉴/자원 아이콘/레거시 참조 없음

- [x] T014 로컬 렌더링으로 밝은/어두운 테마와 데스크톱·모바일을 검수한다.
  Files: 헤더 HTML/CSS/JS
  Verify: 1440px·390px에서 요약, 패널, 오버레이 시각 확인

- [x] T015 SQL 후속 적용 절차와 완료 상태를 기록한다.
  Files: `specs/015-community-weather-header/tasks.md`
  Verify: SQL 경로, 대상 환경, 실행 방법, 검증 쿼리, 예상 결과가 Completion Notes에 있다.

## Completion Notes

- Tests run:
  - `.\gradlew.bat test`: 성공
  - `node --check src/main/resources/static/js/header-weather.js`: 성공
  - 로컬 Chromium: 1440px 패널 가로 오버플로 없음, 390px 패널·제보 모달 가로 오버플로 없음
  - 숨김 모달이 포인터 입력을 가로채던 문제를 발견해 `[hidden] { display: none; }` 회귀 규칙과 테스트를 추가
  - 날씨 아이콘 5개 합계 23,008바이트, 자원 아이콘 미포함
- Required SQL:
  - 파일: `src/main/resources/sql/weather-voting.sql`
  - 로컬 권한 파일: `src/main/resources/sql/weather-voting-permissions-local.sql`
  - 대상: 코드를 사용하는 각 MySQL 8.0 `heartopia_db` 환경(로컬·운영)
  - 순서: 애플리케이션 코드 배포/기동 전에 테이블 SQL과 애플리케이션 계정 권한 SQL을 실행한다. `spring.sql.init.mode=never`이므로 자동 생성되지 않는다.
  - 실행: `mysql -u <user> -p --default-character-set=utf8mb4 heartopia_db < src/main/resources/sql/weather-voting.sql`
  - 로컬 권한 실행: `mysql -u root -p --default-character-set=utf8mb4 < src/main/resources/sql/weather-voting-permissions-local.sql`
  - 계정 Host: 오류의 `'사용자명'@'localhost'`는 접속 출발지일 수 있으므로 `SELECT User, Host FROM mysql.user`로 실제 등록 계정을 확인한다.
  - 운영 권한: `deploy/.env`의 `MYSQL_USER` 계정과 실제 Host에 두 날씨 테이블의 `SELECT, INSERT, UPDATE, DELETE` 권한을 부여한다.
  - 검증: `SHOW TABLES LIKE 'weather_%';`, `SHOW INDEX FROM weather_votes;`, 실제 운영 계정의 `SHOW GRANTS`
  - 예상 결과: 두 날씨 테이블과 인덱스가 조회되고, 운영 애플리케이션 DB 계정의 두 테이블 권한에 `SELECT, INSERT, UPDATE, DELETE`가 모두 표시된다.
- Known risks: 신규 SQL 미적용 환경에서는 날씨 조회·제보 API를 사용할 수 없음
- Follow-up: 참나무·형광석 자원 생성 정보는 시간·날씨 기능 안정화 후 별도 기능으로 검토
