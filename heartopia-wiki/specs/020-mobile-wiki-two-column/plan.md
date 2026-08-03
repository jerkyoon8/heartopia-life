# Implementation Plan: 모바일 메인 카드 고밀도 배치

## Context

- Spec: `specs/020-mobile-wiki-two-column/spec.md`
- Target branch: 현재 작업 브랜치
- Current codebase notes:
  - 메인 페이지 카드와 반응형 CSS는 `templates/wiki/wiki.html`에 함께 있다.
  - `.quick-access-section`은 768px 이하에서 세로 flex로 전환된다.
  - `.wiki-grid`는 576px 이하에서 명시적으로 1열로 전환된다.
  - `.wiki-card`의 기본 높이 140px, 이미지 80px, 제목 20px은 2열 모바일 카드에 크다.

## Approach

기존 데스크톱·태블릿 규칙과 바로가기 2열은 유지한다. 576px 이하의 정보 카드는 4열 아이콘형으로 바꾸고, 데이터 개수는 숨기며 준비 중 상태는 유지한다. 360px에서도 네 카드가 들어가도록 카드 간격, 이미지, 제목, 높이를 추가로 줄인다.

## Impacted Files

- `src/main/resources/templates/wiki/wiki.html`: 모바일 바로가기 2열 및 정보 카드 4열 스타일
- `src/test/java/com/heartopia/wiki/template/WikiMobileLayoutTemplateTest.java`: 모바일 레이아웃 회귀 테스트
- `specs/020-mobile-wiki-two-column/tasks.md`: 구현·검증 진행 상태

## Data Model

- 변경 없음.

## API Or Interface Changes

- 변경 없음. 기존 링크와 Thymeleaf 모델을 그대로 사용한다.

## Validation And Error Handling

- CSS 전용 변경으로 별도 입력 검증이나 오류 처리는 없다.
- 긴 제목은 자연 줄바꿈과 너비 제한으로 카드 밖으로 넘치지 않게 한다.

## Test Plan

- 템플릿 테스트로 모바일 바로가기 2열, 정보 카드 4열, 데이터 개수 숨김 규칙을 확인한다.
- Playwright에서 360px, 375px, 768px, 1280px 화면을 확인한다.
- 360px과 375px에서 열 수, 가로 오버플로, 카드 크기, 제목 잘림을 측정한다.
- 라이트·다크모드 모바일 스크린샷과 콘솔 오류를 확인한다.

## Risks And Mitigations

- 4열에서 긴 제목이 답답해질 수 있음: 제목을 최대 두 줄로 제한하고 아이콘 크기와 글자 크기를 낮춘다.
- 바로가기 설명이 길어 카드 높이가 달라질 수 있음: 동일한 그리드 행에서 카드가 늘어나도록 하고 핵심 버튼 위치를 하단에 맞춘다.
- 터치 영역이 작아질 수 있음: 카드 전체가 링크인 구조와 충분한 최소 높이를 유지한다.

## Alternatives Considered

- 기존 1열 카드 높이만 축소: 스크롤 감소 폭이 작아 사용자의 2열 요구를 충족하지 못한다.
- 가로 스크롤 카드: 한 화면에서 전체 선택지를 비교하기 어렵고 숨겨진 항목을 놓칠 수 있다.
- 모든 화면에서 2열 고정: 데스크톱 정보 밀도를 낮추므로 채택하지 않는다.
- 모바일 정보 카드 2열: 읽기는 편하지만 사용자가 원하는 스크롤 절감 폭이 부족해 4열로 변경한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
