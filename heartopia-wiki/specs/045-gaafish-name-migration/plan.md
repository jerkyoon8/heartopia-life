# Implementation Plan: 동갈치 → 가아피쉬 단독 마이그레이션

## Context

- 로그인+동기화 ON 체크리스트는 `user_checklist`, OFF 또는 비로그인은 `heartopia_checklist`를 사용한다.
- 로그인+동기화 ON 펫 먹이는 `user_pet_food.pets_json`, OFF는 `heartopia_pet_food_profiles`를 사용한다.
- `common-head.html`이 로그인 체크리스트 병합을 먼저 실행하므로 로컬 키 변환은 그 요청보다 앞서야 한다.
- 운영 적용 직전 스냅샷은 fish 4행, cooking 5행, checklist 317행/60명, pet food 1행이다.

## Approach

### 1. 브라우저 1회 마이그레이션

- 공통 헤드에서 로그인 병합보다 먼저 실행되는 버전 마이그레이션을 둔다.
- `heartopia_checklist`의 물고기 4개·요리 5개 일반/명인 키를 신키로 옮긴다.
- 충돌 시 높은 별점을 남기며 성공한 뒤에만 완료 버전을 기록한다.
- 펫 페이지의 초기 업로드·병합보다 먼저 `heartopia_pet_food_profiles`의 네 물고기명을 변경한다.
- 펫 구·신명칭 중복은 상태를 보존해 하나로 합친다.
- 서버 서비스에 영구 별칭 로직은 추가하지 않는다.

### 2. 운영 SQL

- 카탈로그 SQL은 정확한 ID와 구명칭 조건으로 fish 이름 4건, cooking 이름·재료 5건을 변경한다.
- 사용자 상태 SQL은 `user_checklist` 구키를 신키로 옮기고 `user_pet_food.pets_json`의 확인된 네 이름을 변경한다.
- 체크리스트 충돌은 높은 별점을 보존한다.
- 최초 SQL은 예상 건수가 다르면 자동 롤백하는 가드된 일회성 절차로 만들고 사전 검증·백업·롤백·사후 검증 쿼리를 함께 준비한다.
- `image_url`은 모든 UPDATE에서 제외한다.

### 3. 적용 순서

1. 대상 행과 이미지 URL을 운영 서버 제한 경로에 백업한다.
2. 카탈로그 SQL을 트랜잭션으로 실행한다.
3. 로그인 사용자 상태 SQL을 트랜잭션으로 실행한다.
4. 현재 앱 컨테이너를 재시작해 카탈로그 캐시를 비운다. 로컬 마이그레이션 코드는 별도 push·배포 단계로 남긴다.
5. 공개 화면, 체크리스트, 펫 먹이를 검증한다.
6. 구버전 탭의 늦은 쓰기를 고려해 관찰 후 잔여 검색과 사용자 상태 SQL을 한 번 재실행한다.

카탈로그 SQL 이후 전환 전까지 기존 컨테이너는 이미 적재된 구 카탈로그 캐시를 제공한다. 새 컨테이너는 변경된 DB에서 신명칭을 적재한다.

## Impacted Files

- `src/main/resources/templates/fragments/common-head.html`: 로그인 병합 전에 체크리스트 변환 실행
- `src/main/resources/static/js/checklist-key-migration.js`: 버전 기반 체크리스트 키 변환
- `src/main/resources/templates/wiki/others/pets.html`: 초기 동기화 전에 펫 localStorage 변환
- `src/test/js/checklist-key-migration.test.js`: 일반/명인/max/재실행/손상 데이터 테스트
- 펫 먹이 JS 테스트 파일: 이름 변환·중복 병합·상태 보존 테스트
- `src/main/resources/sql/migrate_gaafish_catalog_20260906.sql`: 카탈로그 SQL
- `src/main/resources/sql/migrate_gaafish_user_state_20260906.sql`: 체크리스트·펫 먹이 SQL
- `src/main/resources/sql/verify_gaafish_migration_20260906.sql`: 검증 SQL
- `src/main/resources/sql/rollback_gaafish_migration_20260906.sql`: 롤백 안내

## Data And Interface Changes

- 스키마와 API 형식은 변경하지 않는다.
- 변경 컬럼은 `fish_collections.name`, `cooking_collections.name`, `cooking_collections.ingredients`, `user_checklist.item_key`, `user_pet_food.pets_json`이다.
- 내부 이미지 URL 9건에는 의도적으로 `동갈치`가 남는다.
- 영구 서버 별칭과 옛 URL 리다이렉트는 포함하지 않는다.

## Verification

- JavaScript: 체크리스트 일반/명인 키, max 병합, 펫 중복 병합, 반복 실행, 손상 JSON을 검증한다.
- SQL: 운영 스키마 복제본에서 실행·재실행·롤백을 검증한다.
- 운영: 새 이름 API/UI, 비로그인·sync OFF localStorage, sync ON DB, 펫 설정 보존을 검증한다.
- 전수 검색 기대 결과: 표시명·재료·체크리스트 키·펫 JSON에서 `동갈치` 0건, image_url에서만 9건이다.
- 이미지 URL 9개는 전후 값이 동일하고 HTTP 200이어야 한다.

## Risks And Mitigations

- 로그인 병합이 구키를 먼저 전송: localStorage 이관을 병합보다 앞에 둔다.
- 열린 구버전 탭 재유입: 전환 후 잔여 검색 및 멱등 SQL 1회 재실행으로 정리한다.
- localStorage 손실: 파싱·변환 성공 뒤에만 저장하고 버전 키를 기록한다.
- DB 충돌: 체크리스트는 높은 별점을 보존하고 펫 JSON은 기존 설정을 보존한다.
- 이미지 장애: URL과 파일을 변경 집합에서 제외하고 전후 비교한다.

## Production Execution

- SQL 경로: `src/main/resources/sql/*gaafish*20260906.sql`
- 대상: 운영 MySQL `heartopia_db`
- 실행: 운영 서버 MySQL 8 컨테이너에서 `utf8mb4`로 카탈로그 SQL → 사용자 상태 SQL → 앱 캐시 재기동 → 검증 SQL 순서로 수동 실행했다.
- 예상: fish 신명칭 4건, cooking 신명칭/재료 5건, 구 체크리스트 키 0건, 구 펫 이름 0건, 이미지 URL은 기존 9건 그대로다.
- push, 배포, 운영 SQL 실행은 각각 사용자의 명시적 승인 뒤 진행한다.
