# Tasks: 퍼즐 도감

## Rules

- `[P]`는 병렬 가능 작업이다.
- 테스트가 필요한 경우 테스트 작업을 구현 작업보다 먼저 둔다.
- 각 작업은 파일 경로와 검증 방법을 포함한다.

## Phase 1: Setup

- [x] T001 엑셀 108행과 이미지 80개를 명시적 규칙으로 매칭하고 최종 CSV·한국어 이미지 파일을 생성한다.
  Files: 저장소 외부 원본 자료, `src/main/resources/static/images/others/puzzles`
  Verify: CSV 80행, image_id 1~80 유일, catalog_order 80개 유일, 이미지 80개 존재

## Phase 2: Tests

- [x] T002 [P] 퍼즐 화면의 핵심 필드·필터·메인 카드·헤더 링크를 검사하는 회귀 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/template/PuzzleCollectionTemplateTest.java`, `src/test/java/com/heartopia/wiki/template/HeaderWeatherTemplateTest.java`
  Verify: 구현 전 기대 문자열이 없어 테스트가 실패하고, 구현 후 통과

## Phase 3: Implementation

- [x] T003 퍼즐 테이블과 80개 초기 데이터 SQL을 추가한다.
  Files: `src/main/resources/sql/20260729_create_puzzle_collections.sql`
  Verify: SQL의 INSERT 행 80개, image_id·catalog_order 중복 없음

- [x] T004 퍼즐 목록·개수 조회 모델과 MyBatis/서비스 연결을 추가한다.
  Files: `src/main/java/com/heartopia/wiki/model/PuzzleCollection.java`, `src/main/java/com/heartopia/wiki/mapper/CollectionMapper.java`, `src/main/resources/mapper/CollectionMapper.xml`, `src/main/java/com/heartopia/wiki/service/CollectionService.java`
  Verify: Gradle 컴파일 및 Mapper XML 로딩 테스트 통과

- [x] T005 퍼즐 라우트, 메인 기타 정보 카드, 헤더·사이트맵 링크를 추가한다.
  Files: `src/main/java/com/heartopia/wiki/controller/WikiController.java`, `src/main/resources/templates/fragments/header.html`, `src/main/resources/static/sitemap.xml`
  Verify: 템플릿 테스트와 라우트 문자열 검사 통과

- [x] T006 퍼즐 카드·표 보기와 이름·분류·크기 필터 화면을 구현한다.
  Files: `src/main/resources/templates/wiki/others/puzzles.html`
  Verify: 필터 데이터 속성, 빈 결과, 이미지 대체 UI 검사

## Phase 4: Polish

- [x] T007 로컬 DB에 SQL을 적용하고 앱을 실행해 화면·이미지·필터를 검증한다.
  Files: `src/main/resources/sql/20260729_create_puzzle_collections.sql`
  Verify: DB count 80, 페이지 200, 카드 80개, 이미지 200

- [x] T008 전체 테스트와 변경 범위·후속 조치를 정리한다.
  Files: `specs/017-puzzle-collection/tasks.md`
  Verify: 전체 테스트 통과, 사용자 변경과 기존 변경이 분리되어 있음

## Phase 5: 고래 탐사 시즌

- [x] T009 고래 탐사 시즌 퍼즐 10개의 이름·크기·획득처·가격과 WebP 이미지를 시드 및 정적 리소스에 추가한다.
  Files: `src/main/resources/sql/20260729_create_puzzle_collections.sql`, `src/main/resources/static/images/others/puzzles`
  Verify: 시드 90행, WebP 90개, 99~108번 가격과 파일 경로 일치

- [x] T010 로컬 DB에 갱신 시드를 적용하고 시즌한정 10개와 가격을 조회 검증한다.
  Files: `src/main/resources/sql/20260729_create_puzzle_collections.sql`
  Verify: 전체 90개, `category='시즌한정'` 10개, 가격 `3,760` 3개·`1,200` 7개

## Completion Notes

- Tests run: `.\gradlew.bat test`, 퍼즐 템플릿 회귀 테스트, 로컬 DB 전체 90개·시즌한정 10개·가격별 개수 검증
- Known risks: 이미지가 없는 엑셀 18개는 이번 목록에서 제외
- Follow-up: 운영 반영 시 SQL 실행 후 이미지·코드 배포 필요

## Phase 6: 고래 시즌 분류

- [x] T011 고래 시즌 분류 선택지와 데이터 형식을 검사하는 회귀 테스트를 추가한다.
  Files: `src/test/java/com/heartopia/wiki/template/PuzzleCollectionTemplateTest.java`
  Verify: `고래 탐사 시즌` 분류와 획득처·토큰 가격 검증 통과

- [x] T012 신규·기존 DB용 SQL에 99~108번 최종 데이터를 반영한다.
  Files: `src/main/resources/sql/20260729_create_puzzle_collections.sql`, `src/main/resources/sql/20260730_update_puzzle_whale_category.sql`
  Verify: `시즌한정` 0개, 고래 탐사 시즌 10개, 획득처·토큰 가격 일치

- [x] T013 퍼즐 카드·표·분류 필터에 고래 시즌 분류를 연결한다.
  Files: `src/main/resources/templates/wiki/others/puzzles.html`
  Verify: T011 통과, 기존 분류 필터에서 고래 탐사 시즌 선택 가능

- [x] T014 로컬 DB 패치와 전체 테스트·페이지 렌더링을 검증한다.
  Files: `src/main/resources/sql/20260730_update_puzzle_whale_category.sql`
  Verify: DB 집계·페이지 200·전체 테스트 통과

### Phase 6 Completion

- Tests run: `.\gradlew.bat test`, 퍼즐 템플릿 회귀 테스트, 로컬 `/wiki/others/puzzles` 200 응답 확인
- Local DB: 전체 90개, `시즌한정` 0개, `고래 탐사 시즌` 10개, 지정 획득처 10개, `3,760 토큰` 3개, `1,200 토큰` 7개
- Follow-up: 운영 배포 전 `20260730_update_puzzle_whale_category.sql` 적용 필요
