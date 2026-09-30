# Tasks: 도감 날씨 상시 포함 및 레벨 빠른 선택

- [x] T001 테스트: 날씨 상시 포함 조건과 빠른 레벨 선택 결과를 검증한다.
  Files: `src/test/js/wiki-filter-event.test.js`
  Verify: Node 테스트 실행
- [x] T002 UI: 세 도감 템플릿에 날씨 체크박스와 레벨 버튼을 추가한다.
  Files: `src/main/resources/templates/wiki/collections/{fish,bug,bird}.html`
  Verify: 요소와 기본 상태 확인
- [x] T003 동작: 공통 필터 스크립트와 필요한 스타일을 수정한다.
  Files: `src/main/resources/static/js/wiki-filter.js`, `src/main/resources/static/css/common.css`
  Verify: 필터 테스트 및 구문 검사
- [x] T004 회귀 확인: 관련 테스트와 변경 diff를 점검한다.
  Files: above
  Verify: Node 테스트, Gradle 관련 테스트, `git diff --check`

## Completion Notes

- Tests run: Node 필터 테스트 12개, Gradle `CollectionFilterShortcutTemplateTest` 및 `CollectionTimeFilterTemplateTest`, Playwright 독립 화면에서 날씨·레벨·초기화와 카드/표 동기화, 대상 파일 `git diff --check` 통과.
- Known risks: 실제 서버 템플릿을 렌더링한 화면 배치는 확인하지 않았다.
- Follow-up: 로컬에서만 변경. 운영 적용 없음.
