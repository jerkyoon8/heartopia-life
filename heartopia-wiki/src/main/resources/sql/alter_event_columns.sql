-- 수집품 테이브에 이벤트 카테고리(event_name) 컬럼 추가 마이그레이션 스크립트

ALTER TABLE fish_collections ADD COLUMN event_name VARCHAR(100) DEFAULT NULL;
ALTER TABLE bird_collections ADD COLUMN event_name VARCHAR(100) DEFAULT NULL;
ALTER TABLE bug_collections ADD COLUMN event_name VARCHAR(100) DEFAULT NULL;
ALTER TABLE animal_collections ADD COLUMN event_name VARCHAR(100) DEFAULT NULL;
ALTER TABLE cooking_collections ADD COLUMN event_name VARCHAR(100) DEFAULT NULL;
ALTER TABLE crop_collections ADD COLUMN event_name VARCHAR(100) DEFAULT NULL;
ALTER TABLE flower_collections ADD COLUMN event_name VARCHAR(100) DEFAULT NULL;
ALTER TABLE forageable_collections ADD COLUMN event_name VARCHAR(100) DEFAULT NULL;

-- 예시: '꿈의 명암' 이벤트 아이템 업데이트 (실제 아이템 이름에 맞게 적용 필요)
-- UPDATE [table_name] SET event_name = '꿈의 명암' WHERE name = '아이템 이름';
