# Feature Spec: 헤더 도감 메가 메뉴 확장

## Source

- PRD: `specs/016-header-mega-navigation/prd.md`
- Principles: `specs/principles.md`

## User Scenarios

### Scenario 1: 전체 분류 탐색

- Given 데스크톱에서 공통 헤더가 보인다.
- When 사용자가 `도감` 메뉴에 마우스를 올린다.
- Then `도감`, `취미`, `기타정보` 세 구역과 각 링크가 동시에 표시된다.

### Scenario 2: 메가 메뉴 링크 이동

- Given 메가 메뉴가 열려 있다.
- When 사용자가 항목 하나를 클릭한다.
- Then 해당 기존 페이지 라우트로 이동한다.

## Functional Requirements

- FR-001: 상단 트리거 문구는 `도감`이어야 한다.
- FR-002: 트리거 또는 메가 메뉴에 포인터가 있는 동안 메뉴가 열려 있어야 한다.
- FR-003: 도감 구역은 물고기, 곤충, 새, 동물을 제공해야 한다.
- FR-004: 취미 구역은 요리, 작물, 꽃, 채집물을 제공해야 한다.
- FR-005: 기타정보 구역은 주민들, 모래 조각, 바다 청소, 반려동물을 제공해야 한다.
- FR-006: 각 항목은 현재 존재하는 `/wiki/**` 경로를 사용해야 한다.

## Non-Functional Requirements

- NFR-001: 992px 이상 화면에서 세 열로 균등하게 표시해야 한다.
- NFR-002: 기존 991px 이하 모바일 동작과 날씨 영역을 변경하지 않아야 한다.

## Edge Cases

- 트리거에서 메뉴로 포인터가 이동할 때 hover 영역이 끊기지 않아야 한다.
- 다크 모드에서도 기존 CSS 변수를 사용해 글자와 배경 대비를 유지해야 한다.

## Data Requirements

- 없음

## Clarifications

- Q: `다 나온다`의 범위는 무엇인가?
  A: 현재 구현되어 있고 이전 메가 메뉴에서 제공하던 도감·취미·기타정보 4개씩, 총 12개 링크로 한정한다.

## Review Checklist

- [x] 요구사항이 사용자 관점으로 설명되어 있다.
- [x] 성공 기준이 측정 가능하다.
- [x] 비목표가 명확하다.
- [x] 모호한 표현이 Clarifications에 기록되어 있다.
- [x] 구현 방법이 과하게 먼저 정해지지 않았다.
