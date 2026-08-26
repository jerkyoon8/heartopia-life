# Implementation Plan: 퍼즐·모래 조각 수집 기록과 메인 진행도

## Context

- Spec: `specs/030-puzzle-sandbox-checklist-progress/spec.md`
- Target branch: current working branch
- Current codebase notes:
  - 모든 페이지가 `common-head.html`에서 `ChecklistCore`와 `checklist-sync.js`를 불러온다.
  - `.sync-item`/`data-sync-key`/`.sync-check-btn` 계약을 추가하면 기존 로컬·계정 저장 API를 재사용할 수 있다.
  - 동기화 ON 데이터 로딩은 현재 `.sync-item`이 있는 페이지에서만 수행되므로 메인 진행도에는 그대로 사용할 수 없다.
  - 통합 수집 도감은 별도의 `checklist.js`에서 계정 데이터를 다시 읽고 있어 전역 로딩으로 통합할 때 중복 요청을 제거해야 한다.
  - 메인 카드는 `CategoryItemDto`의 전체 개수만 렌더링하며 체크 카테고리 메타데이터가 없다.

## Approach

1. `CategoryItemDto`에 선택적 `checklistPrefix`를 추가하고 기존 생성자 호환성을 유지한다. 컨트롤러는 체크 기능이 있는 10개 카테고리에만 접두사를 제공한다.
2. `ChecklistCore`에 전체 데이터를 한 번에 교체하는 메서드를 추가한다. `checklist-sync.js`는 체크 DOM 존재 여부와 무관하게 계정 데이터를 한 번 불러와 Core에 일괄 반영하고 전역 준비 Promise를 제공한다.
3. `checklist-sync.js`가 `data-checklist-prefix`와 `data-total`을 가진 메인 카드 진행도를 렌더링하도록 확장한다. 완료 수는 해당 접두사의 일반 체크 키만 세고 전체 수를 넘지 않도록 제한한다.
4. 퍼즐·모래 조각의 카드와 표에 ID 기반 키의 공통 체크 UI를 추가하고, 수집 완료 숨김 토글을 기존 `WikiFilter`에 연결한다.
5. 통합 수집 도감 모델과 템플릿에 퍼즐·모래 조각 카테고리/목록을 추가한다. 신규 항목은 별점·명인 없이 단순 완료 체크만 제공한다.
6. 메인 카드 템플릿은 체크 접두사가 있으면 로딩 상태 후 `완료 / 전체 완료`를, 없으면 기존 데이터 개수를 표시한다. 모바일에서도 진행도 문구는 숨기지 않는다.
7. JS 단위 테스트와 템플릿 구조 테스트를 추가·갱신하고 전체 관련 테스트를 실행한다.

## Impacted Files

- `src/main/java/com/heartopia/wiki/dto/wiki/CategoryItemDto.java`: 선택적 체크 접두사 필드와 호환 생성자
- `src/main/java/com/heartopia/wiki/controller/WikiController.java`: 메인 카드 접두사, 통합 체크리스트 퍼즐·모래 조각 목록
- `src/main/resources/templates/wiki/wiki.html`: 진행도 데이터 속성·로딩/완료 문구 및 모바일 표시
- `src/main/resources/templates/wiki/others/puzzles.html`: 카드/표 체크 UI와 완료 숨김
- `src/main/resources/templates/wiki/others/sandbox.html`: 카드/표 체크 UI와 완료 숨김
- `src/main/resources/templates/wiki/checklist.html`: 신규 카테고리 카드와 단순 체크 목록
- `src/main/resources/static/js/checklist-core.js`: 계정 데이터 일괄 반영 메서드
- `src/main/resources/static/js/checklist-sync.js`: 전역 계정 로딩, 메인 진행도 계산·렌더링, 접근성 상태 갱신
- `src/main/resources/static/js/checklist.js`: 전역 체크리스트 준비 Promise 재사용 및 신규 카테고리 집계
- `src/main/resources/static/css/checklist-sync.css`: 버튼 기본 스타일 보정과 표 체크 버튼 배치
- `src/main/resources/templates/fragments/common-head.html`: 변경된 정적 JS/CSS 캐시 버전
- `src/test/js/checklist-progress.test.js`: 접두사별 완료 수 계산 단위 테스트
- `src/test/java/com/heartopia/wiki/template/PuzzleSandboxChecklistTemplateTest.java`: 신규 페이지·통합 도감·메인 템플릿 계약 테스트
- `src/test/java/com/heartopia/wiki/template/WikiMobileLayoutTemplateTest.java`: 모바일 진행도 표시 규칙 갱신

## Data Model

- DB 변경 없음.
- 신규 체크 키:
  - 퍼즐: `puzzle_id_{puzzle_collections.id}`
  - 모래 조각: `sandbox_id_{sandbox_collections.id}`
- 저장 값은 기존 단순 체크 관례인 `0`을 사용하고 해제 시 키를 삭제한다.
- 메인 진행도 접두사:
  - `fish_`, `bug_`, `bird_`, `flower_`, `crop_`, `cooking_`
  - `sea_cleaning_id_`, `achievement_`, `sandbox_id_`, `puzzle_id_`

## API Or Interface Changes

- 신규 HTTP API 없음.
- `CategoryItemDto`에 nullable `checklistPrefix` 접근자가 추가된다.
- `ChecklistCore.replaceData(data)`가 추가된다.
- `window._heartopiaChecklistReady` Promise가 전역 체크 데이터 초기화 완료 여부를 제공한다.
- 메인 진행도 DOM 계약: `data-checklist-prefix`, `data-total`, `.card-progress`.

## Validation And Error Handling

- 전체 수는 음수가 아닌 정수로 해석하고 완료 수는 `0..total` 범위로 제한한다.
- 계정 체크리스트 응답이 성공한 경우에만 Core를 교체한다.
- 계정 조회 실패 시 진행도 요소에 불러오기 실패 상태를 표시하고 `0`을 실제 값처럼 확정 표시하지 않는다.
- 체크 저장·삭제 요청 실패는 기존 동작과 동일하게 UI를 유지하되 페이지 재진입 시 서버 상태로 복원한다.
- 체크 버튼은 `aria-pressed`를 현재 상태와 함께 갱신한다.

## Test Plan

- JS 단위 테스트:
  - 접두사가 같은 일반 키만 집계
  - `mastery_`와 다른 카테고리 제외
  - 중복/오래된 키로 전체 초과 시 상한 적용
  - 빈 데이터와 잘못된 전체 수 처리
- Java 템플릿 테스트:
  - 퍼즐·모래 조각 카드/표의 ID 기반 키와 체크 버튼
  - 두 페이지의 완료 숨김 토글
  - 통합 수집 도감의 신규 카테고리·목록
  - 메인 카드 진행도 속성과 접두사
  - 모바일에서 진행도 문구 유지
- 기존 체크리스트 서비스·템플릿·필터 테스트 및 전체 Gradle 테스트
- 수동 확인:
  - 비로그인 체크→새로고침→메인 진행도
  - 카드/표 보기 상태 일치와 완료 숨김
  - 로그인 동기화 ON 데이터 로딩과 저장/해제
  - 통합 수집 도감 전체 및 카테고리 진행률

## Risks And Mitigations

- 전역 데이터 로딩 변경이 기존 체크 페이지와 중복될 위험: `window._heartopiaChecklistReady` 하나로 통합하고 `checklist.js`의 직접 조회를 제거한다.
- `setItem` 반복 적용 시 대량 observer 호출: `replaceData`로 단일 알림 처리한다.
- 이름 기반 기존 키의 오래된 기록을 완전히 검증하기 어려움: 전체 수 상한을 적용하고 신규 카테고리는 ID 키를 사용한다.
- 카드와 표에 동일 키가 두 번 존재: Core의 고유 키 기준으로 집계한다.
- 모바일 기존 CSS가 모든 데이터 문구를 숨김: `.card-progress`를 예외로 명시하고 회귀 테스트로 고정한다.

## Alternatives Considered

- 메인 페이지에서 카테고리별 전체 목록을 모두 조회해 유효 키를 HTML에 포함: 정확한 교집합 계산은 가능하지만 DB 조회·HTML 크기가 크게 늘어 이번 범위에는 과하다.
- 진행도 전용 API 추가: 로그인/비로그인 저장소가 나뉘어 로컬 상태를 서버가 알 수 없고 추가 요청이 필요해 채택하지 않는다.
- 신규 두 카테고리만 메인 진행도 표시: 사용자가 모든 체크 지원 카드에 일관되게 적용하기로 결정해 제외한다.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
