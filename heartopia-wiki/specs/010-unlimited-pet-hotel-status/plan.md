# Implementation Plan: 반려동물 호텔 체크 개수 제한 제거

## Context

- Spec: `specs/010-unlimited-pet-hotel-status/spec.md`
- Target branch: current working branch
- Current codebase notes:
  - 클라이언트는 `HOTEL_CAPACITY = 5`와 체크 시 개수 비교로 여섯 번째 입실을 차단한다.
  - 서버는 `MAX_HOTEL_PETS = 5`와 반복문 카운터로 저장을 차단한다.
  - 서버의 `inHotel instanceof Boolean` 검증은 개수 검증과 분리되어 있다.

## Approach

서비스에서 호텔 상수·카운터·최종 개수 오류만 제거하고 불리언 타입 검증은 그대로 둔다. 클라이언트에서도 호텔 개수 계산과 차단 분기를 제거하여 체크 상태를 즉시 저장한다. 호텔 토글 주변에 실제 게임 캐릭터당 정원 안내를 추가한다.

## Impacted Files

- `src/main/java/com/heartopia/wiki/service/UserPetFoodService.java`: 호텔 개수 제한 제거, 타입 검증 유지
- `src/main/resources/templates/wiki/others/pets.html`: 클라이언트 차단 제거 및 안내 문구
- `src/test/java/com/heartopia/wiki/service/UserPetFoodServiceTest.java`: 20마리 호텔 상태 허용 및 잘못된 타입 거부 검증
- `src/test/java/com/heartopia/wiki/template/PetManagementTemplateTest.java`: 용량 상수·차단 제거 및 안내 문구 검증
- `specs/010-unlimited-pet-hotel-status/*.md`: 결정과 작업 기록

## Data Model

- 변경 없음. `inHotel`은 계속 선택적 불리언 필드다.

## API Or Interface Changes

- API 형식 변경 없음.
- 검증 정책만 호텔 체크 개수 무제한으로 변경된다.

## Validation And Error Handling

- `inHotel`이 `Boolean`이 아니면 기존 오류를 반환한다.
- 프로필 20개 초과, 중복 ID 및 나머지 프로필 검증은 유지한다.
- 호텔 상태 개수로는 오류를 반환하지 않는다.

## Test Plan

- 서비스 테스트에서 호텔 상태 20개 저장 성공을 검증한다.
- 문자열 `inHotel` 저장 실패 회귀 테스트를 유지한다.
- 템플릿 테스트에서 용량 상수와 차단 메시지가 제거되고 안내가 존재하는지 검증한다.
- `gradlew.bat test`로 전체 회귀 테스트를 실행한다.

## Risks And Mitigations

- 검증 전체가 약해질 가능성: 삭제 대상을 상수·카운터·개수 분기로 한정하고 타입 오류 테스트를 유지한다.
- 실제 게임 규칙 오해: 저장 버튼 근처에 캐릭터당 5마리 안내를 둔다.

## Alternatives Considered

- 5마리 제한 유지: 공동 위키 계정의 정상 기록을 막으므로 채택하지 않는다.
- 캐릭터 구분 기능 추가: 현재 요구보다 범위가 크므로 제외한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
