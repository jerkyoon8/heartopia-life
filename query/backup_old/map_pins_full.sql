-- 맵 핀 전체 데이터 갱신 (주민 22명 + 동물 8마리)
USE heartopia_db;

-- 1. 기존 데이터 삭제
DELETE FROM map_pins;

-- 2. 주민 데이터 (22명)
INSERT INTO map_pins (category, name, icon_url, map_x, map_y, link_url, description) VALUES
-- 기존 주민 (9명) - 좌표 유지
('villager', '블랑코', '/images/npc/NPC_icon_블랑코.png', 5800, 3900, '/wiki/others/villagers', '원예 멘토 & 상점 주인'),
('villager', '바냐', '/images/npc/NPC_icon_바냐.png', 6200, 3500, '/wiki/others/villagers', '낚시 멘토'),
('villager', '마시모', '/images/npc/NPC_icon_마시모.png', 5600, 3500, '/wiki/others/villagers', '요리 멘토'),
('villager', '앤드류', '/images/npc/NPC_icon_앤드류.png', 5500, 4200, '/wiki/others/villagers', '공방 & 제작 멘토'),
('villager', '에릭', '/images/npc/NPC_icon_에릭.png', 6000, 4500, '/wiki/others/villagers', '시청 직원'),
('villager', '도로시', '/images/npc/NPC_icon_도로시.png', 5000, 3800, '/wiki/others/villagers', '패션 상점'),
('villager', '카칭', '/images/npc/NPC_icon_카칭.png', 5200, 3400, '/wiki/others/villagers', '잡화점'),
('villager', '수집가', '/images/npc/NPC_icon_수집가.png', 6500, 3000, '/wiki/others/villagers', '박물관'),
('villager', '버블', '/images/npc/NPC_icon_버블.png', 4800, 4000, '/wiki/others/villagers', '미용실');

-- 신규 주민 (13명) - 임의 좌표 배정 (추후 조정 필요)
INSERT INTO map_pins (category, name, icon_url, map_x, map_y, link_url, description) VALUES
('villager', '조안 여사', '/images/npc/NPC_icon_조안_여사.png', 4500, 2500, '/wiki/others/villagers', '펫 멘토'),
('villager', '베일리', '/images/npc/NPC_icon_베일리.png', 4500, 2600, '/wiki/others/villagers', '새 관찰 멘토'),
('villager', '나니와', '/images/npc/NPC_icon_나니와.png', 5300, 3300, '/wiki/others/villagers', '곤충 채집 멘토'),
('villager', '알버트 2세', '/images/npc/NPC_icon_알버트_2세.png', 2000, 4000, '/wiki/others/villagers', '골드 상인'),
('villager', '밥 아저씨', '/images/npc/NPC_icon_밥_아저씨.png', 4900, 3700, '/wiki/others/villagers', '인테리어 상인'),
('villager', '애니', '/images/npc/NPC_icon_애니.png', 3000, 3000, '/wiki/others/villagers', '프렌즈 상점 주인'),
('villager', '아타라', '/images/npc/NPC_icon_아타라.png', 3200, 3200, '/wiki/others/villagers', '퀘스트 매니저'),
('villager', '애쥬어', '/images/npc/NPC_icon_애쥬어.png', 3100, 3300, '/wiki/others/villagers', '트렌드 상인'),
('villager', '패티', '/images/npc/NPC_icon_패티.png', 2500, 5000, '/wiki/others/villagers', '순록탑 주변'),
('villager', '버니', '/images/npc/NPC_icon_버니.png', 4000, 5500, '/wiki/others/villagers', '풍차 꽃밭'),
('villager', '윌', '/images/npc/NPC_icon_윌.png', 3500, 2500, '/wiki/others/villagers', '마을'),
('villager', '장난꾸러기', '/images/npc/NPC_icon_장난꾸러기.png', 3600, 2600, '/wiki/others/villagers', '마을 골목'),
('villager', '해리', '/images/npc/NPC_icon_해리.png', 3700, 2700, '/wiki/others/villagers', '마을'),
('villager', '빌', '/images/npc/NPC_icon_빌.png', 6800, 2000, '/wiki/others/villagers', '부두 이벤트 NPC');


-- 3. 동물 데이터 (8마리)
INSERT INTO map_pins (category, name, icon_url, map_x, map_y, link_url, description) VALUES
('animal', '판다', '/images/collections/animals/wild_animal_판다.png', 3000, 3000, '/wiki/collections/animal', '좋아하는 날씨: 비'),
('animal', '카피바라', '/images/collections/animals/wild_animal_카피바라.png', 5000, 1500, '/wiki/collections/animal', '좋아하는 날씨: 비'),
('animal', '토끼', '/images/collections/animals/wild_animal_토끼.png', 1500, 5000, '/wiki/collections/animal', '좋아하는 날씨: 맑음'),
('animal', '여우', '/images/collections/animals/wild_animal_여우.png', 500, 3000, '/wiki/collections/animal', '좋아하는 날씨: 무지개'),
('animal', '해달', '/images/collections/animals/wild_animal_해달.png', 3000, 500, '/wiki/collections/animal', '좋아하는 날씨: 비'),
('animal', '담비', '/images/collections/animals/wild_animal_담비.png', 5000, 5000, '/wiki/collections/animal', '좋아하는 날씨: 무지개'),
('animal', '꽃사슴', '/images/collections/animals/wild_animal_꽃사슴.png', 5500, 3000, '/wiki/collections/animal', '좋아하는 날씨: 맑음'),
('animal', '알파카', '/images/collections/animals/wild_animal_알파카.png', 1000, 1000, '/wiki/collections/animal', '좋아하는 날씨: 맑음');
