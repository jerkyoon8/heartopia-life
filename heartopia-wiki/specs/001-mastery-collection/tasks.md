# Tasks: Mastery Collection

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Data And Model

- [x] T001 Add mastery fields and helpers to collection models and DTOs.
  Files: `src/main/java/com/heartopia/wiki/model`, `src/main/java/com/heartopia/wiki/dto/wiki`
  Verify: Java compile.

- [x] T002 Update MyBatis collection columns and CRUD SQL.
  Files: `src/main/resources/mapper/CollectionMapper.xml`
  Verify: mapper XML compiles in tests.

- [x] T003 Add migration and data update SQL from mastery txt files.
  Files: `src/main/resources/sql/alter_collections_add_mastery.sql`, `src/main/resources/sql/update_mastery_values.sql`
  Verify: SQL contains six table column additions and source-driven updates.

## Phase 2: UI And Sync

- [x] T004 Add detail mastery panel.
  Files: `src/main/resources/templates/wiki/detail.html`
  Verify: panel renders for supported categories and disabled state renders for missing data.

- [x] T005 Add mastery icons to six collection card templates.
  Files: `src/main/resources/templates/wiki/collections/fish.html`, `bug.html`, `bird.html`, `src/main/resources/templates/wiki/items/cooking.html`, `crops.html`, `flowers.html`
  Verify: icons are present and disabled when mastery is unavailable.

- [x] T006 Extend checklist sync JS/CSS for mastery toggles.
  Files: `src/main/resources/static/js/checklist-sync.js`, `src/main/resources/static/css/checklist-sync.css`
  Verify: clicking mastery icon toggles `mastery_{category}_{name}` without changing star key.

## Phase 3: Verification

- [x] T007 Run automated verification.
  Files: project root
  Verify: `.\gradlew.bat test`.

## Completion Notes

- Tests run: `.\gradlew.bat test` passed.
- Known risks: generated update SQL uses exact Korean names; unmatched rows remain NULL and render as disabled mastery data.
- Follow-up: apply `alter_collections_add_mastery.sql` before `update_mastery_values.sql` on the target DB.
