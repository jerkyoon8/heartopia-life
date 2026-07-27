# Tasks: 반려동물 이름 수정 및 호텔 상태

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 기존 프로필 저장·동기화·검증과 작업 트리 변경 조사
  Files: `src/main/resources/templates/wiki/others/pets.html`, `src/main/java/com/heartopia/wiki/service/UserPetFoodService.java`
  Verify: 프로필 JSON 확장으로 로컬·DB 저장을 함께 지원할 수 있고 기존 이미지 별칭 변경이 있음을 확인

## Phase 2: Tests

- [x] T002 서버 호텔 상태 검증 테스트 추가
  Files: `src/test/java/com/heartopia/wiki/service/UserPetFoodServiceTest.java`
  Verify: 구현 전 신규 호텔 필드가 허용되지 않아 테스트 실패

- [x] T003 템플릿 이름 편집·호텔 상태 계약 테스트 추가
  Files: `src/test/java/com/heartopia/wiki/template/PetManagementTemplateTest.java`
  Verify: 구현 전 필수 UI·정규화 계약이 없어 테스트 실패

## Phase 3: Implementation

- [x] T004 서버에 호텔 상태 타입·최대 5마리 검증 구현
  Files: `src/main/java/com/heartopia/wiki/service/UserPetFoodService.java`
  Verify: 서비스 단위 테스트 통과

- [x] T005 이름 수정과 호텔 상태 UI·저장·강조 구현
  Files: `src/main/resources/templates/wiki/others/pets.html`
  Verify: 템플릿 계약 테스트 통과

## Phase 4: Polish

- [x] T006 전체 회귀 테스트와 변경 범위 확인
  Files: 변경 파일 전체
  Verify: `gradlew.bat test` 통과, `git diff --check` 통과, 기존 이미지 별칭 변경 보존

## Completion Notes

- Tests run: 인라인 JavaScript 문법 검사, 대상 테스트, `gradlew.bat test` (`51` tests, `0` failures), `git diff --check`
- Known risks: 현재 세션에서 내장 브라우저가 연결되지 않아 실제 클릭·반응형 시각 검증은 수행하지 못함
- Follow-up: 배포 후 모바일·데스크톱에서 이름 저장/취소, 호텔 5마리 경계, 로그인 동기화 새로고침을 확인
