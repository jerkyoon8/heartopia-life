# Feature Spec: Mastery Collection

## Source

- PRD: `specs/001-mastery-collection/prd.md`
- Principles: `specs/principles.md`

## User Scenarios

### Scenario 1: Detail Mastery Panel

- Given an item has mastery thresholds
- When a user opens its detail page
- Then the page shows the four Korean mastery stages and their threshold rules.

### Scenario 2: Unavailable Mastery Data

- Given an item has `X`, missing thresholds, or no DB mastery values
- When a user views its detail page or card
- Then mastery UI is visible as unavailable/disabled and does not change saved state.

### Scenario 3: Card Mastery Toggle

- Given an item card has mastery values
- When a user clicks the mastery icon
- Then the item mastery key is toggled independently from the star rating key.

### Scenario 4: Administrator Enters Mastery Thresholds

- Given an administrator opens an add or edit modal for a supported collection
- When all four valid thresholds are entered and saved
- Then the values are persisted and repopulated when the item is edited again.

## Functional Requirements

- FR-001: The system must add nullable integer mastery threshold fields for six collection tables.
- FR-002: The system must expose those fields through Java models, DTOs, and MyBatis select columns.
- FR-003: The detail page must render a mastery panel for fish, bug, bird, cooking, crop, and flower.
- FR-004: The mastery panel must show Korean labels in order: `초보자`, `입문자`, `숙련자`, `명인`.
- FR-005: The first threshold must be displayed as `N 이하`; the other three thresholds must be displayed as `N 이상`.
- FR-006: Card mastery icons must be disabled when mastery values are unavailable.
- FR-007: Card mastery toggles must use separate checklist keys shaped as `mastery_{category}_{name}`.
- FR-008: Existing collection star keys shaped as `{category}_{name}` must remain unchanged.
- FR-009: Admin add/edit modals for fish, bug, bird, cooking, flower, crop, and sea cleaning must expose all four mastery threshold inputs.
- FR-010: Existing threshold values must populate the edit modal.
- FR-011: Collection INSERT and UPDATE statements must persist all four threshold fields.
- FR-012: Thresholds must be either all blank or all present; provided values must be non-negative and ordered `beginner <= intro <= expert <= master`.
- FR-013: Animal and forageable collections must remain outside mastery scope.

## Non-Functional Requirements

- NFR-001: UI controls must not cause layout shifts on collection cards.
- NFR-002: The implementation should reuse existing checklist sync flow where possible.
- NFR-003: SQL migration must be repeatable enough for local/prod review by using nullable additions and update statements.

## Edge Cases

- `X` rows: all mastery fields remain `NULL`; UI shows disabled.
- Level 11+ or rows absent from source files: all mastery fields remain `NULL`; UI shows disabled.
- Logged-out users: mastery state persists in localStorage.
- Logged-in sync users: mastery state persists in `user_checklist` with separate item keys.
- Partial values, negative values, or descending values: form submission is blocked and persistence must reject the input.

## Data Requirements

- Add fields:
  - `mastery_beginner_max`
  - `mastery_intro_min`
  - `mastery_expert_min`
  - `mastery_master_min`
- Values come from local txt files under `C:\Users\k\Desktop\user_kit\docs\명인 정보`.

## Clarifications

- Q: What label order should be used?
  A: `초보자`, `입문자`, `숙련자`, `명인`.
- Q: What should happen for `X`?
  A: Show disabled mastery panel/icon and do not allow saving mastery.
- Q: Should English labels be used?
  A: No. Only three English labels are known, so use Korean labels.
- Q: Should animals and forageables receive mastery fields?
  A: No. Keep the feature limited to the six existing mastery collections and sea cleaning.

## Review Checklist

- [x] 요구사항이 사용자 관점으로 설명되어 있다.
- [x] 성공 기준이 측정 가능하다.
- [x] 비목표가 명확하다.
- [x] 모호한 표현이 Assumptions 또는 Clarifications에 기록되어 있다.
- [x] 구현 방법이 과하게 먼저 정해지지 않았다.
