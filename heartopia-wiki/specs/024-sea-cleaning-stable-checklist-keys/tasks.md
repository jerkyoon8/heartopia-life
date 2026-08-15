# Tasks: 바다청소 체크리스트 ID 키 전환

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 바다청소 렌더링 키, 로컬 저장, 로그인 병합, DB 수정 구조와 대상 파일의 기존 변경을 조사한다.
  Files: `sea-cleaning.html`, `checklist.html`, `checklist-core.js`, `checklist-sync.js`, `UserChecklistService.java`, 관련 매퍼
  Verify: 이름이 일반·명인 키에 직접 포함되고 로그인 병합이 원문 키를 그대로 저장함을 확인한다.

## Phase 2: Tests

- [x] T002 로컬 일반·명인 키 변환, 충돌 병합, 다른 도감 무변경 테스트를 추가한다.
  Files: `src/test/js/checklist-key-migration.test.js`
  Verify: 구현 전 Node 테스트가 실패한다.

- [x] T003 서버의 구형 키 정규화와 충돌 병합 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/service/UserChecklistServiceTest.java`
  Verify: 구현 전 대상 Gradle 테스트가 실패한다.

- [x] T004 템플릿·매퍼·SQL의 ID/레거시 키 계약 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/template/SeaCleaningChecklistKeyTemplateTest.java`
  Verify: 구현 전 대상 Gradle 테스트가 실패한다.

## Phase 3: Implementation

- [x] T005 코드 배포 전 컬럼 SQL과 배포 후 사용자 체크리스트 SQL을 추가한다.
  Files: `src/main/resources/sql/20260815_add_sea_cleaning_legacy_checklist_name.sql`, `src/main/resources/sql/20260815_migrate_sea_cleaning_user_checklist_keys.sql`
  Verify: SQL 계약 테스트와 수동 SQL 검토가 통과한다.

- [x] T006 모델·매퍼·템플릿을 ID 키 및 영구 레거시 별칭 구조로 전환한다.
  Files: `SeaCleaningCollection.java`, `CollectionMapper.xml`, `sea-cleaning.html`, `checklist.html`
  Verify: 템플릿 계약 테스트가 통과한다.

- [x] T007 버전 기반 로컬스토리지 마이그레이션을 동기화 초기화 전에 실행한다.
  Files: `checklist-sync.js`, `common-head.html`
  Verify: Node 회귀 테스트와 JS 문법 검사가 통과한다.

- [x] T008 서버 체크리스트의 모든 입출력 경계에서 구형 바다청소 키를 정규화한다.
  Files: `UserChecklistService.java`
  Verify: 서비스 회귀 테스트가 통과한다.

## Phase 4: Polish

- [x] T009 전체 테스트, 변경 범위, 배포 선행 조건과 검증 쿼리를 확정한다.
  Files: 변경 파일 전체, `tasks.md`
  Verify: 전체 Gradle·Node 테스트와 `git diff --check`가 통과한다.

## Completion Notes

- Tests run: Node 테스트 15건, 전체 Gradle 테스트, `bootJar`, JS 문법 검사, 대상 `git diff --check` 통과.
- Known risks: SQL은 실제 MySQL에 아직 실행하지 않았다. 컬럼 SQL은 코드보다 먼저, 사용자 키 SQL은 코드보다 나중에 적용해야 한다.
- Follow-up: 사전 SQL 실행 및 0건 검증 → 코드 배포 → 사후 SQL 실행 및 0건 검증 → 실제 조개 이름 변경 순서를 지킨다.
