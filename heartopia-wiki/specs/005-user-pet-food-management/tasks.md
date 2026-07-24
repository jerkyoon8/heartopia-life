# Tasks: 사용자별 반려동물 먹이 관리

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 기존 저장·인증·화면 구조와 미커밋 변경을 확인한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`, `src/main/java/com/heartopia/wiki/controller/UserPetFoodController.java`, `src/main/java/com/heartopia/wiki/service/UserPetFoodService.java`
  Verify: 기존 JSON 전체 저장 방식, `currentUser`, 대상 파일 diff 확인

## Phase 2: Tests

- [x] T002 템플릿 중심 기능이라 자동 단위 테스트 대신 검증 시나리오를 명세한다.
  Files: `specs/005-user-pet-food-management/spec.md`, `specs/005-user-pet-food-management/plan.md`
  Verify: 로그인/비로그인, 추가/삭제/복원, 기존 데이터 호환 시나리오 포함

## Phase 3: Implementation

- [x] T003 로그인 컨텍스트와 펫 먹이 로컬 저장 키를 추가한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`, `src/main/resources/templates/fragments/common-head.html`, `src/main/resources/templates/fragments/header.html`
  Verify: 로그인 여부·사용자 ID 주입 및 저장 키 선택 로직 확인

- [x] T004 먹이 추가 UI와 프로필 데이터 정규화를 구현한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`
  Verify: `customFoods`, `hiddenFoodIds`, 빈 값·중복·복원 처리 확인

- [x] T005 기본/사용자 정의 먹이 삭제와 관련 상태 정리를 구현한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`
  Verify: 기본은 숨김, 사용자 정의는 제거, 관련 선호·먹여봄 상태 정리 확인

- [x] T006 저장 요청 순서 보장과 저장 실패 안내를 구현한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`
  Verify: Promise 직렬화 및 실패 후 다음 저장 가능 여부 확인

- [x] T009 서버 프로필 JSON 구조·길이·개수 검증과 HTTP 400 응답을 구현한다.
  Files: `src/main/java/com/heartopia/wiki/service/UserPetFoodService.java`, `src/main/java/com/heartopia/wiki/exception/PetFoodValidationException.java`, `src/main/java/com/heartopia/wiki/advice/GlobalExceptionHandler.java`
  Verify: 잘못된 요청에서 mapper가 호출되지 않고 HTTP 400 메시지로 변환되는지 확인

- [x] T010 서버 검증 단위 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/service/UserPetFoodServiceTest.java`
  Verify: 정상·누락 선택 필드·잘못된 타입·80자 초과·100개 초과·중복 이름 테스트

## Phase 4: Polish

- [x] T007 스타일·접근성·모바일·다크 모드를 정리한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`
  Verify: 폼 레이블, 버튼 aria-label, 반응형·다크 모드 선택자 확인

- [x] T008 회귀 테스트와 최종 diff 검토를 수행한다.
  Files: 전체 변경 파일
  Verify: `./gradlew.bat test`, 템플릿 정적 검사, 사용자 기존 변경 보존 확인

- [x] T011 동기화 ON 상태의 DB 저장 흐름을 브라우저에서 검증하고 원상 복구한다.
  Files: 런타임 DB 및 브라우저 세션(소스 변경 없음)
  Verify: 동기화 활성화, API DB 저장, 새로고침 유지, 테스트 데이터 삭제, 동기화 비활성화 확인

- [x] T012 비로그인 사용자에게 먹이 추가·삭제를 허용하고 브라우저 로컬 저장을 검증한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`
  Verify: 비로그인 추가 폼·삭제 버튼 노출, 추가·기본 삭제·새로고침 유지, 공용 키 저장 확인

- [x] T013 로그인·비로그인 localStorage 키를 하나로 통합한다.
  Files: `src/main/resources/templates/wiki/others/pets.html`, `src/main/resources/templates/fragments/common-head.html`, `src/main/resources/templates/fragments/header.html`
  Verify: 로그인·로그아웃 전후 같은 `heartopia_pet_food_profiles` 데이터가 이어지는지 확인

- [x] T014 사용자 정의 먹이를 기존 DB 이름과 매칭해 이미지를 표시한다.
  Files: `src/main/java/com/heartopia/wiki/controller/WikiController.java`, `src/main/resources/templates/wiki/others/pets.html`
  Verify: DB 일치 이름은 이미지 URL, 미일치 이름은 대체 아이콘을 사용하는지 확인

## Completion Notes

- Tests run: `./gradlew.bat test` 성공(펫 먹이 검증 테스트 8개 포함), 인라인 JavaScript 구문 검사 성공, `git diff --check` 성공, 로컬 Chromium에서 OAuth 로그인·추가·중복 차단·기본 먹이 삭제·복원·사용자 정의 먹이 삭제·새로고침 유지·반응형 화면 검증 성공, 81자 먹이 HTTP 400 응답 확인, 동기화 ON DB 저장·GET·새로고침 유지·삭제·OFF 원복 확인, 비로그인 먹이 추가·기본 삭제·공용 로컬 키 저장 확인, DB 등록 이름 `오렌지 잼` 이미지 정상 로드(207px) 및 미등록 이름 대체 아이콘 확인
- Known risks: 같은 브라우저에서 동기화를 끈 여러 로그인 계정은 합의한 공용 localStorage 데이터를 공유한다. 자동화 브라우저 재시작으로 Google 세션이 풀려 이번 공용 키 변경 후 로그인·로그아웃 연속 흐름은 정적 로직과 비로그인 새로고침으로 확인했으며 재로그인 E2E는 반복하지 못했다. 여러 탭·기기 동시 수정, 저장 실패 재시도, localStorage 용량 초과는 합의에 따라 범위에서 제외함.
- Follow-up: DB/SQL 작업은 없으며 배포 후 운영 도메인에서 한 번만 동일 흐름을 확인한다.
