# Tasks: 반려동물 표시 순서 조정

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 현재 배열 렌더링, 로컬 저장, 서버 저장의 순서 보존 방식을 확인한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`, `src/main/java/com/heartopia/wiki/service/UserPetFoodService.java`
  Verify: `state.pets` 배열이 그대로 렌더링·직렬화됨을 확인

## Phase 2: Tests

- [x] T002 이동 버튼과 배열 교환·저장 계약을 검증하는 템플릿 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/template/PetManagementTemplateTest.java`
  Verify: 구현 전 신규 계약 테스트 실패, 구현 후 통과

## Phase 3: Implementation

- [x] T003 선택 상세 툴바에 좌우 이동 컨트롤과 반응형 스타일을 추가한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`
  Verify: 버튼 ID, 레이블, disabled 스타일 확인

- [x] T004 선택 항목 배열 이동, 경계 처리, 저장 및 재렌더링을 구현한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`
  Verify: 신규 템플릿 테스트 통과

## Phase 4: Polish

- [x] T005 전체 테스트와 변경 범위 검토를 수행한다.
  Files: `specs/009-pet-display-order/tasks.md`
  Verify: `gradlew.bat test`, `git diff --check`

## Completion Notes

- Tests run: `gradlew.bat test` — 55개 통과, 실패 0개
- Known risks: 없음
- Follow-up: 배포 후 로컬·로그인 동기화 모드에서 새로고침 순서 유지 확인
