# Implementation Plan: 요리 회복량 UI·영문명 참고표

## Context

- Spec: `specs/028-cooking-bilingual-recovery-ui/spec.md`
- Target branch: 현재 작업 트리, push 금지
- Current codebase notes:
  - 목록과 상세는 `CollectionMapper`의 동일 `cookingColumns` SELECT를 사용한다.
  - `CookingCollection` 모델이 Thymeleaf 목록·상세와 관리자 폼 바인딩에 공통 사용된다.
  - 목록 카드에는 공통 가격 fragment가 있고 상세에는 별도 5성 가격 grid가 있다.
  - Spring SQL 자동 실행이 꺼져 있어 마이그레이션은 배포 전에 수동 적용해야 한다.

## Approach

한 번의 스키마/백필 SQL로 nullable 회복량 필드만 추가한다. 모델과 MyBatis 공통 컬럼·CRUD를 확장해 추가 쿼리 없이 데이터를 전달하고, 목록/상세 UI에는 기존 가격 영역 바로 아래에 회복량 영역을 추가한다. 영문명은 Markdown 참고표로만 생성한다.

## Impacted Files

- `src/main/resources/sql/20260817_add_cooking_recovery.sql`: 회복량 컬럼 및 175개 백필
- `_workspace/recipe_detail_matching_results/cooking_name_ko_en_reference.md`: 서비스 외부 이름 비교표
- `tools/build_cooking_ui_migration.py`: 검증 CSV에서 결정론적으로 백필 SQL 생성
- `src/main/java/com/heartopia/wiki/model/CookingCollection.java`: 새 필드와 회복량 helper
- `src/main/resources/mapper/CollectionMapper.xml`: SELECT/검색/INSERT/UPDATE 연결
- `src/main/resources/templates/wiki/items/cooking.html`: 카드·표·관리자 입력 UI
- `src/main/resources/templates/wiki/detail.html`: 상세 회복량 UI
- `src/test/java/com/heartopia/wiki/template/CookingBilingualRecoveryTemplateTest.java`: UI 계약 테스트
- `src/test/java/com/heartopia/wiki/data/CookingBilingualRecoveryDataTest.java`: SQL 데이터 계약 테스트

## Data Model

- `recovery_1`~`recovery_5 INT NULL`
- 회복량 배열 순서는 1성부터 5성까지 고정한다.

## API Or Interface Changes

- `CookingCollection`: `recovery1`~`recovery5`, `getRecoveries()`, `hasRecoveryData()` 추가
- 공개 URL 변경 없음
- 관리자 요리 폼에 회복량 입력 5개 추가

## Validation And Error Handling

- 생성기는 canonical 175행, 고유 한글명 175개, 영문명 175개를 강제한다.
- 회복량 숫자는 비음수가 아니어야 하며 없는 슬롯은 NULL로 유지한다.
- UI는 전체 NULL과 부분 NULL을 모두 처리한다.

## Test Plan

- 모델/Mapper/템플릿 계약을 JUnit 문자열·리플렉션 테스트로 검증한다.
- SQL이 175개 이름을 백필하며 111개 이상 숫자 회복량을 포함하는지 검증한다.
- 전체 Gradle 테스트 또는 관련 테스트를 실행한다.
- SQL/코드 의존 순서와 push 미실행을 최종 확인한다.

## Risks And Mitigations

- 코드 먼저 배포 시 새 컬럼 SELECT 실패: SQL을 반드시 코드 배포 전에 실행하도록 명시한다.
- 기존 작업 트리가 매우 더러움: 요청 파일만 수정하고 stage/commit/push하지 않는다.
- 모바일 카드 과밀: 5열 compact grid와 작은 보조 텍스트를 사용한다.

## Alternatives Considered

- Java 정적 Map: DB와 관리자 CRUD가 분리되고 재배포 없이 수정할 수 없어 제외했다.
- 별도 회복량 테이블: 1:1 고정 5슬롯 데이터에 과설계라 제외했다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 없다.
