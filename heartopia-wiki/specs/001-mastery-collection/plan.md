# Implementation Plan: Mastery Collection

## Context

- Spec: `specs/001-mastery-collection/spec.md`
- Current codebase notes:
  - Collection SQL columns are centralized in `src/main/resources/mapper/CollectionMapper.xml`.
  - Collection list pages use DTOs for fish, bug, bird, flower, and crop, while cooking uses the model directly.
  - Detail pages share `src/main/resources/templates/wiki/detail.html`.
  - Existing checklist sync stores numeric values by `item_key` in `user_checklist`; local mode stores the same shape in `heartopia_checklist`.
  - Models and DB columns already contain the four mastery values, but six collection admin forms and their INSERT/UPDATE mapper statements omit them. Sea cleaning already persists the fields.

## Approach

Add nullable mastery fields through models, DTOs, mapper columns, and migration SQL. Reuse checklist storage by adding independent `mastery_...` keys instead of changing the stored value shape for star ratings. Add a shared JS/CSS layer for mastery toggles and a shared Thymeleaf fragment for card icons where feasible.

Extend the existing admin modals with a consistent four-field mastery section. Include those values in edit-button JSON, persist them in the six missing MyBatis INSERT/UPDATE statements, and enforce the same all-or-none/non-negative/ordered validation in the browser and server before writes.

## Impacted Files

- `src/main/java/com/heartopia/wiki/model/*Collection.java`: add mastery fields and helper methods.
- `src/main/java/com/heartopia/wiki/dto/wiki/*.java`: expose mastery fields where list pages use DTOs.
- `src/main/resources/mapper/CollectionMapper.xml`: select, insert, and update mastery columns.
- `src/main/resources/templates/wiki/detail.html`: render mastery panel.
- `src/main/resources/templates/wiki/collections/*.html`: add mastery card icon.
- `src/main/resources/templates/wiki/items/*.html`: add mastery card icon.
- `src/main/resources/static/js/checklist-sync.js`: support mastery toggle keys.
- `src/main/resources/static/css/checklist-sync.css`: style mastery icons/panel states if needed.
- `src/main/resources/sql/*`: add migration and data update SQL.
- `src/main/java/com/heartopia/wiki/service/MasteryThresholdValidator.java`: central server-side validation.
- `src/main/java/com/heartopia/wiki/controller/AdminDataController.java`: validate supported collection writes.
- `src/main/resources/static/js/admin-data.js`: shared form validation and edit-value population support.
- Six supported collection templates plus `sea-cleaning.html`: expose consistent admin inputs and serialized edit values.

## Data Model

- Six collection tables receive four nullable integer fields:
  - `mastery_beginner_max`
  - `mastery_intro_min`
  - `mastery_expert_min`
  - `mastery_master_min`
- Java fields use camelCase equivalents.

## API Or Interface Changes

- No new HTTP endpoints.
- Existing `/api/user/checklist` persists mastery through separate item keys, e.g. `mastery_fish_붕어`.
- Existing admin CRUD endpoints accept the four model-bound integer fields; no API shape beyond those form fields is added.

## Validation And Error Handling

- All four values blank means mastery unavailable; otherwise all four are required.
- Values must be non-negative and non-decreasing from beginner through master.
- Browser validation provides immediate feedback; server validation prevents bypassed form submissions from writing invalid data.
- Disabled UI when any mastery value is missing.
- `X` source rows are represented by NULL values.
- Existing star rating save/delete behavior remains untouched.

## Test Plan

- Run `.\gradlew.bat test`.
- Build templates through Spring context if tests cover it; otherwise run a local boot check if needed.
- Manually inspect generated SQL for expected column names and Korean update statements.
- Add regression tests for all supported templates, mapper INSERT/UPDATE coverage, edit JSON, and validator edge cases.
- Browser-check one add/edit modal in desktop/mobile dark mode and confirm shared behavior across template tests.

## Risks And Mitigations

- Name mismatches in SQL updates: source rows update by exact name; unmatched rows remain disabled instead of breaking reads.
- Template duplication across six pages: keep markup small and consistent.
- Admin forms may omit new fields: keep DB columns nullable so add/update can leave mastery values unchanged or null.
- Repeated template markup can drift: test all seven supported templates for the same four named inputs.

## Alternatives Considered

- Store mastery in the same checklist value object as stars: rejected to avoid migrating all existing localStorage and DB values.
- New `user_mastery_checklist` table: rejected because existing checklist sync table already supports arbitrary item keys.
- New standalone mastery admin page: rejected because the values belong to an individual collection item and the existing add/edit modal is the shortest workflow.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
