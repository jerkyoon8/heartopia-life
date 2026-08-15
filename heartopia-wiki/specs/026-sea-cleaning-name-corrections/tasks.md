# Tasks: 바다청소 이름 일괄 변경

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 대상 ID, 실제 기존 이름, 레거시 별칭을 로컬 DB에서 확인한다.
  Files: `sea_cleaning_collections`
  Verify: ID 1, 6, 8, 10, 11, 14와 기존 이름·레거시 별칭이 일치한다.

## Phase 2: Tests

- [x] T002 ID별 이름 매핑, 트랜잭션 안전성, 레거시 별칭 보존 계약 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/sql/SeaCleaningRenameSqlTest.java`
  Verify: 구현 전 SQL 파일 부재로 테스트가 실패한다.

## Phase 3: Implementation

- [x] T003 실행 전 검증과 부분 변경 차단을 포함한 배포 후 이름 변경 SQL을 추가한다.
  Files: `src/main/resources/sql/20260815_rename_sea_cleaning_collections.sql`
  Verify: SQL 계약 테스트가 통과한다.

## Phase 4: Polish

- [x] T004 전체 테스트와 형식 검사를 실행하고 운영 적용 순서를 확정한다.
  Files: 변경 파일 전체, `tasks.md`
  Verify: 전체 Gradle 테스트와 대상 `git diff --check`가 통과한다.

## Completion Notes

- Tests run: 전체 Gradle 테스트 150건과 `bootJar`, SQL 계약 테스트, 대상 형식 검사 통과.
- Local verification: 최초 실행 `updated_rows=6`, `migration_status=applied`; 재실행 `updated_rows=0`, `migration_status=already applied` 확인.
- Render verification: 서버 재기동 후 새 이름 6개, 기존 표시 이름 0개, 카드 18개, ID 키와 레거시 매핑 유지를 확인했다.
- Known risks: 운영 DB의 ID·기존 이름이 다르면 SQL은 0건을 갱신하고 `NOT APPLIED`를 출력한다.
- Follow-up: ID 코드 배포 → 사용자 키 이전 SQL → 이름 변경 SQL → 앱 재시작 → 새 이름·별점·명인 상태 확인 순서로 운영 적용한다.
