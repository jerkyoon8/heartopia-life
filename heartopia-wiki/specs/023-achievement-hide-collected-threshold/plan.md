# Implementation Plan: 업적 수집 항목 숨김 우선순위 수정

## Context

- Spec: `specs/023-achievement-hide-collected-threshold/spec.md`
- Target branch: `main`
- Current codebase notes:
  - `WikiFilter._matchesElement`는 기준치가 1 이상이면 체크 값이 숫자이고 기준치 이상일 때만 숨긴다.
  - 업적의 체크 버튼은 별점 UI가 없지만 다른 도감과 동일하게 값 `0`을 저장한다.
  - 업적 카드에는 동기화 키가 있으나 테이블 행에는 동기화 키가 없다.
  - `achievements.html`의 기존 미커밋 캐시 버전 변경은 보존해야 한다.

## Approach

숨김 판정을 순수 함수로 분리하여 `수집 여부 -> 별점 지원 여부 -> 기준치` 순으로 평가한다. 업적 카드와 행에는 별점 미지원 표식을 추가하고, 행에도 체크리스트 키를 제공한다. 기존 Node 테스트 파일에서 별점 지원/미지원 조합을 검증한다.

## Impacted Files

- `src/main/resources/static/js/wiki-filter.js`: 별점 지원 여부를 선제 판정하는 숨김 함수 추가 및 공용 필터 연결.
- `src/main/resources/templates/wiki/others/achievements.html`: 카드/행 별점 미지원 표식과 행 동기화 키 추가. 기존 변경 보존.
- `src/test/js/wiki-filter-event.test.js`: 업적과 별점 도감의 숨김 기준 회귀 테스트 추가.
- `specs/023-achievement-hide-collected-threshold/*.md`: 요구사항, 설계, 작업 및 검증 기록.

## Data Model

- DB 및 저장 형식 변경 없음.
- DOM 계약으로 `data-supports-star-rating="false"`를 업적 요소에 추가한다. 속성이 없는 기존 도감 요소는 별점 지원으로 간주한다.

## API Or Interface Changes

- `wikiShouldHideCollected({ isCollected, checklistValue, threshold, supportsStarRating })` 순수 함수를 CommonJS 테스트 내보내기에 추가한다.
- 서버 API 변경 없음.

## Validation And Error Handling

- 수집되지 않은 항목은 항상 숨기지 않는다.
- 별점 미지원 수집 항목은 기준치와 무관하게 숨긴다.
- 별점 지원 항목은 유효한 양수 기준치에서 숫자 값만 비교한다.
- 기준치가 `0`, 누락 또는 유효하지 않으면 기존 기본값처럼 모든 수집 항목을 숨긴다.

## Test Plan

- 수정 전 새 Node 테스트가 실패하는지 확인한다.
- 수정 후 `node --test src/test/js/wiki-filter-event.test.js`를 실행한다.
- `node --check src/main/resources/static/js/wiki-filter.js`를 실행한다.
- 전체 `gradlew.bat test`와 `git diff --check`를 실행한다.
- 템플릿 정적 테스트로 업적 카드와 행의 데이터 계약을 검증한다.

## Risks And Mitigations

- 공용 필터 동작 변경 위험: 순수 함수 입력 조합 테스트와 기존 전체 테스트를 함께 실행한다.
- 사용자 미커밋 변경 충돌: 대상 템플릿의 기존 버전 변경은 수정하지 않고 필요한 속성만 추가한다.

## Alternatives Considered

- 업적 키 접두사 `achievement_`를 코드에서 직접 검사: 새 별점 미지원 유형마다 조건이 늘어나므로 채택하지 않는다.
- DOM에서 별 아이콘을 검색: 테이블 행에는 별 아이콘이 없어 별점 도감 행까지 잘못 판정할 수 있어 채택하지 않는다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
