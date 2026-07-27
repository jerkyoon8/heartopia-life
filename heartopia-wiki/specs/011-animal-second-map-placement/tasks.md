# Tasks: 고래낙하 협곡 동물 위치 지정

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 기존 동물 관리자 입력, 지도별 API, 미배치 핀 배치 흐름을 조사한다.
  Files: `src/main/resources/templates/wiki/collections/animal.html`, `src/main/java/com/heartopia/wiki/controller/MapController.java`, `src/main/resources/static/js/map/*.js`
  Verify: 현재 실패 원인과 재사용할 `map_key` 흐름을 plan에 기록

## Phase 2: Tests

- [x] T002 [P] 동물 API의 기본 지도와 고래낙하 협곡 분리 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/controller/MapControllerAnimalMapTest.java`
  Verify: 구현 전 새 기대 동작으로 실패하고 구현 후 통과

- [x] T003 [P] 관리자 위치 선택지, 지도 버튼명, 미배치 동물 배치 계약 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/template/AnimalSecondMapTemplateTest.java`
  Verify: 구현 전 새 기대 동작으로 실패하고 구현 후 통과

## Phase 3: Implementation

- [x] T004 동물 API 응답에 지도 키를 제공하고 위치에 따라 지도별 필터링한다.
  Files: `src/main/java/com/heartopia/wiki/model/AnimalCollection.java`, `src/main/java/com/heartopia/wiki/controller/MapController.java`
  Verify: `MapControllerAnimalMapTest` 통과

- [x] T005 동물 관리자 입력과 지도 이동 링크에 고래낙하 협곡을 연결한다.
  Files: `src/main/resources/templates/wiki/collections/animal.html`, `src/main/resources/templates/wiki/detail.html`
  Verify: 추가·수정 모달 계약과 지도 링크 테스트 통과

- [x] T006 두 번째 지도 표시명과 미배치 동물 핀 템플릿 생성을 구현한다.
  Files: `src/main/resources/templates/wiki/map.html`, `src/main/resources/static/js/map/map-state.js`, `src/main/resources/static/js/map/map-ui.js`
  Verify: 템플릿 계약 테스트 통과

- [x] T007 고래낙하 협곡 지도의 카테고리·핀·구역을 전체 표시 상태로 초기화한다.
  Files: `src/main/resources/static/js/map/map-core.js`, `src/main/resources/templates/wiki/map.html`, `src/test/java/com/heartopia/wiki/template/AnimalSecondMapTemplateTest.java`
  Verify: 고래낙하 협곡에서만 전체 표시 초기값이 적용되는 계약 테스트 통과

## Phase 4: Polish

- [x] T008 전체 회귀 테스트와 변경 범위를 확인하고 작업 문서를 완료한다.
  Files: 변경 파일 전체, `specs/011-animal-second-map-placement/tasks.md`
  Verify: `gradlew test`, `git diff --check`, 요청 외 변경 미포함 확인

## Completion Notes

- Tests run: `gradlew test` 62개 통과, `node --check` 지도 JS 3개 통과, `git diff --check` 통과
- Known risks: 실제 운영 관리자 계정으로 핀을 배치하는 브라우저 확인은 배포 후 필요
- Follow-up: 돌고래를 추가할 때 위치를 정확히 `고래낙하 협곡`으로 선택하고, 배포 후 두 번째 지도에서 핀 좌표를 지정
