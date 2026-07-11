# PRD: Whale Season Second Map

## 1. Summary

### Problem

고래 탐사 시즌 채집물 자료와 두 번째 맵 이미지는 준비됐지만, 채집물 도감/필터/지도 핀 저장 흐름이 기존 맵 중심으로만 동작한다.

### Proposed Solution

고래 시즌 채집물을 기존 채집물 스타일로 추가하고, 이벤트 빠른 필터와 `map_key` 기반 핀 저장/조회 흐름을 추가한다.

### Success Criteria

- 채집물 도감에서 고래 탐사 시즌 아이템 3개가 기존 카드/테이블 스타일로 보인다.
- 채집물 도감에서 고래 탐사 시즌만 빠르게 볼 수 있다.
- 관리자 로그인 상태에서 `mapKey=second` 지도에 기존 방식으로 채집물 핀을 찍을 수 있다.
- 기존 맵의 핀은 새 맵에 섞이지 않는다.

## 2. Users And Use Cases

### Primary Users

- 관리자: 새 시즌 아이템과 새 지도 핀을 관리한다.
- 일반 사용자: 채집물 도감과 지도에서 시즌 정보를 확인한다.

### User Stories

- As an admin, I want to place pins on the second map, so that whale season forageables can be mapped separately.
- As a visitor, I want to filter forageables by whale season, so that I can see only event items.

## 3. Functional Scope

### In Scope

- 고래 탐사 시즌 채집물 데이터 SQL 및 이미지 정적 리소스 추가
- 채집물 페이지의 고래 탐사 시즌 빠른 필터 버튼
- `map_pins.map_key` 기반 조회/저장
- 새 지도에서 관리자 핀 배치 활성화

### Out Of Scope

- 실제 프로덕션 DB 직접 반영
- 새 지도 전용 위치 zone 전체 작성
- 다른 카테고리 시즌 데이터 추가

## 4. Acceptance Criteria

- `second-map.webp` 선택 시 `map_key='second'` 핀만 표시된다.
- 새 지도에서 관리자 핀 추가 요청이 `mapKey=second`로 저장된다.
- 기존 `map_key`가 없는/기존 데이터는 `town`으로 취급된다.
- 고래 시즌 채집물은 `event_name='고래 탐사 시즌'`과 `show_on_map=TRUE`로 준비된다.

## 5. Constraints

- Tech: Spring Boot, MyBatis, Thymeleaf, vanilla JS
- Data: Spring SQL auto initialization is disabled, SQL must be applied separately.
- External Dependencies: user-provided WebP images under `C:\Users\k\Desktop\user_kit\고래시즌\채집물`

## 6. Risks

- DB 마이그레이션 미적용: 배포 후 새 맵 핀 저장이 실패할 수 있으므로 SQL 실행 안내를 남긴다.
- 기존 데이터 혼입: 서버/클라이언트 양쪽에서 `mapKey` 기본값과 필터를 둔다.

## 7. Open Questions

- 없음. 현재 범위는 틀과 저장 흐름 구현으로 진행한다.
