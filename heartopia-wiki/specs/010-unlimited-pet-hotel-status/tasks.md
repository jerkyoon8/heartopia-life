# Tasks: 반려동물 호텔 체크 개수 제한 제거

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 클라이언트와 서버의 호텔 개수 제한 및 별도 타입 검증 위치를 확인한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`, `src/main/java/com/heartopia/wiki/service/UserPetFoodService.java`
  Verify: 개수 제한 제거가 타입 검증에 영향을 주지 않음을 확인

## Phase 2: Tests

- [x] T002 호텔 상태 20개 허용과 잘못된 타입 거부를 검증하도록 서비스 테스트를 수정한다.
  Files: `src/test/java/com/heartopia/wiki/service/UserPetFoodServiceTest.java`
  Verify: 구현 전 20개 허용 테스트 실패, 구현 후 통과

- [x] T003 클라이언트 제한 제거와 게임 규칙 안내를 검증하는 템플릿 테스트를 수정한다.
  Files: `src/test/java/com/heartopia/wiki/template/PetManagementTemplateTest.java`
  Verify: 구현 전 신규 계약 실패, 구현 후 통과

## Phase 3: Implementation

- [x] T004 서버 호텔 개수 제한만 제거하고 불리언 타입 검증을 유지한다.
  Files: `src/main/java/com/heartopia/wiki/service/UserPetFoodService.java`
  Verify: 서비스 테스트 통과

- [x] T005 클라이언트 개수 차단을 제거하고 게임 내 정원 안내를 추가한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`
  Verify: 템플릿 테스트 통과

## Phase 4: Polish

- [x] T006 전체 테스트와 변경 범위 검토를 수행한다.
  Files: `specs/010-unlimited-pet-hotel-status/tasks.md`
  Verify: `gradlew.bat test`, `git diff --check`

## Completion Notes

- Tests run: `gradlew.bat test` — 54개 통과, 실패 0개
- Known risks: 없음
- Follow-up: 배포 후 여섯 번째 이상 호텔 체크 및 새로고침 유지 확인
