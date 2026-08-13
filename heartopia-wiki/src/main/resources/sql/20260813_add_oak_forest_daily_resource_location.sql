-- 기존 일일 자원 위치 테이블에 참나무숲 위치 유형을 추가한다.
-- 애플리케이션 배포 전에 MySQL 8.0의 heartopia_db에 1회 적용한다.

ALTER TABLE daily_resource_locations
    DROP CHECK chk_daily_resource_fluorite_type,
    DROP CHECK chk_daily_resource_fluorite_house,
    DROP CHECK chk_daily_resource_oak_type,
    DROP CHECK chk_daily_resource_oak_house,
    ADD CONSTRAINT chk_daily_resource_fluorite_type
        CHECK (fluorite_location_type IN ('HOUSE_FRONT', 'RUINS', 'OAK_FOREST')),
    ADD CONSTRAINT chk_daily_resource_fluorite_house
        CHECK (
            (fluorite_location_type = 'HOUSE_FRONT'
                AND fluorite_house_number IS NOT NULL
                AND fluorite_house_number >= 1)
            OR (fluorite_location_type IN ('RUINS', 'OAK_FOREST')
                AND fluorite_house_number IS NULL)
        ),
    ADD CONSTRAINT chk_daily_resource_oak_type
        CHECK (oak_location_type IN ('HOUSE_FRONT', 'RUINS', 'OAK_FOREST')),
    ADD CONSTRAINT chk_daily_resource_oak_house
        CHECK (
            (oak_location_type = 'HOUSE_FRONT'
                AND oak_house_number IS NOT NULL
                AND oak_house_number >= 1)
            OR (oak_location_type IN ('RUINS', 'OAK_FOREST')
                AND oak_house_number IS NULL)
        );

SELECT CONSTRAINT_NAME, CHECK_CLAUSE
FROM information_schema.CHECK_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = DATABASE()
  AND CONSTRAINT_NAME LIKE 'chk_daily_resource_%'
ORDER BY CONSTRAINT_NAME;
