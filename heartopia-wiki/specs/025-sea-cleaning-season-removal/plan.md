# Implementation Plan: 바다청소 시즌 제외 및 레벨 필터 확장

## Context

- Spec: `specs/025-sea-cleaning-season-removal/spec.md`
- Target branch: 현재 작업 트리
- Current codebase notes:
  - 로컬 바다청소 18개 중 17개가 `event_name='고래 시즌'`이고, 현재 이벤트 목록에는 포함되지 않아 공통 필터가 숨긴다.
  - 운영 페이지는 이벤트 필터가 없는 배포본으로 전체 항목을 출력한다.
  - 바다청소 템플릿의 레벨 선택지는 `#numbers.sequence(1, 6)`으로 고정되어 있다.
  - 바다청소 모델·매퍼·템플릿에는 진행 중인 ID 체크리스트 키 전환 변경이 있으므로 해당 변경을 보존한다.

## Approach

바다청소 템플릿에서 이벤트 관련 UI·데이터 속성·필터 구성을 제거하고 레벨 범위를 8로 늘린다. MyBatis 저장 경로에서는 신규 이벤트 값을 받지 않으며 수정 시 과거 값을 NULL로 정리한다. 전역 이벤트 후보 UNION에서도 바다청소를 제거하고, 기존 환경을 일괄 정리하는 반복 실행 가능한 SQL을 추가한다.

## Impacted Files

- `src/main/resources/templates/wiki/others/sea-cleaning.html`: 이벤트 필터·속성·관리자 입력 제거, 레벨 1~8 확장.
- `src/main/resources/mapper/CollectionMapper.xml`: 바다청소 조회/INSERT에서 이벤트 제외, UPDATE에서 NULL 보장.
- `src/main/resources/mapper/EventSettingsMapper.xml`: 이벤트 후보 UNION에서 바다청소 제외.
- `src/main/resources/sql/20260815_clear_sea_cleaning_event_names.sql`: 기존 시즌 값 정리 및 검증 쿼리.
- `src/test/java/com/heartopia/wiki/template/CurrentEventFilterTemplateTest.java`: 시즌 도감 목록에서 바다청소 제외.
- `src/test/java/com/heartopia/wiki/template/SeaCleaningSeasonExclusionTest.java`: 템플릿·매퍼·SQL 회귀 계약 추가.

## Data Model

- `sea_cleaning_collections.event_name` 컬럼은 유지한다.
- 바다청소 조회 모델에는 이벤트 값을 채우지 않는다.
- 기존 값은 별도 SQL과 개별 UPDATE 모두에서 NULL로 정리한다.

## API Or Interface Changes

- 외부 API 변경 없음.
- 바다청소 관리자 폼에서 이벤트 입력란이 사라진다.
- 바다청소 레벨 필터 선택지가 Lv.8까지 늘어난다.

## Validation And Error Handling

- DB 정리 SQL은 NULL이 아닌 행만 갱신해 반복 실행할 수 있게 한다.
- SQL 실행 후 잔여 이벤트 행 수가 0인지 검증한다.
- 템플릿 계약 테스트로 이벤트 UI·속성의 재유입과 레벨 범위 회귀를 막는다.

## Test Plan

- 대상 Gradle 템플릿 계약 테스트 실행.
- 전체 Gradle 테스트 실행.
- 로컬 페이지 HTML에서 바다청소 카드 18개가 이벤트 속성 없이 렌더링되는지 확인.
- 레벨 필터에 7·8이 포함되는지 HTML로 확인.
- `git diff --check` 실행.

## Risks And Mitigations

- 공용 이벤트 테스트가 바다청소를 계속 시즌 도감으로 간주할 수 있다: 시즌 도감 목록에서 명시적으로 제외하고 별도 비시즌 계약 테스트를 둔다.
- SQL 미실행 환경에 과거 값이 남을 수 있다: 화면·조회·저장 모두에서 값을 사용하지 않아 기능은 정상 유지되도록 한다.

## Alternatives Considered

- 로컬 DB의 값만 수동 삭제: 향후 관리자 입력과 전역 이벤트 집계에서 같은 문제가 재발하므로 채택하지 않는다.
- `event_name` 물리 컬럼 삭제: 공용 스키마와 데이터 배포 부담이 불필요하게 커져 채택하지 않는다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
