-- 고래 탐사 시즌 채집물 및 두 번째 지도 분리용 패치
-- 적용 대상: MySQL 8.0 / heartopia_db

-- map_pins.map_key 추가
SET @has_map_pin_map_key := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'map_pins'
      AND COLUMN_NAME = 'map_key'
);
SET @sql := IF(
    @has_map_pin_map_key = 0,
    'ALTER TABLE map_pins ADD COLUMN map_key VARCHAR(50) NOT NULL DEFAULT ''town'' AFTER id',
    'SELECT ''map_pins.map_key already exists'''
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE map_pins SET map_key = 'town' WHERE map_key IS NULL OR map_key = '';

SET @has_map_pin_map_key_index := (
    SELECT COUNT(*)
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'map_pins'
      AND INDEX_NAME = 'idx_map_pins_map_key_category'
);
SET @sql := IF(
    @has_map_pin_map_key_index = 0,
    'CREATE INDEX idx_map_pins_map_key_category ON map_pins (map_key, category)',
    'SELECT ''idx_map_pins_map_key_category already exists'''
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- location_zones.map_key 추가 및 zone_key unique를 map_key + zone_key unique로 확장
SET @has_location_zone_map_key := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'location_zones'
      AND COLUMN_NAME = 'map_key'
);
SET @sql := IF(
    @has_location_zone_map_key = 0,
    'ALTER TABLE location_zones ADD COLUMN map_key VARCHAR(50) NOT NULL DEFAULT ''town'' AFTER id',
    'SELECT ''location_zones.map_key already exists'''
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE location_zones SET map_key = 'town' WHERE map_key IS NULL OR map_key = '';

SET @zone_key_unique_index := (
    SELECT INDEX_NAME
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'location_zones'
      AND NON_UNIQUE = 0
      AND INDEX_NAME <> 'PRIMARY'
    GROUP BY INDEX_NAME
    HAVING COUNT(*) = 1
       AND SUM(COLUMN_NAME = 'zone_key') = 1
    LIMIT 1
);
SET @sql := IF(
    @zone_key_unique_index IS NULL,
    'SELECT ''single-column zone_key unique index not found''',
    CONCAT('ALTER TABLE location_zones DROP INDEX ', @zone_key_unique_index)
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_location_zone_map_unique := (
    SELECT COUNT(*)
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'location_zones'
      AND INDEX_NAME = 'uk_location_zones_map_zone'
);
SET @sql := IF(
    @has_location_zone_map_unique = 0,
    'ALTER TABLE location_zones ADD UNIQUE KEY uk_location_zones_map_zone (map_key, zone_key)',
    'SELECT ''uk_location_zones_map_zone already exists'''
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 고래 탐사 시즌 채집물
UPDATE forageable_collections
SET location = '고래낙하 협곡 - 고래낙하',
    price = 0,
    energy = NULL,
    image_url = '/images/collections/forage/미역.webp',
    event_name = '고래 탐사 시즌',
    show_on_map = TRUE
WHERE name = '미역';

INSERT INTO forageable_collections (name, location, price, energy, image_url, event_name, show_on_map)
SELECT '미역', '고래낙하 협곡 - 고래낙하', 0, NULL, '/images/collections/forage/미역.webp', '고래 탐사 시즌', TRUE
WHERE NOT EXISTS (SELECT 1 FROM forageable_collections WHERE name = '미역');

UPDATE forageable_collections
SET location = '고래낙하 협곡 - 해파리 동굴',
    price = 0,
    energy = NULL,
    image_url = '/images/collections/forage/바다 아스파라거스.webp',
    event_name = '고래 탐사 시즌',
    show_on_map = TRUE
WHERE name = '바다 아스파라거스';

INSERT INTO forageable_collections (name, location, price, energy, image_url, event_name, show_on_map)
SELECT '바다 아스파라거스', '고래낙하 협곡 - 해파리 동굴', 0, NULL, '/images/collections/forage/바다 아스파라거스.webp', '고래 탐사 시즌', TRUE
WHERE NOT EXISTS (SELECT 1 FROM forageable_collections WHERE name = '바다 아스파라거스');

UPDATE forageable_collections
SET location = '고래낙하 협곡 - 산호 거리',
    price = 0,
    energy = NULL,
    image_url = '/images/collections/forage/바다 포도.webp',
    event_name = '고래 탐사 시즌',
    show_on_map = TRUE
WHERE name = '바다 포도';

INSERT INTO forageable_collections (name, location, price, energy, image_url, event_name, show_on_map)
SELECT '바다 포도', '고래낙하 협곡 - 산호 거리', 0, NULL, '/images/collections/forage/바다 포도.webp', '고래 탐사 시즌', TRUE
WHERE NOT EXISTS (SELECT 1 FROM forageable_collections WHERE name = '바다 포도');
