# Implementation Plan: 헤더 도감 메가 메뉴 확장

## Context

- Spec: `specs/016-header-mega-navigation/spec.md`
- Target branch: `main`
- Current codebase notes:
  - 공통 탐색은 `templates/fragments/header.html`에 마크업과 전용 CSS가 함께 있다.
  - 현재 hover 트리거 클래스와 메가 메뉴 유지 동작은 이미 구현되어 있다.
  - 기존 세 열 메뉴 링크는 현재 컨트롤러 라우트와 일치한다.

## Approach

기존 hover 구조는 유지하고 트리거 문구, 그리드 열 수, 구역 마크업만 변경한다. 템플릿 정적 테스트를 먼저 새 요구사항으로 갱신한 뒤 최소 범위로 헤더를 수정한다.

## Impacted Files

- `src/main/resources/templates/fragments/header.html`: 트리거 문구, 세 열 CSS, 12개 링크
- `src/test/java/com/heartopia/wiki/template/HeaderWeatherTemplateTest.java`: 탐색 구조 회귀 검증

## Data Model

- 변경 없음

## API Or Interface Changes

- 변경 없음

## Validation And Error Handling

- 모든 링크가 기존 정적 라우트인지 테스트와 코드 검색으로 확인한다.

## Test Plan

- 헤더 템플릿 테스트에서 세 제목과 대표·전체 경로를 검증한다.
- 전체 Gradle 테스트를 실행한다.
- 데스크톱 브라우저에서 hover 메뉴의 열 수와 가로 오버플로를 확인한다.

## Risks And Mitigations

- 기존 테스트가 옛 메뉴 구조를 강제함: 요구사항에 맞게 테스트를 먼저 갱신한다.
- 세 열 레이아웃 폭 문제: 기존 `repeat(3, 1fr)` 구조를 복원한다.

## Alternatives Considered

- 상단에 세 메뉴를 각각 노출: 사용자가 `도감` 하나에 hover해 모두 보길 원하므로 제외한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있지 않다.
