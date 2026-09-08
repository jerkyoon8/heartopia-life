# PRD: 6시간 단위 관리자 날씨 예약

## 1. Summary

### Problem

날씨를 일일 자원 위치 행에 하루 한 값으로 저장하면 하루 안의 `00·06·12·18시` 날씨 변화를 표현할 수 없고 두 기능의 관리 화면과 배포 수명 주기가 결합된다.

### Proposed Solution

날씨 전용 예약 테이블과 관리자 화면을 만들고 HeartoCast에서 확인한 200일치 6시간 구간을 저장한다. 공개 패널은 기존 모양을 유지하며 상세 구간은 예약값을, 7일 요약은 일간 우선순위로 계산한 값을 표시한다.

### Success Criteria

- 날짜와 `0·6·12·18`시 조합으로 날씨 800건을 중복 없이 저장한다.
- 상세 패널이 현재 구간부터 다섯 개의 실제 예약값을 표시한다.
- 7일 요약은 `무지개 > 유성우 > 비 > 맑음` 우선순위를 적용한다.
- 일일 자원 위치 저장·조회는 날씨 스키마와 무관하게 동작한다.
- 로컬 MySQL 마이그레이션, API, 관리자 화면과 전체 테스트가 통과한다.

## 2. Users And Use Cases

### Primary Users

- 6시간별 날씨를 관리하는 운영 관리자
- 헤더에서 현재·향후 날씨를 확인하는 방문자

### User Stories

- As an 운영 관리자, I want to 날짜와 6시간 구간별 날씨를 수정, so that 수집한 예보의 일부만 안전하게 정정할 수 있다.
- As a 방문자, I want to 실제 시간대별 날씨를 확인, so that 특정 날씨에만 가능한 활동을 계획할 수 있다.

## 3. Functional Scope

### In Scope

- 별도 `weather_schedules` 테이블과 MyBatis 저장·조회
- `/wiki/admin/weather-schedules` 전용 관리 화면
- 날짜, 구간, 날씨 코드의 관리자 upsert 및 삭제
- 2026-09-08부터 2027-03-26까지 200일, 800구간 seed
- `SUNNY`, `RAIN`, `RAINBOW`, `METEOR_SHOWER`, `HEATWAVE`, `SNOW`, `AURORA` 지원
- 기존 날씨 패널의 표시 전용 동작 유지
- 기존 일일 자원 위치의 날씨 필드 제거

### Out Of Scope

- HeartoCast 자동 동기화 작업
- 사용자 날씨 투표 재활성화
- 기존 투표 테이블 삭제
- 시간별 상세 강우·구름 종류를 별도 아이콘으로 표시

## 4. Acceptance Criteria

- 예약 키는 `forecast_date + slot_hour`이며 구간은 `0, 6, 12, 18`만 허용한다.
- 미예약 구간은 `EMPTY`, 예약 구간은 `CONFIRMED`로 반환한다.
- 상세 예보는 달력 날짜를 그대로 사용하며 오전 6시 게임 날짜 보정을 하지 않는다.
- 일간 요약은 해당 달력 날짜 네 구간 중 가장 높은 우선순위 날씨를 사용한다.
- 수집본의 `2026-12-31`은 비·맑음 중 비가, `2027-01-01`은 맑음·비·무지개 중 무지개가 일간 대표여야 한다.
- 관리자 이외 사용자는 관리 화면과 변경 요청에 접근할 수 없다.
- 일일 자원 위치 SQL과 폼에 `weather_code`가 남아 있지 않는다.

## 5. Constraints

- Tech: Java 17, Spring Boot, Thymeleaf, Vanilla JS, MyBatis, MySQL 8.0
- Time: Asia/Seoul, 달력 날짜 기준 `00·06·12·18시`
- Data: HeartoCast 연간 월·일 자료에서 2026-09-08 기준 200일을 변환한 고정 seed
- External Dependencies: 런타임 외부 호출 없음

## 6. Risks

- 운영 코드가 테이블보다 먼저 배포됨: 운영 MySQL에 테이블과 seed를 먼저 적용한 뒤 푸시한다.
- 외부 원본이 수정됨: `source_weather_ids`를 보존해 추적 가능하게 한다.
- 기존 날씨 이미지에 눈·오로라가 없음: 해당 코드 전용 정적 이미지를 추가하기 전까지 기존 레이아웃 안에서 이모지 대체 표시를 사용한다.
- 200일 seed 재실행: unique key 기반 upsert로 멱등성을 보장한다.

## 7. Open Questions

- 없음. 별도 테이블, 6시간 단위, 200일 범위와 표시 우선순위가 사용자 확인 및 데이터 교차 검증으로 확정되었다.
