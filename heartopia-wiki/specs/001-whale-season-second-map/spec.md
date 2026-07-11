# Feature Spec: Whale Season Second Map

## Source

- PRD: `specs/001-whale-season-second-map/prd.md`
- Principles: `specs/principles.md`

## User Scenarios

### Scenario 1: Whale Season Filter

- Given the forageable page contains event and non-event items
- When the user clicks the whale season filter button
- Then only items with `data-event` containing `고래 탐사 시즌` remain visible

### Scenario 2: Second Map Pin Placement

- Given an admin is on `/wiki/map?mapKey=second`
- When the admin starts placement for a whale season forageable and clicks the map
- Then a new `map_pins` row is saved with `map_key='second'`

### Scenario 3: Existing Map Isolation

- Given existing map pins have no explicit map key or use `town`
- When the user opens `/wiki/map?mapKey=second`
- Then those existing pins are hidden

## Functional Requirements

- FR-001: The forageable page must provide a one-click whale season filter.
- FR-002: Whale season forageable assets must live in the same static collection image folder as existing forageables.
- FR-003: Map pin API responses must support filtering by `mapKey`.
- FR-004: Map pin create requests must persist the selected `mapKey`.
- FR-005: Existing map data must default to `town`.
- FR-006: Second map forageable master data must expose whale season forageables so admins can place them.

## Non-Functional Requirements

- NFR-001: Existing public map URLs continue to work without `mapKey`.
- NFR-002: Admin-only write permissions remain controlled by existing security rules.

## Edge Cases

- If `mapKey` is omitted, use `town`.
- If a forageable has no `mapKey`, treat it as belonging to `town` unless mapped from whale season API logic.
- If the DB migration is not applied, code deploy alone is insufficient for second map pin persistence.

## Data Requirements

- `map_pins.map_key VARCHAR(50) NOT NULL DEFAULT 'town'`
- `location_zones.map_key VARCHAR(50) NOT NULL DEFAULT 'town'` for future separate zone data
- Whale season forageables: 미역, 바다 아스파라거스, 바다 포도

## Clarifications

- Q: Should pins from the first map appear on the second map?
  A: No. Only `mapKey=second` pins should appear there.

## Review Checklist

- [x] 요구사항이 사용자 관점으로 설명되어 있다.
- [x] 성공 기준이 측정 가능하다.
- [x] 비목표가 명확하다.
- [x] 모호한 표현이 Assumptions 또는 Clarifications에 기록되어 있다.
- [x] 구현 방법이 과하게 먼저 정해지지 않았다.
