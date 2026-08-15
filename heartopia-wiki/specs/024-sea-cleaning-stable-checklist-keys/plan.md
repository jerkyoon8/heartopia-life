# Implementation Plan: 바다청소 체크리스트 ID 키 전환

## Context

- Spec: `specs/024-sea-cleaning-stable-checklist-keys/spec.md`
- Target branch: `main`
- Current codebase notes:
  - 바다청소 카드·테이블·전체 체크리스트가 모두 이름 기반 키를 렌더링한다.
  - `heartopia_checklist`는 모든 도감 키가 함께 있는 단일 로컬스토리지 객체다.
  - 로그인 시 `common-head.html`이 DOM 초기화 전에 로컬 객체 전체를 서버 `/checklist/migrate`로 보낸다.
  - 서버의 현재 병합은 키를 검증하거나 정규화하지 않고 그대로 upsert한다.
  - 바다청소 DB 행은 관리자 수정 시 `id`로 갱신되므로 기존 행의 ID는 이름 변경과 무관하게 유지된다.

## Approach

코드 배포 전에 DB에 최초 이름을 보존하는 `legacy_checklist_name`을 추가한다. 렌더링 키는 ID 기반으로 바꾸되 레거시 키를 데이터 속성으로 제공하고, 코드 배포 후 기존 `user_checklist`를 ID 키로 병합한다. 공용 체크리스트 스크립트가 버전 2 미적용 브라우저에서 레거시 키를 한 번 변환하며, 서버 서비스도 모든 입력·조회에서 구형 키를 정규화해 오래된 브라우저의 재업로드를 막는다.

## Impacted Files

- `src/main/resources/sql/20260815_add_sea_cleaning_legacy_checklist_name.sql`: 코드 배포 전 컬럼 추가와 레거시 이름 고정.
- `src/main/resources/sql/20260815_migrate_sea_cleaning_user_checklist_keys.sql`: 코드 배포 후 서버 체크리스트 병합·구형 키 삭제.
- `src/main/java/com/heartopia/wiki/model/SeaCleaningCollection.java`: 레거시 이름 필드.
- `src/main/resources/mapper/CollectionMapper.xml`: 레거시 이름 조회.
- `src/main/java/com/heartopia/wiki/service/UserChecklistService.java`: 서버 키 정규화와 충돌 병합.
- `src/main/resources/templates/wiki/others/sea-cleaning.html`: 카드·행 ID 키와 레거시 키 렌더링.
- `src/main/resources/templates/wiki/checklist.html`: 전체 체크리스트의 ID 키와 레거시 키 렌더링.
- `src/main/resources/static/js/checklist-sync.js`: 버전 기반 로컬 키 마이그레이션.
- `src/main/resources/templates/fragments/common-head.html`: 변경된 동기화 스크립트 캐시 버전.
- `src/test/js/checklist-key-migration.test.js`: 로컬 변환 회귀 테스트.
- `src/test/java/com/heartopia/wiki/service/UserChecklistServiceTest.java`: 서버 정규화·충돌 회귀 테스트.
- `src/test/java/com/heartopia/wiki/template/SeaCleaningChecklistKeyTemplateTest.java`: 템플릿·SQL·매퍼 계약 테스트.

## Data Model

- `sea_cleaning_collections.legacy_checklist_name VARCHAR(100) NULL` 추가.
- 기존 행은 `legacy_checklist_name=name`으로 초기화한다.
- 신규 행은 레거시 키가 없으므로 `NULL`을 유지한다.
- 관리자 UPDATE 문은 해당 컬럼을 수정하지 않는다.

## API Or Interface Changes

- HTTP API 형식은 유지한다.
- 바다청소 `item_key` 값만 이름 기반에서 ID 기반으로 변경한다.
- `SeaCleaningCollection`에 `legacyChecklistName` 속성을 추가한다.
- `checklist-sync.js`는 테스트 가능한 로컬 키 변환 함수를 CommonJS로 내보낸다.

## Validation And Error Handling

- 서버는 정확한 바다청소 구형 접두사만 변환하고 다른 키는 그대로 둔다.
- 매핑되지 않는 삭제 항목의 구형 키는 보존한다.
- 충돌 시 `Math.max`로 더 높은 별점을 보존한다.
- 브라우저 저장 실패 시 구형 키와 버전을 그대로 두어 재시도할 수 있게 한다.
- 전체 바다청소 목록에서 유효한 매핑을 하나 이상 확보한 경우에만 버전을 기록한다.

## Test Plan

- 구현 전에 Node·서비스·템플릿 계약 테스트가 실패하는지 확인한다.
- Node 테스트로 일반 키, 명인 키, 충돌, 다른 도감 무변경, 버전 완료 동작을 검증한다.
- Mockito 서비스 테스트로 migrate/get/upsert/delete/batch/toggle 경계와 불필요한 매핑 조회 방지를 검증한다.
- 정적 테스트로 두 템플릿의 ID·레거시 데이터 속성, SQL 순서, 매퍼 컬럼을 검증한다.
- 전체 `gradlew.bat test`, Node 테스트, JS 문법 검사, `git diff --check`를 실행한다.

## Risks And Mitigations

- 사전 SQL보다 코드가 먼저 배포되면 바다청소 조회가 실패한다: 컬럼 SQL을 먼저 실행하고 코드 배포 후 사용자 키 SQL을 실행한다.
- 현재 이름을 바꾼 뒤 SQL을 실행하면 더 오래된 로컬 키를 알 수 없다: 모든 이름 변경 전에 이 SQL을 먼저 실행한다.
- 스크립트 캐시로 구형 키가 렌더링될 수 있다: `checklist-sync.js` 캐시 버전을 올린다.

## Alternatives Considered

- 이름 변경 때마다 정적 JS 매핑 추가: 운영자가 매번 코드 배포를 해야 하므로 채택하지 않는다.
- 접속 시 전역 API로 매핑 조회: 모든 페이지에 네트워크 비용이 생기므로 채택하지 않는다.
- 모든 도감을 동시에 ID로 전환: 현재 요구 범위를 넘어 위험과 배포 작업이 커지므로 채택하지 않는다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
