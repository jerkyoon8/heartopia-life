# Implementation Plan: 현재 이벤트 도감 필터

## Context

- Spec: `specs/022-current-event-filter/spec.md`
- Target branch: `main`
- Current codebase notes:
  - 각 도감 모델과 MyBatis 조회에는 이미 `event_name`/`eventName`이 존재한다.
  - 물고기 필터 패턴과 공통 `WikiFilter`는 체크박스 다중 선택 UI의 기반을 이미 제공한다.
  - 이벤트 필터는 대부분 단일 `<select>`이며, 물고기·곤충·새·요리에는 고정 이벤트 스위치와 연결된 중복 스크립트가 있다.
  - 동물·모래 조각·바다 청소는 이벤트 필드가 있지만 공통 이벤트 필터가 없다.
  - `/wiki/admin/**`는 이미 Spring Security에서 `ROLE_ADMIN`으로 보호된다.
  - SQL 자동 초기화가 꺼져 있으므로 새 테이블 생성 SQL과 애플리케이션 계정 권한 SQL은 배포 전에 별도로 실행해야 한다.
  - 작업 시작 시 다른 기능의 미커밋 변경이 다수 존재하므로 해당 파일을 보존하고 이번 기능 파일/구간만 수정한다.

## Approach

1. `wiki_current_events` 전용 테이블과 MyBatis mapper를 추가한다. 이벤트 후보 조회는 기존 10개 도감 테이블의 `event_name`을 `UNION`하여 정규화된 고유 목록으로 만든다.
2. `EventSettingsService`가 현재 이벤트 조회와 전체 교체 저장을 담당한다. 저장 전 제출값을 실제 후보 목록과 교차 검증하고 트랜잭션 안에서 삭제 후 일괄 삽입한다.
3. `EventSettingsController`와 관리자 전용 Thymeleaf 화면을 추가해 복수 체크, 전체 선택/해제, 저장 결과 메시지를 제공한다.
4. `WikiController`의 이벤트 지원 목록 페이지에서 현재 이벤트 목록을 모델에 넣는다.
5. `wiki-components.html`에 공통 이벤트 필터 fragment를 추가하고 모든 이벤트 지원 도감에서 재사용한다.
6. `WikiFilter`에 `event-multi` 타입을 추가한다. 페이지 DOM의 `data-event`를 이용해 옵션을 자동 생성하고, 일반 항목은 항상 통과시키며 선택된 이벤트만 통과시킨다.
7. 로컬 저장소에는 기본값과 다른 이벤트별 재정의만 저장한다. 현재 이벤트 목록이 바뀌면 재정의 없는 항목은 새 관리자 기본값을 즉시 따른다.
8. 기존 고정 이벤트 스위치와 연결 스크립트를 제거하고 이벤트 필터 설정을 공통 타입으로 변경한다.
9. QA에서 확인된 모바일 헤더 높이, 375px 카드 한 열, 다크모드 독립 선택창 대비를 공통 CSS에서 보완한다.
10. 관리자 현재 이벤트와 페이지 이벤트 후보를 함께 렌더링하고, 페이지에 없는 현재 이벤트는 선택 불가 상태와 안내 문구로 표시한다.
11. `wiki_quick_events`를 추가하고 관리자 화면에서 현재 이벤트와 빠른 선택 이벤트를 한 번에 검증·교체한다.
12. 공통 fragment에 검색창 옆 빠른 필터와 상세 필터의 `일반` 값을 추가하고, `WikiFilter`가 두 UI를 하나의 상태로 동기화한다.
13. 순수 이벤트 판정 함수를 Node 내장 테스트로 실행해 일반/복수 이벤트/빈 선택/빠른 모드 전환을 검증한다.
14. 상단 빠른 필터의 기존 독립 토글·선택 상자를 하나의 40px 분할형 컨트롤로 합친다. 왼쪽 체크 영역은 ON/OFF 상태, 오른쪽 트리거는 기존 복수 선택 드롭다운을 유지한다.

## Impacted Files

- `src/main/resources/sql/20260812_create_wiki_current_events.sql`: 현재 이벤트 테이블 생성 SQL.
- `src/main/resources/sql/20260812_grant_wiki_current_events_{local,production}.sql`: 로컬·운영 애플리케이션 계정 DML 권한 SQL.
- `src/main/resources/sql/20260813_create_wiki_quick_events.sql`: 빠른 선택 이벤트 테이블 생성 SQL.
- `src/main/resources/sql/20260813_grant_wiki_quick_events_{local,production}.sql`: 환경별 빠른 이벤트 테이블 권한 SQL.
- `src/main/java/com/heartopia/wiki/mapper/EventSettingsMapper.java`: 이벤트 후보/현재 목록 조회와 저장 계약.
- `src/main/resources/mapper/EventSettingsMapper.xml`: 10개 도감 테이블 이벤트명 합집합 및 현재 이벤트 CRUD.
- `src/main/java/com/heartopia/wiki/service/EventSettingsService.java`: 검증, 정규화, 트랜잭션 저장.
- `src/main/java/com/heartopia/wiki/controller/EventSettingsController.java`: 관리자 조회/저장 엔드포인트.
- `src/main/java/com/heartopia/wiki/controller/WikiController.java`: 이벤트 지원 목록 모델에 현재 이벤트 추가.
- `src/main/resources/templates/wiki/admin-event-settings.html`: 관리자 복수 선택 화면.
- `src/main/resources/templates/fragments/header.html`: 관리자 이벤트 설정 진입 링크.
- `src/main/resources/templates/fragments/wiki-components.html`: 공통 이벤트 다중 선택 fragment.
- `src/main/resources/static/js/wiki-filter.js`: 이벤트 옵션 생성, 기본값/재정의 저장, 필터 및 초기화 로직.
- `src/main/resources/static/css/common.css`: 현재/지난 이벤트 그룹과 필터 상태 스타일.
- `src/main/resources/templates/wiki/collections/{fish,bug,bird,animal,forageable}.html`: 공통 이벤트 필터 적용.
- `src/main/resources/templates/wiki/items/{cooking,flowers,crops}.html`: 공통 이벤트 필터 적용.
- `src/main/resources/templates/wiki/others/{sandbox,sea-cleaning}.html`: 이벤트 데이터 속성과 공통 이벤트 필터 적용.
- `src/test/java/com/heartopia/wiki/service/EventSettingsServiceTest.java`: 검증 및 전체 교체 저장 단위 테스트.
- `src/test/java/com/heartopia/wiki/template/CurrentEventFilterTemplateTest.java`: 대상 페이지 공통 fragment/설정/data-event 회귀 테스트.
- `src/test/java/com/heartopia/wiki/template/CookingEventFilterTemplateTest.java`: 기존 고정 스위치 기대값을 새 공통 필터 기대값으로 갱신.
- `src/test/java/com/heartopia/wiki/template/QaDarkModeAndEventFilterRegressionTest.java`: QA에서 발견한 모바일·다크모드·이벤트 상태 회귀 테스트.
- `src/test/java/com/heartopia/wiki/sql/EventSettingsPermissionSqlTest.java`: 환경별 권한 SQL 누락 방지 회귀 테스트.
- `specs/022-current-event-filter/tasks.md`: 구현 체크리스트 및 검증 기록.

## Data Model

- `wiki_current_events`
  - `event_name VARCHAR(100) NOT NULL PRIMARY KEY`
  - `created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP`
  - `updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`
- 기존 수집품과의 외래 키는 두지 않는다. 하나의 이벤트가 여러 테이블에 문자열로 존재하고 데이터 수정 시 이름이 바뀔 수 있기 때문이다.
- 저장 시 선택 집합 전체를 교체한다. 행 수가 매우 작고 관리자가 한 화면에서 전체 상태를 결정하므로 부분 갱신보다 일관성이 명확하다.
- `wiki_quick_events`는 동일한 키/타임스탬프 구조를 사용한다. 두 설정은 하나의 서비스 트랜잭션에서 함께 교체한다.

## API Or Interface Changes

- `GET /wiki/admin/event-settings`: 이벤트 후보와 현재 선택을 표시한다.
- `POST /wiki/admin/event-settings`: `currentEventNames`, `quickEventNames` 반복 파라미터를 받아 두 집합을 저장한다. 파라미터가 없으면 해당 집합을 전체 해제한다.
- `WikiFilter` 필터 구성에 `{ id: 'eventFilter', dataKey: 'event', type: 'event-multi' }`를 추가한다.
- 공통 fragment는 `currentEventNames`, `quickEventNames` 모델 속성을 숨은 기본값으로 출력한다.

## Validation And Error Handling

- null, 빈 문자열, 앞뒤 공백은 제거한다.
- 실제 도감 데이터에 없는 제출값이 하나라도 있으면 저장하지 않고 관리자 화면에 오류 메시지를 표시한다.
- 중복 선택은 순서를 유지한 고유 집합으로 정규화한다.
- 로컬 저장소 JSON 파싱/쓰기 오류는 잡아서 현재 이벤트 기본값으로 계속 동작한다.
- 현재 이벤트 테이블 누락은 배포 오류로 간주하며 코드에서 조용히 무시하지 않는다.
- 현재 이벤트 테이블에 대한 애플리케이션 계정의 DML 권한 누락도 배포 오류로 간주하며 환경별 권한 SQL로 해결한다.

## Test Plan

- 서비스 단위 테스트: 복수 저장, 전체 해제, 중복/공백 정규화, 알 수 없는 이벤트 거부, 트랜잭션 호출 순서.
- 템플릿 회귀 테스트: 10개 대상 페이지가 공통 fragment, `event-multi` 설정 및 카드/표의 `data-event`를 제공하는지 확인한다.
- 기존 전체 Gradle 테스트를 실행한다.
- 환경별 권한 SQL에 `wiki_current_events`의 `SELECT`, `INSERT`, `UPDATE`, `DELETE` 권한과 대상 계정 Host가 포함되는지 테스트한다.
- 수동 확인: 관리자로 이벤트 2개 저장 → 도감 최초 기본 노출 → 지난 이벤트 2개 추가 → 새로고침 유지 → 초기화 → 관리자 현재 이벤트 변경 후 기본값 반영을 확인한다.
- Node 실행 테스트: `일반` 포함/제외, 복수 이벤트 합집합, 빠른 필터 켜기/끄기, 선택 없는 빠른 필터 거부를 검증한다.
- 공통 UI 회귀 테스트: 분할형 wrapper, 좌우 세그먼트, ON/OFF 표시, 모바일 비분리 규칙과 기존 ID/ARIA 연결을 정적 검증한다.

## Risks And Mitigations

- 기존 템플릿에 중복 이벤트 JS가 남아 충돌: 고정 ID 검색 회귀 테스트와 `rg` 검증으로 제거 여부를 확인한다.
- 표 행에 `data-event`가 없는 페이지는 카드/표 결과가 달라짐: 대상별 템플릿 테스트로 두 뷰를 확인한다.
- 사용자 재정의가 영구적으로 오래된 기본값을 덮음: 현재 기본값과 같아진 재정의는 로드 시 정리한다.
- 여러 도감 테이블의 이벤트 후보 쿼리 비용: 관리자 화면에서만 합집합 쿼리를 실행하고 일반 도감은 작은 현재 이벤트 테이블만 조회한다.

## Alternatives Considered

- 애플리케이션 설정 파일에 현재 이벤트 저장: 변경마다 재배포가 필요해 운영 요구에 맞지 않는다.
- 범용 key/value 사이트 설정 테이블에 JSON 배열 저장: 미래 확장성은 있지만 현재 기능에 JSON 직렬화와 타입 검증 복잡도를 추가한다. 이벤트 전용 관계형 테이블과 확장 가능한 관리자 화면을 선택한다.
- `wiki_current_events`에 `quick_enabled` 컬럼 추가: 현재 여부와 빠른 후보 여부가 독립적인 두 집합이므로 nullable 행과 upsert 분기가 늘어난다. 작은 전용 테이블 두 개가 저장과 검증을 단순하게 유지한다.
- 각 도감 테이블에 `is_current_event` 추가: 동일 이벤트를 여러 테이블에서 반복 수정해야 해 일관성이 나쁘다.
- 모든 이벤트를 기본 표시하고 `지난 이벤트 숨김` 스위치 추가: 현재 콘텐츠 집중이라는 핵심 목표와 복수 과거 이벤트 선택 요구를 충족하지 못한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 구현 전에 확인할 미확정 사항이 없다.
