# Tasks: 모바일 메인 카드 고밀도 배치

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 메인 카드 구조와 기존 반응형 중단점을 확인한다.
  Files: `src/main/resources/templates/wiki/wiki.html`
  Verify: 바로가기 768px 세로 전환과 정보 카드 576px 1열 전환 확인

## Phase 2: Tests

- [x] T002 모바일 고밀도 카드 CSS 회귀 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/template/WikiMobileLayoutTemplateTest.java`
  Verify: 구현 전 테스트 실패 확인

## Phase 3: Implementation

- [x] T003 모바일 바로가기와 정보 카드를 2열 소형 레이아웃으로 변경한다.
  Files: `src/main/resources/templates/wiki/wiki.html`
  Verify: 템플릿 테스트와 360px·375px Playwright 확인

- [x] T005 후속 결정에 따라 모바일 정보 카드를 4열 아이콘형으로 변경한다.
  Files: `src/main/resources/templates/wiki/wiki.html`, `src/test/java/com/heartopia/wiki/template/WikiMobileLayoutTemplateTest.java`
  Verify: 360px·375px에서 4열, 제목 최대 두 줄, 가로 오버플로 없음

## Phase 4: Polish

- [x] T004 라이트·다크모드와 태블릿·데스크톱 회귀를 확인한다.
  Files: `src/main/resources/templates/wiki/wiki.html`, `specs/020-mobile-wiki-two-column/tasks.md`
  Verify: Playwright 스크린샷, 가로 오버플로 없음, 콘솔 오류 없음, `git diff --check`

## Completion Notes

- Tests run: `WikiMobileLayoutTemplateTest`, `PetManagementTemplateTest` 통과. Playwright에서 360px·375px 모바일 4열, 768px 2열, 1280px 4열과 라이트·다크모드를 확인했다.
- Browser measurements: 360px 카드 폭 73px/높이 84px, 375px 카드 폭 약 77px/높이 84px, 두 화면 모두 문서 가로 오버플로와 카드 내부 오버플로 0건.
- Known risks: 360px보다 좁은 비표준 화면에서는 카드 제목 줄바꿈이 늘어날 수 있다.
- Follow-up: 배포 후 실제 모바일 브라우저에서 글자 크기 확대 설정을 사용한 경우도 확인한다.
