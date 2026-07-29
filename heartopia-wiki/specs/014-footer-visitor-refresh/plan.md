# Implementation Plan: 공통 푸터 및 접속자 통계 재배치

## Context

- Spec: `specs/014-footer-visitor-refresh/spec.md`
- Target branch: 현재 작업 브랜치
- Current codebase notes:
  - 공통 푸터는 `templates/fragments/footer.html` 한 곳에서 관리되고 대부분의 공개·관리 페이지가 이를 참조한다.
  - 접속자 통계 마크업과 반응형 숨김 규칙은 `templates/fragments/header.html` 안에 있으며, 유사한 공통 스타일이 `common.css`에도 중복되어 있다.
  - `GlobalControllerAdvice`가 모든 페이지에 `weeklyVisitors`, `todayVisitors`를 제공하므로 백엔드 변경 없이 푸터에서 재사용할 수 있다.
  - 모든 대상 페이지는 `common-head.html`을 통해 `common.css`를 로드한다.

## Approach

공통 푸터 프래그먼트를 의미 있는 섹션과 링크를 갖는 시맨틱 HTML로 교체하고, 모든 시각 규칙은 `common.css`의 `.site-footer` 범위에 둔다. 헤더의 접속자 마크업 및 중복 스타일을 제거해 상단 우측 공간을 비운다. 기존 모델 속성을 푸터에서 조건부 렌더링하고, CSS 캐시 버전을 올린 뒤 템플릿 검사와 애플리케이션 테스트를 수행한다.

## Impacted Files

- `src/main/resources/templates/fragments/footer.html`: 새 브랜드/안내/연결/통계/법적 고지 구조
- `src/main/resources/templates/fragments/header.html`: 접속자 카운터 마크업 및 내부 스타일 제거
- `src/main/resources/static/css/common.css`: 푸터 전용 테마·반응형 스타일 추가, 중복 접속자 스타일 제거
- `src/main/resources/templates/fragments/common-head.html`: `common.css` 캐시 버전 갱신
- `specs/014-footer-visitor-refresh/*.md`: 요구사항, 설계, 작업 및 검증 기록

## Data Model

- 변경 없음.
- 기존 `weeklyVisitors`, `todayVisitors` 모델 속성을 읽기 전용으로 재사용한다.

## API Or Interface Changes

- 외부 API 변경 없음.
- 공통 템플릿 인터페이스는 기존 `footer` 프래그먼트 이름을 유지한다.
- 헤더 DOM에서 `.visitor-counter`가 제거되고 푸터에 `.footer-visitor-stats`가 추가된다.

## Validation And Error Handling

- 통계 묶음은 `weeklyVisitors != null`일 때만 렌더링한다.
- 숫자는 기존과 동일한 Thymeleaf `#numbers.formatInteger`를 사용한다.
- 이메일은 `mailto:` 링크로 제공하고 긴 주소의 줄바꿈을 CSS로 허용한다.
- CSS 선택자를 푸터 루트 아래로 제한한다.

## Test Plan

- `./gradlew.bat test`로 기존 Spring 테스트를 실행한다.
- 정적 검색으로 헤더의 `.visitor-counter` 제거와 푸터의 통계 바인딩을 확인한다.
- 로컬 애플리케이션에서 `/wiki`를 데스크톱·모바일 너비로 렌더링해 레이아웃, 링크, 숫자, 밝은/어두운 테마를 확인한다.
- 가능하면 브라우저 스크린샷으로 데스크톱 및 모바일 푸터를 시각 검토한다.

## Risks And Mitigations

- 전 페이지 푸터 회귀: 기존 프래그먼트 이름과 포함 방식을 유지하고 스타일을 루트 클래스에 한정한다.
- Bootstrap 유틸리티와 우선순위 충돌: 기존 인라인 스타일과 유틸리티 의존을 줄이고 전용 클래스만 사용한다.
- CSS 캐시로 변경 미반영: `common.css` 쿼리 버전을 갱신한다.
- 짧은 모바일 화면의 과도한 높이: 정보 열을 1열로 바꾸되 패딩과 간격을 축소한다.

## Alternatives Considered

- 참고 이미지처럼 전체 폭 강한 그라데이션과 외부 프로필·후원 카드 추가: 실제 링크가 없고 기존 사이트 정체성에서 벗어나므로 제외했다.
- 푸터 전용 CSS 파일 생성: 변경 규모가 작고 모든 페이지가 이미 공통 CSS를 로드하므로 불필요한 요청과 관리 파일을 늘린다.
- 통계용 새 API 호출: 이미 서버 렌더링 모델 데이터가 있으므로 중복 네트워크 요청이 된다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있지 않다.
