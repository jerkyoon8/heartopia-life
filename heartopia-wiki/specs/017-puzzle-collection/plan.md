# Implementation Plan: 퍼즐 도감

## Context

- Spec: `specs/017-puzzle-collection/spec.md`
- Target branch: 현재 작업 브랜치
- Current codebase notes:
  - `WikiController`가 목록 데이터를 모델에 담아 Thymeleaf 화면을 렌더링한다.
  - 도감 데이터는 `CollectionMapper` → `CollectionService` 흐름으로 조회한다.
  - 메인 화면의 기타 정보 카드는 `CategoryItemDto` 목록으로 구성된다.
  - 헤더의 기타정보 링크는 `fragments/header.html`에 정적으로 선언되어 있다.
  - `spring.sql.init.mode=never`이므로 새 SQL은 로컬 DB에 별도 실행해야 한다.

## Approach

엑셀을 읽어 이미지 ID와 엑셀 도감순의 명시적 대응표를 만든 뒤, 한국어 파일명 이미지를 생성한다. 프로젝트에는 기존 80개와 고래 탐사 시즌 10개를 합친 이미지 90개, 재실행 가능한 테이블·시드 SQL, 단순 조회용 모델·Mapper·Service를 둔다. 화면은 물고기 도감의 필터 마크업과 공통 카드 스타일, `wiki-filter.js`를 활용해 검색·분류·크기 필터를 제공한다.

## Impacted Files

- `src/main/resources/static/images/others/puzzles/*.webp`: 한국어 퍼즐 이미지 90개
- `src/main/resources/sql/20260729_create_puzzle_collections.sql`: 테이블과 90개 시드
- `src/main/java/com/heartopia/wiki/model/PuzzleCollection.java`: 퍼즐 데이터 모델
- `src/main/java/com/heartopia/wiki/mapper/CollectionMapper.java`: 목록·개수 조회
- `src/main/resources/mapper/CollectionMapper.xml`: 퍼즐 조회 SQL
- `src/main/java/com/heartopia/wiki/service/CollectionService.java`: 캐시된 목록·개수 서비스
- `src/main/java/com/heartopia/wiki/controller/WikiController.java`: 목록 라우트와 기타 정보 카드
- `src/main/resources/templates/wiki/others/puzzles.html`: 퍼즐 목록 UI
- `src/main/resources/templates/fragments/header.html`: 기타정보 메뉴 링크
- `src/main/resources/static/sitemap.xml`: 공개 URL
- `src/test/java/com/heartopia/wiki/template/PuzzleCollectionTemplateTest.java`: 템플릿·데이터 연결 회귀 테스트
- `src/test/java/com/heartopia/wiki/template/HeaderWeatherTemplateTest.java`: 헤더 링크 기대값
- 저장소 외부 원본 자료: 최종 CSV와 한국어 파일명 이미지

## Data Model

- `puzzle_collections`
  - `id`: 내부 PK
  - `image_id`: 원본 이미지 ID, 1~80, unique
  - `catalog_order`: 엑셀 도감순, 1~56 또는 59~82, unique
  - `category`: 일반/동물
  - `name`: 한국어 퍼즐 이름, unique
  - `size`: 1x1~4x4
  - `acquisition_method`: 획득처
  - `purchase_price`: 선택 문자열
  - `image_url`: 정적 WebP 경로
  - `sort_order`: 화면 정렬 순서

## API Or Interface Changes

- `GET /wiki/others/puzzles`: 퍼즐 도감 화면
- `CollectionMapper.findAllPuzzles()`
- `CollectionMapper.countAllPuzzles()`
- `CollectionService.getAllPuzzles()`
- `CollectionService.getPuzzleCount()`

## Validation And Error Handling

- 생성 단계에서 기존 이미지 1~80과 시즌 이미지 99~108, 결과 90행, 파일 90개를 검증한다.
- SQL의 unique key와 upsert로 중복 삽입을 방지한다.
- 구매가격 null은 화면에서 `-`로 표시한다.
- 이미지 실패 시 텍스트 카드 내용과 퍼즐 아이콘 대체 요소를 유지한다.

## Test Plan

- 시드 행 수, image_id와 catalog_order 유일성, 실제 이미지 90개 존재 검사
- Gradle 전체 테스트
- 템플릿 테스트로 라우트 모델명·필터 속성·헤더 링크·메인 카드 연결 검사
- 로컬 DB SQL 실행 후 `SELECT COUNT(*) FROM puzzle_collections;` 결과 90 확인
- 로컬 앱에서 `/wiki/others/puzzles` 응답 200, 카드 90개, 이미지 요청 성공 확인
- 데스크톱·모바일 화면 시각 확인

## Risks And Mitigations

- 기존 작업 트리가 더러움: 요청 파일만 수정하고 다른 변경은 건드리지 않는다.
- 로컬 DB 접속 정보 부재 가능성: 앱 설정의 로컬 계정으로 먼저 시도하고, 접속이 막히면 SQL 파일과 정확한 실행·검증 절차를 남긴다.
- 카드 90개로 초기 DOM이 큼: 이미지 lazy loading을 사용하고 별도 상세 페이지는 만들지 않는다.

## Alternatives Considered

- 정적 JSON만 사용: DB 기반인 기존 도감 구조와 검색·개수 집계 패턴을 따르기 어려워 채택하지 않았다.
- 엑셀 108개 전체를 이미지 없이 노출: “이미지와 맞는 것”을 완성하라는 요청과 어긋나 채택하지 않았다.
- 관리자 CRUD까지 구현: 현재 로컬 MVP 범위를 넘어 제외했다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.

## Whale Category Update

- 기존 설치 DB용 재실행 가능 SQL 패치로 99~108번의 분류와 상점 정보를 갱신한다.
- 신규 설치용 퍼즐 시드 SQL에도 동일한 최종 데이터를 반영한다.
- 별도 이벤트 모델·컬럼은 추가하지 않고 기존 `category` 조회 흐름을 유지한다.
- 퍼즐 화면의 기존 분류 필터에 `고래 탐사 시즌` 선택지를 추가한다.
- 회귀 테스트로 모델·Mapper·필터·시드·패치 SQL을 검증한 뒤 로컬 DB에 패치를 적용한다.
