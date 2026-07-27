# Implementation Plan: 반려동물 이름 수정 및 호텔 상태

## Context

- Spec: `specs/007-pet-name-hotel-status/spec.md`
- Target branch: current working branch
- Current codebase notes:
  - 반려동물 상태는 `pets.html`의 프로필 객체 배열로 관리한다.
  - 동기화가 꺼지면 `heartopia_pet_food_profiles` localStorage에, 켜지면 기존 `/api/user/pet-food` API와 `user_pet_food.pets_json`에 전체 배열을 저장한다.
  - 서버는 허용된 프로필 필드와 이름 길이 등을 `UserPetFoodService`에서 검증한다.
  - 현재 `pets.html`에는 사용자가 작업 중인 먹이 이미지 별칭 변경이 있으므로 해당 부분을 보존해야 한다.

## Approach

기존 프로필 JSON에 `inHotel` 불리언을 추가하고 누락 시 `false`로 정규화한다. 선택 툴바에 이름 편집 폼과 호텔 체크 컨트롤을 추가하며, 목록 칩에 호텔 배지와 강조 스타일을 표시한다. 클라이언트에서 여섯 번째 입실을 즉시 막고 서버에서도 전체 입실 개수를 재검증한다.

## Impacted Files

- `src/main/resources/templates/wiki/others/pets.html`: 이름 편집 UI·동작, 호텔 체크·제한·표시, 프로필 정규화
- `src/main/java/com/heartopia/wiki/service/UserPetFoodService.java`: `inHotel` 허용 필드, 타입과 최대 5마리 검증
- `src/test/java/com/heartopia/wiki/service/UserPetFoodServiceTest.java`: 호텔 필드 서버 검증 회귀 테스트
- `src/test/java/com/heartopia/wiki/template/PetManagementTemplateTest.java`: 이름 편집·호텔 UI 및 프로필 기본값 계약 테스트
- `specs/007-pet-name-hotel-status/tasks.md`: 실행 및 검증 기록

## Data Model

- 반려동물 프로필 JSON에 `inHotel: boolean`을 추가한다.
- 기존 프로필은 필드 누락을 허용하며 클라이언트에서 `false`로 정규화한다.
- 별도 테이블, 컬럼, 마이그레이션은 추가하지 않는다.

## API Or Interface Changes

- 기존 `PUT /api/user/pet-food`, 마이그레이션, 동기화 API가 `inHotel` 필드를 허용한다.
- 엔드포인트와 응답 형식의 최상위 구조는 변경하지 않는다.
- 선택 툴바에 이름 수정 버튼·폼과 호텔 체크박스를 추가한다.

## Validation And Error Handling

- 클라이언트는 이름을 trim하고 빈 값과 80자 초과를 거부한다.
- 서버는 기존 이름 검증을 그대로 적용한다.
- 클라이언트는 입실 중인 프로필이 5개이면 여섯 번째 체크를 되돌리고 안내한다.
- 서버는 `inHotel`이 불리언이 아니거나 `true`가 5개를 초과하면 저장·마이그레이션·동기화를 거부한다.
- 저장 실패는 기존 메시지 경로를 사용한다.

## Test Plan

- 서비스 단위 테스트:
  - 기존 프로필의 호텔 필드 누락 허용
  - 입실 5마리 허용
  - 입실 6마리 거부 및 DB 미쓰기
  - 잘못된 호텔 필드 타입 거부
- 템플릿 계약 테스트:
  - 이름 편집 폼과 호텔 체크 컨트롤 존재
  - 신규·기존 프로필에 `inHotel` 기본값 적용
  - 호텔 최대값 상수와 목록 배지 렌더링 존재
- Gradle 전체 테스트 실행
- 변경 diff를 확인해 기존 이미지 별칭 변경이 보존되었는지 확인

## Risks And Mitigations

- 클라이언트 상태와 서버 검증 불일치: 양쪽에 동일한 최대값 5를 두고 경계 테스트를 추가한다.
- 인라인 HTML/JS가 커짐: 기존 페이지 구조 안에서 이름·호텔 관련 함수만 분리하고 새 외부 의존성은 추가하지 않는다.
- 사용자 작업과 충돌: 대상 파일의 이미지 별칭 구간은 수정하지 않고 최종 diff로 보존을 확인한다.

## Alternatives Considered

- 호텔 전용 DB 테이블 추가: 날짜·객실 이력 없이 현재 상태만 필요해 과도하므로 채택하지 않는다.
- 여섯 번째 체크 시 가장 오래된 반려동물 자동 퇴실: 사용자의 기존 상태를 임의 변경하므로 채택하지 않는다.
- 이름 수정에 브라우저 `prompt` 사용: 모바일 사용성과 검증 안내가 떨어져 인라인 편집 폼을 사용한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
