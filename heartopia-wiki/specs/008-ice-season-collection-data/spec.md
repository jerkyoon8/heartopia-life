# Feature Spec: 빙설 시즌 도감 데이터 추가

## Source

- PRD: `specs/008-ice-season-collection-data/prd.md`
- Principles: `specs/principles.md`

## User Scenarios

### Scenario 1: 이벤트별 전체 항목 조회

- Given 빙설 시즌 데이터 SQL이 적용되어 있다.
- When 사용자가 각 도감에서 `빙설 시즌` 이벤트를 선택한다.
- Then 해당 종류의 빙설 시즌 항목이 이름, 이미지, 상세 정보와 함께 표시된다.

### Scenario 2: 등급별 판매가 확인

- Given 사용자가 빙설 시즌 항목 카드를 보고 있다.
- When 1성부터 5성까지의 가격 영역을 확인한다.
- Then 원본 가격 규칙 또는 사용자 확정값에 따른 다섯 가격이 빠짐없이 표시된다.

### Scenario 3: 요리 재료 확인

- Given 사용자가 빙설 시즌 요리 항목을 보고 있다.
- When 재료 정보를 확인한다.
- Then 중복 재료는 수량으로 합산된 조리 재료 목록이 표시된다.

## Functional Requirements

- FR-001: 시스템은 취미를 제외한 빙설 시즌 27종을 여섯 도감 테이블에 저장해야 한다.
- FR-002: 모든 행은 `event_name = '빙설 시즌'`이어야 한다.
- FR-003: 모든 행은 `price_1`부터 `price_5`까지 값을 가져야 한다.
- FR-004: 무는 레벨 1, 성장 시간 15분, 씨앗 구매가 10원, 판매가 30/45/60/120/240이어야 한다.
- FR-005: 히말라야양귀비는 레벨 1, 성장 시간 1일, 씨앗 구매가 100원, 판매가 100/150/200/400/800이어야 한다.
- FR-006: 요리 10종은 원본 재료와 합산 수량을 `ingredients` 및 `cooking_ingredients`에 저장해야 한다.
- FR-007: 새·곤충·물고기는 원본의 레벨, 출현 장소, 상시 시간·날씨 및 종류·크기를 현재 스키마에 맞춰 저장해야 한다.
- FR-008: 27종의 `image_url`은 저장소 안의 WebP 정적 리소스를 가리켜야 한다.
- FR-009: 데이터 SQL은 동일 이름의 기존 대상 행과 요리 재료를 정리한 후 재삽입하여 반복 실행 가능해야 한다.

## Non-Functional Requirements

- NFR-001: SQL은 MySQL 8.0 및 `utf8mb4` 실행을 전제로 한다.
- NFR-002: 기존 수정 파일과 관계없는 리팩터링을 하지 않는다.
- NFR-003: 정적 이미지 파일명은 기존 종류별 디렉터리 관례를 따른다.

## Edge Cases

- 동일 이름의 빙설 시즌 데이터가 이미 있으면 대상 행만 교체하고 다른 이벤트나 일반 항목은 보존한다.
- 요리 행을 교체하기 전에 연결된 `cooking_ingredients`를 먼저 삭제해 외래 키 오류를 막는다.
- 원본 새 가격은 2성 기준이므로 1성 가격은 내림 처리하고 3~5성은 2/4/8배로 계산한다.
- `갈은 무와 스테이크`는 사용자 입력의 `같은 무와 스테이크` 대신 원본 데이터의 정식 명칭을 사용한다.
- `오리지널 슈가파우더 팬케이크` 재료는 원본 JSON에 기재된 블루베리를 그대로 사용한다.

## Data Requirements

- 대상 테이블: `crop_collections`, `flower_collections`, `cooking_collections`, `cooking_ingredients`, `bird_collections`, `bug_collections`, `fish_collections`
- 원본: Polaris6000 Heartopia 빙설 시즌 JSON과 WebP 이미지
- 히말라야양귀비: 사용자 확정 성장·가격 데이터와 `C:\Users\k\Desktop\user_kit\flowers\flowers\히말라야양귀비.webp`
- 삭제 정책: SQL 재실행 시 이름과 이벤트명이 모두 일치하는 이번 대상 데이터만 교체

## Clarifications

- Q: 히말라야양귀비의 누락 데이터와 이미지는 무엇을 사용하는가?
  A: 성장 시간 1일, 씨앗 구매가 100원, 판매가 100/150/200/400/800과 사용자가 제공한 WebP를 사용한다.
- Q: 취미 `눈 조각`도 포함하는가?
  A: 포함하지 않는다.
- Q: 기존 스키마에 없는 요리 체력 회복량도 새 필드로 추가하는가?
  A: 이번 범위는 현재 도감이 지원하는 상세 정보 전체이며 신규 스키마 필드는 추가하지 않는다.

## Review Checklist

- [x] 요구사항이 사용자 관점으로 설명되어 있다.
- [x] 성공 기준이 측정 가능하다.
- [x] 비목표가 명확하다.
- [x] 모호한 표현이 Assumptions 또는 Clarifications에 기록되어 있다.
- [x] 구현 방법이 과하게 먼저 정해지지 않았다.
