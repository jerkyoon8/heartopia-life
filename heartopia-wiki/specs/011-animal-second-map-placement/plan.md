# Implementation Plan: 고래낙하 협곡 동물 위치 지정

## Context

- Spec: `specs/011-animal-second-map-placement/spec.md`
- Target branch: `main`
- Current codebase notes:
  - 두 번째 지도는 내부 키 `second`와 `map_pins.map_key`로 이미 분리되어 있다.
  - 채집물 API만 지도별 필터링을 수행하고, 동물 API는 `mapKey`를 받지 않고 전체 동물을 반환한다.
  - `AnimalCollection`에는 클라이언트 지도 필터가 사용하는 `mapKey`가 없다.
  - 동물 관리자 모달의 위치는 자유 텍스트 입력이라 정식 위치명을 명시적으로 고르기 어렵다.
  - 지도 사이드바의 미배치 동물은 마스터 데이터로 생성되지만 기존 위치 지정 버튼은 실제 핀만 찾기 때문에 신규 미배치 동물 템플릿을 만들지 못한다.

## Approach

기존 DB 스키마와 `second` 지도 키를 그대로 사용한다. 동물 API가 `mapKey`를 받고 `animal_collections.location`을 기준으로 동물만 지도별 필터링해 반환하도록 한다. 응답 동물에는 계산된 `mapKey`를 제공해 기존 클라이언트 지도 필터와 호환한다.

관리자 모달은 기존 자유 입력 호환성을 유지하는 `datalist` 방식으로 `고래낙하 협곡`을 명시적 선택지로 제공한다. 지도 UI는 미배치 동물 버튼을 누를 때 마스터 동물에서 새 핀 템플릿을 생성하고, 기존 배치 로직이 활성 지도 키 `second`를 저장하도록 연결한다.

고래낙하 협곡 지도에서는 초기 카테고리·항목·구역 가시성을 모두 켜 `전체 표시` 상태로 시작한다. 기본 지도는 기존 기본 가시성 정책을 유지한다.

## Impacted Files

- `src/main/java/com/heartopia/wiki/model/AnimalCollection.java`: API 응답용 `mapKey` 필드 추가
- `src/main/java/com/heartopia/wiki/controller/MapController.java`: 동물 API의 지도별 필터링과 지도 키 계산
- `src/main/resources/templates/wiki/collections/animal.html`: 관리자 위치 추천 선택지와 두 번째 지도 링크
- `src/main/resources/templates/wiki/detail.html`: 고래낙하 협곡 동물 상세의 두 번째 지도 링크
- `src/main/resources/templates/wiki/map.html`: 두 번째 지도 버튼 표시명 변경 및 JS 캐시 버전 갱신
- `src/main/resources/static/js/map/map-state.js`: 두 번째 지도 레이블 변경
- `src/main/resources/static/js/map/map-core.js`: 고래낙하 협곡의 전체 표시 초기값
- `src/main/resources/static/js/map/map-ui.js`: 미배치 동물의 핀 템플릿 생성
- `src/test/java/com/heartopia/wiki/controller/MapControllerAnimalMapTest.java`: 지도별 동물 API 필터링 테스트
- `src/test/java/com/heartopia/wiki/template/AnimalSecondMapTemplateTest.java`: 모달·지도 버튼·미배치 배치 계약 테스트

## Data Model

- 기존 `animal_collections.location`을 지도 귀속 원본으로 사용한다.
- `AnimalCollection.mapKey`는 DB 열이 아닌 API 응답용 런타임 필드다.
- `location == "고래낙하 협곡"`이면 `mapKey = "second"`, 나머지는 `mapKey = "town"`으로 계산한다.
- 핀 저장은 기존 `map_pins.map_key`를 그대로 사용한다.

## API Or Interface Changes

- `GET /wiki/map/api/animals`
  - 선택 쿼리: `mapKey`
  - 생략 시: `town`
  - `mapKey=second`: 고래낙하 협곡 동물만 반환
  - `mapKey=town`: 나머지 동물만 반환
- 동물 관리자 위치 필드에 `고래낙하 협곡` 추천 선택지 추가
- 두 번째 지도 버튼 표시명을 `고래낙하 협곡`으로 변경

## Validation And Error Handling

- 위치 필드는 기존처럼 필수값을 유지한다.
- 기존 자유 입력 위치는 수정 시 그대로 보존한다.
- 비어 있는 `mapKey`는 기존 정책대로 `town`으로 정규화한다.
- 미배치 동물 마스터를 찾지 못하면 위치 지정 모드에 진입하지 않고 오류를 발생시키지 않는다.
- 핀 저장 API와 관리자 권한 검증은 기존 구현을 재사용한다.

## Test Plan

- 컨트롤러 단위 테스트로 `town`, `second`, 기본값의 동물 분리를 검증한다.
- 템플릿 계약 테스트로 관리자 위치 선택지, 지도 버튼명, 동물 상세 링크를 검증한다.
- JS 계약 테스트로 미배치 동물에서 활성 지도 키를 가진 핀 템플릿을 만드는지 검증한다.
- JS 계약 테스트로 고래낙하 협곡에서만 전체 표시 초기값이 적용되는지 검증한다.
- Gradle 전체 테스트를 실행한다.
- 수동 확인 시 관리자로 돌고래를 `고래낙하 협곡`에 추가하고 두 번째 지도에서 핀을 배치한 뒤 일반 사용자 화면을 확인한다.

## Risks And Mitigations

- 캐시된 동물 객체의 `mapKey`가 요청 간 섞일 위험: 서로 다른 지도에 속한 객체만 반환하고 계산된 키를 일관되게 설정한다.
- 기존 임의 위치값이 선택 UI에서 사라질 위험: 닫힌 `select` 대신 `datalist`를 사용한다.
- 미배치 항목 버튼이 빈 템플릿으로 진입할 위험: 실제 핀이 없으면 카테고리별 마스터에서 명시적으로 템플릿을 만든다.
- 다른 카테고리 동작 변경 위험: fallback 생성은 동물에만 적용한다.

## Alternatives Considered

- `animal_collections`에 `map_key` 열 추가: 데이터 정규화에는 유리하지만 동물 하나의 요구에 새 운영 DB 마이그레이션이 필요해 제외했다.
- 모든 도감 종류를 위치 기반으로 공통 분리: 향후 확장성은 좋지만 사용자가 이번 범위를 동물로 확정해 제외했다.
- 기존 위치 텍스트만 안내문으로 보완: 정확한 값 선택과 지도 연결을 보장하지 못해 제외했다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
