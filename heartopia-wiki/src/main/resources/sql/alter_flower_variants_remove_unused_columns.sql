-- create_flower_breeding_schema.sql 초기 버전에서 만든 불필요 컬럼 정리용.
-- 이미 해당 컬럼이 생성된 DB에서만 직접 확인 후 실행한다.

ALTER TABLE flower_variants DROP COLUMN color_hex;
ALTER TABLE flower_variants DROP COLUMN sell_price;
ALTER TABLE flower_variants DROP COLUMN event_price;
ALTER TABLE flower_variants DROP COLUMN is_seed_color;
