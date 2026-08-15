# PRD: 바다청소 이름 일괄 변경

## 1. Summary

### Problem

운영 바다청소 도감의 조개·고둥 이름 6개를 최신 명칭으로 교정해야 한다. 이름 기반으로 직접 갱신하면 오탈자나 이후 이름 변경 때문에 잘못된 행을 수정할 수 있고, 체크리스트 레거시 별칭까지 바꾸면 기존 사용자 상태를 복구할 수 없다.

### Proposed Solution

확인된 바다청소 ID를 기준으로 이름 6개를 한 트랜잭션에서 변경한다. `legacy_checklist_name`은 수정하지 않고, 배포 후 ID 체크리스트 키 전환이 완료된 다음 SQL을 실행한다.

### Success Criteria

- 지정된 ID 6개의 `name`만 새 이름으로 변경된다.
- `legacy_checklist_name`은 변경 전 이름을 유지한다.
- 변경 후 이름 중복과 변경 누락이 없다.
- 기존 별점·명인 체크리스트 상태가 ID 키로 유지된다.

## 2. Users And Use Cases

### Primary Users

- 최신 바다청소 명칭을 조회하는 사용자
- 운영 데이터를 관리하는 관리자

### User Stories

- As a user, I want corrected sea-cleaning names without losing my ratings, so that the catalog remains accurate and my progress is preserved.

## 3. Functional Scope

### In Scope

- ID 1, 6, 8, 10, 11, 14의 이름 변경
- 실행 전 상태·중복 검증, 트랜잭션 갱신, 실행 후 결과 검증 SQL
- 배포 및 체크리스트 키 이전 이후 실행 순서 명시

### Out Of Scope

- `legacy_checklist_name` 변경
- 이미지 URL 또는 이미지 파일명 변경
- 나머지 바다청소 항목 변경

## 4. Acceptance Criteria

- ID 1은 `손상된 바닷조개`가 된다.
- ID 6은 `개굴잠쟁이`가 된다.
- ID 8은 `프로라 텔린조개`가 된다.
- ID 10은 `크로세아 클램`이 된다.
- ID 11은 `무명올각시실꼬리고둥`이 된다.
- ID 14는 `노빌리스 두순고둥`이 된다.
- 여섯 행의 `legacy_checklist_name`은 기존 값과 동일하다.

## 5. Constraints

- Tech: MySQL 8.0.
- Time: 새 코드 배포와 사용자 체크리스트 ID 키 이전 이후 실행한다.
- Data: ID는 로컬 기준 1, 6, 8, 10, 11, 14이며 운영 실행 전에 기존 이름을 재검증한다.
- External Dependencies: 애플리케이션 캐시 갱신을 위한 재시작 또는 재배포가 필요하다.

## 6. Risks

- 운영 ID가 로컬과 다를 수 있다: SQL이 ID와 기존 이름을 동시에 조건으로 검사하고 예상 6건이 아니면 갱신하지 않도록 한다.
- 직접 SQL 변경이 애플리케이션 캐시에 즉시 반영되지 않는다: SQL 실행 후 애플리케이션을 재시작한다.
- 이름 변경으로 기존 로컬 키가 끊길 수 있다: 영구 레거시 별칭을 보존하고 ID 키 코드 배포 뒤 실행한다.

## 7. Open Questions

- 없음. 사용자 입력의 `샤프란 대왕조개`는 현재 DB의 ID 10 `사프란 대왕조개`로 확인했다.
