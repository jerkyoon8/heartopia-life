-- ================================================================
-- Heartopia Wiki - DB 인덱스 최적화
-- 실행 방법: MySQL에서 아래 쿼리를 직접 실행
-- 주의: 이미 인덱스가 있으면 에러가 나므로, 처음 한 번만 실행
-- ================================================================

USE heartopia_db;

-- ===== fish_collections =====
-- name: 상세보기 (WHERE name = ?), 검색 (LIKE), 자동완성
-- location: 관련정보 조회 (WHERE location = ?)
ALTER TABLE fish_collections
    ADD INDEX idx_fish_name (name),
    ADD INDEX idx_fish_location (location);

-- ===== bug_collections =====
ALTER TABLE bug_collections
    ADD INDEX idx_bug_name (name),
    ADD INDEX idx_bug_location (location);

-- ===== bird_collections =====
ALTER TABLE bird_collections
    ADD INDEX idx_bird_name (name),
    ADD INDEX idx_bird_location (location);

-- ===== animal_collections =====
ALTER TABLE animal_collections
    ADD INDEX idx_animal_name (name),
    ADD INDEX idx_animal_location (location);

-- ===== cooking_collections =====
ALTER TABLE cooking_collections
    ADD INDEX idx_cooking_name (name);

-- ===== flower_collections =====
ALTER TABLE flower_collections
    ADD INDEX idx_flower_name (name);

-- ===== crop_collections =====
ALTER TABLE crop_collections
    ADD INDEX idx_crop_name (name);

-- ===== forageable_collections =====
ALTER TABLE forageable_collections
    ADD INDEX idx_forageable_name (name),
    ADD INDEX idx_forageable_location (location);

-- ===== cooking_ingredients =====
-- cooking_id: 재료 조회 (WHERE cooking_id = ?)
-- item_id: CASE 서브쿼리 성능 향상
ALTER TABLE cooking_ingredients
    ADD INDEX idx_ingredient_cooking_id (cooking_id),
    ADD INDEX idx_ingredient_item_id (item_id);

-- 적용 확인 (선택사항)
-- SHOW INDEX FROM fish_collections;
-- SHOW INDEX FROM cooking_ingredients;
