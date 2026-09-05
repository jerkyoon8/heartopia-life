# Feature Spec: 동갈치 → 가아피쉬 단독 마이그레이션

## Source

- PRD: `specs/045-gaafish-name-migration/prd.md`
- Principles: `specs/principles.md`

## User Scenarios

### 비로그인 또는 동기화 OFF

- Given 체크리스트 또는 펫 먹이 localStorage에 구명칭이 있다.
- When 변경 버전 사이트를 처음 연다.
- Then 구명칭을 신명칭으로 한 번 이관하고 기존 상태를 유지한다.

### 로그인 및 동기화 ON

- Given 운영 DB에 구명칭 체크리스트 키 또는 펫 먹이명이 있다.
- When 운영 데이터 마이그레이션을 실행한다.
- Then DB에는 신명칭만 남고 기존 별점과 펫 설정이 유지된다.

## Name Mappings

| 유형 | 구명칭 | 신명칭 |
|---|---|---|
| 물고기 | 갈색 얼룩 동갈치 | 갈색 얼룩 가아피쉬 |
| 물고기 | 검은 얼룩 동갈치 | 검은 얼룩 가아피쉬 |
| 물고기 | 연금색 동갈치 | 연금색 가아피쉬 |
| 물고기 | 은색 동갈치 | 은색 가아피쉬 |
| 요리 | 선인장 갈색 얼룩 동갈치 수프 | 선인장 갈색 얼룩 가아피쉬 수프 |
| 요리 | 선인장 검은 얼룩 동갈치 수프 | 선인장 검은 얼룩 가아피쉬 수프 |
| 요리 | 선인장 연금색 동갈치 수프 | 선인장 연금색 가아피쉬 수프 |
| 요리 | 선인장 은색 동갈치 수프 | 선인장 은색 가아피쉬 수프 |
| 요리 | 선인장 황금 동갈치 수프 | 선인장 황금 가아피쉬 수프 |

## Functional Requirements

- FR-001: 위 물고기 4개 이름만 변경한다.
- FR-002: 위 요리 5개 이름과 각 `ingredients`의 대응 재료명만 변경한다.
- FR-003: 체크리스트는 물고기 4개와 요리 5개의 일반 키 및 `mastery_` 키를 변환한다.
- FR-004: `heartopia_checklist` 변환은 로그인 병합 요청보다 먼저 실행하고 완료 버전을 기록한다.
- FR-005: `user_checklist`는 운영 SQL로 직접 이관하며 충돌 시 높은 `star_rating`을 보존한다.
- FR-006: `heartopia_pet_food_profiles`의 네 물고기명을 변환하고 상태를 유지한다.
- FR-007: `user_pet_food.pets_json`의 네 물고기명을 운영 SQL로 직접 변경한다.
- FR-008: 이미지 URL과 업로드 파일은 변경하지 않는다.
- FR-009: 영구 구명칭 별칭 처리와 옛 상세 URL 리다이렉트는 추가하지 않는다.

## Edge Cases

- 구키와 새키가 함께 있으면 일반/명인 키별로 높은 별점을 남긴다.
- 펫 custom food에 구·신명칭이 함께 있으면 신명칭 항목 하나로 병합하고 상태를 보존한다.
- 손상된 localStorage는 덮어쓰지 않고 완료 버전도 기록하지 않는다.
- 구버전 탭의 늦은 저장은 잔여 검색 후 멱등 DB SQL 재실행으로 정리한다.
- 운영 영향 행 수가 사전 스냅샷과 다르면 커밋하지 않는다.

## Data Requirements

- fish 4행, cooking 이름 5행·ingredients 5행
- checklist 적용 시점 317행·60명·구키 9종
- pet food 현재 1행·`customFoods[].name` 4개
- target-name 충돌, `cooking_ingredients`, `map_pins` 현재 0건
- image_url 9행은 옛 문자열을 의도적으로 유지

## Review Checklist

- [x] 표시 데이터와 사용자 상태 범위가 구분되어 있다.
- [x] 로그인 여부와 동기화 상태별 데이터 원본이 명확하다.
- [x] 펫 먹이 포함 여부가 확정되었다.
- [x] 이미지 불변 조건이 명확하다.
