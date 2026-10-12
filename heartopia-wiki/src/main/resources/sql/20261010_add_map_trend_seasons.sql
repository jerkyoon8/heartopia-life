-- MySQL 8.0 heartopia_db. 기존 20260829_create_dynamic_map_resources.sql 적용 후 1회 실행.
-- 로컬 검증 대상. 운영에는 현재 실행하지 않는다. 향후 코드 배포 전에 실행해야 한다.
ALTER TABLE dynamic_map_resources
    ADD COLUMN event_name VARCHAR(100) NULL,
    ADD COLUMN forageable_id INT NULL,
    ADD UNIQUE KEY uk_dynamic_map_resource_forageable (map_key, forageable_id),
    ADD CONSTRAINT fk_dynamic_resource_forageable FOREIGN KEY (forageable_id)
        REFERENCES forageable_collections(id) ON DELETE CASCADE;

INSERT INTO dynamic_map_resources (map_key, name, icon_url, description, event_name)
SELECT 'town', '속이 빈 나무', '/images/map/dynamic-resources/oak.webp',
       '숲속 섬. 성숙한 나무를 조사하면 보상을 획득할 수 있습니다.', '밤의 점술회'
WHERE NOT EXISTS (SELECT 1 FROM dynamic_map_resources WHERE map_key='town' AND name='속이 빈 나무');

INSERT INTO dynamic_map_resources (map_key, name, icon_url, event_name, forageable_id)
SELECT 'town', f.name, f.image_url, '밤의 점술회', f.id
FROM forageable_collections f
WHERE f.name='뽕나무버섯' AND f.show_on_map=1
  AND NOT EXISTS (SELECT 1 FROM dynamic_map_resources d WHERE d.map_key='town' AND d.name=f.name);

-- 기대 결과: 나무 1건(연결 ID NULL), 버섯 1건(기존 채집물 ID).
SELECT name, event_name, forageable_id FROM dynamic_map_resources WHERE event_name='밤의 점술회';
