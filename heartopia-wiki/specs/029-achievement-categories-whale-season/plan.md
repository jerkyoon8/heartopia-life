# Implementation Plan: 업적 카테고리 관리와 고래 시즌 업적 추가

## Context

- Spec: `specs/029-achievement-categories-whale-season/spec.md`
- Target branch: 현재 작업 트리
- Current codebase notes:
  - `Achievement.categories`와 MyBatis CRUD는 이미 쉼표 구분 문자열을 완전히 지원한다.
  - 관리자 모달에는 `categories`, `tip`, `sortOrder` 입력이 없고 수정 버튼 데이터에도 이 필드들이 빠져 있다.
  - 공개 카테고리 필터는 `achievements.html`에 정적으로 정의되어 있다.
  - 공통 `admin-data.js`는 단일 값 입력 복원만 제공하므로 카테고리 체크박스 그룹용 동기화가 필요하다.
  - 원본에는 4개 이미지와 `info.txt`가 있으며 `숨바꼭질 파티`에 해당하는 업적 행은 없다.

## Approach

기존 DB 모델과 API 계약은 유지한다. 관리자 화면에는 읽기 쉬운 체크박스 선택지를 제공하고, 선택 결과를 기존 `categories` 문자열에 동기화하는 숨은 입력을 둔다. 서버에서도 허용된 카테고리, 최소 한 개, 중복 제거를 검증한다. 신규 업적은 반복 실행 가능한 날짜형 SQL과 이름에 맞춘 정적 이미지로 배포한다.

## Impacted Files

- `src/main/resources/templates/wiki/others/achievements.html`: 신규 공개 필터, 관리자 카테고리/팁/정렬 입력, 수정 데이터 필드 추가
- `src/main/resources/static/js/admin-data.js`: 카테고리 체크박스와 숨은 문자열 입력 동기화 및 최소 선택 검증
- `src/main/java/com/heartopia/wiki/controller/AdminDataController.java`: 업적 카테고리 정규화 및 허용 목록 검증
- `src/main/resources/sql/20260819_add_whale_season_achievements.sql`: 네 업적 멱등 upsert 및 검증 조회
- `src/main/resources/static/images/achievements/*.webp`: 제공된 네 업적 이미지
- `src/test/java/com/heartopia/wiki/template/AchievementCategoryAdminTemplateTest.java`: 폼·필터·수정 데이터 회귀 테스트
- `src/test/java/com/heartopia/wiki/sql/WhaleSeasonAchievementsSqlTest.java`: SQL 데이터 및 멱등성 회귀 테스트

## Data Model

- 테이블과 컬럼 변경 없음.
- `achievements.categories`: 기존 `VARCHAR(100)` 쉼표 구분 형식을 유지한다.
- 신규 행은 `name` 유니크 키를 기준으로 upsert한다.

## API Or Interface Changes

- 기존 `POST /wiki/admin/data/achievement/add`와 `/update` 요청에 정상적인 `categories`, 선택적인 `tip`, `sortOrder` 값이 포함된다.
- 엔드포인트와 응답 방식은 변경하지 않는다.

## Validation And Error Handling

- 클라이언트는 카테고리 체크박스가 하나도 선택되지 않으면 제출을 막고 첫 선택지에 검증 메시지를 표시한다.
- 서버는 빈 카테고리 또는 허용되지 않은 카테고리를 거부하고, 유효한 값은 공백과 중복을 제거해 쉼표 문자열로 정규화한다.
- `sortOrder`가 누락되면 DB의 `NOT NULL` 제약과 맞게 0으로 정규화하고 음수는 거부한다. 신규 SQL은 명시적인 값을 사용한다.

## Test Plan

- Gradle 전체 테스트로 Java 컴파일과 기존 회귀를 확인한다.
- 템플릿 테스트로 두 신규 필터, 카테고리 입력, 팁/정렬 입력과 수정 데이터 포함을 확인한다.
- SQL 테스트로 네 이름, 조건, 칭호, 팁, 이미지 URL, 정렬 순서 및 `ON DUPLICATE KEY UPDATE`를 확인한다.
- 정적 이미지 4개 존재와 확장자를 파일 목록으로 확인한다.

## Risks And Mitigations

- 여러 체크박스와 단일 문자열 모델 간 불일치: 숨은 입력 한 개를 진실 원천으로 삼아 초기화·수정·제출 시점마다 명시적으로 동기화한다.
- Thymeleaf 수동 JSON 문자열의 따옴표: 새 필드는 현재 원본처럼 따옴표가 없는 값이며 템플릿 회귀 테스트로 필드 포함을 확인한다.
- `sort_order` 충돌: 정렬 값은 유니크가 아니므로 59~62를 사용하되 조회는 기존처럼 안정적인 데이터 순서를 따른다.

## Alternatives Considered

- 카테고리 테이블과 관계 테이블 도입: 현재 데이터 규모와 기존 쉼표 기반 필터에 비해 범위가 크므로 제외한다.
- 자유 텍스트 카테고리 입력: 오타로 필터가 깨질 가능성이 높아 고정 선택지를 사용한다.
- 다중 선택 `<select>`: 데스크톱에서 보조 키가 필요해 관리자가 놓치기 쉬우므로 체크박스를 사용한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
