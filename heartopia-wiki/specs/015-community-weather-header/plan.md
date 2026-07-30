# Implementation Plan: 아시아 서버 참여형 시간·날씨 헤더

## Context

- Spec: `specs/015-community-weather-header/spec.md`
- Target branch: 현재 작업 브랜치
- Current codebase notes:
  - 공통 헤더는 `templates/fragments/header.html` 한 파일이 모든 주요 페이지에 제공한다.
  - 헤더 내부에 설정·로그아웃 스크립트가 이미 길게 존재하므로 날씨 동작은 별도 JS 파일로 분리한다.
  - `CustomOAuth2User`에서 DB 사용자 ID와 `ROLE_ADMIN` 권한을 얻을 수 있다.
  - `/api/user/**`는 로그인 전용이며 공통 `<meta>`에 CSRF 토큰이 제공된다.
  - MyBatis 매퍼는 인터페이스와 XML을 분리하고 `ON DUPLICATE KEY UPDATE`로 사용자별 상태를 갱신한다.
  - MySQL 8.0을 사용하며 `spring.sql.init.mode=never`이므로 신규 SQL은 별도 적용해야 한다.
  - 사용자가 제공한 날씨 WebP 5개의 합계는 약 23KB이며 자원 아이콘 2개는 이번 범위에서 제외한다.

## Approach

날짜와 슬롯으로 식별되는 사용자 현재 표와 실제 값 변경 이력을 별도 테이블에 저장한다. 공개 조회 서비스는 아시아 서버 현재 시각을 기준으로 상세 5칸과 내일부터 시작하는 기본 7일 키를 만들고, 가중 집계 결과를 상태(`CONFIRMED`, `TIED`, `EMPTY`)로 변환한다. 상세 시간대와 날짜별 기본 결과는 독립적으로 유지하며 서로 대체하지 않는다.

공통 헤더에는 가벼운 요약 버튼과 확장 예보 패널을 추가한다. 로그인 사용자가 제보를 시작하면 별도 오버레이에서 알고 있는 여러 칸을 선택하고 한 번의 POST로 제출한다. 시계와 구간 경계는 클라이언트에서 갱신하며 6시간 경계가 바뀌면 API를 다시 조회한다.

## Impacted Files

- `src/main/resources/sql/weather-voting.sql`: 신규 투표·변경 이력 테이블과 인덱스
- `src/main/java/com/heartopia/wiki/model/WeatherVote.java`: 현재 표 모델
- `src/main/java/com/heartopia/wiki/model/WeatherVoteTally.java`: 집계 행 모델
- `src/main/java/com/heartopia/wiki/dto/weather/*.java`: 조회·배치 제출 요청/응답 DTO
- `src/main/java/com/heartopia/wiki/mapper/WeatherVoteMapper.java`: 투표·집계·정리 매퍼 인터페이스
- `src/main/resources/mapper/WeatherVoteMapper.xml`: MySQL 조회/upsert/history/cleanup SQL
- `src/main/java/com/heartopia/wiki/service/WeatherForecastService.java`: 시간 키 생성, 검증, 가중 합의, 저장
- `src/main/java/com/heartopia/wiki/controller/WeatherForecastController.java`: 공개 GET 및 로그인 POST API
- `src/main/java/com/heartopia/wiki/config/SecurityConfig.java`: 날씨 POST 인증 규칙
- `src/main/resources/templates/fragments/header.html`: 메뉴 정리, 시간·날씨 요약·패널·제보 오버레이
- `src/main/resources/static/css/common.css`: 날씨 UI 밝은/어두운 테마 및 반응형 스타일
- `src/main/resources/static/js/header-weather.js`: 시계, 조회, 패널, 배치 입력·제출
- `src/main/resources/static/images/weather/*.webp`: 사용자가 제공한 날씨 아이콘 5개
- `src/main/resources/templates/fragments/common-head.html`: 공통 CSS 캐시 버전 갱신
- `src/test/java/com/heartopia/wiki/service/WeatherForecastServiceTest.java`: 시간 구간·집계·검증 테스트
- `src/test/java/com/heartopia/wiki/template/HeaderWeatherTemplateTest.java`: 헤더 메뉴·마크업·자산 회귀 테스트

## Data Model

- `weather_votes`
  - `id BIGINT PK`
  - `user_id BIGINT FK users(id) ON DELETE CASCADE`
  - `forecast_date DATE`
  - `slot_hour TINYINT`: 기본 `-1`, 상세 `0/6/12/18`
  - `weather_code VARCHAR(32)`
  - `vote_weight TINYINT`: 일반 1, 관리자 5
  - `created_at`, `updated_at`
  - UNIQUE `(user_id, forecast_date, slot_hour)`
  - INDEX `(forecast_date, slot_hour, weather_code)`
- `weather_vote_history`
  - 사용자·예보 키, 이전/새 날씨, 변경 시각
  - `user_id` FK, `changed_at` 인덱스
- 현재 표는 수정 시 덮어쓰고, 값이 바뀐 경우에만 이력을 추가한다.
- 제출 때 `forecast_date < 오늘`인 현재 표와 `changed_at < 현재-7일` 이력을 정리한다.

## API Or Interface Changes

- `GET /api/weather/forecast`
  - 공개
  - 서버 기준 시각, 인증 여부, 상세 5칸, 기본 7일, 현재 사용자의 선택을 반환
- `POST /api/weather/votes`
  - 로그인 필수, CSRF 유지
  - `{ "votes": [{ "forecastDate": "YYYY-MM-DD", "slotHour": 6, "weatherCode": "SUNNY" }] }`
  - 최대 12개, 일부 칸 제출 허용, 성공 후 최신 전체 예보 반환
- 날씨 코드: `SUNNY`, `RAIN`, `RAINBOW`, `METEOR_SHOWER`, `HEATWAVE`
- 상태: `CONFIRMED`, `TIED`, `EMPTY`

## Validation And Error Handling

- 서버가 현재 `Asia/Seoul` 날짜와 허용 상세 5키·기본 7키를 직접 계산한다.
- 중복 키, 빈 배치, 12개 초과, 잘못된 날짜·슬롯·날씨는 400으로 처리한다.
- 가중치는 요청에서 받지 않고 인증 권한으로 1 또는 5를 결정한다.
- 비로그인 POST는 Spring Security가 차단한다.
- 클라이언트 조회 실패는 시계를 유지하고 날씨에 `정보 없음`을 표시한다.
- 제출 실패 시 선택을 유지하고 오류 메시지를 보여준다.

## Test Plan

- 서비스 단위 테스트
  - 08시 기준 상세 5구간과 자정 날짜 전환
  - 날짜별 기본 예보가 내일부터 7일 후까지 생성됨
  - 일반 4표 대 관리자 5점 결과
  - 일반 6표가 관리자 5점을 역전
  - 최고 점수 동점
  - 상세 EMPTY와 TIED가 날짜별 기본 날씨에 의해 대체되지 않음
  - 허용 범위 밖 날짜·슬롯·날씨·중복 키 거부
  - 기존 값 변경 시에만 이력 추가
- 정적 템플릿 테스트
  - `아이템들`, `기타` 상위 메뉴·열 제거
  - 날씨 요약·패널·오버레이 및 JS 포함
  - 날씨 아이콘 5종 존재, 자원 아이콘 미포함
- `gradlew.bat test`
- 로컬 서버와 API fixture를 사용한 1440px·390px 밝은/어두운 테마 시각 검증

## Risks And Mitigations

- 신규 SQL 미적용 시 API 500: 코드 배포 전 SQL 실행을 필수 순서로 안내하고 검증 쿼리를 제공한다.
- 공통 헤더 크기 증가: 요약만 상시 노출하고 패널·오버레이는 필요할 때만 렌더링한다.
- 브라우저 시각 조작: API가 서버 시각과 허용 키를 결정하고 클라이언트 시계는 표시용으로만 사용한다.
- 집계 쿼리 증가: 예보 범위를 7일로 제한하고 복합 인덱스로 단일 집계 조회한다.
- 동시 수정: 사용자별 UNIQUE 키와 upsert를 사용하고 배치 저장을 트랜잭션 처리한다.

## Alternatives Considered

- 다른 사이트 API 또는 UI 복제: 외부 의존성과 권리 문제를 만들고 사용자 요청의 독립 디자인 방향과 맞지 않아 제외했다.
- 관리자 강제 잠금: 관리자의 오류를 다른 사용자가 고칠 수 없으므로 5점 가중 투표로 대체했다.
- 7일 전체 6시간 상세 입력: 게임이 제공하지 않는 데이터를 요구하고 입력 부담이 커 제외했다.
- 무기한 변경 이력: 예보 수명보다 길고 불필요한 저장을 늘려 7일 보관으로 제한했다.
- 날씨 API 요청마다 정리 DELETE 실행: 공개 페이지 조회가 쓰기를 유발하므로 제출 트랜잭션에서만 만료 데이터를 정리한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있지 않다.
