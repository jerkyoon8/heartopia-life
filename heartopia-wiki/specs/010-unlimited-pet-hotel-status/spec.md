# Feature Spec: 반려동물 호텔 체크 개수 제한 제거

## Source

- PRD: `specs/010-unlimited-pet-hotel-status/prd.md`
- Principles: `specs/principles.md`

## User Scenarios

### Scenario 1: 여섯 번째 이상 호텔 상태 기록

- Given 다섯 마리의 반려동물이 이미 호텔 상태다.
- When 사용자가 다른 반려동물도 호텔 상태로 체크한다.
- Then 개수 오류 없이 상태가 저장되고 호텔 표시가 적용된다.

### Scenario 2: 잘못된 호텔 상태 차단

- Given API 요청의 `inHotel` 값이 문자열 또는 숫자다.
- When 서버가 프로필을 저장하려 한다.
- Then 유효성 검사 오류로 저장을 거부한다.

## Functional Requirements

- FR-001: 클라이언트는 호텔 상태의 `true` 개수를 세거나 체크를 차단하지 않아야 한다.
- FR-002: 서버는 호텔 상태의 `true` 개수를 제한하지 않아야 한다.
- FR-003: 서버는 `inHotel` 필드가 존재하면 값이 `Boolean`인지 검증해야 한다.
- FR-004: 클라이언트는 불러온 값이 엄격히 `true`일 때만 호텔 상태로 정규화해야 한다.
- FR-005: 전체 프로필 최대 20개와 기존 프로필 필드 검증은 유지해야 한다.
- FR-006: 화면에는 `게임 내 캐릭터당 호텔 정원은 5마리`라는 안내를 제공해야 한다.

## Non-Functional Requirements

- NFR-001: API payload와 DB 스키마를 변경하지 않는다.
- NFR-002: 잘못된 타입 검증의 오류 메시지와 HTTP 처리 흐름을 유지한다.

## Edge Cases

- 모든 프로필 20개가 호텔 상태여도 저장할 수 있다.
- `inHotel` 필드가 없는 과거 프로필은 기존처럼 호텔 미입실로 처리한다.
- `false`는 유효하며 호텔 체크 해제로 저장한다.

## Data Requirements

- `inHotel`: 선택적 불리언
- 저장 가능한 프로필 총개수: 기존과 동일하게 최대 20개
- 호텔 상태 프로필 개수: 별도 제한 없음

## Clarifications

- Q: 어떤 검증을 유지하는가?
  A: `inHotel` 불리언 타입, 허용 필드, ID·이름·종류, 먹이 상태, 전체 프로필 개수 검증을 유지한다.
- Q: 게임 내 5마리 규칙은 어떻게 처리하는가?
  A: 사용자 안내로만 표시하고 위키 저장을 차단하지 않는다.

## Review Checklist

- [x] 요구사항이 사용자 관점으로 설명되어 있다.
- [x] 성공 기준이 측정 가능하다.
- [x] 비목표가 명확하다.
- [x] 모호한 표현이 Assumptions 또는 Clarifications에 기록되어 있다.
- [x] 구현 방법이 과하게 먼저 정해지지 않았다.
