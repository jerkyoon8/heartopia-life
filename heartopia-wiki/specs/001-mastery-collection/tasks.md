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

## Phase 4: Admin Mastery Entry

- [x] T008 Add failing regression tests for seven supported admin forms, edit payloads, persistence SQL, and threshold validation.
  Files: `src/test/java/com/heartopia/wiki/template/AdminMasteryInputTemplateTest.java`, `src/test/java/com/heartopia/wiki/service/MasteryThresholdValidatorTest.java`
  Verify: tests fail while the six collection forms and mapper writes omit mastery fields.

- [x] T009 Add four mastery inputs and edit payload values to fish, bug, bird, cooking, flower, crop, and align sea-cleaning validation markup.
  Files: supported collection templates, `src/main/resources/static/js/admin-data.js`
  Verify: edit modal restores values; all blank is accepted; partial/negative/descending values are blocked with a message.

- [x] T010 Persist and server-validate the four mastery thresholds on supported add/update endpoints.
  Files: `src/main/resources/mapper/CollectionMapper.xml`, `src/main/java/com/heartopia/wiki/service/MasteryThresholdValidator.java`, `src/main/java/com/heartopia/wiki/controller/AdminDataController.java`
  Verify: mapper and validator regression tests pass; invalid values do not reach service writes.

- [x] T011 Run full automated and browser verification and record completion.
  Files: changed files and this task document
  Verify: full Gradle tests, JavaScript syntax, diff check, and admin modal dark/mobile inspection pass.

## Completion Notes

- Tests run: `.\gradlew.bat test --rerun-tasks --no-daemon`, `node --check src/main/resources/static/js/admin-data.js`, and `git diff --check` passed. Chrome form harness passed partial, valid, and descending-value cases; seven public collection pages returned HTTP 200 after restart.
- Known risks: the authenticated administrator modal could not be opened automatically because local admin access uses OAuth. Template coverage verifies all seven forms and edit payloads; an authenticated visual check remains advisable before push.
- Follow-up: no new schema is required. The existing four mastery columns must already be present in the six collection tables and sea-cleaning table. Verify one authenticated edit/save cycle locally before deployment.
