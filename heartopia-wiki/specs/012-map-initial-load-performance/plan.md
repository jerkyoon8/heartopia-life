# Implementation Plan: 지도 초기 로딩 성능 개선

## Context

- Spec: `specs/012-map-initial-load-performance/spec.md`
- Target branch: `main`
- Current codebase notes:
  - `map-core.js`는 `img.onload` 내부에서 핀·구역 요청을 시작하고, 완료 후 도감 API 6개를 다시 요청한다.
  - 고래낙하 협곡 운영 데이터는 현재 핀 26개, 구역 0개, 동물 1개이며 지도 이미지는 약 2.4MB다.
  - 최근 고래낙하 협곡의 전체 표시 기본값이 추가됐지만 현재 데이터 규모에서는 직렬 네트워크 워터폴이 더 큰 초기 지연 요인이다.
  - 과거 `MapController.getPins`의 반복 선형 탐색 병목은 이미 `Map` 조회로 개선됐다.
  - 지도 API는 현재 `Cache-Control: no-store`이므로 이번 변경에서는 캐시 정책을 건드리지 않는다.

## Approach

`map-state.js`의 지도 설정에 각 지도가 지원하는 마스터 데이터 카테고리를 선언한다. `map-core.js`는 이 설정으로 필요한 요청 목록을 만들고, DOM 준비 직후 이미지 로딩과 초기 데이터 요청을 동시에 시작한다.

이미지와 모든 필수 데이터가 준비되면 Leaflet 지도, 마스터 상태, 가시성, 마커를 설정하고 카테고리 목록을 한 번만 렌더링한다. 초기 가시성이 꺼진 마커는 상태에만 등록하고 사용자가 켤 때 Leaflet 레이어에 추가한다. 기존의 두 단계 렌더링, 모든 지도에서 무조건 여섯 도감 요청, 매번 다른 핀 URL을 만드는 타임스탬프 쿼리를 제거한다.

`map-api.js`의 구역 조회는 성공 시 배열을 반환하고 HTTP 오류를 상위 초기화로 전달해 불완전한 초기화를 피한다.

기본 지도 PNG는 원본 해상도를 유지한 WebP 품질 90으로 변환한다. PNG 원본은 작업용으로 보관하고 `map-state.js`의 서비스 경로만 WebP로 전환한다.

## Impacted Files

- `src/main/resources/static/js/map/map-state.js`: 지도별 지원 데이터 카테고리와 조회 함수를 추가한다.
- `src/main/resources/static/images/map/heartopia-map.webp`: 원본 해상도를 유지한 서비스용 WebP를 추가한다.
- `src/main/resources/static/js/map/map-api.js`: 구역 조회의 HTTP 상태 확인, 결과 반환, 오류 전파를 추가한다.
- `src/main/resources/static/js/map/map-core.js`: 이미지/API 병렬 요청, 지도별 선택 요청, 숨김 마커 지연 부착, 단일 초기 렌더링으로 초기화 흐름을 재구성한다.
- `src/main/resources/templates/wiki/map.html`: 변경된 JS 캐시 버전을 갱신한다.
- `src/test/java/com/heartopia/wiki/template/MapInitialLoadPerformanceTemplateTest.java`: 초기 로딩 성능 계약을 소스 단위로 검증한다.
- `specs/012-map-initial-load-performance/*`: 요구사항, 설계, 작업 및 검증 결과를 기록한다.

## Data Model

- DB 또는 서버 모델 변경 없음.
- `MapApp.MAPS.<key>.dataCategories`에 지도별 마스터 카테고리 문자열 배열을 추가한다.
- 기존 `state.master*` 배열 구조는 유지한다.

## API Or Interface Changes

- 서버 엔드포인트 및 JSON 형식 변경 없음.
- `MapApp.getActiveDataCategories()` 클라이언트 함수를 추가한다.
- `MapApp.api.loadAllZones()`는 성공 시 구역 배열을 반환하고 실패 시 reject한다.

## Validation And Error Handling

- 공통 JSON 요청 함수에서 `response.ok`를 확인한다.
- 알 수 없는 지도 키는 기존 `getInitialMapKey()`로 `town` 처리한다.
- 지원하지 않는 마스터 카테고리 설정은 요청 목록에서 제외한다.
- 초기 데이터 실패는 한 곳에서 기록하고 마커·목록 초기화를 진행하지 않는다.
- 이미지 오류는 별도 로그를 남긴다.

## Test Plan

- Java 템플릿 계약 테스트로 지도별 카테고리 설정, 이미지/API 병렬 시작, 두 번째 지도 선택 요청, 초기 렌더 1회, 핀 타임스탬프 제거를 검증한다.
- 기존 동물 두 번째 지도 계약 테스트를 포함한 Gradle 전체 테스트를 실행한다.
- 변경된 지도 JavaScript 파일에 `node --check`를 실행한다.
- 가능하면 로컬 또는 브라우저에서 `/wiki/map`과 `/wiki/map?mapKey=second`의 핀·목록·딥 링크를 수동 확인한다.

## Risks And Mitigations

- 초기화 블록 재구성 중 관리자 클릭 이벤트가 누락될 위험: 지도 클릭 등록 블록은 데이터 준비 뒤 기존 내용 그대로 유지한다.
- 카테고리 이름과 상태 키 불일치 위험: 단일 요청 정의 객체에 URL과 상태 키를 함께 둔다.
- 기존 테스트가 정확한 소스 문자열에 의존할 위험: 기존 `showAllByDefault` 표현은 유지한다.

## Alternatives Considered

- 고래낙하 협곡 전체 표시 기본값 해제: 렌더 부하는 줄지만 확정된 기존 UX 요구를 되돌리므로 제외했다.
- 지도 이미지 무손실 WebP: 2.22MB로 줄지만 고품질 WebP 0.27MB보다 전송량 이점이 작아 제외했다.
- HTTP 캐시 추가: 더 큰 개선 여지가 있지만 관리자 수정 반영과 무효화 정책 결정이 필요해 제외했다.
- 도감 API 통합 엔드포인트 추가: 왕복 수는 더 줄지만 서버 API 변경과 테스트 범위가 커져 이번 최소 변경에서 제외했다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
