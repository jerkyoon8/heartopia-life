# Implementation Plan: 일일 자원 위치

## Context

- Spec: `specs/018-daily-resource-locations/spec.md`
- Target branch: 현재 작업 브랜치
- Current codebase notes:
  - 공통 헤더의 시계·날씨는 `fragments/header.html`, `common.css`, `header-weather.js`로 구성된다.
  - 시계 API 응답은 이미 Asia/Seoul 서버 시각을 제공한다.
  - `/wiki/admin/**`는 `SecurityConfig`에서 `ROLE_ADMIN`으로 보호된다.
  - 관리자 CRUD는 Controller → Service → MyBatis Mapper → MySQL 패턴을 사용한다.
  - `spring.sql.init.mode=never`이므로 신규 테이블 SQL은 로컬 DB에 별도로 적용해야 한다.

## Approach

`daily_resource_locations` 테이블에 게임 날짜별 두 자원 위치를 저장한다. 서비스는 주입 가능한 `Clock`으로 Asia/Seoul 현재 시각에서 6시간을 빼 게임 날짜를 계산하고, 현재 위치 API와 관리자 CRUD에 동일한 검증 규칙을 적용한다. 헤더는 날씨 컴포넌트 내부에서 시계 버튼 바로 왼쪽에 별도 위치 블록을 배치하며, 전용 JS가 서버 시각을 기준으로 다음 오전 6시 재조회와 탭 복귀 재조회를 담당한다.

## Impacted Files

- `src/main/resources/sql/20260730_create_daily_resource_locations.sql`: 테이블·인덱스·체크 제약
- `src/main/java/com/heartopia/wiki/model/DailyResourceLocation.java`: 날짜별 위치 모델과 표시 라벨
- `src/main/java/com/heartopia/wiki/mapper/DailyResourceLocationMapper.java`: 현재 날짜·전체 목록·upsert·삭제 인터페이스
- `src/main/resources/mapper/DailyResourceLocationMapper.xml`: MyBatis SQL
- `src/main/java/com/heartopia/wiki/service/DailyResourceLocationService.java`: 오전 6시 게임 날짜, 검증, CRUD
- `src/main/java/com/heartopia/wiki/dto/DailyResourceLocationResponse.java`: 공개 API 응답
- `src/main/java/com/heartopia/wiki/controller/DailyResourceLocationController.java`: 공개 조회 API와 관리자 페이지·변경 요청
- `src/main/resources/templates/wiki/admin-daily-resource-locations.html`: 관리자 예약 입력·목록 화면
- `src/main/resources/templates/fragments/header.html`: 시계 왼쪽 위치 블록과 관리자 링크
- `src/main/resources/static/css/common.css`: 헤더 위치 블록의 반응형·테마 스타일
- `src/main/resources/static/js/header-daily-resources.js`: 초기 조회, 오전 6시 예약 갱신, 탭 복귀 갱신
- `src/test/java/com/heartopia/wiki/service/DailyResourceLocationServiceTest.java`: 시간 경계·검증·upsert 테스트
- `src/test/java/com/heartopia/wiki/template/HeaderDailyResourceLocationTemplateTest.java`: 헤더·관리자 화면·SQL 연결 회귀 테스트

## Data Model

- `daily_resource_locations`
  - `id`: BIGINT PK
  - `game_date`: DATE, unique
  - `fluorite_location_type`: `HOUSE_FRONT` 또는 `RUINS`
  - `fluorite_house_number`: 집 앞일 때 양의 정수, 유적일 때 null
  - `oak_location_type`: `HOUSE_FRONT` 또는 `RUINS`
  - `oak_house_number`: 집 앞일 때 양의 정수, 유적일 때 null
  - `is_active`: 관리자 삭제 시 false, 같은 날짜 재저장 시 true
  - `created_at`, `updated_at`

## API Or Interface Changes

- `GET /api/daily-resource-locations/current`: 서버 시각과 현재 두 위치 라벨 공개 조회
- `GET /wiki/admin/daily-resource-locations`: 관리자 예약 목록·입력 페이지
- `POST /wiki/admin/daily-resource-locations/save`: 날짜 기준 등록 또는 수정
- `POST /wiki/admin/daily-resource-locations/delete`: ID 기준 비활성화

## Validation And Error Handling

- 위치 유형은 허용 목록 두 개만 받는다.
- `HOUSE_FRONT`는 1 이상의 집 번호를 요구한다.
- `RUINS`는 전달된 집 번호를 null로 정규화한다.
- 유효하지 않은 관리자 입력은 저장하지 않고 flash 오류 메시지와 함께 관리 페이지로 돌려보낸다.
- 현재 데이터가 없거나 공개 API 요청이 실패하면 헤더에 `위치 정보 없음`을 표시한다.
- 삭제는 신규 테이블에 별도 DELETE 권한이 없어도 동작하도록 UPDATE 기반 비활성화로 처리한다.

## Test Plan

- 고정 `Clock`으로 오전 5:59와 6:00 게임 날짜 경계를 검사한다.
- 집 앞·유적 정규화와 잘못된 집 번호 거부를 검사한다.
- 같은 날짜 저장이 mapper upsert로 전달되는지 검사한다.
- SQL 테이블·unique key·허용 위치 제약과 헤더 DOM/API 경로를 템플릿 테스트로 검사한다.
- Gradle 전체 테스트를 실행한다.
- 로컬 MySQL에 SQL을 적용하고 오늘·미래 샘플 예약을 저장·조회한다.
- 로컬 페이지에서 헤더 위치 텍스트, 관리자 페이지 200, 공개 API, 모바일 너비를 확인한다.

## Risks And Mitigations

- 공통 헤더 폭 증가: 기존 날씨 컨테이너 안에 결합하고 좁은 화면에서 라벨을 축약한다.
- 매 페이지 API 호출: 최초 1회, 오전 6시 경계, 탭 복귀 시에만 조회한다.
- 브라우저 절전으로 타이머 지연: `visibilitychange`에서 재조회한다.
- DB 테이블 미적용 상태에서 앱 오류: 코드 실행·검증 전에 생성 SQL을 로컬 DB에 적용하고 배포 시 선행 조건으로 명시한다.
- 신규 테이블 DELETE 권한 부재: 물리 삭제 대신 복구 가능한 비활성화를 사용한다.

## Alternatives Considered

- 헤더 안 인라인 관리자 폼: 미래 날짜 목록 관리가 어렵고 일반 헤더가 복잡해져 제외했다.
- 자유문구 위치: 오타와 표기 불일치가 누적되므로 제외했다.
- 매분 API 폴링: 트래픽이 불필요하게 증가해 오전 6시 예약 타이머와 탭 복귀 재조회로 대체한다.
- 이전 날짜 위치 자동 유지: 잘못된 오래된 위치를 보여 줄 위험이 있어 빈 상태를 사용한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
