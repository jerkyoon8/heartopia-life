# Feature Spec: 바다청소 시즌 제외 및 레벨 필터 확장

## Source

- PRD: `specs/025-sea-cleaning-season-removal/prd.md`
- Principles: `specs/principles.md`

## User Scenarios

### Scenario 1: 바다청소 전체 기본 조회

- Given 바다청소 행에 과거 이벤트명이 저장되어 있어도
- When 사용자가 바다청소 페이지를 연다
- Then 이벤트 선택 없이 전체 항목이 필터 대상에 포함된다.

### Scenario 2: 고레벨 바다청소 필터링

- Given Lv.7 및 Lv.8 바다청소 항목이 존재할 때
- When 사용자가 레벨 필터를 연다
- Then Lv.7과 Lv.8을 선택해 해당 항목만 조회할 수 있다.

### Scenario 3: 관리자 데이터 저장

- Given 관리자가 바다청소를 추가하거나 수정할 때
- When 저장 요청이 처리된다
- Then 시즌 입력 없이 저장되고 수정 대상의 기존 이벤트 값은 NULL이 된다.

## Functional Requirements

- FR-001: 시스템은 바다청소 페이지에 빠른 이벤트 필터와 상세 이벤트 필터를 렌더링하지 않아야 한다.
- FR-002: 시스템은 바다청소 카드와 테이블 행을 이벤트 값으로 필터링하지 않아야 한다.
- FR-003: 시스템은 바다청소 관리자 폼에서 이벤트 입력을 제공하지 않아야 한다.
- FR-004: 시스템은 바다청소 INSERT에 `event_name` 값을 저장하지 않고 UPDATE 시 `event_name=NULL`을 보장해야 한다.
- FR-005: 시스템은 전역 이벤트 후보를 만들 때 `sea_cleaning_collections`를 조회하지 않아야 한다.
- FR-006: 시스템은 기존 바다청소 행의 모든 `event_name`을 NULL로 바꾸는 반복 실행 가능한 SQL을 제공해야 한다.
- FR-007: 시스템은 바다청소 레벨 필터에 1부터 8까지의 선택지를 제공해야 한다.

## Non-Functional Requirements

- NFR-001: 기존 바다청소 ID 체크리스트 키와 레거시 키 이전 동작을 보존해야 한다.
- NFR-002: 다른 도감의 이벤트 필터와 이벤트 저장 동작에 영향을 주지 않아야 한다.

## Edge Cases

- DB 정리 SQL을 아직 실행하지 않은 환경에서도 화면은 이벤트 값을 사용하지 않으므로 전체 항목을 표시한다.
- Lv.7 또는 Lv.8 데이터가 없는 환경에서도 필터 선택지는 유지되며 결과 없음 상태가 정상 표시된다.
- 수정 전 행에 이벤트 값이 남아 있으면 해당 행을 수정하는 시점에 NULL로 정리된다.

## Data Requirements

- `sea_cleaning_collections.event_name` 컬럼은 삭제하지 않는다.
- 기존 값은 `UPDATE sea_cleaning_collections SET event_name = NULL WHERE event_name IS NOT NULL` 형태로 정리한다.
- 검증 결과는 `event_name IS NOT NULL`인 행이 0건이어야 한다.

## Clarifications

- Q: 바다청소의 공용 `event_name` 컬럼 자체를 삭제하는가?
  A: 아니오. 스키마 호환성을 위해 남기되 바다청소 기능에서는 사용하지 않는다.
- Q: 운영 서버가 정상인 이유는 무엇인가?
  A: 운영 페이지에는 현재 이벤트 필터가 배포되지 않았고 전체 항목을 렌더링한다. 로컬의 공통 이벤트 필터 추가와 로컬 DB의 `고래 시즌` 값이 결합되어 문제가 드러났다.

## Review Checklist

- [x] 요구사항이 사용자 관점으로 설명되어 있다.
- [x] 성공 기준이 측정 가능하다.
- [x] 비목표가 명확하다.
- [x] 모호한 표현이 Assumptions 또는 Clarifications에 기록되어 있다.
- [x] 구현 방법이 과하게 먼저 정해지지 않았다.
