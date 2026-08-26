# Implementation Plan: 일일 자원·방문자 조회 최적화

## Context

- Spec: `specs/031-daily-resource-visitor-query-optimization/spec.md`
- Target branch: 현재 작업 브랜치
- Current codebase notes:
  - 현재 위치는 `game_date` 고유 인덱스로 빠르게 조회하지만 매 API 호출마다 SELECT한다.
  - 클라이언트는 응답의 `serverTime`으로 다음 오전 6시까지 남은 시간을 계산한다.
  - `GlobalControllerAdvice`가 `HttpSession`을 직접 인자로 받고 모든 MVC 요청에서 오늘·주간 쿼리를 각각 호출한다.
  - Spring Cache는 기본 무기한 JVM 캐시라 시간 경계가 있는 이번 값에 그대로 사용하기 어렵다.

## Approach

`DailyResourceLocationService`에 게임 날짜 키 기반의 작은 동기화 캐시를 둔다. 캐시에는 위치 행 또는 빈 결과만 저장하고 응답 시각은 매 요청마다 생성한다. 서비스의 오전 6시 스케줄 및 게임 날짜별 최초 조회에서 과거 행을 삭제하고 캐시를 비운다. 저장·삭제도 성공 후 캐시를 비운다.

방문자 집계는 `VisitorSummary` DTO와 조건부 합계 SQL로 오늘·주간 값을 한 번에 읽는다. 전역 Advice는 URI와 실제 핸들러의 `@ResponseBody`/`@RestController` 여부를 먼저 검사하고 JSON 요청이라면 즉시 반환하며, HTML 요청일 때만 `request.getSession()`을 호출하여 세션 생성과 방문자 DB 작업을 피한다.

## Impacted Files

- `HeartopiaWikiApplication.java`: 오전 6시 스케줄링 활성화.
- `DailyResourceLocationService.java`: 위치 캐시, 시작/오전 6시 정리, 변경 시 캐시 무효화.
- `DailyResourceLocationCleanupService.java`: 과거 위치 물리 삭제의 독립 트랜잭션 경계.
- `DailyResourceLocationMapper.java`: 과거 날짜 삭제 메서드.
- `DailyResourceLocationMapper.xml`: `game_date < 기준일` 물리 삭제 SQL.
- `VisitorSummary.java`: 오늘·주간 집계 전달 DTO.
- `VisitorMapper.java`: 단일 집계 메서드.
- `VisitorMapper.xml`: 조건부 합계 단일 SELECT.
- `VisitorService.java`: 단일 요약 조회 제공.
- `GlobalControllerAdvice.java`: API 조기 제외, 지연 세션 생성, 단일 집계 사용.
- `DailyResourceLocationServiceTest.java`: 시간 경계·캐시·빈 결과·무효화·정리 테스트.
- `GlobalControllerAdviceTest.java`: HTML/API 요청의 서비스 호출, 세션 생성, 실제 MVC JSON 디스패치 테스트.
- `VisitorServiceTest.java`: 단일 매퍼 호출 전달 테스트.
- `VisitorMapperSqlTest.java`: 집계 SQL 계약 테스트.
- `HeaderDailyResourceLocationTemplateTest.java`: 과거 삭제 SQL 계약 보강.

## Data Model

- 신규 DB 객체는 없다.
- 신규 Java DTO `VisitorSummary`는 `todayVisitors`, `weeklyVisitors` 정수 필드를 가진다.
- `daily_resource_locations`의 과거 행은 물리 삭제한다.

## API Or Interface Changes

- 외부 HTTP API와 JSON 형식 변경 없음.
- 내부 `VisitorMapper#getVisitorSummary()`와 `VisitorService#getVisitorSummary()`를 추가하고 기존 오늘·주간 개별 메서드는 제거한다.
- 내부 `DailyResourceLocationMapper#deleteBeforeGameDate(LocalDate)`를 추가한다.

## Validation And Error Handling

- 기존 위치 입력 검증을 유지한다.
- 삭제 기준은 서비스가 계산한 현재 게임 날짜만 전달한다.
- 정리나 DB 조회 예외는 숨기지 않고 기존 Spring 예외 처리 흐름으로 전달하여 잘못된 캐시 상태를 확정하지 않는다.

## Test Plan

- 단위 테스트: 05:59/06:00 날짜 전환, 동일 날짜 캐시 적중, 빈 값 캐시, 날짜 변경 캐시 미사용, 저장·삭제 무효화, 과거 정리 기준과 캐시 제거.
- Advice 단위 테스트: `/api`, `/api/...`, `/wiki/map/api`, `/wiki/map/api/...`에서 세션/서비스 미사용; HTML에서 세션당 1회 증가와 요약 1회 조회.
- 매퍼 계약 테스트: 과거만 삭제하는 조건과 오늘·주간 단일 조건부 합계 확인.
- 전체 Gradle 테스트를 반복 실행하고 변경 대상 테스트를 별도로 실행한다.
- 정적 검색으로 제거된 개별 오늘·주간 메서드 참조가 남지 않았는지 확인한다.

## Risks And Mitigations

- 캐시 동시성: 캐시 읽기·교체·무효화를 동기화하고 날짜를 캐시 키로 검증한다.
- 오전 6시 작업 누락: 애플리케이션 준비 시에도 동일 정리를 실행한다.
- API에서 세션이 먼저 생성되는 문제: 메서드에서 `HttpSession` 인자를 제거하고 URI 검사 후 명시적으로 세션을 얻는다.
- 집계 결과 매핑 오류: 명시적 MyBatis `resultMap`과 서비스 테스트를 둔다.

## Alternatives Considered

- Spring 기본 `@Cacheable`: TTL이 없어 오전 6시 만료를 별도 구현해야 하고 빈 값·응답 시각 제어가 불명확하여 사용하지 않는다.
- 브라우저/CDN 캐시: 관리자 정정 반영이 지연될 수 있어 제외한다.
- 조회수 10~30초 TTL 캐시: 숫자 정확성을 낮추지 않고도 중복 왕복 대부분을 제거할 수 있어 이번 범위에서는 제외한다.
- 과거 행을 조회에서만 숨기기: 사용자 요구가 이전 기록 불필요이므로 물리 삭제를 선택한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
