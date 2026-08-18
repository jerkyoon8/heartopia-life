# Tasks: 요리 회복량 UI·영문명 참고표

## Rules

- 각 작업은 파일 경로와 검증 방법을 포함한다.
- 운영 반영 시 DB 백업과 SQL 검증을 마친 뒤 코드 배포를 진행한다.

## Phase 1: Setup

- [x] T001 현재 요리 조회·모델·목록·상세·관리자 흐름과 검증 CSV를 확인한다.
  Files: `CollectionMapper.xml`, `CookingCollection.java`, `cooking.html`, `detail.html`, `_workspace/...validation.csv`
  Verify: 필드가 하나의 공통 모델/SELECT를 통해 전달됨을 확인

## Phase 2: Tests

- [x] T002 회복량 데이터/UI와 영문명 비저장 계약 테스트를 추가한다.
  Files: `CookingBilingualRecoveryTemplateTest.java`, `CookingBilingualRecoveryDataTest.java`
  Verify: 구현 전 요구 계약을 코드로 고정

## Phase 3: Implementation

- [x] T003 검증 CSV에서 스키마/백필 SQL을 생성하고 불변식을 검사한다.
  Files: `tools/build_cooking_ui_migration.py`, `20260817_add_cooking_recovery.sql`, `cooking_name_ko_en_reference.md`
  Verify: DB SQL에는 영문명 없음; Markdown에 한글·영문 175개; SQL에 숫자 회복량 111개 행

- [x] T004 모델과 MyBatis 조회·검색·관리자 CRUD를 확장한다.
  Files: `CookingCollection.java`, `CollectionMapper.xml`
  Verify: 컴파일 및 Mapper 계약 테스트

- [x] T005 목록·상세·관리자 화면에 회복량 UI를 추가한다.
  Files: `cooking.html`, `detail.html`
  Verify: 템플릿 계약 테스트와 모바일 스타일 확인

## Phase 4: Polish

- [x] T006 관련/전체 테스트를 실행하고 SQL 선적용 절차와 잔여 데이터 공백을 기록한다.
  Files: `tasks.md`
  Verify: 테스트 통과, git push 미실행, 운영 변경 없음

## Completion Notes

- Tests run: migration generator compile/run; 175-row CSV-to-SQL cross-check; focused cooking template/data tests; full `gradlew test` (pass).
- Known risks: 64 recipes have no numeric recovery in either verified source and intentionally show `회복량 정보 없음`; one production-only recipe (`은하수 과자`) has no verified English name/recovery and follows the same fallback.
- Deployment order: back up `cooking_collections`, apply `src/main/resources/sql/20260817_add_cooking_recovery.sql`, verify `176 / 111`, and only then deploy code. English names remain outside the service DB/UI.
