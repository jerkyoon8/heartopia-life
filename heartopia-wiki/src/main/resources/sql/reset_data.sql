-- NPC Data Update Script
-- (User performs manual deletion of existing data)


-- 1. 블랑코 (Blanc)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (1, '블랑코 (Blanc)', '원예 멘토 & 상점 주인', '/images/npc/NPC_icon_블랑코.png', '원예 상점', '튜토리얼 진행');

-- Roles (Blanc)
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (1, 1, 'GUIDE', '원예', '희귀 꽃, 씨앗, 작물, 곤충');
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (2, 1, 'SHOP', '원예 상점', NULL);

-- Shop Items (Blanc)
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (1, 2, '꽃 씨앗');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (2, 2, '작물 씨앗');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (3, 2, '재배 상자');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (4, 2, '비료');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (5, 2, '성장 촉진제');

-- Gifts (Blanc)
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (1, 1, '희귀 꽃', TRUE);
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (2, 1, '씨앗', TRUE);
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (3, 1, '작물', TRUE);
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (4, 1, '곤충', TRUE);


-- 2. 바냐 (Vanya)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (2, '바냐 (Vanya)', '낚시 멘토', '/images/npc/NPC_icon_바냐.png', '가든 스트리트', '튜토리얼 진행');

-- Roles (Vanya)
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (3, 2, 'GUIDE', '낚시', '모든 물고기, 해산물, 낚시 용품');
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (4, 2, 'SHOP', '낚시 상점', NULL);
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (5, 2, 'EVENT', '얼음 낚시', '이벤트 진행 가능');
-- Quest Removed for Vanya

-- Shop Items (Vanya)
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (6, 4, '낚시대');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (7, 4, '미끼');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (8, 4, '어항');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (9, 4, '특수 아이템');

-- Gifts (Vanya)
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (5, 2, '모든 물고기', TRUE);
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (6, 2, '해산물', TRUE);
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (7, 2, '낚시 용품', TRUE);
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (8, 2, '쓰레기', FALSE);
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (9, 2, '광석', FALSE);


-- 3. 마시모 (Massimo)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (3, '마시모 (Massimo)', '요리 멘토', '/images/npc/NPC_icon_마시모.png', '카페', 'Lv.6 + 취미 티켓');

-- Roles (Massimo)
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (7, 3, 'GUIDE', '요리', '요리된 음식, 희귀 식재료');
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (8, 3, 'SHOP', '레스토랑 상점', NULL);

-- Shop Items (Massimo)
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (10, 8, '식재료');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (11, 8, '레시피');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (12, 8, '주방용품 도면');

-- Gifts (Massimo)
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (10, 3, '요리된 음식', TRUE);
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (11, 3, '희귀 식재료', TRUE);


-- 4. 조안 여사 (Mrs. Joanne)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (4, '조안 여사 (Mrs. Joanne)', '펫 멘토', '/images/npc/NPC_icon_조안_여사.png', '펫 하우스', 'Lv.12 + 취미 티켓');

-- Roles (Joanne)
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (9, 4, 'GUIDE', '펫 케어', '해산물 부케');
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (10, 4, 'SHOP', '펫 샵', NULL);

-- Shop Items (Joanne)
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (13, 10, '펫');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (14, 10, '펫 먹이');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (15, 10, '펫 의상');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (16, 10, '펫 용품');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (17, 10, '자동 급식기');

-- Gifts (Joanne)
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (12, 4, '해산물 부케', TRUE);
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (13, 4, '쓰레기', FALSE);


-- 5. 베일리 (Bailey)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (5, '베일리 (Bailey)', '새 관찰 멘토', '/images/npc/NPC_icon_베일리.png', '펫 하우스 2층', 'Lv.6 + 취미 티켓');

-- Roles (Bailey)
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (11, 5, 'GUIDE', '새 관찰', '고품질 새 사진');
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (12, 5, 'EVENT', '새들의 복귀 사건', '이벤트 무작위 발생');

-- Gifts (Bailey)
INSERT IGNORE INTO villager_gifts (id, villager_id, item_name, is_loved) VALUES (14, 5, '고품질 새 사진', TRUE);


-- 6. 나니와 (Naniwa)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (6, '나니와 (Naniwa)', '곤충 채집 멘토', '/images/npc/NPC_icon_나니와.png', '가든 스트리트', 'Lv.6 + 취미 티켓');

-- Roles (Naniwa)
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (13, 6, 'GUIDE', '곤충 채집', NULL);
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (14, 6, 'SHOP', '곤충 상점', NULL);
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (15, 6, 'EVENT', '곤충 떼 사건', '이벤트 무작위 발생');

-- Shop Items (Naniwa)
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (18, 14, '채집통');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (19, 14, '포충망');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (20, 14, '특수 아이템');


-- 7. 앤드류 (Andrew)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (7, '앤드류 (Andrew)', '탈것 상인', '/images/npc/NPC_icon_앤드류.png', '카 센터', NULL);

-- Roles (Andrew)
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (16, 7, 'SHOP', '탈것 상점', NULL);

-- Shop Items (Andrew)
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (21, 16, '자전거');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (22, 16, '오토바이');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (23, 16, '승용차');


-- 8. 알버트 2세 (Albert II)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (8, '알버트 2세 (Albert II)', '골드 상인', '/images/npc/NPC_icon_알버트_2세.png', '교외에서 순회', NULL);

-- Roles (Albert II)
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (17, 8, 'SHOP', '판매 가능', '아이템 판매 상점');

-- Shop Items
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (24, 17, '골드 거래');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (25, 17, '희귀 아이템');


-- 9. 밥 아저씨 (Uncle Bob)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (9, '밥 아저씨 (Uncle Bob)', '인테리어 상인', '/images/npc/NPC_icon_밥_아저씨.png', '가구점', NULL);

-- Roles
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (18, 9, 'SHOP', '인테리어 샵', '판매 물품 변경 : 토요일 6시');

-- Shop Items
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (26, 18, '가구');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (27, 18, '카페트');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (28, 18, '벽지');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (29, 18, '건축 자재');


-- 10. 도로시 (Dorothy)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (10, '도로시 (Dorothy)', '의상 디자이너', '/images/npc/NPC_icon_도로시.png', '옷 가게', NULL);

-- Roles
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (19, 10, 'SHOP', '부띠끄', '판매 물품 변경 : 매일 6시');

-- Shop Items
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (30, 19, '의류');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (31, 19, '장신구');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (32, 19, '메이크업');


-- 11. 애니 (Annie)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (11, '애니 (Annie)', '프렌즈 상점 주인', '/images/npc/NPC_icon_애니.png', '마을 중앙', NULL);

-- Roles
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (20, 11, 'SHOP', '프렌즈 & 뮤직', NULL);

-- Shop Items
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (33, 20, '이모티콘');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (34, 20, '악기');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (35, 20, '녹음기');


-- 12. 카칭 (Kaching)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (12, '카칭 (Kaching)', '잡화 상인', '/images/npc/NPC_icon_카칭.png', '거주 거리 바깥', '도시 방문');

-- Roles
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (21, 12, 'SHOP', '잡화점', NULL);

-- Shop Items
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (36, 21, '다양한 잡화');


-- 13. 아타라 (Atara)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (13, '아타라 (Atara)', '퀘스트 매니저', '/images/npc/NPC_icon_아타라.png', '광장 게시판', NULL);

-- Roles
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (22, 13, 'QUEST', '주간 퀘스트', NULL);


-- 14. 애쥬어 (Azure)
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (14, '애쥬어 (Azure)', '트렌드 상인', '/images/npc/NPC_icon_애쥬어.png', '광장', NULL);

-- Roles
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (23, 14, 'SHOP', '트렌드 상점', NULL);
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (24, 14, 'EVENT', '트렌드 이벤트', '시즌별 이벤트 진행');

-- Shop Items
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (37, 23, '눈조각');
INSERT IGNORE INTO role_items (id, role_id, item_name) VALUES (38, 23, '계절 아이템');


-- 15-21 Remaining Villagers
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (15, '에릭 (Eric)', '주민', '/images/npc/NPC_icon_에릭.png', '마을', NULL);
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (16, '수집가 (Collector)', '수집가', '/images/npc/NPC_icon_수집가.png', '커피마당', NULL);
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (17, '패티 (Patty)', '주민', '/images/npc/NPC_icon_패티.png', '순록탑', NULL);
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (18, '버니 (Bunny)', '주민', '/images/npc/NPC_icon_버니.png', '풍차 꽃밭', NULL);
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (19, '윌 (Will)', '주민', '/images/npc/NPC_icon_윌.png', '마을', NULL);
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (20, '장난꾸러기 (Prankster)', '주민', '/images/npc/NPC_icon_장난꾸러기.png', '마을 골목', NULL);
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (21, '해리 (Harry)', '주민', '/images/npc/NPC_icon_해리.png', '마을', NULL);

-- 22. 빌 (Bill) - New
INSERT IGNORE INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES (22, '빌 (Bill)', '이벤트 NPC', '/images/npc/NPC_icon_빌.png', '부두', NULL);

-- Roles (Bill)
INSERT IGNORE INTO villager_roles (id, villager_id, role_type, title, description) VALUES (25, 22, 'EVENT', '바다 낚시 사건', '이벤트 진행');

