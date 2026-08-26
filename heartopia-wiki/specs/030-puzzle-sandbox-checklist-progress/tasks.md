# Tasks: 퍼즐·모래 조각 수집 기록과 메인 진행도

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 기존 체크 키·동기화·필터·메인 카드 구조와 신규 항목 ID 사용 가능 여부 조사
  Files: `src/main/**`, `src/test/**`
  Verify: PRD/Spec/Plan에 조사 결과와 확정 키 형식 기록

## Phase 2: Tests

- [x] T002 [P] 메인 접두사별 완료 수 계산 단위 테스트 추가
  Files: `src/test/js/checklist-progress.test.js`
  Verify: 구현 전 신규 테스트 실패, 구현 후 Node 테스트 통과

- [x] T003 [P] 퍼즐·모래 조각·통합 도감·메인 진행도 템플릿 계약 테스트 추가
  Files: `src/test/java/com/heartopia/wiki/template/PuzzleSandboxChecklistTemplateTest.java`, `src/test/java/com/heartopia/wiki/template/WikiMobileLayoutTemplateTest.java`
  Verify: 구현 전 신규 테스트 실패, 구현 후 Gradle 템플릿 테스트 통과

## Phase 3: Implementation

- [x] T004 전역 체크 데이터 일괄 로딩과 메인 진행도 렌더링 구현
  Files: `src/main/resources/static/js/checklist-core.js`, `src/main/resources/static/js/checklist-sync.js`, `src/main/resources/static/css/checklist-sync.css`, `src/main/resources/templates/fragments/common-head.html`
  Verify: JS 단위 테스트 및 기존 체크 키 마이그레이션 테스트 통과

- [x] T005 메인 카드 체크 접두사와 `완료 / 전체` UI 구현
  Files: `src/main/java/com/heartopia/wiki/dto/wiki/CategoryItemDto.java`, `src/main/java/com/heartopia/wiki/controller/WikiController.java`, `src/main/resources/templates/wiki/wiki.html`
  Verify: 메인 템플릿 테스트 통과

- [x] T006 퍼즐·모래 조각 카드/표 체크와 완료 숨김 구현
  Files: `src/main/resources/templates/wiki/others/puzzles.html`, `src/main/resources/templates/wiki/others/sandbox.html`
  Verify: ID 기반 키·체크 버튼·필터 계약 테스트 통과

- [x] T007 통합 수집 도감에 퍼즐·모래 조각 추가 및 중복 계정 조회 제거
  Files: `src/main/java/com/heartopia/wiki/controller/WikiController.java`, `src/main/resources/templates/wiki/checklist.html`, `src/main/resources/static/js/checklist.js`
  Verify: 신규 카테고리 집계 및 전체 진행률 테스트 통과

## Phase 4: Polish

- [x] T008 관련 JS·템플릿·서비스 회귀 테스트와 전체 Gradle 테스트 실행
  Files: 변경 파일 전체
  Verify: Node 테스트, `gradlew test`, `git diff --check` 통과

- [x] T009 문서 상태와 잔여 위험 정리
  Files: `specs/030-puzzle-sandbox-checklist-progress/tasks.md`
  Verify: 완료 작업 체크, 실행 테스트와 후속 조치 기록

## Completion Notes

- Tests run: `node --test src/test/js/*.test.js` (19개 통과), `gradlew test` (174개 통과), 변경 파일 대상 `git diff --check` 및 JS 구문 검사 통과
- Known risks: 이름 기반 기존 카테고리의 오래된 키는 전체 수 상한으로 방어하며 완전한 유효 키 교집합 검증은 하지 않는다.
- Follow-up: 배포 후 비로그인·로그인 동기화 ON 환경에서 실제 체크/메인 진행도 확인. DB 스키마나 SQL 적용은 필요 없음.
