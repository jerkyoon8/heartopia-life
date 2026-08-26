# Tasks: 일일 자원·방문자 조회 최적화

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 요구사항·현재 호출 흐름·시간 경계·기존 인덱스를 조사하고 PRD/Spec/Plan을 작성한다.
  Files: `specs/031-daily-resource-visitor-query-optimization/*.md`
  Verify: 문서의 성공 기준과 구현 범위가 일치하는지 검토

## Phase 2: Tests

- [x] T002 [P] 위치 캐시·빈 결과·날짜 전환·관리자 변경 무효화·과거 정리 단위 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/service/DailyResourceLocationServiceTest.java`
  Verify: 구현 전 컴파일 실패 또는 테스트 실패 확인

- [x] T003 [P] HTML/API별 방문자 추적·집계 호출·세션 생성 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/advice/GlobalControllerAdviceTest.java`
  Verify: API 요청에서 기존 Advice가 서비스를 호출하여 테스트가 실패하는지 확인

- [x] T004 [P] 방문자 단일 집계 서비스와 매퍼 SQL 계약 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/service/VisitorServiceTest.java`, `src/test/java/com/heartopia/wiki/sql/VisitorMapperSqlTest.java`
  Verify: 신규 인터페이스 부재로 구현 전 실패 확인

## Phase 3: Implementation

- [x] T005 과거 일일 자원 삭제 매퍼와 오전 6시/시작 정리, 날짜 키 캐시, 변경 시 무효화를 구현한다.
  Files: `HeartopiaWikiApplication.java`, `DailyResourceLocationService.java`, `DailyResourceLocationMapper.java`, `DailyResourceLocationMapper.xml`
  Verify: T002 및 기존 일일 자원 테스트 통과

- [x] T006 오늘·주간 방문자 단일 집계 DTO·매퍼·서비스를 구현한다.
  Files: `VisitorSummary.java`, `VisitorMapper.java`, `VisitorMapper.xml`, `VisitorService.java`
  Verify: T004 통과 및 제거된 메서드 참조 없음

- [x] T007 API 조기 제외와 HTML 요청 지연 세션 생성을 전역 Advice에 구현한다.
  Files: `GlobalControllerAdvice.java`
  Verify: T003 통과

## Phase 4: Polish

- [x] T008 변경 대상 테스트를 반복 실행하고 전체 Gradle 테스트로 회귀를 확인한다.
  Files: 전체 테스트
  Verify: 대상 테스트 및 `gradlew test` 성공

- [x] T009 diff·작업 트리·문서 체크리스트를 검토하고 후속 배포 사항을 정리한다.
  Files: 변경 파일, `tasks.md`
  Verify: 요청 범위 밖 변경 없음, DB 스키마 실행 단계 없음 확인

## Completion Notes

- Tests run: 대상 Java 테스트 반복 통과, 전체 Java 193개 통과(실패/오류/스킵 0), Node 19개 통과, Spring MVC 실제 디스패치 테스트 통과
- Known risks: 단일 JVM 캐시이므로 향후 활성 트래픽 인스턴스가 동시에 여러 개가 되면 분산 캐시 또는 이벤트 기반 무효화가 필요하다.
- Follow-up: 별도 SQL 실행은 필요 없다. 코드 배포 후 첫 현재 위치/관리자 조회에서 과거 행이 정리되는지, API 요청당 방문자 SQL이 0회인지 운영 로그/APM으로 확인 권장
