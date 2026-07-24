# Implementation Plan: 사용자별 반려동물 먹이 관리

## Context

- Spec: `specs/005-user-pet-food-management/spec.md`
- Target branch: 현재 작업 브랜치
- Current codebase notes:
  - 반려동물·먹이 상태는 `pets.html`의 Vanilla JS가 반려동물 프로필 배열로 관리한다.
  - 동기화 활성 사용자는 인증 전용 `/api/user/pet-food`에 전체 프로필 JSON을 저장한다.
  - 동기화 비활성 사용자는 하나의 공용 localStorage 키를 사용한다.
  - 기본 먹이는 강아지·고양이 이름 배열로 정의되어 있고 표시용 ID는 이름에서 생성한다.
  - 대상 템플릿에는 사용자의 미커밋 다크 모드·이미지 별칭 변경이 있으므로 해당 변경을 보존해야 한다.

## Approach

서버 API와 DB 스키마는 그대로 유지하고 프로필 JSON을 확장한다. 선택 반려동물에 `customFoods`와 `hiddenFoodIds`를 정규화하고, 표시 목록은 기본 목록에서 숨김 항목을 제외한 뒤 사용자 정의 항목을 결합한다. 동기화가 꺼진 상태는 로그인 여부와 관계없이 하나의 localStorage 키를 사용한다.

반려동물 페이지 컨트롤러는 기존 캐시된 물고기·요리·채집·작물 목록에서 이름별 이미지 URL 맵을 만들어 Thymeleaf에 제공한다. 사용자 정의 먹이는 공백을 제거한 이름으로 이 맵을 조회하며, 매칭되지 않거나 이미지가 없으면 기존 대체 아이콘을 쓴다.

## Impacted Files

- `src/main/resources/templates/wiki/others/pets.html`: 인증 컨텍스트, 먹이 추가 폼, 삭제 버튼, 프로필 정규화, 목록 결합, 개인별 저장 키, 순차 저장, 스타일 추가
- `src/main/resources/templates/fragments/common-head.html`: 동기화 상태와 공용 펫 먹이 로컬 저장 키 제공, 로그인 시 마이그레이션 처리
- `src/main/resources/templates/fragments/header.html`: 동기화 토글과 로그아웃 백업에서 공용 저장 키 사용
- `src/main/java/com/heartopia/wiki/controller/WikiController.java`: 기존 도감 DB의 먹이 이름별 이미지 URL을 반려동물 화면에 제공
- `src/main/java/com/heartopia/wiki/service/UserPetFoodService.java`: 프로필 JSON 구조·길이·개수 검증
- `src/main/java/com/heartopia/wiki/exception/PetFoodValidationException.java`: 사용자 입력 검증 실패 예외
- `src/main/java/com/heartopia/wiki/advice/GlobalExceptionHandler.java`: 펫 먹이 검증 실패를 HTTP 400 JSON으로 변환
- `src/test/java/com/heartopia/wiki/service/UserPetFoodServiceTest.java`: 정상·경계·거부 검증 단위 테스트
- `specs/005-user-pet-food-management/tasks.md`: 구현 작업 및 검증 상태 기록

## Data Model

- 기존 반려동물 프로필 JSON에 다음 선택 필드를 추가한다.
  - `customFoods: Array<{id: string, name: string}>`
  - `hiddenFoodIds: Array<string>`
- 기존 필드가 없는 데이터는 클라이언트 정규화 단계에서 빈 배열로 처리한다.
- DB 컬럼·테이블·인덱스 변경은 없다.

## API Or Interface Changes

- 기존 `PUT /api/user/pet-food` 요청 본문의 각 프로필에 신규 선택 필드가 포함될 수 있다.
- API 경로, 메서드, 응답 형식은 변경하지 않는다.
- 검증 실패 응답은 HTTP 400과 `{ success: false, message }` JSON을 반환한다.
- UI에 먹이 추가 폼과 먹이 카드별 삭제 버튼을 추가하고 DB 이미지 매칭 결과를 표시한다.

## Validation And Error Handling

- 이름의 앞뒤 공백을 제거하며 빈 값은 거부한다.
- 공백 제거·소문자화한 이름 키로 중복을 검사한다.
- 서버는 필수 필드와 중첩 필드 타입, 허용 값, 문자열 길이, 항목 수를 다시 검증한다.
- 숨긴 기본 먹이와 이름이 같으면 복원으로 처리한다.
- 저장 실패 시 화면 상단 메시지로 알리고 순차 저장 체인은 다음 저장을 계속 받을 수 있게 복구한다.

## Test Plan

- `./gradlew.bat test`로 기존 Spring 테스트 회귀 확인
- 정적 검사로 템플릿 내 중복 ID, 함수 참조, 인증 조건, 신규 프로필 필드를 확인
- 가능하면 로컬 애플리케이션에서 로그인/비로그인 DOM과 추가·삭제·복원 흐름을 수동 확인
- 사용자 변경이 있는 `pets.html`의 기존 diff가 보존됐는지 최종 diff 확인

## Risks And Mitigations

- 같은 브라우저의 동기화 OFF 계정들이 데이터를 공유함: 로그인·로그아웃 연속성을 우선하는 명시적 제품 정책으로 허용한다.
- 이미지 맵 생성 비용: 기존 `@Cacheable` 목록을 재사용해 캐시 준비 후 DB 반복 조회를 피한다.
- 비동기 PUT 응답 순서 역전: Promise 체인으로 요청을 직렬화한다.
- 사용자 정의 이름을 통한 XSS: 기존 `escapeHtml`/`escapeAttr` 경로만 사용해 렌더링한다.
- 기본 먹이 삭제 후 복원 경로 부재: 같은 이름 추가를 복원 동작으로 정의한다.

## Alternatives Considered

- 기본 먹이 원본 배열에서 삭제: 모든 사용자에게 영향을 주므로 채택하지 않는다.
- 사용자 정의 먹이 전용 DB 테이블: 현재 JSON 기반 프로필 규모에 비해 과도하며 마이그레이션이 필요해 채택하지 않는다.
- 로그인 즉시 동기화를 강제: 기존 명시적 동기화 선택 정책을 깨므로 채택하지 않는다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
