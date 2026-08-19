# Tasks: 업적 카테고리 관리와 고래 시즌 업적 추가

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 기존 업적 CRUD, 공개 필터, 데이터 원본과 이미지 이름을 조사하고 요구사항을 확정한다.
  Files: `specs/029-achievement-categories-whale-season/*.md`
  Verify: PRD, Spec, Plan에서 데이터 4개와 신규 카테고리 2개 범위 확인

## Phase 2: Tests

- [x] T002 [P] 관리자 카테고리 입력과 공개 필터에 대한 템플릿 회귀 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/template/AchievementCategoryAdminTemplateTest.java`
  Verify: 구현 전 대상 문자열 부재로 테스트 실패 확인

- [x] T003 [P] 고래 시즌 업적 SQL 내용과 멱등성을 검증하는 회귀 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/sql/WhaleSeasonAchievementsSqlTest.java`
  Verify: 구현 전 SQL 리소스 부재로 테스트 실패 확인

## Phase 3: Implementation

- [x] T004 업적 관리자 모달과 공개 필터에 카테고리, 팁, 정렬 입력 및 수정 데이터를 추가한다.
  Files: `src/main/resources/templates/wiki/others/achievements.html`
  Verify: 템플릿 테스트 통과

- [x] T005 카테고리 체크박스 그룹 동기화 및 최소 선택 검증을 구현한다.
  Files: `src/main/resources/static/js/admin-data.js`
  Verify: JS 구문 검사와 전체 테스트 통과

- [x] T006 업적 카테고리를 서버에서 정규화하고 허용 목록을 검증한다.
  Files: `src/main/java/com/heartopia/wiki/controller/AdminDataController.java`
  Verify: Java 컴파일과 전체 테스트 통과

- [x] T007 네 업적용 멱등 SQL과 정적 이미지를 추가한다.
  Files: `src/main/resources/sql/20260819_add_whale_season_achievements.sql`, `src/main/resources/static/images/achievements/*.webp`
  Verify: SQL 테스트 통과 및 이미지 4개 존재 확인

## Phase 4: Polish

- [x] T008 전체 테스트와 변경 범위 검토를 수행하고 적용 절차를 기록한다.
  Files: `specs/029-achievement-categories-whale-season/tasks.md`
  Verify: `gradlew.bat test`, `git diff --check`, 관련 파일 diff 확인

## Completion Notes

- Tests run: staged snapshot `gradlew.bat clean test` (167 tests, 0 failures), `node --check src/main/resources/static/js/admin-data.js`, 관리자 수정/검증 Playwright, 공개 필터/상세 Playwright, 로컬 MySQL SQL 2회 연속 실행, scoped `git diff --check`
- Known risks: 운영 DB SQL 미적용 상태에서는 신규 데이터가 보이지 않음
- Follow-up: 새 애플리케이션 배포와 정적 이미지 응답을 먼저 확인한 뒤 운영 `heartopia_db`에 신규 SQL을 실행하고, 검증 조회가 4행을 반환하는지와 이미지 응답의 `Content-Type: image/webp`를 확인
