# Feature Spec: 요리 회복량 UI·영문명 참고표

## Source

- PRD: `specs/028-cooking-bilingual-recovery-ui/prd.md`
- Principles: `specs/principles.md`

## User Scenarios

### Scenario 1: 목록에서 이름과 회복량 확인

- Given 회복량이 저장된 요리
- When 방문자가 요리 목록을 연다
- Then 카드 가격 아래에 1~5성 회복량이 표시되고 이름은 기존 한글명만 유지된다.

### Scenario 2: 상세에서 등급별 회복량 확인

- Given 방문자가 요리 상세를 연다
- When 등급별 판매가 영역을 확인한다
- Then 바로 아래에서 동일한 별 순서의 회복량을 확인할 수 있다.

### Scenario 3: 미공개 회복량

- Given 원문에 숫자 회복량이 없는 요리
- When 목록 또는 상세를 연다
- Then 임의 숫자 대신 `회복량 정보 없음`이 표시된다.

### Scenario 4: 관리자 편집

- Given 관리자가 요리 수정 모달을 연다
- When 회복량을 수정해 저장한다
- Then 해당 필드가 기존 요리 데이터와 함께 갱신된다.

## Functional Requirements

- FR-001: 시스템은 요리별 nullable `recovery_1`~`recovery_5`만 저장해야 한다.
- FR-002: 시스템은 검증 CSV의 한글·영문 175개 매칭을 DB/UI 밖의 Markdown으로 생성해야 한다.
- FR-003: 시스템은 숫자가 검증된 111개 회복량만 백필하고 나머지는 NULL로 유지해야 한다.
- FR-004: 목록 카드·표·상세 이름은 기존 한글명만 표시해야 한다.
- FR-006: 목록 카드의 가격 UI 아래에 등급별 회복량 또는 빈 상태를 표시해야 한다.
- FR-007: 상세 가격 UI 아래에 등급별 회복량 또는 빈 상태를 표시해야 한다.
- FR-008: 관리자 추가/수정은 회복량 필드를 보존해야 한다.
- FR-010: 기존 한글명을 URL·체크리스트 식별자로 계속 사용해야 한다.

## Non-Functional Requirements

- NFR-001: 목록 조회는 기존 단일 SELECT를 유지하고 추가 쿼리를 발생시키지 않아야 한다.
- NFR-002: NULL 데이터 때문에 Thymeleaf 렌더링 오류가 발생하지 않아야 한다.
- NFR-003: 모바일에서 5칸 UI가 카드 폭을 넘지 않아야 한다.
- NFR-004: 기존 가격, 필터, 체크리스트 및 명인 UI를 변경하지 않아야 한다.

## Edge Cases

- 영문명은 서비스 DB와 UI에서 조회하거나 표시하지 않는다.
- 회복량 5개가 모두 NULL이면 빈 상태를 표시한다.
- 일부 회복량만 NULL이면 해당 등급은 `-`로 표시한다.
- 운영 DB의 Heartodex 미수록 요리 1개는 회복량 NULL 상태로 정상 표시한다.

## Data Requirements

- 입력 기준: `_workspace/recipe_detail_matching_results/heartodex_keepersnote_production_validation.csv`
- 저장: `cooking_collections.recovery_1`~`recovery_5`
- 외부 참고: `_workspace/recipe_detail_matching_results/cooking_name_ko_en_reference.md`
- 스키마/백필 SQL은 한 파일로 제공하며 운영 DB에는 이번 작업에서 실행하지 않는다.

## Clarifications

- Q: `전부 회복량`은 미공개 값도 추정한다는 의미인가?
  A: 데이터 무결성을 위해 1~5성 슬롯은 전부 지원하되, 원문 숫자가 없는 64개는 NULL/정보 없음으로 표시한다.
- Q: 어느 화면에 노출하는가?
  A: 사용자가 이름과 수치를 만나는 목록 카드·표·상세 화면 모두에 적용한다.

## Review Checklist

- [x] 요구사항이 사용자 관점으로 설명되어 있다.
- [x] 성공 기준이 측정 가능하다.
- [x] 비목표가 명확하다.
- [x] 모호한 표현이 Clarifications에 기록되어 있다.
- [x] 구현 방법이 요구사항과 분리되어 있다.
