# Feature Spec: 6시간 단위 관리자 날씨 예약

## Source

- PRD: `specs/050-admin-weather-schedule/prd.md`
- Principles: `specs/principles.md`

## User Scenarios

### Scenario 1: 시간대별 예약 확인

- Given 한 날짜의 네 구간에 서로 다른 날씨가 예약되어 있다.
- When 방문자가 날씨 상세 패널을 연다.
- Then 현재 구간부터 다섯 구간의 날짜·시각과 각 예약 날씨가 표시된다.

### Scenario 2: 일간 대표 날씨

- Given 하루에 맑음, 비, 유성우가 함께 있다.
- When 7일 요약을 확인한다.
- Then 대표 날씨는 유성우로 표시된다.

### Scenario 3: 관리자 정정

- Given 관리자가 날씨 예약 화면에 접근했다.
- When 날짜, 시작 시각, 날씨를 저장한다.
- Then 같은 날짜·시각 행이 생성되거나 기존 행이 갱신된다.

### Scenario 4: 일일 자원과 분리

- Given 날씨 테이블이 아직 없거나 비어 있다.
- When 일일 자원 위치를 저장하고 조회한다.
- Then 일일 자원 기능은 날씨 컬럼을 요구하지 않고 정상 동작한다.

## Functional Requirements

- FR-001: `weather_schedules`는 날짜, 슬롯 시각, 날씨 코드, 원본 시간별 ID, 활성 상태를 저장해야 한다.
- FR-002: 날짜와 슬롯 시각 조합은 유일해야 한다.
- FR-003: 슬롯 시각은 `0, 6, 12, 18`만 허용해야 한다.
- FR-004: 허용 날씨 코드는 `SUNNY`, `RAIN`, `RAINBOW`, `METEOR_SHOWER`, `HEATWAVE`, `SNOW`, `AURORA`다.
- FR-005: 관리자는 예약을 목록 조회, upsert, 비활성 삭제할 수 있어야 한다.
- FR-006: 공개 상세 예보는 현재 6시간 구간부터 다섯 구간을 반환해야 한다.
- FR-007: 공개 일간 예보는 다음 날부터 일곱 날짜를 반환해야 한다.
- FR-008: 일간 대표는 코드 우선순위로 선택해야 한다.
- FR-009: 사용자 날씨 제보 UI와 POST API는 제공하지 않아야 한다.
- FR-010: 200일 seed는 재실행해도 같은 800행을 유지해야 한다.
- FR-011: 헤더의 관리자 편집 링크는 날씨 전용 관리 화면으로 이동해야 한다.

## Non-Functional Requirements

- NFR-001: 상세 및 7일 요약에 필요한 범위는 한 번의 범위 쿼리로 읽는다.
- NFR-002: 공개 API 오류는 HTML 성공 응답으로 위장하지 않고 JSON 5xx로 응답해야 한다.
- NFR-003: 관리 변경 경로는 기존 `/wiki/admin/**` 보안 규칙으로 관리자만 접근해야 한다.
- NFR-004: 기존 날씨 패널 레이아웃과 모바일 동작을 유지해야 한다.

## Edge Cases

- 자정 이후 슬롯은 이전 게임 날짜가 아니라 해당 달력 날짜의 `0시` 예약을 사용한다.
- 날짜·시각 예약이 없으면 해당 상세 구간은 `EMPTY`다.
- 하루 네 구간이 모두 비어 있으면 일간 결과도 `EMPTY`다.
- 같은 우선순위라면 더 이른 슬롯의 날씨를 선택한다.
- 눈과 오로라는 이미지가 없어도 텍스트와 대체 아이콘으로 구분돼야 한다.
- 소프트 삭제한 행을 다시 저장하면 활성 상태로 복구해야 한다.

## Data Requirements

- 테이블: `weather_schedules`
- 유일 키: `(forecast_date, slot_hour)`
- 조회 인덱스: `(forecast_date, is_active)`
- seed 범위: `2026-09-08`부터 `2027-03-26`까지 800행
- 원본 추적: 각 6시간 구간의 HeartoCast `weatherId` 6개를 `source_weather_ids`에 보존
- 기존 `weather_votes`, `weather_vote_history`: 삭제하지 않음

## Clarifications

- Q: 날씨와 일일 자원 위치를 같은 화면에서 관리하는가?
  A: 아니다. 날씨 전용 화면과 테이블을 사용한다.
- Q: 시간 단위는 무엇인가?
  A: 달력 날짜 기준 6시간이며 시작 시각은 0, 6, 12, 18시다.
- Q: 일간 대표 우선순위는 무엇인가?
  A: 검증된 주요 순서는 `RAINBOW > METEOR_SHOWER > RAIN > SUNNY`이며 눈·오로라는 일반 맑음보다 우선 표시한다.

## Review Checklist

- [x] 요구사항이 사용자 관점으로 설명되어 있다.
- [x] 성공 기준이 측정 가능하다.
- [x] 비목표가 명확하다.
- [x] 모호한 표현이 Clarifications에 기록되어 있다.
- [x] 구현 방법이 과하게 먼저 정해지지 않았다.
