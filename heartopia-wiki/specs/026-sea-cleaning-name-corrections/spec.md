# Feature Spec: 바다청소 이름 일괄 변경

## Source

- PRD: `specs/026-sea-cleaning-name-corrections/prd.md`
- Principles: `specs/principles.md`

## User Scenarios

### Scenario 1: 이름 교정 후 체크 상태 유지

- Given 기존 이름으로 별점 또는 명인 상태를 저장한 사용자가 있을 때
- When 관리자가 바다청소 이름 6개를 변경한다
- Then 화면에는 새 이름이 표시되고 체크 상태는 ID 키로 유지된다.

### Scenario 2: 운영 데이터 불일치 방지

- Given 운영 DB의 ID와 기존 이름이 예상값과 다를 수 있을 때
- When 이름 변경 SQL을 실행한다
- Then 사전 조건이 정확히 6건일 때만 변경하며 그렇지 않으면 오류로 롤백한다.

## Functional Requirements

- FR-001: SQL은 ID 1, 6, 8, 10, 11, 14와 각각의 기존 이름을 함께 검증해야 한다.
- FR-002: SQL은 검증된 6개 행의 `name`만 CASE 식으로 변경해야 한다.
- FR-003: SQL은 `legacy_checklist_name`을 수정하지 않아야 한다.
- FR-004: SQL은 새 이름이 기존 다른 행과 충돌하는지 실행 전에 검사해야 한다.
- FR-005: 사전 조건이 하나라도 다르면 단일 UPDATE는 0건만 갱신하고 부분 변경을 만들지 않아야 한다.
- FR-006: SQL은 실행 후 ID, 새 이름, 레거시 별칭을 조회해 검증해야 한다.

## Non-Functional Requirements

- NFR-001: MySQL 8.0에서 실행 가능해야 한다.
- NFR-002: 반복 실행 시 이미 변경된 상태를 식별할 수 있어야 한다.
- NFR-003: 비밀번호나 운영 접속 정보를 SQL 파일에 포함하지 않아야 한다.

## Edge Cases

- 운영 ID가 다르거나 기존 이름이 하나라도 다르면 갱신 건수가 0이 된다.
- 새 이름이 다른 바다청소 행에 이미 있으면 갱신 건수가 0이 된다.
- 이미 전체 변경이 완료된 상태에서는 검증 조회로 상태를 확인하고 UPDATE를 재실행하지 않는다.

## Data Requirements

- 변경 매핑: 1→손상된 바닷조개, 6→개굴잠쟁이, 8→프로라 텔린조개, 10→크로세아 클램, 11→무명올각시실꼬리고둥, 14→노빌리스 두순고둥.
- 기존 이름: 손상된 조개껍데기, 은빛 대합, 뱃머리 벚꽃조개, 사프란 대왕조개, 가는줄갯고둥, 등롱 화염고둥.
- 레거시 별칭은 위 기존 이름을 유지한다.

## Clarifications

- Q: `샤프란 대왕조개`를 기존 이름 조건으로 사용하는가?
  A: 아니오. DB에서 확인된 실제 기존 이름 `사프란 대왕조개`와 ID 10을 사용한다.

## Review Checklist

- [x] 요구사항이 사용자 관점으로 설명되어 있다.
- [x] 성공 기준이 측정 가능하다.
- [x] 비목표가 명확하다.
- [x] 모호한 표현이 Assumptions 또는 Clarifications에 기록되어 있다.
- [x] 구현 방법이 과하게 먼저 정해지지 않았다.
