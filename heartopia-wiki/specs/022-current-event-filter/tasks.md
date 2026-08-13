# Tasks: 현재 이벤트 도감 필터

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 요구사항, 페이지 범위, 데이터 및 운영 결정을 PRD/Spec/Plan으로 확정한다.
  Files: `specs/022-current-event-filter/{prd,spec,plan,tasks}.md`
  Verify: 문서에 관리자 화면, 복수 현재 이벤트, 10개 대상 도감, SQL 선적용 조건이 포함된다.

## Phase 2: Tests

- [x] T002 [P] 현재 이벤트 저장 서비스의 복수 저장·전체 해제·입력 검증 테스트를 작성한다.
  Files: `src/test/java/com/heartopia/wiki/service/EventSettingsServiceTest.java`
  Verify: 구현 전 컴파일 또는 테스트 실패를 확인하고 구현 후 통과한다.

- [x] T003 [P] 모든 대상 템플릿이 공통 이벤트 필터와 `data-event`를 제공하는 회귀 테스트를 작성한다.
  Files: `src/test/java/com/heartopia/wiki/template/CurrentEventFilterTemplateTest.java`, `src/test/java/com/heartopia/wiki/template/CookingEventFilterTemplateTest.java`
  Verify: 기존 단일 필터/고정 스위치 상태에서 실패하고 공통 필터 적용 후 통과한다.

## Phase 3: Implementation

- [x] T004 현재 이벤트 테이블 SQL과 MyBatis 영속성 계층을 구현한다.
  Files: `src/main/resources/sql/20260812_create_wiki_current_events.sql`, `src/main/java/com/heartopia/wiki/mapper/EventSettingsMapper.java`, `src/main/resources/mapper/EventSettingsMapper.xml`
  Verify: mapper XML 파싱 및 관련 단위 테스트가 통과한다.

- [x] T005 현재 이벤트 검증·저장 서비스와 관리자 컨트롤러/화면을 구현한다.
  Files: `src/main/java/com/heartopia/wiki/service/EventSettingsService.java`, `src/main/java/com/heartopia/wiki/controller/EventSettingsController.java`, `src/main/resources/templates/wiki/admin-event-settings.html`, `src/main/resources/templates/fragments/header.html`
  Verify: 서비스 테스트 통과 및 `/wiki/admin/event-settings` 경로/폼 정적 검증.

- [x] T006 공통 체크박스형 이벤트 필터 UI와 `WikiFilter`의 기본값·사용자 재정의·필터 동작을 구현한다.
  Files: `src/main/resources/templates/fragments/wiki-components.html`, `src/main/resources/static/js/wiki-filter.js`, `src/main/resources/static/css/common.css`
  Verify: 이벤트 없음/현재/지난 이벤트 DOM 케이스와 초기화 로직을 테스트 또는 정적 검증한다.

- [x] T007 10개 이벤트 지원 도감에 공통 필터와 현재 이벤트 모델을 연결하고 기존 고정 스위치를 제거한다.
  Files: `src/main/java/com/heartopia/wiki/controller/WikiController.java`, 대상 도감 템플릿 10개
  Verify: 템플릿 회귀 테스트와 `rg`로 고정 이벤트 스위치가 남지 않았음을 확인한다.

## Phase 4: Polish

- [x] T013 빠른 선택 이벤트 DB, 서비스, 관리자 복수 설정을 구현한다.
  Files: `src/main/resources/sql/20260813_*wiki_quick_events*.sql`, `EventSettingsMapper.*`, `EventSettingsService.java`, `EventSettingsController.java`, `admin-event-settings.html`
  Verify: 두 설정의 조회·검증·트랜잭션 교체 테스트가 통과한다.

- [x] T014 상세 필터의 `일반` 값과 검색창 옆 빠른 이벤트 필터를 공통 구현한다.
  Files: `wiki-components.html`, `wiki-filter.js`, `common.css`, 이벤트 도감 템플릿 10개, `WikiController.java`
  Verify: 상단/상세 상태 동기화, 카드/표 일치, 모바일·다크모드 정적 검사가 통과한다.

- [x] T015 실행형 이벤트 필터 회귀 테스트와 SQL/템플릿 테스트를 추가한다.
  Files: `src/test/js/wiki-filter-event.test.js`, 관련 JUnit 테스트
  Verify: `node --test src/test/js/wiki-filter-event.test.js`, `./gradlew test`, `./gradlew bootJar`가 통과한다.

- [x] T016 상단 빠른 이벤트 필터를 하나의 연결형 분할 컨트롤로 압축한다.
  Files: `src/main/resources/templates/fragments/wiki-components.html`, `src/main/resources/static/css/common.css`
  Verify: 왼쪽 ON/OFF와 오른쪽 복수 선택이 한 wrapper 안에 있고 375px에서도 줄바꿈과 가로 넘침이 없다.

- [x] T017 분할형 컨트롤의 구조·상태·반응형 회귀 테스트를 추가하고 전체 검증한다.
  Files: `src/test/java/com/heartopia/wiki/template/CurrentEventFilterTemplateTest.java`, `src/test/js/wiki-filter-event.test.js`
  Verify: 관련 JUnit, Node 테스트, 전체 Gradle 테스트와 `git diff --check`가 통과한다.

- [x] T018 실제 Chrome 기반 Playwright 이벤트 필터 회귀 테스트를 프로젝트에 추가한다.
  Files: `package.json`, `package-lock.json`, `playwright.config.js`, `e2e/event-filter.spec.js`, `.gitignore`
  Verify: 초기값, 복수 선택, ON/OFF, 새로고침, 초기화, 선택 없음, 상세 필터 양방향 동기화, 깨진 저장값, 키보드, 10개 도감, 375px, 다크모드 및 콘솔/로컬 요청 오류 검사가 통과한다.

- [x] T008 전체 테스트, 변경 diff, 작업 트리 충돌 여부를 확인하고 문서 완료 상태를 갱신한다.
  Files: 변경 파일 전체, `specs/022-current-event-filter/tasks.md`
  Verify: `./gradlew test` 통과, 관련 파일 diff 검토, 기존 사용자 변경 미포함 확인.

- [x] T009 [P] 로컬·운영 애플리케이션 계정의 현재 이벤트 테이블 DML 권한 SQL과 누락 방지 테스트를 추가한다.
  Files: `src/main/resources/sql/20260812_grant_wiki_current_events_{local,production}.sql`, `src/test/java/com/heartopia/wiki/sql/EventSettingsPermissionSqlTest.java`
  Verify: 환경별 계정 Host와 `SELECT`, `INSERT`, `UPDATE`, `DELETE` 권한을 검사하는 테스트가 통과한다.

- [x] T010 QA에서 발견한 모바일 헤더/카드 넘침, 동물 카드 줄바꿈, 다크모드 선택창 대비를 수정한다.
  Files: `src/main/resources/static/css/common.css`, `src/main/resources/templates/fragments/header.html`, `src/main/resources/templates/wiki/collections/forageable.html`
  Verify: 375×812 다크모드에서 10개 도감의 문서 폭이 화면 폭을 넘지 않고 입력 글자가 식별된다.

- [x] T011 페이지에 없는 관리자 현재 이벤트를 비활성 안내 옵션으로 표시하고 실제 이벤트가 전혀 없을 때의 상태를 명확히 한다.
  Files: `src/main/resources/static/js/wiki-filter.js`, `src/main/resources/static/css/common.css`
  Verify: 물고기 도감에 `고래 탐사 시즌 · 이 도감에 항목 없음`이 표시되고 필터 결과에는 영향을 주지 않는다.

- [x] T012 QA 회귀 테스트와 전체 브라우저/Gradle 검증을 실행하고 보고서를 갱신한다.
  Files: `src/test/java/com/heartopia/wiki/template/QaDarkModeAndEventFilterRegressionTest.java`, `.gstack/qa-reports/qa-report-localhost-2026-08-12.md`
  Verify: 전체 테스트 통과, 10개 도감 데스크톱·모바일 다크모드 재검사, 콘솔 오류 0건.

## Completion Notes

- Tests run: `./gradlew test` 통과, `node --check src/main/resources/static/js/wiki-filter.js` 통과, `git diff --check` 통과. 10개 도감 데스크톱·모바일 다크모드 브라우저 재검사에서 문서 수평 넘침과 콘솔 오류가 0건이었다.
- Known risks: 인증된 관리자 설정 화면 자체는 브라우저에서 재검사하지 못했다. 공개 도감에 전달된 관리자 기본값과 비활성 안내 옵션은 실제 렌더링 DOM으로 확인했다.
- Follow-up: 운영 DB에는 코드 배포 전에 테이블 생성 SQL과 운영 권한 SQL을 적용하고 검증 쿼리로 테이블, 권한, 현재 이벤트 행을 확인한다.

### 2026-08-13 빠른 이벤트 선택 확장

- Tests run: `node --check src/main/resources/static/js/wiki-filter.js`, `node --test src/test/js/wiki-filter-event.test.js`, `./gradlew test bootJar`, `git diff --check` 통과.
- Compatibility: 폼 버전 필드가 없는 구버전 관리자 요청은 기존 빠른 선택 값을 보존하며, 식별할 수 없는 빈 구버전 요청은 저장하지 않고 새로고침을 안내한다.
- QA constraint: 현재 세션에는 headless browse 실행 파일과 인앱 브라우저가 없어 실제 클릭·반응형 화면 자동화는 실행하지 못했다. 실행형 상태 전환 테스트와 기존 템플릿/다크모드 회귀 테스트로 대체했다.
- Follow-up: 코드 배포 전에 `20260813_create_wiki_quick_events.sql`과 대상 환경 권한 SQL을 적용하고 테이블 및 앱 계정 권한을 검증한다.

### 2026-08-13 빠른 이벤트 분할 컨트롤 압축

- UI: 독립 토글과 이벤트 선택 상자를 40px 높이의 연결형 컨트롤로 합쳤다. 왼쪽은 `이벤트만 보기` ON/OFF, 오른쪽은 관리자 허용 이벤트 복수 선택을 담당한다.
- Responsive: 375px Chrome 렌더링에서 한 줄 유지와 가로 넘침 없음, 데스크톱에서 검색·수집 숨김·상세 옵션과 같은 줄 정렬을 확인했다.
- Tests run: `node --check src/main/resources/static/js/wiki-filter.js`, `node --test src/test/js/wiki-filter-event.test.js` 7건, `./gradlew test`, 관련 `git diff --check` 통과.
- Browser constraint: 인앱 브라우저를 사용할 수 없어 자동 클릭 검사는 기존 실행형 상태 전환 테스트로 대체했고, 실제 Chrome 데스크톱·375px 스크린샷으로 레이아웃을 검증했다.

### 2026-08-13 Playwright 브라우저 회귀 검증

- Command: `npm install`, 앱 실행 후 `npm run test:e2e:event-filter`.
- Result: 실제 Chrome에서 영구 회귀 테스트 7건 통과. 10개 도감을 1280px과 375px에서 각각 순회했으며 내부 콘솔 예외, 로컬 요청 실패, 문서/컨트롤 가로 넘침이 없었다.
- State coverage: 관리자 설정값을 DOM에서 동적으로 읽으므로 특정 이벤트명 변경에 의존하지 않는다. 빠른 이벤트가 2개 미만이면 복수 선택 시나리오만 명시적으로 skip한다.
- Evidence: `.gstack/qa-reports/qa-report-localhost-event-filter-2026-08-13.md`와 `screenshots/event-filter-*.png`.
