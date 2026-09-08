# Implementation Plan: 6시간 단위 관리자 날씨 예약

## Context

- Spec: `specs/050-admin-weather-schedule/spec.md`
- Target branch: `main` (로컬 검증 후 별도 승인된 push만 수행)
- Current codebase notes:
  - 공개 응답 DTO와 헤더 패널은 이미 상세 5칸·일간 7칸 구조다.
  - 현재 미커밋 구현은 `daily_resource_locations.weather_code`에 하루 날씨 하나를 결합해 요구와 다르다.
  - SQL 자동 초기화가 꺼져 있어 로컬과 운영 모두 명시적으로 마이그레이션해야 한다.
  - HeartoCast 수집본은 200일·800구간이며 모든 6시간 구간 내부 코드가 일관된다.

## Approach

잘못 추가한 일일 자원 날씨 필드를 원복하고 `WeatherSchedule` 모델·매퍼·서비스·컨트롤러를 독립적으로 추가한다. 공개 예보 서비스는 날짜 범위 한 번을 조회해 상세 슬롯 맵과 일간 우선순위를 만든다. 관리자 화면은 날짜, 네 슬롯 중 하나, 날씨를 upsert하며 목록에서 수정·삭제할 수 있게 한다. 200일 CSV를 멱등 SQL seed로 생성해 로컬 DB에 실제 적용한다.

## Impacted Files

- `src/main/resources/sql/20260908_create_weather_schedules.sql`: 전용 테이블
- `src/main/resources/sql/20260908_seed_weather_schedules_200d.sql`: 800구간 seed
- `src/main/java/com/heartopia/wiki/model/WeatherSchedule.java`: 예약 모델과 표시 라벨
- `src/main/java/com/heartopia/wiki/mapper/WeatherScheduleMapper.java`: 범위·전체 조회와 upsert/삭제
- `src/main/resources/mapper/WeatherScheduleMapper.xml`: MySQL 쿼리
- `src/main/java/com/heartopia/wiki/service/WeatherScheduleService.java`: 관리자 검증·관리
- `src/main/java/com/heartopia/wiki/service/WeatherForecastService.java`: 시간대 조회·일간 집계
- `src/main/java/com/heartopia/wiki/controller/WeatherScheduleController.java`: 관리자 CRUD
- `src/main/resources/templates/wiki/admin-weather-schedules.html`: 전용 화면
- `src/main/resources/templates/fragments/header.html`: 관리자 날씨 편집 링크
- `src/main/resources/static/js/header-weather.js`: 눈·오로라 대체 표시
- `DailyResourceLocation*`: 잘못 추가된 날씨 의존 제거
- 관련 서비스·템플릿·SQL 테스트

## Data Model

- `weather_schedules.id BIGINT AUTO_INCREMENT`
- `forecast_date DATE NOT NULL`
- `slot_hour TINYINT NOT NULL CHECK IN (0,6,12,18)`
- `weather_code VARCHAR(32) NOT NULL`
- `source_weather_ids VARCHAR(64) NULL`
- `is_active BOOLEAN NOT NULL DEFAULT TRUE`
- `UNIQUE(forecast_date, slot_hour)`

## API Or Interface Changes

- `GET /api/weather/forecast`: 응답 형태 유지, 별도 예약 테이블 기반으로 변경
- `GET /wiki/admin/weather-schedules`: 관리자 전용 관리 화면 추가
- `POST /wiki/admin/weather-schedules/save`: 날짜·슬롯 upsert
- `POST /wiki/admin/weather-schedules/delete`: 소프트 삭제
- `/api/weather/votes`: 제거 상태 유지

## Validation And Error Handling

- 날짜 필수, 슬롯 4개만 허용, 날씨 코드는 allowlist로 검증한다.
- 공개 API에서 DB 오류가 나면 기존 전역 HTML 오류 처리 대신 JSON 오류 상태가 유지되도록 컨트롤러 계약을 검사한다.
- seed는 `ON DUPLICATE KEY UPDATE`로 재실행 가능하게 한다.

## Test Plan

- 테스트 우선: 슬롯 검증, upsert, 상세 날짜 경계, 일간 우선순위, 미예약 처리
- 템플릿/SQL 계약: 별도 관리자 링크와 폼, 전용 테이블, 800 seed, 일일 자원 분리
- `node --check`로 헤더 JS 구문 확인
- 전체 Gradle 테스트
- 로컬 MySQL에 create+seed 적용 후 800행·200일·날짜별 4행 확인
- 로컬 서버에서 health, `/api/weather/forecast`, `/wiki`, 관리자 URL 보안 응답 확인

## Risks And Mitigations

- 사용자 변경이 많은 dirty tree: 요청 파일의 관련 hunk만 수정하고 stage/push하지 않는다.
- 테이블 선적용이 필요한 배포: 로컬 검증 후 운영 SQL을 코드 push 전에 실행·검증한다.
- 기존 데이터 파일과 SQL 불일치: seed 행 수와 CSV 행 수를 테스트로 고정한다.

## Alternatives Considered

- 일일 자원 테이블에 네 개 컬럼 추가: 기능 결합과 확장성 문제가 남아 제외한다.
- 기존 투표 테이블을 관리자 예약으로 재사용: 사용자·가중치 의미와 unique key가 달라 제외한다.
- 런타임 외부 API 호출: 외부 장애가 공개 헤더에 전파되므로 고정 seed 방식으로 제한한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 없다.
