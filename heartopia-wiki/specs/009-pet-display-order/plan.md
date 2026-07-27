# Implementation Plan: 반려동물 표시 순서 조정

## Context

- Spec: `specs/009-pet-display-order/spec.md`
- Target branch: current working branch
- Current codebase notes:
  - 반려동물은 `state.pets` 배열 순서대로 렌더링된다.
  - 로컬 저장과 서버 JSON 저장 모두 배열 순서를 보존한다.
  - 서버 저장 요청은 `saveQueue`로 직렬화되어 있다.
  - 기존 반려동물 템플릿에 이름 수정·호텔 기능의 미커밋 사용자 변경이 있으므로 해당 코드 위에 최소 변경으로 추가한다.

## Approach

선택 상세 툴바에 좌우 이동 버튼 두 개를 추가한다. 공통 `moveSelectedPet(offset)` 함수가 현재 인덱스와 인접 인덱스를 교환한 뒤 기존 저장·렌더링 흐름을 호출한다. `renderSelectedPet()`에서 현재 위치에 따라 버튼의 `disabled` 상태를 갱신한다.

## Impacted Files

- `src/main/resources/templates/wiki/others/pets.html`: 이동 버튼, 스타일, 이벤트 바인딩, 배열 이동 및 경계 상태 렌더링
- `src/test/java/com/heartopia/wiki/template/PetManagementTemplateTest.java`: 이동 컨트롤과 저장 동작 계약 검증
- `specs/009-pet-display-order/*.md`: 요구사항과 작업 기록

## Data Model

- 변경 없음. 기존 프로필 JSON 배열 순서만 변경한다.

## API Or Interface Changes

- API 변경 없음.
- DOM ID: `movePetLeftBtn`, `movePetRightBtn`
- JavaScript 함수: `moveSelectedPet(offset)`

## Validation And Error Handling

- 선택 항목을 찾지 못하거나 목표 인덱스가 범위를 벗어나면 즉시 반환한다.
- 버튼 비활성화 상태와 함수 내부 경계 검사를 모두 적용한다.

## Test Plan

- 템플릿 계약 테스트로 버튼 ID, 이벤트 연결, 배열 교환, 저장·렌더링 호출과 경계 비활성화를 확인한다.
- `gradlew.bat test`로 전체 회귀 테스트를 실행한다.

## Risks And Mitigations

- 기존 템플릿 변경과 충돌: 해당 위치만 작은 패치로 수정하고 주변 사용자 코드를 보존한다.
- 버튼 클릭 후 선택이 풀릴 가능성: `selectedPetId`는 건드리지 않고 배열 요소만 교환한다.

## Alternatives Considered

- 드래그 앤 드롭: 모바일 접근성, 키보드 조작 및 구현 복잡도가 커서 이번 요구 범위를 넘어선다.
- 각 카드 내부 화살표: 중첩 버튼 마크업 문제가 생기므로 선택 상세 툴바의 독립 버튼을 사용한다.
- 별도 `sortOrder` 필드: 기존 배열 자체가 순서를 보존하므로 불필요한 데이터 변경이다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
