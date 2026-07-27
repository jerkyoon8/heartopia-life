# Tasks: 빙설 시즌 도감 데이터 추가

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 원본 JSON, 이미지와 사용자 확정 꽃 데이터를 대조하고 필드 매핑을 확정한다.
  Files: `specs/008-ice-season-collection-data/{prd,spec,plan}.md`
  Verify: 27종 수량, 가격 규칙, 이미지 원본 경로 검토

## Phase 2: Tests

- [x] T002 SQL의 대상 수량, 핵심 가격, 재료 및 이미지 참조를 검증하는 계약 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/data/IceSeasonCollectionDataTest.java`
  Verify: 구현 전 신규 리소스가 없어 실패하고 구현 후 통과

## Phase 3: Implementation

- [x] T003 27종과 요리 재료를 반복 실행 가능하게 반영하는 MySQL 8 SQL을 작성한다.
  Files: `src/main/resources/sql/20260727_insert_ice_season_collections.sql`
  Verify: 테스트의 이름·가격·재료 계약 통과

- [x] T004 27종의 WebP 원본을 기존 종류별 정적 이미지 경로로 복사한다.
  Files: `src/main/resources/static/images/**`
  Verify: 테스트가 모든 SQL 이미지 경로를 클래스패스에서 찾음

## Phase 4: Polish

- [x] T005 전체 테스트와 변경 범위 검토를 수행하고 후속 DB 실행 절차를 기록한다.
  Files: `specs/008-ice-season-collection-data/tasks.md`
  Verify: `gradlew.bat test`, `git diff --check`, 신규 파일 목록 검토

## Completion Notes

- Tests run: `gradlew.bat test` — 54개 통과, 실패 0개
- Known risks: SQL은 애플리케이션 배포와 별도로 대상 MySQL에 실행해야 한다.
- Follow-up: 운영 반영 시 코드·정적 이미지 배포 후 SQL 실행, 테이블별 1/1/10/5/5/5 검증
