# Tasks: 도감 시간 필터 카드·표 결과 일치

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 원인과 기존 카드·표 데이터 속성 패턴 확인
  Files: `src/main/resources/static/js/wiki-filter.js`, `src/main/resources/templates/wiki/collections/{fish,bug,bird}.html`
  Verify: 곤충·새 표 행만 `data-time`이 없고 공통 필터는 해당 속성을 읽는지 확인

## Phase 2: Tests

- [x] T002 곤충·새·물고기 표 행 시간 속성 계약 테스트 추가
  Files: `src/test/java/com/heartopia/wiki/template/CollectionTimeFilterTemplateTest.java`
  Verify: 수정 전 곤충·새 검증이 실패하고 물고기 검증은 통과

## Phase 3: Implementation

- [x] T003 곤충과 새 표 행에 등장 시간 데이터 연결
  Files: `src/main/resources/templates/wiki/collections/bug.html`, `src/main/resources/templates/wiki/collections/bird.html`
  Verify: 템플릿 계약 테스트 통과

## Phase 4: Polish

- [x] T004 전체 회귀 테스트와 변경 범위 확인
  Files: 변경 파일 전체
  Verify: `gradlew.bat test` 통과 및 diff에 관련 변경만 포함

## Completion Notes

- Tests run: `gradlew.bat test` (`45` tests, `0` failures)
- Known risks: 실제 운영 화면 확인은 배포 후 필요
- Follow-up: 배포 후 곤충·새 도감의 표 보기에서 날씨 `비`, 시간 `6~12`, `상시 포함` 해제 조건을 확인
