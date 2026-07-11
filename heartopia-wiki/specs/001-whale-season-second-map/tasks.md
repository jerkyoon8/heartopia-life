# Tasks: Whale Season Second Map

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 [P] Copy whale season forageable images into static assets.
  Files: `src/main/resources/static/images/collections/forage/*`
  Verify: `Get-ChildItem src/main/resources/static/images/collections/forage`

- [x] T002 Create SQL migration/seed for map keys and whale forageables.
  Files: `src/main/resources/sql/20260711_whale_season_second_map.sql`
  Verify: SQL is idempotent where practical.

## Phase 2: Implementation

- [x] T003 Add map key support to map models, mappers, service, and controller.
  Files: `src/main/java/com/heartopia/wiki/**`, `src/main/resources/mapper/*Map*.xml`
  Verify: `gradlew test`

- [x] T004 Enable second-map admin pin placement in map JS.
  Files: `src/main/resources/static/js/map/map-api.js`, `map-core.js`, `map-state.js`
  Verify: `node --check`

- [x] T005 Add whale season quick filter to forageable page.
  Files: `src/main/resources/templates/wiki/collections/forageable.html`
  Verify: DOM button sets `eventFilter` to `고래 탐사 시즌`.

## Phase 3: Verification

- [x] T006 Run syntax/tests and inspect changed files.
  Files: changed files
  Verify: `node --check`, `gradlew test`

## Completion Notes

- Tests run: `node --check` for changed map JS files, `.\gradlew.bat test`
- Known risks: DB migration must be applied before second-map pin writes can persist in an environment that does not yet have `map_key`.
- Follow-up: Apply `src/main/resources/sql/20260711_whale_season_second_map.sql` to the target DB.
