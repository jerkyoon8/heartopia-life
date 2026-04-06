-- location_zones 테이블에 map_x, map_y 컬럼 추가
-- 기존 데이터에 영향 없음 (NULL 허용)
ALTER TABLE location_zones ADD COLUMN map_x INT NULL COMMENT '위치 x좌표 (픽셀)' AFTER polygon_points;
ALTER TABLE location_zones ADD COLUMN map_y INT NULL COMMENT '위치 y좌표 (픽셀)' AFTER map_x;