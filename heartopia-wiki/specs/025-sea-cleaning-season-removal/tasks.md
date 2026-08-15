# Tasks: 바다청소 시즌 제외 및 레벨 필터 확장

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 운영·로컬 렌더링과 바다청소 이벤트 저장·집계·필터 경로를 비교한다.
  Files: `sea-cleaning.html`, `CollectionMapper.xml`, `EventSettingsMapper.xml`, 운영 바다청소 페이지
  Verify: 로컬 17개에 `고래 시즌`이 있고 운영은 이벤트 필터 없이 Lv.8 항목까지 출력함을 확인한다.

## Phase 2: Tests

- [x] T002 바다청소의 비시즌 계약과 Lv.8 필터 계약 테스트를 추가하고 공용 이벤트 테스트의 대상 목록을 바로잡는다.
  Files: `src/test/java/com/heartopia/wiki/template/SeaCleaningSeasonExclusionTest.java`, `CurrentEventFilterTemplateTest.java`
  Verify: 구현 전 신규 계약 테스트가 실패한다.

## Phase 3: Implementation

- [x] T003 바다청소 화면에서 이벤트 UI·속성·필터·관리자 입력을 제거하고 레벨을 8까지 확장한다.
  Files: `src/main/resources/templates/wiki/others/sea-cleaning.html`
  Verify: 대상 템플릿 테스트가 통과한다.

- [x] T004 바다청소 저장과 전역 이벤트 집계에서 시즌 값을 제거한다.
  Files: `src/main/resources/mapper/CollectionMapper.xml`, `src/main/resources/mapper/EventSettingsMapper.xml`
  Verify: 매퍼 계약 테스트가 통과한다.

- [x] T005 기존 바다청소 이벤트 값을 NULL로 정리하는 SQL을 추가한다.
  Files: `src/main/resources/sql/20260815_clear_sea_cleaning_event_names.sql`
  Verify: SQL이 NULL이 아닌 행만 갱신하고 0건 검증 쿼리를 포함한다.

## Phase 4: Polish

- [x] T006 전체 테스트와 로컬 렌더링을 검증하고 적용 후속 작업을 기록한다.
  Files: 변경 파일 전체, `tasks.md`
  Verify: 전체 Gradle 테스트, 로컬 HTML 확인, `git diff --check`가 통과한다.

## Completion Notes

- Tests run: 전체 Gradle 테스트 147건 및 `bootJar`, 대상 Node 테스트 15건, 대상 `git diff --check` 통과.
- Local verification: 서버 재기동 후 HTTP 200, 카드 18개, 이벤트 필터 0개, `data-event` 0개, 레벨 선택지 1~8, ID 체크리스트 키 유지를 확인했다.
- Local data: `event_name IS NOT NULL` 17건을 정리 SQL과 동일한 쿼리로 NULL 처리했고 잔여 0건을 확인했다.
- Known risks: 운영 DB에는 아직 정리 SQL을 실행하지 않았다. 코드상 값은 무시되므로 화면 장애는 없지만 데이터 일관성을 위해 배포 후 운영에도 실행한다.
- Follow-up: 운영 배포 후 `src/main/resources/sql/20260815_clear_sea_cleaning_event_names.sql` 실행 및 `remaining_event_names=0` 확인.
