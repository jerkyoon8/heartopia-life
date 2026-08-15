# PRD: 바다청소 시즌 제외 및 레벨 필터 확장

## 1. Summary

### Problem

바다청소는 시즌 도감이 아닌데 로컬 데이터의 `event_name`에 `고래 시즌`이 저장되어 공통 이벤트 필터가 대부분의 항목을 숨긴다. 또한 실제 바다청소 데이터는 Lv.8까지 있지만 화면의 레벨 필터는 Lv.6까지만 제공한다.

### Proposed Solution

바다청소를 화면, 관리자 입력, 전역 이벤트 집계에서 시즌 기능과 분리하고 기존 `event_name` 값을 비우는 데이터 정리 SQL을 제공한다. 레벨 필터는 Lv.1부터 Lv.8까지 선택할 수 있게 확장한다.

### Success Criteria

- 별도의 이벤트 선택 없이 모든 바다청소 항목이 기본 출력된다.
- 바다청소를 추가하거나 수정해도 시즌 값이 저장되지 않는다.
- 바다청소 데이터가 전역 현재·빠른 이벤트 목록 후보에 포함되지 않는다.
- 레벨 필터에서 Lv.1~Lv.8을 선택할 수 있다.

## 2. Users And Use Cases

### Primary Users

- 바다청소 도감을 조회하고 레벨별로 거르는 사용자
- 바다청소 항목을 관리하는 관리자

### User Stories

- As a user, I want all sea-cleaning items shown independently of seasons, so that past-event defaults do not hide the catalog.
- As a user, I want to filter sea-cleaning items through level 8, so that the filter covers the complete catalog.
- As an administrator, I want sea-cleaning data kept outside event configuration, so that it cannot accidentally affect global event filters.

## 3. Functional Scope

### In Scope

- 바다청소 페이지의 빠른·상세 이벤트 필터 제거
- 바다청소 카드·테이블의 이벤트 필터용 속성 제거
- 관리자 바다청소 폼과 INSERT/UPDATE에서 이벤트 입력·저장 제거
- 전역 이벤트 후보 조회에서 바다청소 테이블 제외
- 기존 바다청소 `event_name`을 NULL로 정리하는 SQL
- 바다청소 레벨 필터를 Lv.8까지 확장

### Out Of Scope

- 다른 도감의 이벤트 필터 동작 변경
- `sea_cleaning_collections.event_name` 물리 컬럼 삭제
- 운영 바다청소 항목의 이름·가격·숙련도 데이터 변경

## 4. Acceptance Criteria

- 로컬 DB에 과거 `event_name` 값이 남아 있어도 페이지 렌더링 결과에는 영향을 주지 않는다.
- 이벤트 필터 UI와 `data-event`가 바다청소 템플릿에 존재하지 않는다.
- 바다청소 저장 SQL은 이벤트 입력값을 사용하지 않고 기존 행의 이벤트 값을 NULL로 만든다.
- 전역 이벤트명 UNION에 `sea_cleaning_collections`가 존재하지 않는다.
- 레벨 필터에 7과 8이 포함된다.
- 기존 ID 기반 체크리스트 키와 로컬 마이그레이션은 그대로 유지된다.

## 5. Constraints

- Tech: Java 17, Spring Boot, Thymeleaf, MyBatis, MySQL 8.0.
- Time: 바다청소 범위로 제한한다.
- Data: Spring SQL 자동 실행이 꺼져 있으므로 정리 SQL은 환경별로 별도 실행해야 한다.
- External Dependencies: 없음.

## 6. Risks

- 로컬 DB 정리 SQL을 실행하지 않으면 불필요한 값이 남는다: UI와 저장 경로에서도 시즌 값을 무시해 화면 장애를 막고 별도 검증 쿼리를 제공한다.
- 공용 모델에서 이벤트 필드를 즉시 삭제하면 매퍼 호환 범위가 커진다: 물리 컬럼과 상속 필드는 유지하되 바다청소 경로에서만 사용하지 않는다.

## 7. Open Questions

- 없음. 바다청소는 시즌에 포함하지 않고 레벨 범위는 1~8로 확정한다.
