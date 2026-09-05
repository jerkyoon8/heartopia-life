# Tasks: 동갈치 → 가아피쉬 단독 마이그레이션

## Rules

- 테스트를 구현보다 먼저 작성한다.
- 운영 SQL, 배포, push는 각각 사용자 승인 후 진행한다.

## Phase 1: Preparation

- [x] T001 운영 문자열 컬럼을 읽기 전용 조사하고 영향 범위를 기록한다.
  Verify: fish 4, cooking 5, checklist 317/60명, pet 1행/4개 이름, image_url 9, target 충돌 0

- [x] T002 운영 대상 행을 서버 전용 제한 경로에 백업하고 이미지 URL을 기록한다.
  Verify: 복원 가능한 백업, 사용자 데이터 저장소 미노출

## Phase 2: Tests And Implementation

- [x] T003 체크리스트 localStorage 마이그레이션 테스트를 먼저 추가한다.
  Files: `src/test/js/checklist-key-migration.test.js`
  Verify: 일반/명인 키, max 병합, 반복 실행, 손상 데이터

- [x] T004 펫 localStorage 마이그레이션 테스트를 먼저 추가한다.
  Files: 기존 테스트 구조에 맞는 펫 JS 테스트 파일
  Verify: 네 이름 변환, 구·신 중복 병합, 상태 보존, 반복 실행

- [x] T005 체크리스트 변환을 로그인 병합보다 먼저 실행하도록 구현한다.
  Files: `src/main/resources/static/js/checklist-key-migration.js`, `src/main/resources/templates/fragments/common-head.html`
  Verify: 변환된 키만 `/api/user/checklist/migrate`로 전송

- [x] T006 펫 변환을 초기 업로드·병합보다 먼저 실행하도록 구현한다.
  Files: `src/main/resources/templates/wiki/others/pets.html` 및 분리된 JS가 있으면 해당 파일
  Verify: 로컬 네 이름 변경 및 펫 상태 보존

- [x] T007 카탈로그·사용자 상태·검증·롤백 SQL을 작성한다.
  Files: `src/main/resources/sql/*gaafish*20260906.sql`
  Verify: 정확한 대상 조건, 예상 건수 불일치 시 자동 롤백, image_url UPDATE 없음

- [ ] T008 운영 스키마 복제본에서 SQL 실행·재실행·롤백을 검증한다.
  Verify: 체크리스트 max 보존, 펫 JSON 유효·상태 보존, 대상 외 변경 0

## Phase 3: Production Rollout

- [x] T009 사전 검증 후 카탈로그 SQL을 트랜잭션 실행한다.
  Verify: fish 4, cooking name/ingredients 5, image_url 동일

- [ ] T010 새 코드를 blue-green 배포하고 새 컨테이너 검증 후 전환한다.
  Verify: readiness 200, 새 이름 API/UI, 이미지 200

- [x] T011 로그인 사용자 상태 SQL을 트랜잭션 실행한다.
  Verify: 구 checklist 키 0, 별점 보존, pet JSON 구명칭 0·유효성 정상

- [ ] T012 로그인 상태별 회귀와 전수 검증을 수행한다.
  Verify: 비로그인/sync OFF/sync ON/pet 통과, 옛 문자열은 image_url 9건만 존재

- [ ] T013 관찰 후 구버전 탭 재유입을 검색하고 사용자 상태 SQL을 재실행한다.
  Verify: `user_checklist.item_key`, `user_pet_food.pets_json`의 구명칭 0건

## Completion Notes

- 2026-09-06 운영 적용 완료: fish 4건, cooking 5건, checklist 317행/60명, pet food 1행/4개 이름
- 앱 컨테이너 재시작 후 목록의 표시 텍스트 구명칭 0건, 신명칭 상세 페이지 9개 HTTP 200 확인
- 이미지 URL 9개는 기존 `동갈치` 경로 그대로이며 모두 HTTP 200 확인
- localStorage 체크리스트·펫 먹이 버전 마이그레이션과 선행 실행 테스트 완료(T003~T006)
- 미완료: push 후 자동 blue-green 배포 확인(T010), 로그인 상태별 전체 회귀와 잔여 재유입 정리(T012~T013)
