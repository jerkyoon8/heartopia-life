# Tasks: 지도 초기 로딩 성능 개선

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 기존 성능 기록, 최근 지도 변경, 운영 응답 규모와 초기화 순서를 확인한다.
  Files: `src/main/resources/static/js/map/*`, `specs/011-animal-second-map-placement/*`
  Verify: 과거 서버 병목과 현재 클라이언트 워터폴을 구분하고 계획에 기록

## Phase 2: Tests

- [x] T002 지도 초기 로딩 성능 계약 테스트를 먼저 추가한다.
  Files: `src/test/java/com/heartopia/wiki/template/MapInitialLoadPerformanceTemplateTest.java`
  Verify: 구현 전 새 테스트 실패, 구현 후 통과

## Phase 3: Implementation

- [x] T003 지도별 마스터 데이터 카테고리 설정을 추가한다.
  Files: `src/main/resources/static/js/map/map-state.js`
  Verify: 기본 지도 6개, 고래낙하 협곡 2개 카테고리 계약 테스트 통과

- [x] T004 이미지와 선택된 초기 API를 병렬로 요청하고, 숨김 마커 부착과 초기 목록 렌더 낭비를 줄인다.
  Files: `src/main/resources/static/js/map/map-core.js`, `src/main/resources/static/js/map/map-api.js`
  Verify: 새 계약 테스트와 `node --check` 통과

- [x] T005 지도 JS 캐시 버전을 갱신한다.
  Files: `src/main/resources/templates/wiki/map.html`
  Verify: 템플릿 계약 테스트 통과

- [x] T006 기본 지도 해상도를 유지한 WebP를 추가하고 서비스 경로를 전환한다.
  Files: `src/main/resources/static/images/map/heartopia-map.webp`, `src/main/resources/static/js/map/map-state.js`, `src/main/resources/templates/wiki/map.html`
  Verify: `1995 × 1998`, 1MB 미만, 지도 상태의 WebP 경로 확인

## Phase 4: Polish

- [x] T007 전체 회귀 테스트를 실행하고 결과와 후속 작업을 기록한다.
  Files: `specs/012-map-initial-load-performance/tasks.md`
  Verify: `.\gradlew.bat test`, 변경 JS `node --check`, `git diff --check`

## Completion Notes

- Tests run: `node --check` for `map-state.js`, `map-api.js`, `map-core.js`; `.\gradlew.bat test --rerun-tasks`; Pillow metadata verification (`1995 × 1998`, WebP, 280,574 bytes); `git diff --check`
- Known risks: 인앱 브라우저를 사용할 수 없어 실제 브라우저의 초기 렌더 시간과 네트워크 워터폴은 이번 작업에서 재측정하지 못했다.
- Follow-up: 배포 후 `/wiki/map`과 `/wiki/map?mapKey=second`의 Network/Performance 기록을 각각 남겨 변경 전후를 비교한다. 다음 최적화 후보는 공개 조회 API 캐시 정책이다.
