# Tasks: 헤더 도감 메가 메뉴 확장

## Rules

- 테스트를 구현보다 먼저 갱신한다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 기존 메가 메뉴와 실제 페이지 라우트를 확인한다.
  Files: `src/main/resources/templates/fragments/header.html`, `src/main/java/com/heartopia/wiki/controller/WikiController.java`
  Verify: 12개 링크가 모두 기존 라우트에 대응한다.

## Phase 2: Tests

- [x] T002 새 도감·취미·기타정보 구조의 정적 회귀 테스트를 작성한다.
  Files: `src/test/java/com/heartopia/wiki/template/HeaderWeatherTemplateTest.java`
  Verify: 구현 전 테스트 실패

## Phase 3: Implementation

- [x] T003 헤더 트리거와 세 열 메가 메뉴를 구현한다.
  Files: `src/main/resources/templates/fragments/header.html`
  Verify: 템플릿 테스트 통과

## Phase 4: Polish

- [x] T004 전체 테스트와 데스크톱 hover 레이아웃을 확인한다.
  Files: 변경 파일
  Verify: `gradlew.bat test` 성공, 브라우저 가로 오버플로 없음

## Completion Notes

- Tests run:
  - `.\gradlew.bat test --tests com.heartopia.wiki.template.HeaderWeatherTemplateTest`: 성공
  - `.\gradlew.bat test`: 성공
  - 로컬 Chromium 1440px: 도감 hover 시 세 열, 12개 링크, 메뉴 hover 유지, 가로 오버플로 없음
- Known risks: 모바일은 기존 정책대로 메가 메뉴를 숨긴다.
- Follow-up: 모바일 메가 메뉴가 필요하면 별도 터치 탐색으로 설계한다.
