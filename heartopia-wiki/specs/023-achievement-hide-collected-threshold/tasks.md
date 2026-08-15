# Tasks: 업적 수집 항목 숨김 우선순위 수정

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 현재 숨김 판정, 업적 저장 값, 카드/테이블 DOM 계약과 기존 미커밋 변경을 조사한다.
  Files: `src/main/resources/static/js/wiki-filter.js`, `src/main/resources/static/js/checklist.js`, `src/main/resources/templates/wiki/others/achievements.html`
  Verify: 업적 값 `0`, 기준치 `3`에서 현재 판정이 `false`임을 Node 재현으로 확인한다.

## Phase 2: Tests

- [x] T002 별점 미지원 업적과 별점 지원 도감의 숨김 우선순위 회귀 테스트를 먼저 추가한다.
  Files: `src/test/js/wiki-filter-event.test.js`
  Verify: 구현 전 `node --test src/test/js/wiki-filter-event.test.js`가 새 테스트에서 실패한다.

- [x] T003 업적 카드와 테이블 행의 필터 데이터 계약을 정적 테스트로 추가한다.
  Files: `src/test/java/com/heartopia/wiki/template/AchievementHideCollectedTemplateTest.java`
  Verify: 구현 전 관련 Gradle 테스트가 실패한다.

## Phase 3: Implementation

- [x] T004 수집 여부, 별점 지원 여부, 기준치 순서로 숨김을 판정하는 순수 함수를 공용 필터에 연결한다.
  Files: `src/main/resources/static/js/wiki-filter.js`
  Verify: Node 회귀 테스트와 문법 검사가 통과한다.

- [x] T005 업적 카드/행을 별점 미지원으로 표시하고 행에 동기화 키를 추가한다.
  Files: `src/main/resources/templates/wiki/others/achievements.html`
  Verify: 템플릿 정적 테스트가 통과하고 기존 캐시 버전 변경이 보존된다.

## Phase 4: Polish

- [x] T006 전체 회귀 검사와 변경 범위 검토를 완료한다.
  Files: 변경 파일 전체
  Verify: `node --check`, `node --test`, `gradlew.bat test`, `git diff --check` 통과.

## Completion Notes

- Tests run: `node --check`, Node 테스트 10건, 전체 Gradle 테스트, 대상 `git diff --check` 통과.
- Known risks: 브라우저 E2E 대신 순수 판정 테스트와 템플릿 계약 테스트로 검증했다.
- Follow-up: 배포 시 기존 미커밋 변경인 정적 리소스 캐시 버전 `2.7`을 함께 반영한다.
