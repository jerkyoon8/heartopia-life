# PRD: 업적 수집 항목 숨김 우선순위 수정

## 1. Summary

### Problem

업적에서 달성한 항목을 숨기도록 설정해도, 전역 수집도감 별점 기준치가 1~5로 설정되어 있으면 달성 값 `0`이 기준치보다 낮다고 처리되어 항목이 계속 노출된다.

### Proposed Solution

항목이 별점 기능을 지원하는지 먼저 판정한다. 별점이 없는 업적은 수집 여부만으로 숨기고, 별점이 있는 수집도감에만 설정된 기준치를 후적용한다.

### Success Criteria

- 별점 기준치가 1~5여도 달성한 업적 카드는 숨겨진다.
- 업적 테이블 보기에서도 달성한 행이 숨겨진다.
- 별점이 있는 도감의 `N성 이상 숨김` 동작은 그대로 유지된다.

## 2. Users And Use Cases

### Primary Users

- 업적 달성 상태와 수집도감 별점 상태를 함께 관리하는 사용자

### User Stories

- As a wiki user, I want completed achievements to stay hidden regardless of the collection star threshold, so that only unfinished achievements remain visible.

## 3. Functional Scope

### In Scope

- 업적 카드와 테이블 행을 별점 미지원 항목으로 명시한다.
- 공용 숨김 판정에서 별점 지원 여부를 기준치보다 먼저 적용한다.
- 해당 조합을 검증하는 JavaScript 회귀 테스트를 추가한다.

### Out Of Scope

- 별점 기준치 설정 UI 변경
- 체크리스트 저장 형식 또는 서버 API 변경
- 업적 카테고리 필터 구조 변경

## 4. Acceptance Criteria

- `wikiHideThreshold`가 `3`이고 업적 값이 `0`이면 숨김 대상으로 판정한다.
- 별점 지원 항목 값이 `0`이면 같은 조건에서 노출하고, 값이 `3` 이상이면 숨긴다.
- 미수집 항목은 별점 지원 여부와 무관하게 노출한다.
- 업적 카드와 테이블 행 모두 동일한 저장 키와 별점 미지원 표식을 가진다.

## 5. Constraints

- Tech: 기존 `WikiFilter`, `ChecklistCore`, Thymeleaf 데이터 속성을 재사용한다.
- Time: 현재 버그 수정 범위로 제한한다.
- Data: 기존 체크 값 `0`과 별점 값 `1~5` 형식을 변경하지 않는다.
- External Dependencies: 없음.

## 6. Risks

- 공용 필터 회귀: 판정을 순수 함수로 분리하고 별점 지원/미지원 조합을 테스트한다.
- 테이블 보기 상태 불일치: 업적 행에도 카드와 같은 동기화 키를 제공한다.

## 7. Open Questions

- 없음. 업적은 별점 미지원이며, 수집도감 기준치는 업적에 적용하지 않는 것으로 확정한다.
