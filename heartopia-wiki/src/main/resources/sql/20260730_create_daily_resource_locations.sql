-- 일일 형광석·그자리 참나무 위치
-- 게임 날짜는 Asia/Seoul 오전 6시부터 다음 날 오전 5시 59분까지 적용한다.

CREATE TABLE IF NOT EXISTS daily_resource_locations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    game_date DATE NOT NULL,
    fluorite_location_type VARCHAR(20) NOT NULL,
    fluorite_house_number INT NULL,
    oak_location_type VARCHAR(20) NOT NULL,
    oak_house_number INT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_daily_resource_location_game_date (game_date),
    CONSTRAINT chk_daily_resource_fluorite_type
        CHECK (fluorite_location_type IN ('HOUSE_FRONT', 'RUINS')),
    CONSTRAINT chk_daily_resource_fluorite_house
        CHECK (
            (fluorite_location_type = 'HOUSE_FRONT' AND fluorite_house_number IS NOT NULL AND fluorite_house_number >= 1)
            OR (fluorite_location_type = 'RUINS' AND fluorite_house_number IS NULL)
        ),
    CONSTRAINT chk_daily_resource_oak_type
        CHECK (oak_location_type IN ('HOUSE_FRONT', 'RUINS')),
    CONSTRAINT chk_daily_resource_oak_house
        CHECK (
            (oak_location_type = 'HOUSE_FRONT' AND oak_house_number IS NOT NULL AND oak_house_number >= 1)
            OR (oak_location_type = 'RUINS' AND oak_house_number IS NULL)
        )
);
