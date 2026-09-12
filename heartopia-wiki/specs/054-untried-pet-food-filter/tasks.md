# Tasks: 안 먹여본 음식 필터

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 기존 필터·저장·렌더링 구조 확인
  Files: `src/main/resources/templates/wiki/others/pets.html`
  Verify: 로그인 여부와 무관하게 `pet.tried`를 사용하는 공통 렌더링 경로 확인

## Phase 2: Tests

- [x] T002 [P] 안 먹여본 음식 버튼과 필터 분기 템플릿 테스트 추가
  Files: `src/test/java/com/heartopia/wiki/template/PetManagementTemplateTest.java`
  Verify: 구현 전 대상 테스트 실패 확인

- [x] T003 [P] 실제 화면 필터 E2E 테스트 추가
  Files: `e2e/pet-food-untried-filter.spec.js`
  Verify: 미시도 목록·검색 교차 적용·체크 후 제거 시나리오 정의

## Phase 3: Implementation

- [x] T004 안 먹여본 음식 필터 버튼과 조건 추가
  Files: `src/main/resources/templates/wiki/others/pets.html`
  Verify: 대상 템플릿 테스트 통과

## Phase 4: Polish

- [x] T005 전체 테스트와 로컬 브라우저 검증
  Files: 위 변경 파일
  Verify: Gradle 전체 테스트 및 Playwright 대상 테스트 통과

## Completion Notes

- Tests run: `gradlew.bat test` 성공, Playwright 대상 E2E 2건 성공
- Known risks: 없음
- Follow-up: 운영 반영과 Git push는 사용자 확인 후 별도 진행
