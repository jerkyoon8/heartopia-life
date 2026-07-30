# Tasks: 일일 자원 위치

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 기존 헤더 날씨·시계와 관리자 CRUD, 보안, 시간대 패턴을 확인하고 확정 결정을 문서화한다.
  Files: `specs/018-daily-resource-locations/*.md`
  Verify: 날짜 비노출, 별도 관리자 페이지, 위치 허용값, 오전 6시 경계가 명시됨

## Phase 2: Tests

- [x] T002 [P] 오전 6시 경계와 위치 입력 검증·정규화 서비스 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/service/DailyResourceLocationServiceTest.java`
  Verify: 구현 전 컴파일 실패, 구현 후 5:59/6:00·집 앞·유적·오류 사례 통과

- [x] T003 [P] 헤더 위치 블록, 관리자 폼, 공개 API 연결, SQL 구조 회귀 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/template/HeaderDailyResourceLocationTemplateTest.java`
  Verify: 구현 전 기대 파일·문자열 부재로 실패, 구현 후 통과

## Phase 3: Implementation

- [x] T004 날짜별 위치 테이블과 모델·Mapper를 추가하고 삭제는 비활성화로 처리한다.
  Files: `src/main/resources/sql/20260730_create_daily_resource_locations.sql`, `src/main/java/com/heartopia/wiki/model/DailyResourceLocation.java`, `src/main/java/com/heartopia/wiki/mapper/DailyResourceLocationMapper.java`, `src/main/resources/mapper/DailyResourceLocationMapper.xml`
  Verify: MySQL 8.0 SQL 실행, `game_date` unique, mapper 로딩

- [x] T005 오전 6시 게임 날짜와 위치 검증·조회·upsert 서비스를 구현한다.
  Files: `src/main/java/com/heartopia/wiki/service/DailyResourceLocationService.java`, `src/main/java/com/heartopia/wiki/dto/DailyResourceLocationResponse.java`
  Verify: T002 통과

- [x] T006 관리자 페이지와 공개 현재 위치 API를 구현한다.
  Files: `src/main/java/com/heartopia/wiki/controller/DailyResourceLocationController.java`, `src/main/resources/templates/wiki/admin-daily-resource-locations.html`
  Verify: 관리자 페이지·저장·삭제 경로와 공개 GET 응답 검사

- [x] T007 시계 왼쪽 공개 위치 UI와 오전 6시·탭 복귀 갱신을 구현한다.
  Files: `src/main/resources/templates/fragments/header.html`, `src/main/resources/static/css/common.css`, `src/main/resources/static/js/header-daily-resources.js`
  Verify: T003 통과, 날짜 미노출, 데스크톱·모바일 레이아웃 확인

## Phase 4: Polish

- [x] T008 로컬 DB에 SQL과 샘플 예약을 적용하고 API·관리자 화면·헤더를 검증한다.
  Files: `src/main/resources/sql/20260730_create_daily_resource_locations.sql`
  Verify: 오전 6시 기준 현재 행 조회, 공개 API 200, 관리 페이지 ADMIN 보호

- [x] T009 전체 테스트와 변경 범위·배포 선행 조건을 정리한다.
  Files: `specs/018-daily-resource-locations/tasks.md`
  Verify: `.\gradlew.bat test` 통과, SQL 적용 절차와 검증 쿼리 기록

## Completion Notes

- Tests run: `.\gradlew.bat test` 전체 통과. 로컬 공개 API 200, 활성 데이터가 없을 때 `위치 정보 없음`, 비로그인 관리자 경로 302 로그인 이동을 확인했다.
- Known risks: 운영 DB에 테이블이 없으면 기능이 동작하지 않는다. 위치 정보 미등록 시 헤더에는 두 자원 모두 `위치 정보 없음`으로 표시된다.
- Follow-up: 운영 코드 배포 전에 `src/main/resources/sql/20260730_create_daily_resource_locations.sql`을 MySQL 8.0 운영 DB에 적용하고 `DESCRIBE daily_resource_locations;`로 구조를 확인한다.
