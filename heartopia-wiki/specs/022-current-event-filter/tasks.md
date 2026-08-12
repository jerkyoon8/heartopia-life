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
