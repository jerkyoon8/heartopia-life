# Implementation Plan: 빙설 시즌 도감 데이터 추가

## Context

- Spec: `specs/008-ice-season-collection-data/spec.md`
- Target branch: current working branch
- Current codebase notes:
  - 각 도감은 DB의 `event_name`을 읽어 기존 이벤트 필터와 배지를 자동 구성한다.
  - Spring SQL 자동 초기화가 비활성화되어 신규 SQL은 별도 실행해야 한다.
  - 작업 트리에 사용자 변경이 있으므로 기존 Java, MyBatis, 템플릿 파일은 수정하지 않는다.
  - 현재 도감 스키마는 요리 체력 회복량을 지원하지 않는다.

## Approach

기존 UI와 조회 로직을 그대로 활용하도록 신규 MySQL 데이터 스크립트를 만든다. 대상 이름과 이벤트명이 일치하는 행만 관계 순서에 맞춰 삭제한 후 27종을 재삽입한다. 제공된 원본 WebP 26개와 사용자 제공 WebP 1개는 기존 종류별 정적 이미지 디렉터리 및 파일명 관례로 복사한다. JUnit 테스트는 SQL에 모든 항목·가격·재료가 포함되는지와 참조된 이미지가 실제로 존재하는지를 검증한다.

## Impacted Files

- `src/main/resources/sql/20260727_insert_ice_season_collections.sql`: 27종 및 요리 재료의 반복 실행 가능한 데이터 스크립트
- `src/main/resources/static/images/collections/{crop,bird,bug,fish}/`: 종류별 이벤트 WebP
- `src/main/resources/static/images/flowers/히말라야양귀비.webp`: 사용자 제공 꽃 WebP
- `src/main/resources/static/images/items/cook/`: 빙설 시즌 요리 WebP 10개
- `src/test/java/com/heartopia/wiki/data/IceSeasonCollectionDataTest.java`: SQL 계약과 이미지 존재 검증
- `specs/008-ice-season-collection-data/*.md`: 요구사항, 설계, 실행 계획과 작업 상태

## Data Model

- 기존 여섯 컬렉션 테이블을 그대로 사용한다.
- 요리는 표시용 `ingredients` 문자열과 관계형 `cooking_ingredients`를 함께 저장한다.
- 새·곤충·물고기의 원본 상시 조건은 `weather='상시'`, `time='상시'`로 저장한다.
- 서식지는 기존 필터 관례에 맞춰 대분류 `location`과 세부 `sub_location`으로 분리한다.

## API Or Interface Changes

- 없음. 기존 도감 목록과 이벤트 필터가 신규 DB 행을 자동 표시한다.

## Validation And Error Handling

- 트랜잭션 안에서 요리 재료, 요리, 나머지 컬렉션 순으로 대상 행만 교체한다.
- SQL 종료 전 테이블별 예상 행 수를 반환하는 검증 쿼리를 포함한다.
- 테스트에서 27개 고유 이름, 등급별 대표 가격, 요리 재료와 모든 WebP 경로를 검증한다.

## Test Plan

- `gradlew.bat test`로 전체 테스트를 실행한다.
- 신규 테스트에서 SQL 및 정적 리소스 계약을 검증한다.
- 실제 DB 적용 후 이벤트별 테이블 행 수와 NULL 가격·누락 이미지를 확인하는 검증 쿼리를 실행한다.

## Risks And Mitigations

- 외부 원본 파일이 향후 바뀔 수 있음: 이번에 확인한 데이터를 SQL과 테스트에 고정한다.
- 삭제 후 삽입 중 실패 가능성: MySQL 트랜잭션으로 원자성을 확보한다.
- 이미지 파일명 인코딩 문제: UTF-8 한글 파일명을 사용하고 클래스패스 리소스 존재 테스트를 둔다.
- 기존 변경과 충돌 가능성: 신규 파일만 추가한다.

## Alternatives Considered

- 관리자 화면에서 수동 입력: 27종과 재료 관계를 반복 가능하게 재현·검증하기 어려워 채택하지 않는다.
- 애플리케이션 시작 시 자동 시드: 운영 환경의 `spring.sql.init.mode=never` 정책과 맞지 않아 채택하지 않는다.
- 요리 체력 필드 신규 추가: 전체 요리 스키마·관리 화면·데이터 보강이 필요한 별도 기능이므로 이번 데이터 추가 범위에서 제외한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
