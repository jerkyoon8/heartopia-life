# Implementation Plan: 바다청소 이름 일괄 변경

## Context

- Spec: `specs/026-sea-cleaning-name-corrections/spec.md`
- Target branch: 현재 작업 트리
- Current codebase notes:
  - 로컬 DB에서 대상 ID와 기존 이름을 확인했다: 1, 6, 8, 10, 11, 14.
  - ID 키 전환용 `legacy_checklist_name`에 현재 기존 이름이 저장되어 있다.
  - `CollectionService.getAllSeaCleaningCollections()`는 캐시되므로 직접 SQL 변경 후 애플리케이션 재시작이 필요하다.

## Approach

대상 행을 트랜잭션에서 잠근 뒤 세션 변수로 실행 전 조건, 새 이름 충돌, 레거시 별칭을 검증한다. 조건이 정확하면 ID 기반 단일 UPDATE를 수행한다. 조건이 다르면 WHERE 절이 전체 갱신을 차단해 0건만 처리하며, SELECT·UPDATE 외 추가 권한은 요구하지 않는다.

## Impacted Files

- `src/main/resources/sql/20260815_rename_sea_cleaning_collections.sql`: 안전한 일괄 이름 변경과 검증.
- `src/test/java/com/heartopia/wiki/sql/SeaCleaningRenameSqlTest.java`: ID·이름·레거시·트랜잭션 계약 검증.
- `specs/026-sea-cleaning-name-corrections/*`: 적용 순서와 데이터 계약 문서.

## Data Model

- `sea_cleaning_collections.name`만 갱신한다.
- `legacy_checklist_name`, ID, 이미지 URL, 체크리스트 데이터는 변경하지 않는다.

## API Or Interface Changes

- API 및 화면 코드 변경 없음.
- 운영 DB의 표시 이름만 변경된다.

## Validation And Error Handling

- 기존 ID·이름 6건 일치 여부를 검사한다.
- 레거시 별칭 6건이 기존 이름과 일치하는지 검사한다.
- 새 이름이 다른 ID에 존재하는지 검사한다.
- 불일치 시 조건부 단일 UPDATE가 0건을 반환해 부분 변경을 방지한다.
- 이미 6건 모두 변경된 경우 상태를 반환하고 데이터는 다시 갱신하지 않는다.

## Test Plan

- SQL 계약 테스트로 6개 매핑, 레거시 비수정, 트랜잭션·롤백·SIGNAL을 확인한다.
- 로컬 DB 복사본 또는 로컬 DB에서 실행할 때 변경 전후 조회와 체크리스트 키를 확인한다.
- 전체 Gradle 테스트와 `git diff --check`를 실행한다.

## Risks And Mitigations

- 운영 데이터가 예상과 다를 수 있다: 부분 변경 없이 SIGNAL로 중단한다.
- SQL 실행 후 이름이 즉시 안 보일 수 있다: 애플리케이션 캐시를 재시작으로 비운다.
- 실행 시점이 잘못되면 구형 이름 키가 끊길 수 있다: ID 키 코드 배포와 사용자 키 이전 뒤에만 실행한다.

## Alternatives Considered

- 이름을 WHERE 조건으로만 UPDATE: 오탈자와 중복에 취약해 채택하지 않는다.
- 관리자 화면에서 6번 수정: 캐시 제거는 되지만 반복 작업 중 실수 가능성이 높고 원자적이지 않아 채택하지 않는다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
