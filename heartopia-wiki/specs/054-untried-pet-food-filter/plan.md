# Implementation Plan: 안 먹여본 음식 필터

## Context

- Spec: `specs/054-untried-pet-food-filter/spec.md`
- Target branch: 현재 로컬 작업 브랜치
- Current codebase notes:
  - 필터 버튼과 필터 상태, 음식 렌더링 로직이 `pets.html`에 함께 있다.
  - 기존 `matchesFoodFilter(pet, food)`가 검색 조건과 `tried`, `like`, `dislike` 분기를 처리한다.
  - 로그인·비로그인 기록 모두 렌더링 전에 같은 `state.pets` 구조로 정규화된다.

## Approach

기존 탭에 `data-filter="untried"` 버튼을 추가하고 `matchesFoodFilter`에 `!tried` 분기를 추가한다. 데이터 저장이나 API는 변경하지 않는다. 정적 템플릿 테스트로 버튼·분기를 고정하고 Playwright로 실제 필터 결과와 즉시 갱신을 확인한다.

## Impacted Files

- `src/main/resources/templates/wiki/others/pets.html`: 안 먹여본 음식 버튼과 필터 분기 추가
- `src/test/java/com/heartopia/wiki/template/PetManagementTemplateTest.java`: 템플릿 회귀 검증 추가
- `e2e/pet-food-untried-filter.spec.js`: 로컬 화면 동작 검증 추가

## Data Model

- 변경 없음. 기존 `pet.tried[food.id]`의 truthy 여부를 사용한다.

## API Or Interface Changes

- 화면 필터 값 `untried`를 추가한다.
- 서버 API 변경 없음.

## Validation And Error Handling

- 미시도 결과가 없으면 기존 빈 결과 메시지를 재사용한다.
- 반려동물 미선택 상태는 기존 비활성 화면을 유지한다.

## Test Plan

- 템플릿 테스트: 버튼 문구·필터 값·`!tried` 분기 존재 확인
- 전체 Gradle 테스트: 기존 반려동물 관리 및 다른 기능 회귀 확인
- Playwright: 로컬 저장소에 반려동물과 시도 기록을 준비하고 미시도 목록, 검색 교차 적용, 먹여봄 처리 후 즉시 제거를 확인

## Risks And Mitigations

- 기존 버튼 활성화 상태와 불일치: 공통 `.food-filter-btn` 이벤트 및 렌더링 방식을 그대로 재사용한다.
- 사용자 기록 저장에 영향: 읽기 전용 필터만 추가하고 저장 구조를 수정하지 않는다.

## Alternatives Considered

- 먹여본 음식을 목록 아래로 정렬: 미시도 음식만 보고 싶다는 요청을 충족하지 않고 목록 길이도 줄지 않아 채택하지 않는다.
- 별도 요약 카드 추가: 탐색 동선 개선에 필수적이지 않아 이번 범위에서 제외한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
