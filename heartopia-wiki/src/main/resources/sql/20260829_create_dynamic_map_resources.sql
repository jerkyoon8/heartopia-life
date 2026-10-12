-- 지도별 변동 자원 마스터 데이터를 저장한다.
-- 애플리케이션 배포 전에 MySQL 8.0의 heartopia_db에 1회 적용한다.

CREATE TABLE IF NOT EXISTS dynamic_map_resources (
    id BIGINT NOT NULL AUTO_INCREMENT,
    map_key VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    icon_url VARCHAR(500) NULL,
    description TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_dynamic_map_resources_map_name (map_key, name),
    KEY idx_dynamic_map_resources_map_key (map_key),
    CONSTRAINT chk_dynamic_map_resources_map_key CHECK (map_key IN ('town', 'second'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SELECT TABLE_NAME, TABLE_ROWS
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'dynamic_map_resources';
