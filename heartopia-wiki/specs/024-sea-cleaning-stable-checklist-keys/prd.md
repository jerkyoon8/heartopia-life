# PRD: 바다청소 체크리스트 ID 키 전환

## 1. Summary

### Problem

바다청소 체크·별점·명인 상태의 저장 키가 조개 이름으로 만들어져, 운영 중 이름을 변경하면 기존 사용자 상태가 새 항목과 연결되지 않는다. 서버 DB 값은 SQL로 바꿀 수 있지만 오래된 브라우저의 로컬 값도 나중에 복구되어야 한다.

### Proposed Solution

바다청소만 DB ID 기반 체크리스트 키로 전환한다. 전환 직전 이름을 변경 불가 레거시 별칭으로 저장하고, 서버 저장값과 브라우저 로컬 저장값을 ID 키로 한 번 마이그레이션한다.

### Success Criteria

- 바다청소 이름을 변경해도 체크·1~5별·명인 상태가 유지된다.
- 전환 배포 전에 접속하지 않은 로컬 사용자도 나중에 바다청소 또는 체크리스트 페이지에 들어오면 상태가 복구된다.
- 로그인 동기화 사용자가 구형 로컬 키를 업로드해도 서버에는 ID 키로 저장된다.
- 물고기, 곤충, 새, 요리, 꽃, 작물, 업적의 키는 변경하지 않는다.

## 2. Users And Use Cases

### Primary Users

- 바다청소 수집 상태를 로컬 또는 계정 동기화로 저장한 사용자
- 운영 중 조개 이름을 수정하는 관리자

### User Stories

- As a user, I want my sea-cleaning ratings and mastery state to survive item renames, so that editorial corrections do not erase my progress.
- As an administrator, I want to rename sea-cleaning items without coordinating user-data key changes each time.

## 3. Functional Scope

### In Scope

- `sea_cleaning_{이름}`을 `sea_cleaning_id_{ID}`로 전환한다.
- `mastery_sea_cleaning_{이름}`을 `mastery_sea_cleaning_id_{ID}`로 전환한다.
- 현재 이름을 최초 레거시 별칭으로 고정하는 DB 컬럼과 SQL 마이그레이션을 추가한다.
- 로컬스토리지 버전을 사용해 브라우저 데이터를 최초 한 번 변환한다.
- 서버 체크리스트 쓰기·병합·조회 경계에서 구형 키를 정규화한다.

### Out Of Scope

- 다른 도감의 이름 기반 키 전환
- 체크리스트 API URL 또는 인증 정책 변경
- 실제 조개 이름 데이터 변경

## 4. Acceptance Criteria

- 일반 키와 명인 키 모두 동일한 바다청소 ID를 사용한다.
- 기존 키와 새 키가 동시에 있으면 더 높은 별점을 보존한다.
- 로컬 변환 성공 후에만 `heartopia_checklist_sea_cleaning_version=2`를 저장한다.
- 버전이 이미 `2`면 데이터 순회 없이 종료한다.
- 새 바다청소 항목은 처음부터 ID 키를 사용하며 레거시 별칭이 없어도 동작한다.
- 운영 이름 변경은 `legacy_checklist_name`을 수정하지 않는다.

## 5. Constraints

- Tech: Java 17, Spring Boot 3.4.2, MyBatis, MySQL 8.0, Vanilla JS.
- Time: 바다청소 범위로 제한한다.
- Data: 컬럼 SQL은 코드 배포 전에, 사용자 키 SQL은 코드 배포 후에 실행해야 한다.
- External Dependencies: 없음.

## 6. Risks

- 코드가 DB 컬럼보다 먼저 배포되면 조회가 실패한다: 사전 컬럼 SQL과 사후 사용자 키 SQL을 분리하고 각각 검증 쿼리를 제공한다.
- 구형·신형 키 충돌로 별점이 낮아질 수 있다: 병합 시 큰 값을 보존한다.
- 오래된 브라우저가 구형 키를 다시 업로드할 수 있다: 서버 입력 경계에서도 영구적으로 정규화한다.

## 7. Open Questions

- 없음. 전환 범위는 바다청소만이며, 장기 미접속 로컬 데이터도 보존하는 것으로 확정한다.
