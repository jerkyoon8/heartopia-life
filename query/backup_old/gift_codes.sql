use heartopia_db;-- 1. Gift Code 테이블 생성

CREATE TABLE IF NOT EXISTS cooking_ingredients (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    cooking_id      INT          NOT NULL,
    ingredient_name VARCHAR(100) NOT NULL,
    quantity        INT          NOT NULL DEFAULT 1,
    item_type       VARCHAR(30)  DEFAULT NULL,
    item_id         INT          DEFAULT NULL,
    CONSTRAINT fk_ci_cooking
        FOREIGN KEY (cooking_id) REFERENCES cooking_collections(id) ON DELETE CASCADE
);


-- id 확인
SELECT id FROM cooking_collections WHERE name = '베지 샐러드';
-- 재료 삽입 (id가 1이라면)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
VALUES (1, '아무 채소', 2);

CREATE TABLE IF NOT EXISTS cooking_ingredients (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    cooking_id      INT          NOT NULL,
    ingredient_name VARCHAR(100) NOT NULL,
    quantity        INT          NOT NULL DEFAULT 1,
    item_type       VARCHAR(30)  DEFAULT NULL,
    item_id         INT          DEFAULT NULL,
    CONSTRAINT fk_ci_cooking
        FOREIGN KEY (cooking_id) REFERENCES cooking_collections(id) ON DELETE CASCADE
);

-- =========================================================
-- 채집 도감(forageable_collections) location 한국어 변환
-- 기준: 물고기/새/곤충 도감의 location 명명 규칙과 동일하게 적용
-- =========================================================

USE heartopia_db;

-- 1. 숲 계열
--    'Forest (Spirit Oak Pine)' → '숲'  (세부: 영혼의 참나무 숲)
UPDATE forageable_collections
SET location = '숲'
WHERE location = 'Forest (Spirit Oak Pine)';

--    'Forest (Forest Island)' → '숲'  (세부: 숲속 섬)
UPDATE forageable_collections
SET location = '숲'
WHERE location = 'Forest (Forest Island)';

--    'Forest' → '숲'
UPDATE forageable_collections
SET location = '숲'
WHERE location = 'Forest';

-- 2. 홈 계열
--    'Home'   → '홈'
UPDATE forageable_collections
SET location = '홈'
WHERE location = 'Home';

--    'Bushes' → '홈'  (집 근처 관목)
UPDATE forageable_collections
SET location = '홈'
WHERE location = 'Bushes';

--    'Tree'   → '홈'  (집 근처 나무)
UPDATE forageable_collections
SET location = '홈'
WHERE location = 'Tree';

--    'Bamboo' → '홈'  (집 근처 대나무)
UPDATE forageable_collections
SET location = '홈'
WHERE location = 'Bamboo';

-- 3. 어촌
--    'Fishing Village' → '어촌'
UPDATE forageable_collections
SET location = '어촌'
WHERE location = 'Fishing Village';

-- 4. 꽃밭
--    'Flower Field' → '꽃밭'
UPDATE forageable_collections
SET location = '꽃밭'
WHERE location = 'Flower Field';

-- 5. 온천산
--    'Onsen Mountain' → '온천산'
UPDATE forageable_collections
SET location = '온천산'
WHERE location = 'Onsen Mountain';

-- 6. 도시 근교
--    'Gigantic Tree in the Suburb' → '도시 근교'
UPDATE forageable_collections
SET location = '도시 근교'
WHERE location = 'Gigantic Tree in the Suburb';

-- 7. 특수 구역 (location_zones에 없는 고유 이벤트/희귀 장소)
--    'Roaming Oak-Oak'             → '방랑하는 오크오크'
UPDATE forageable_collections
SET location = '방랑하는 오크오크'
WHERE location = 'Roaming Oak-Oak';

--    'Fluorite Mine'               → '형석 광산'
UPDATE forageable_collections
SET location = '형석 광산'
WHERE location = 'Fluorite Mine';

--    'Meteor Shower (Meteorite Ore)' → '운석우'
UPDATE forageable_collections
SET location = '운석우'
WHERE location = 'Meteor Shower (Meteorite Ore)';

-- 결과 확인
SELECT id, name, location FROM forageable_collections ORDER BY location, id;


CREATE TABLE IF NOT EXISTS gift_code (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code_name VARCHAR(50) NOT NULL UNIQUE,
    rewards VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE, EXPIRED, SOON
    expiration_date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT '물고기' AS 테이블, location AS 위치, sub_location AS 세부위치 
FROM fish_collections GROUP BY location, sub_location
UNION ALL
SELECT '새', location, sub_location FROM bird_collections GROUP BY location, sub_location
UNION ALL
SELECT '곤충', location, sub_location FROM bug_collections GROUP BY location, sub_location
ORDER BY 테이블, 위치, 세부위치;


-- 누락된 image_url 컬럼 추가
ALTER TABLE crop_collections ADD COLUMN image_url VARCHAR(255) DEFAULT NULL;
ALTER TABLE flower_collections ADD COLUMN image_url VARCHAR(255) DEFAULT NULL;
ALTER TABLE forageable_collections ADD COLUMN image_url VARCHAR(255) DEFAULT NULL;
-- image_url 초기 데이터 설정
UPDATE crop_collections SET image_url = CONCAT('/images/items/crops/', name, '.png') WHERE image_url IS NULL;
UPDATE flower_collections SET image_url = CONCAT('/images/items/flowers/', name, '.png') WHERE image_url IS NULL;
UPDATE forageable_collections SET image_url = CONCAT('/images/collections/forage/', name, '.png') WHERE image_url IS NULL;
select * from villagers;

-- 2. 기존 데이터 삭제 (중복 방지)
DELETE FROM gift_code;

-- 3. 데이터 삽입 (Active Codes)
INSERT INTO gift_code (code_name, rewards, status, expiration_date) VALUES 
('r4p8n6m2q9', '10x 소원별, 3x 인어 집어기, 10x 비료', 'ACTIVE', '2026-03-31'),
('heartopia10m', '10x 소원별', 'ACTIVE', '2026-03-31'),
('lifewithline', '10x 소원별', 'ACTIVE', '2026-03-31'),
('happy2026', '10x 달빛 크리스탈, 8888 골드', 'ACTIVE', '2026-03-31'),
('k7m9q2a8l5', '5x 소원별, 3x 인어 집어기, 10x 비료', 'ACTIVE', '2026-03-31'),
('heartopia5m', '10x 소원별', 'ACTIVE', '2026-03-31'),
('top1thanks', '5x 소원별, 2x 인어향수, 10x 오렌지', 'ACTIVE', '2026-03-31'),
('r4a8x2n', '5x 소원별, 10x 성장 촉진제, 10x 오렌지', 'ACTIVE', '2026-03-31'),
('true5mthks', '10x 고급목재, 2x 셰프 특선 샐러드, 20x 관목가지', 'ACTIVE', '2026-03-31'),
('letsparty', '15x 소원별, 5000 골드, 3x 수리도구', 'ACTIVE', '2026-03-31'),
('b8n2k5l', '2x 완벽한 형광석, 6x 희귀목재, 10x 돌', 'ACTIVE', '2026-03-31'),
('dcthx4u', '10x 소원별', 'ACTIVE', '2026-06-30'),
('m7r9q4a', '2x 인어향수, 10000 골드, 10x 달걀', 'ACTIVE', '2026-03-31'),
('x2l8k6p', '5x 소원별, 10x 비료, 10x 사과', 'ACTIVE', '2026-03-31'),
('h9q3a7m5', '2x 그 자리 참나무, 10x 우유, 10x 목재', 'ACTIVE', '2026-03-31'),
('letsbuild', '15x 소원별, 5000 골드, 10x 비료', 'ACTIVE', '2026-03-31'),
('letsdressup', '15x 소원별, 5000 골드, 10x 성장 촉진제', 'ACTIVE', '2026-03-31'),
('a7k9m2q8l', '5x 소원별, 3x 수리도구, 10x 블루베리', 'ACTIVE', '2026-03-31'),
('z4p6n8r2', '10x 고급목재, 2x 셰프 특선 샐러드, 20x 관목가지', 'ACTIVE', '2026-03-31'),
('specialgift0103', '100x 달빛 크리스탈', 'SOON', '2026-02-07'),
('heartopia0108', '100x 달빛 크리스탈', 'SOON', '2026-02-07'),
('mylittlepony', '100x 달빛 크리스탈', 'SOON', '2026-02-07');

-- 4. 데이터 삽입 (Expired Codes)
INSERT INTO gift_code (code_name, rewards, status, expiration_date) VALUES 
('Crystals', '100x 달빛 크리스탈', 'EXPIRED', NULL),
('officialstream', 'Unknown', 'EXPIRED', NULL),
('finaltest', 'Unknown', 'EXPIRED', NULL);