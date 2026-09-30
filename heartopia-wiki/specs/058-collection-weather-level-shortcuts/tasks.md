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

## 2026-10-01 UX 수정 및 캐시 회귀

- [x] T005 날씨 복수 선택·레벨 범위·캐시 버전 회귀 테스트 작성.
- [x] T006 세 도감 템플릿의 날씨 체크 UI와 레벨 시작·끝 입력 구현.
- [x] T007 공통 필터 로직·스타일 및 정적 자산 버전 수정.
- [x] T008 전체 테스트와 로컬 서버의 실제 도감 페이지에서 클릭·초기화 검증.

검증: Gradle 전체 테스트 통과, Node 테스트 33개 통과. 로컬 127.0.0.1:18080의 물고기·곤충·새 화면에서 3~8 선택, 잘못된 범위 유지, 맑음+비 복수 선택, 상시 포함 해제, 카드/표 일치, 초기화 확인. 390px 화면에서 가로 넘침 없음과 마지막 날씨 옵션 클릭 가능 확인.

이 단계는 로컬에서 구현·검증한 뒤 후속 요청에 따라 배포 대상으로 전환했다.

## 2026-10-01 중복 날씨 선택지 정리

- [x] T009 `무지개만 출력` UI·분기·테스트 제거 및 명세 갱신.
- [x] T010 전체 테스트와 실제 로컬 화면에서 날씨·레벨·캐시 주소 검증.
- [x] T011 이번 기능 변경만 별도 커밋으로 `main`에 푸시하고 운영 배포 검증.

T010 결과: Gradle 전체 테스트와 Node 33개 통과. 로컬 서버를 재시작한 뒤 물고기·곤충·새의 실제 페이지에서 3~8 및 1~10 범위, 맑음+비와 무지개 선택, 상시 포함 해제, 초기화, 카드/표 일치를 확인했다. 390px 화면에서 가로 넘침이 없고 무지개 체크가 가능하다. 운영 HTML은 `wiki-filter.js?v=2.9`, 로컬 HTML은 `v=2.10`을 요청한다. JS 응답은 1년 캐시이므로 새 URL이 기존 캐시와 분리된다.
