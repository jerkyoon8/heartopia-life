# Implementation Plan: 도감 시간 필터 카드·표 결과 일치

## Context

- Spec: `specs/006-collection-time-filter-table-sync/spec.md`
- Target branch: current working branch
- Current codebase notes:
  - 공통 `WikiFilter`는 카드와 표 행을 각각 `_matchesFilters`로 검사한다.
  - 시간 값은 각 요소의 `data-time`에서 읽는다.
  - 카드에는 곤충·새 모두 `data-time`이 있으나 표 행에는 누락되어 있다.
  - 물고기 표 행에는 이미 같은 형태의 `data-time`이 있다.
  - 시간 겹침은 반개구간 비교(`<`)를 사용해 경계만 맞닿는 구간을 제외한다.

## Approach

물고기 도감의 기존 패턴을 따라 곤충과 새 표 행에 `th:data-time`을 추가한다. 공통 필터 로직이나 데이터 모델은 변경하지 않는다. 템플릿 계약 테스트를 추가해 카드에는 있고 표에는 빠지는 회귀를 방지한다.

## Impacted Files

- `src/main/resources/templates/wiki/collections/bug.html`: 곤충 표 행에 `bug.time` 연결
- `src/main/resources/templates/wiki/collections/bird.html`: 새 표 행에 `bird.time` 연결
- `src/test/java/com/heartopia/wiki/template/CollectionTimeFilterTemplateTest.java`: 표 행의 시간 데이터 속성 회귀 테스트
- `specs/006-collection-time-filter-table-sync/tasks.md`: 작업 및 검증 상태 기록

## Data Model

- 변경 없음. 기존 `BugCollection.time`, `BirdCollection.time`을 사용한다.

## API Or Interface Changes

- 외부 API 변경 없음.
- 렌더링된 곤충·새 표 행에 `data-time` HTML 속성이 추가된다.

## Validation And Error Handling

- Thymeleaf가 기존 모델의 `time` 값을 그대로 렌더링하므로 별도 입력 검증이나 오류 처리는 추가하지 않는다.
- 시간 문자열 파싱 실패 및 `상시` 처리는 기존 공통 필터 정책을 유지한다.

## Test Plan

- 템플릿 계약 테스트로 곤충·새 표 행 시작 태그 안에 각각 올바른 `th:data-time`이 있는지 검증한다.
- 물고기 표 행에도 기존 속성이 유지되는지 함께 검증한다.
- Gradle 전체 테스트를 실행한다.
- 실제 구간 계산은 현재 공통 필터의 `<` 비교를 정적 확인하여 `6~12`와 인접 구간이 겹치지 않음을 확인한다.

## Risks And Mitigations

- 템플릿 구조 변경으로 테스트가 실제 의미 없이 통과할 수 있음: 표 행 시작 태그 범위만 잘라 해당 속성을 검사한다.
- 기존 사용자 작업과 충돌할 수 있음: 현재 수정된 다른 파일을 건드리지 않고 대상 템플릿의 한 속성씩만 변경한다.

## Alternatives Considered

- 공통 필터에서 시간 값이 없는 표 행을 대응 카드와 매핑: 누락된 렌더링 계약을 숨기고 복잡도를 늘리므로 채택하지 않는다.
- 공통 시간 로직 재작성: 현재 경계 비교는 이미 올바르며 이번 원인과 무관하므로 채택하지 않는다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
