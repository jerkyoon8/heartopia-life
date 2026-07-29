# Tasks: 공통 푸터 및 접속자 통계 재배치

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 기존 공통 푸터, 헤더 통계, 테마 변수와 모델 데이터 흐름을 조사한다.
  Files: `src/main/resources/templates/fragments/footer.html`, `src/main/resources/templates/fragments/header.html`, `src/main/resources/static/css/common.css`, `src/main/java/com/heartopia/wiki/advice/GlobalControllerAdvice.java`
  Verify: 영향 지점과 재사용 가능한 모델 속성이 `plan.md`에 기록되어 있다.

## Phase 2: Tests

- [x] T002 새 푸터의 필수 링크·통계 바인딩과 헤더 통계 제거를 정적 검사한다.
  Files: `src/main/resources/templates/fragments/footer.html`, `src/main/resources/templates/fragments/header.html`
  Verify: 검색 결과가 요구사항과 일치하고 Thymeleaf 표현식이 온전하다.

## Phase 3: Implementation

- [x] T003 공통 푸터를 브랜드 소개, 운영 안내, 연결 링크, 통계, 법적 고지 구조로 교체한다.
  Files: `src/main/resources/templates/fragments/footer.html`
  Verify: 기존 프래그먼트 이름이 유지되고 필수 링크와 두 통계가 조건부 렌더링된다.

- [x] T004 헤더에서 접속자 카운터 마크업과 중복 스타일을 제거한다.
  Files: `src/main/resources/templates/fragments/header.html`, `src/main/resources/static/css/common.css`
  Verify: `.visitor-counter`와 `.visitor-count-num` 검색 결과가 없다.

- [x] T005 푸터 전용 밝은/어두운 테마 및 반응형 스타일을 추가하고 CSS 캐시 버전을 갱신한다.
  Files: `src/main/resources/static/css/common.css`, `src/main/resources/templates/fragments/common-head.html`
  Verify: 푸터 선택자가 `.site-footer` 아래로 제한되고 768px/480px 미디어 쿼리가 존재한다.

## Phase 4: Polish

- [x] T006 애플리케이션 테스트와 대표 페이지 시각 검증을 수행한다.
  Files: 변경된 템플릿 및 CSS
  Verify: `gradlew.bat test` 통과, 데스크톱·모바일 및 밝은/어두운 테마에서 레이아웃 확인

- [x] T007 문서 상태와 남은 위험·후속 작업을 기록한다.
  Files: `specs/014-footer-visitor-refresh/tasks.md`
  Verify: 완료된 작업, 실행 테스트, 시간·날씨 후속 작업이 Completion Notes에 기록되어 있다.

## Completion Notes

- Tests run: `.\gradlew.bat test` 성공, `/wiki` HTTP 200, 데스크톱 1440px·모바일 390px 밝은/어두운 테마 렌더링 확인, 두 너비 모두 가로 오버플로 없음
- Known risks: Font Awesome 아이콘은 기존 공통 CDN 스타일시트 가용성에 의존한다.
- Follow-up: 기존 헤더 우측 영역에 시간·날씨 정보를 추가하는 별도 작업
