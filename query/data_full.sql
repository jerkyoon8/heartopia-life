-- Heartopia Wiki - Master Integrated Data Script
-- Version: 1.0 (2026-03-18)
-- Purpose: Complete data synchronization with correct image URLs and validated attributes.

USE heartopia_db;

-- [Phase 0] Global Settings & Truncation
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE location_zones;
TRUNCATE TABLE gift_code;
TRUNCATE TABLE role_items;
TRUNCATE TABLE villager_gifts;
TRUNCATE TABLE villager_roles;
TRUNCATE TABLE map_pins;
TRUNCATE TABLE villagers;
TRUNCATE TABLE wiki_reports;
TRUNCATE TABLE cooking_ingredients;
TRUNCATE TABLE cooking_collections;
TRUNCATE TABLE forageable_collections;
TRUNCATE TABLE crop_collections;
TRUNCATE TABLE flower_collections;
TRUNCATE TABLE animal_collections;
TRUNCATE TABLE bug_collections;
TRUNCATE TABLE bird_collections;
TRUNCATE TABLE fish_collections;

SET FOREIGN_KEY_CHECKS = 1;

-- [Phase 1] Basic Infrastructure Data
-- 1-1. Location Zones
INSERT INTO location_zones (zone_key, display_name, color, parent_zone_key) VALUES
('강', '강 전체', '#60a5fa', NULL), ('거목강', '거목 강', '#3b82f6', '강'), ('고요한강', '고요한 강', '#3b82f6', '강'), ('노을강', '노을 강', '#3b82f6', '강'), ('얕은강', '얕은 강', '#3b82f6', '강'),
('바다', '바다 전체', '#0ea5e9', NULL), ('고래바다', '고래바다', '#0284c7', '바다'), ('구해', '구해', '#0284c7', '바다'), ('동해', '동해', '#0284c7', '바다'), ('잔잔한바다', '잔잔한 바다', '#0284c7', '바다'),
('호수', '호수 전체', '#38bdf8', NULL), ('근교호수', '근교 호수', '#0ea5e9', '호수'), ('숲속호수', '숲속 호수', '#0ea5e9', '호수'), ('온천산호수', '온천산 호수', '#0ea5e9', '호수'), ('초원호수', '초원 호수', '#0ea5e9', '호수'), ('근교도시호수', '도시 근교 호수', '#0ea5e9', '호수'),
('숲', '숲 전체', '#4ade80', NULL), ('영혼참나무', '영혼의 참나무 숲', '#16a34a', '숲'), ('순록탑', '순록탑', '#16a34a', '숲'), ('숲속섬', '숲속 섬', '#16a34a', '숲'), ('점핑플랫폼', '점핑 플랫폼', '#16a34a', '숲'), ('숲호숫가', '숲 호숫가', '#16a34a', '숲'),
('꽃밭', '꽃밭 전체', '#f472b6', NULL), ('고래산꽃밭', '고래산 꽃밭', '#ec4899', '꽃밭'), ('보라빛해변', '보라빛 해변', '#ec4899', '꽃밭'), ('풍차꽃밭', '풍차꽃밭', '#ec4899', '꽃밭'),
('어촌', '어촌 전체', '#fb923c', NULL), ('어촌부두', '부두', '#ea580c', '어촌'), ('동쪽부두', '동쪽 부두', '#ea580c', '어촌'), ('어촌등대', '등대', '#ea580c', '어촌'), ('어촌광장', '어촌 광장', '#ea580c', '어촌'),
('온천산', '온천산 전체', '#fb7185', NULL), ('온천', '온천', '#f43f5e', '온천산'), ('바위절벽', '바위절벽', '#f43f5e', '온천산'), ('온천산유적', '유적', '#f43f5e', '온천산'), ('화산호수', '화산 호수', '#f43f5e', '온천산'), ('온천산호숫가', '온천산 호숫가', '#f43f5e', '온천산'),
('도시', '도시 전체', '#a78bfa', NULL), ('도시근교', '도시 근교', '#7c3aed', '도시'), ('도심', '도심', '#7c3aed', '도시'),
('해변', '해변', '#fbbf24', NULL), ('물가', '물가', '#34d399', NULL), ('강변', '강변', '#60a5fa', '강');

-- 1-2. Gift Codes
INSERT INTO gift_code (code_name, rewards, status, expiration_date) VALUES 
('r4p8n6m2q9', '10x 소원별, 3x 인어 집어기, 10x 비료', 'ACTIVE', '2026-03-31'), ('heartopia10m', '10x 소원별', 'ACTIVE', '2026-03-31'),
('lifewithline', '10x 소원별', 'ACTIVE', '2026-03-31'), ('happy2026', '10x 달빛 크리스탈, 8888 골드', 'ACTIVE', '2026-03-31'),
('k7m9q2a8l5', '5x 소원별, 3x 인어 집어기, 10x 비료', 'ACTIVE', '2026-03-31'), ('heartopia5m', '10x 소원별', 'ACTIVE', '2026-03-31'),
('top1thanks', '5x 소원별, 2x 인어향수, 10x 오렌지', 'ACTIVE', '2026-03-31'), ('r4a8x2n', '5x 소원별, 10x 성장 촉진제, 10x 오렌지', 'ACTIVE', '2026-03-31'),
('true5mthks', '10x 고급목재, 2x 셰프 특선 샐러드, 20x 관목가지', 'ACTIVE', '2026-03-31'), ('letsparty', '15x 소원별, 5000 골드, 3x 수리도구', 'ACTIVE', '2026-03-31'),
('b8n2k5l', '2x 완벽한 형광석, 6x 희귀목재, 10x 돌', 'ACTIVE', '2026-03-31'), ('dcthx4u', '10x 소원별', 'ACTIVE', '2026-06-30'),
('m7r9q4a', '2x 인어향수, 10000 골드, 10x 달걀', 'ACTIVE', '2026-03-31'), ('x2l8k6p', '5x 소원별, 10x 비료, 10x 사과', 'ACTIVE', '2026-03-31'),
('h9q3a7m5', '2x 그 자리 참나무, 10x 우유, 10x 목재', 'ACTIVE', '2026-03-31'), ('letsbuild', '15x 소원별, 5000 골드, 10x 비료', 'ACTIVE', '2026-03-31'),
('letsdressup', '15x 소원별, 5000 골드, 10x 성장 촉진제', 'ACTIVE', '2026-03-31'), ('a7k9m2q8l', '5x 소원별, 3x 수리도구, 10x 블루베리', 'ACTIVE', '2026-03-31'),
('z4p6n8r2', '10x 고급목재, 2x 셰프 특선 샐러드, 20x 관목가지', 'ACTIVE', '2026-03-31');

-- [Phase 2] Biological & Collection Data
-- 2-1. Fish Collections
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size, image_url) VALUES 
('강', '전체', '민물배스', 1, NULL, NULL, 75, 112, 150, 300, 600, NULL, '/images/collections/fish/민물배스.png'),
('강', '전체', '왕새우', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL, '/images/collections/fish/왕새우.png'),
('강', '전체', '틸라피아', 1, NULL, NULL, 320, 480, 640, 1280, 2560, NULL, '/images/collections/fish/틸라피아.png'),
('강', '얕은 강', '바벨', 1, NULL, NULL, 75, 112, 150, 300, 600, NULL, '/images/collections/fish/바벨.png'),
('강', '얕은 강', '큰가시고기', 7, '비/무지개', NULL, 150, 225, 300, 600, 1200, NULL, '/images/collections/fish/큰가시고기.png'),
('강', '고요한 강', '미노우', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL, '/images/collections/fish/미노우.png'),
('강', '고요한 강', '민물대구', 4, NULL, '12~24', 230, 345, 460, 920, 1840, NULL, '/images/collections/fish/민물대구.png'),
('강', '고요한 강', '첨연어', 6, '무지개', NULL, 150, 225, 300, 600, 1200, NULL, '/images/collections/fish/첨연어.png'),
('강', '거목 강', '하늘종개', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL, '/images/collections/fish/하늘종개.png'),
('강', '거목 강', '민물잰더', 3, '해/무지개', NULL, 230, 345, 460, 920, 1840, NULL, '/images/collections/fish/민물잰더.png'),
('강', '거목 강', '레드벨리피라냐', 4, NULL, NULL, 230, 345, 460, 920, 1840, NULL, '/images/collections/fish/레드벨리피라냐.png'),
('강', '거목 강', '후첸', 9, '무지개', '0~6 / 12~24', 380, 570, 760, 1520, 3040, NULL, '/images/collections/fish/후첸.png'),
('강', '노을 강', '큰얼룩배스', 1, NULL, NULL, 50, 0, 0, 0, 0, NULL, '/images/collections/fish/큰얼룩배스.png'),
('강', '노을 강', '유럽잉어', 4, '해/무지개', '12~24', 230, 345, 460, 920, 1840, NULL, '/images/collections/fish/유럽잉어.png'),
('호수', '전체', '유럽처브', 1, NULL, NULL, 75, 0, 0, 0, 0, NULL, '/images/collections/fish/유럽처브.png'),
('호수', '전체', '유럽백조어', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL, '/images/collections/fish/유럽백조어.png'),
('호수', '전체', '유럽참개구리', 1, NULL, NULL, 320, 480, 640, 1280, 2560, NULL, '/images/collections/fish/유럽참개구리.png'),
('호수', '숲속 호수', '텐치', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL, '/images/collections/fish/텐치.png'),
('호수', '숲속 호수', '머드개복치', 2, NULL, '6~24', 100, 150, 200, 400, 800, NULL, '/images/collections/fish/머드개복치.png'),
('호수', '숲속 호수', '유럽민물가재', 3, NULL, '0~12 / 18~24', 100, 150, 200, 400, 800, NULL, '/images/collections/fish/유럽민물가재.png'),
('호수', '숲속 호수', '큰입배스', 4, '해/무지개', NULL, 230, 345, 460, 920, 1840, NULL, '/images/collections/fish/큰입배스.png'),
('호수', '숲속 호수', '큰진주조개', 6, '무지개', NULL, 380, 570, 760, 1520, 3040, NULL, '/images/collections/fish/큰진주조개.png'),
('호수', '숲속 호수', '북유럽파란가재', 8, NULL, '0~6  / 18~24', 250, 375, 500, 1000, 2000, NULL, '/images/collections/fish/북유럽파란가재.png'),
('호수', '숲속 호수', '북극곤들매기', 10, '비/무지개', '12~24', 610, 915, 1220, 2440, 4880, NULL, '/images/collections/fish/북극곤들매기.png'),
('호수', '근교 호수', '붕어', 1, NULL, NULL, 75, 112, 150, 300, 600, NULL, '/images/collections/fish/붕어.png'),
('호수', '근교 호수', '백조어', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL, '/images/collections/fish/백조어.png'),
('호수', '근교 호수', '돌마자', 2, NULL, NULL, 100, 150, 200, 400, 800, NULL, '/images/collections/fish/돌마자.png'),
('호수', '근교 호수', '홍합', 3, '비/무지개', NULL, 100, 150, 200, 400, 800, NULL, '/images/collections/fish/홍합.png'),
('호수', '근교 호수', '민물게', 4, NULL, NULL, 100, 150, 200, 400, 800, NULL, '/images/collections/fish/민물게.png'),
('호수', '근교 호수', '루드', 5, NULL, NULL, 150, 225, 300, 600, 1200, NULL, '/images/collections/fish/루드.png'),
('호수', '근교 호수', '사루기', 6, NULL, NULL, 230, 345, 460, 920, 1840, NULL, '/images/collections/fish/사루기.png'),
('호수', '근교 호수', '줄무늬송사리', 7, '해/무지개', '0~6 / 12~24', 150, 225, 300, 600, 1200, NULL, '/images/collections/fish/줄무늬송사리.png'),
('호수', '근교 호수', '강꼬치고기', 9, '비/무지개', '0~6  / 18~24', 610, 915, 1220, 2440, 4880, NULL, '/images/collections/fish/강꼬치고기.png'),
('바다', '전체', '정어리', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL, '/images/collections/fish/정어리.png'),
('바다', '전체', '배스', 1, NULL, NULL, 75, 112, 150, 300, 600, NULL, '/images/collections/fish/배스.png'),
('바다', '잔잔한 바다', '노란전갱이', 3, NULL, NULL, 155, 232, 310, 620, 1240, NULL, '/images/collections/fish/노란전갱이.png'),
('바다', '잔잔한 바다', '참다랑어', 9, '무지개', '6~18', 850, 1275, 1700, 3400, 6800, NULL, '/images/collections/fish/참다랑어.png'),
('바다', '동해', '바다새우', 1, NULL, NULL, 50, 0, 0, 0, 0, NULL, '/images/collections/fish/바다새우.png'),
('바다', '고래바다', '황새치', 10, '무지개', '6~18', 850, 1275, 1700, 3400, 6800, NULL, '/images/collections/fish/황새치.png'),
('바다', '구해', '귀상어', 10, '무지개', '0~6 / 18~24', 850, 1275, 1700, 3400, 6800, NULL, '/images/collections/fish/귀상어.png'),
('바다', '바다낚시 사건', '황금킹크랩', 8, '무지개', NULL, 850, 1275, 1700, 3400, 6800, NULL, '/images/collections/fish/황금킹크랩.png');

-- 2-2. Bird Collections
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, image_url) VALUES 
('물가', NULL, '큰홍학', 1, NULL, NULL, 10, 40, 80, 160, 320, '/images/collections/bird/큰홍학.png'),
('호수', NULL, '청둥오리', 1, NULL, NULL, 10, 40, 80, 160, 320, '/images/collections/bird/청둥오리.png'),
('강', NULL, '홍머리오리', 2, NULL, NULL, 17, 68, 136, 272, 544, '/images/collections/bird/홍머리오리.png'),
('강', NULL, '호사북방오리', 3, NULL, NULL, 17, 68, 136, 272, 544, '/images/collections/bird/호사북방오리.png'),
('해변', NULL, '바다갈매기', 2, NULL, NULL, 17, 68, 136, 272, 544, '/images/collections/bird/바다갈매기.png'),
('바다', NULL, '유럽가마우지', 3, NULL, NULL, 17, 68, 136, 272, 544, '/images/collections/bird/유럽가마우지.png'),
('새들의 복귀 사건', NULL, '청금강앵무', 1, NULL, NULL, 10, 40, 80, 160, 320, '/images/collections/bird/청금강앵무.png'),
('새들의 복귀 사건', NULL, '청공작', 1, NULL, NULL, 10, 40, 80, 160, 320, '/images/collections/bird/청공작.png'),
('어촌', '등대', '아조레스멋쟁이새', 10, '무지개', NULL, 47, 190, 380, 760, 1520, '/images/collections/bird/아조레스멋쟁이새.png'),
('꽃밭', '보라빛해변', '아메리카홍학', 9, '무지개', NULL, 47, 190, 380, 760, 1520, '/images/collections/bird/아메리카홍학.png'),
('온천산', '온천', '매', 8, '비/무지개', NULL, 65, 260, 520, 1040, 2080, '/images/collections/bird/매.png');

-- 2-3. Bug Collections
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5, image_url) VALUES 
('예외', '유인기 필요', '슬코스키몰포나비', 1, '-', '-', 5, 300, 1200, 2400, 4800, 9600, '/images/collections/bug/슬코스키몰포나비.png'),
('물가', '-', '큰고추잠자리', 1, '-', '-', 5, 63, 252, 504, 1008, 2016, '/images/collections/bug/큰고추잠자리.png'),
('강변', '-', '밀잠자리', 4, '비/무지개', '-', 5, 93, 372, 744, 1488, 2976, '/images/collections/bug/밀잠자리.png'),
('이벤트', '유인사건', '아폴로모시나비', 1, '-', '-', 5, 265, 1060, 2120, 4240, 8480, '/images/collections/bug/아폴로모시나비.png'),
('홈', '-', '별노린재', 1, '-', '-', 5, 55, 220, 440, 880, 1760, '/images/collections/bug/별노린재.png'),
('숲', '전체', '호랑나비', 1, '-', '-', 5, 40, 160, 320, 640, 1280, '/images/collections/bug/호랑나비.png'),
('도시', '도심', '유럽갈고리나비', 1, '-', '-', 5, 40, 160, 320, 640, 1280, '/images/collections/bug/유럽갈고리나비.png'),
('어촌', '전체', '배추흰나비', 1, '-', '-', 5, 40, 160, 320, 640, 1280, '/images/collections/bug/배추흰나비.png'),
('꽃밭', '전체', '아스파라거스벌레', 1, '-', '-', 5, 55, 220, 440, 880, 1760, '/images/collections/bug/아스파라거스벌레.png'),
('숲', '순록탑', '헤쿠바몰포나비', 10, '무지개', '6~18', 5, 300, 1200, 2400, 4800, 9600, '/images/collections/bug/헤쿠바몰포나비.png'),
('숲', '영혼참나무', '메넬라우스나비', 7, '해/무지개', '6~24', 5, 415, 1660, 3320, 6640, 13280, '/images/collections/bug/메넬라우스나비.png'),
('꽃밭', '보라해변', '헬레나몰포나비', 10, '무지개', '6~18', 5, 300, 1200, 2400, 4800, 9600, '/images/collections/bug/헬레나몰포나비.png');

-- 2-4. Animal Collections
INSERT INTO animal_collections (name, location, favorite_food, favorite_weather, image_url) VALUES 
('판다', '세갈래길 근처', '대나무, 사과, 옥수수', '비', '/images/collections/animals/wild_animal_판다.png'),
('카피바라', '유적 오른쪽', '토마토, 포도, 라즈베리', '비', '/images/collections/animals/wild_animal_카피바라.png'),
('토끼', '2번 ~ 3번 홈 주변 버스 오른쪽 길', '잡초, 딸기, 당근', '맑음', '/images/collections/animals/wild_animal_토끼.png'),
('여우', '9시 방향 초원 호수 아래 꽃밭 가는 길', '고기, 민물배스, 큰입배스', '무지개', '/images/collections/animals/wild_animal_여우.png'),
('해달', '6시 방향 잔잔한 바다, 바위 위', '홍합, 바다새우, 왕새우', '비', '/images/collections/animals/wild_animal_해달.png'),
('담비', '4번 홈 위쪽', '계란, 망둥어, 배스', '무지개', '/images/collections/animals/wild_animal_담비.png'),
('꽃사슴', '3시 방향 숲 버스 위쪽', '상추, 관목가지, 베지샐러드', '맑음', '/images/collections/animals/wild_animal_꽃사슴.png'),
('알파카', '보라빛 해변에서 등대로 가는 다리 주변', '블루베리, 파인애플, 밀', '맑음', '/images/collections/animals/wild_animal_알파카.png');

-- 2-5. Cooking Collections
INSERT INTO cooking_collections (name, description, difficulty, energy_gain, sell_price, image_url) VALUES 
('베지 샐러드', '신선한 채소로 만든 기본 샐러드', 1, 20, 150, '/images/collections/cook/베지 샐러드.png'),
('토마토 수프', '따뜻하고 부드러운 토마토 수프', 1, 25, 180, '/images/collections/cook/토마토 수프.png'),
('미트소스 파스타', '고소한 고기 소스가 듬뿍 들어간 파스타', 2, 45, 350, '/images/collections/cook/미트소스 파스타.png'),
('생선 구이', '노릇노릇하게 구운 신선한 생선', 1, 30, 220, '/images/collections/cook/생선 구이.png'),
('버섯 리조또', '향긋한 버섯과 부드러운 크림의 조화', 3, 55, 420, '/images/collections/cook/버섯 리조또.png'),
('과일 타르트', '달콤한 과일이 올라간 바삭한 타르트', 3, 40, 380, '/images/collections/cook/과일 타르트.png');

-- 2-5-1. Cooking Ingredients
-- 베지 샐러드 (ID: 1)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) VALUES (1, '상추', 2), (1, '토마토', 1);
-- 토마토 수프 (ID: 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) VALUES (2, '토마토', 3), (2, '우유', 1);
-- 미트소스 파스타 (ID: 3)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) VALUES (3, '밀', 2), (3, '고기', 1), (3, '토마토', 1);
-- 생선 구이 (ID: 4)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) VALUES (4, '민물배스', 1), (4, '소금', 1);
-- 버섯 리조또 (ID: 5)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) VALUES (5, '쌀', 1), (5, '표고버섯', 2), (5, '우유', 1);
-- 과일 타르트 (ID: 6)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) VALUES (6, '밀', 1), (6, '딸기', 2), (6, '블루베리', 1);

-- 2-6. Crop Collections
INSERT INTO crop_collections (name, level, growth_time, seed_buy_price, seed_sell_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES 
('토마토', 1, '15 min', 10, 5, 30, 40, 50, 60, 70, '/images/items/crops/토마토.png'),
('감자', 1, '60 min', 30, 15, 90, 120, 150, 180, 220, '/images/items/crops/감자.png'),
('밀', 2, '4 hours', 95, 47, 285, 381, 475, 570, 855, '/images/items/crops/밀.png'),
('상추', 3, '8 hours', 145, 72, 435, 582, 726, 870, 1305, '/images/items/crops/상추.png'),
('당근', 5, '2 hours', 50, 25, 155, 207, 258, 310, 460, '/images/items/crops/당근.png'),
('딸기', 6, '6 hours', 125, 0, 375, 502, 626, 750, 1125, '/images/items/crops/딸기.png'),
('옥수수', 6, '12 hours', 170, 0, 515, 690, 860, 1030, 1545, '/images/items/crops/옥수수.png');

-- 2-7. Flower Collections
INSERT INTO flower_collections (name, level, growth_time, seed_buy_price, seed_sell_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES 
('데이지', 3, '18 hours', 30, 15, 100, 150, 200, 250, 400, '/images/items/flowers/데이지.png'),
('팬지', 4, '18 hours', 30, 15, 100, 150, 200, 250, 400, '/images/items/flowers/팬지.png'),
('꽃양귀비', 5, '1 day', 60, 30, 185, 280, 370, 460, 740, '/images/items/flowers/꽃양귀비.png'),
('안스리움', '5 day', '1 day', 60, 30, 185, 280, 370, 460, 740, '/images/items/flowers/안스리움.png'),
('장미', 10, '3 days', 300, 0, 850, 1275, 1700, 3400, 6800, '/images/items/flowers/장미.png');

-- 2-8. Forageable Collections
INSERT INTO forageable_collections (name, location, price, energy, image_url) VALUES
('송이버섯', '숲', 0, '+5', NULL),
('관목 가지', '홈', 5, NULL, '/images/collections/forage/관목 가지.png'),
('목재', '홈', 6, NULL, '/images/collections/forage/목재.png'),
('대나무', '홈', 7, NULL, '/images/collections/forage/대나무.png'),
('돌', '홈', 8, NULL, '/images/collections/forage/돌.png'),
('고급 목재', '홈', 12, NULL, '/images/collections/forage/고급 목재.png'),
('광석', '홈', 14, NULL, '/images/collections/forage/광석.png'),
('블루베리', '홈', 16, '+5', '/images/collections/forage/블루베리.png'),
('표고버섯', '어촌', 16, '+5', '/images/collections/forage/표고버섯.png'),
('이상한 표고버섯 (검정)', '어촌', 16, NULL, '/images/collections/forage/이상한 표고버섯(회색).png'),
('이상한 표고버섯 (빨강)', '어촌', 16, NULL, '/images/collections/forage/이상한 표고버섯(빨강).png'),
('이상한 표고버섯 (파랑)', '어촌', 16, NULL, '/images/collections/forage/이상한 표고버섯(하늘).png'),
('양송이버섯', '꽃밭', 16, '+5', '/images/collections/forage/양송이버섯.png'),
('이상한 양송이버섯 (파랑)', '꽃밭', 16, NULL, '/images/collections/forage/이상한 양송이 버섯(파랑).png'),
('이상한 양송이버섯 (핑크)', '꽃밭', 16, NULL, '/images/collections/forage/이상한 양송이 버섯(핑크).png'),
('이상한 양송이버섯 (초록)', '꽃밭', 16, NULL, '/images/collections/forage/이상한 양송이 버섯(초록).png'),
('그물버섯', '숲', 16, '+5', '/images/collections/forage/그물버섯.png'),
('이상한 그물버섯 (보라)', '숲', 16, NULL, '/images/collections/forage/이상한 그물버섯(파랑).png'),
('이상한 그물버섯 (빨강)', '숲', 16, NULL, '/images/collections/forage/이상한 그물버섯(빨강).png'),
('이상한 그물버섯 (핑크)', '숲', 16, NULL, '/images/collections/forage/이상한 그물버섯(핑크).png'),
('느타리버섯', '온천산', 16, '+5', '/images/collections/forage/느타리버섯.png'),
('이상한 느타리버섯 (핑크)', '온천산', 16, NULL, '/images/collections/forage/이상한 느타리버섯(핑크).png'),
('이상한 느타리버섯 (보라)', '온천산', 16, NULL, '/images/collections/forage/이상한 느타리버섯(파랑).png'),
('이상한 느타리버섯 (주황)', '온천산', 16, NULL, '/images/collections/forage/이상한 느타리버섯(주황).png'),
('라즈베리', '홈', 26, '+7', '/images/collections/forage/라즈베리.png'),
('사과', '홈', 28, '+8', '/images/collections/forage/사과.png'),
('귤 (오렌지)', '홈', 28, '+8', '/images/collections/forage/오렌지.png'),
('희귀 목재', '도시 근교', 50, NULL, '/images/collections/forage/희귀 목재.png'),
('검은 트러플', '숲', 99, '+25', '/images/collections/forage/검은 트러플.png'),
('방랑하는 오크 목재', '방랑하는 오크오크', 150, NULL, NULL),
('완벽한 형석', '형석 광산', 150, NULL, NULL),
('별똥별 조각', '운석우', 150, NULL, NULL);

-- [Phase 3] Social & System Data
-- 3-1. Villagers
INSERT INTO villagers (id, name, sub_title, image_url, location, unlock_condition) VALUES 
(1, '블랑코 (Blanc)', '원예 멘토 & 상점 주인', '/images/npc/NPC_icon_블랑코.png', '원예 상점', '튜토리얼 진행'),
(2, '바냐 (Vanya)', '낚시 멘토', '/images/npc/NPC_icon_바냐.png', '가든 스트리트', '튜토리얼 진행'),
(3, '마시모 (Massimo)', '요리 멘토', '/images/npc/NPC_icon_마시모.png', '카페', 'Lv.6 + 취미 티켓'),
(4, '조안 여사 (Mrs. Joanne)', '펫 멘토', '/images/npc/NPC_icon_조안_여사.png', '펫 하우스', 'Lv.12 + 취미 티켓'),
(5, '베일리 (Bailey)', '새 관찰 멘토', '/images/npc/NPC_icon_베일리.png', '펫 하우스 2층', 'Lv.6 + 취미 티켓'),
(6, '나니와 (Naniwa)', '곤충 채집 멘토', '/images/npc/NPC_icon_나니와.png', '가든 스트리트', 'Lv.6 + 취미 티켓'),
(7, '앤드류 (Andrew)', '탈것 상인', '/images/npc/NPC_icon_앤드류.png', '카 센터', NULL),
(8, '알버트 2세 (Albert II)', '골드 상인', '/images/npc/NPC_icon_알버트_2세.png', '교외에서 순회', NULL),
(9, '밥 아저씨 (Uncle Bob)', '인테리어 상인', '/images/npc/NPC_icon_밥_아저씨.png', '가구점', NULL),
(10, '도로시 (Dorothy)', '의상 디자이너', '/images/npc/NPC_icon_도로시.png', '옷 가게', NULL),
(11, '애니 (Annie)', '프렌즈 상점 주인', '/images/npc/NPC_icon_애니.png', '마을 중앙', NULL),
(12, '카칭 (Kaching)', '잡화 상인', '/images/npc/NPC_icon_카칭.png', '거주 거리 바깥', '도시 방문'),
(13, '아타라 (Atara)', '퀘스트 매니저', '/images/npc/NPC_icon_아타라.png', '광장 게시판', NULL),
(14, '애쥬어 (Azure)', '트랜드 상인', '/images/npc/NPC_icon_애쥬어.png', '광장', NULL),
(15, '에릭 (Eric)', '주민', '/images/npc/NPC_icon_에릭.png', '마을', NULL),
(16, '수집가 (Collector)', '수집가', '/images/npc/NPC_icon_수집가.png', '커피마당', NULL),
(17, '패티 (Patty)', '주민', '/images/npc/NPC_icon_패티.png', '순록탑', NULL),
(18, '버니 (Bunny)', '주민', '/images/npc/NPC_icon_버니.png', '풍차 꽃밭', NULL),
(19, '윌 (Will)', '주민', '/images/npc/NPC_icon_윌.png', '마을', NULL),
(20, '장난꾸러기 (Prankster)', '주민', '/images/npc/NPC_icon_장난꾸러기.png', '마을 골목', NULL),
(21, '해리 (Harry)', '주민', '/images/npc/NPC_icon_해리.png', '마을', NULL),
(22, '빌 (Bill)', '이벤트 NPC', '/images/npc/NPC_icon_빌.png', '부두', NULL);

-- 3-2. Villager Roles
INSERT INTO villager_roles (id, villager_id, role_type, title, description) VALUES 
(1, 1, 'GUIDE', '원예', '희귀 꽃, 씨앗, 작물, 곤충'), (2, 1, 'SHOP', '원예 상점', NULL),
(3, 2, 'GUIDE', '낚시', '모든 물고기, 해산물, 낚시 용품'), (4, 2, 'SHOP', '낚시 상점', NULL),
(5, 2, 'EVENT', '얼음 낚시', '이벤트 진행 가능'), (7, 3, 'GUIDE', '요리', '요리된 음식, 희귀 식재료'),
(8, 3, 'SHOP', '레스토랑 상점', NULL), (9, 4, 'GUIDE', '펫 케어', '해산물 부케'),
(10, 4, 'SHOP', '펫 샵', NULL), (11, 5, 'GUIDE', '새 관찰', '고품질 새 사진'),
(12, 5, 'EVENT', '새들의 복귀 사건', '이벤트 무작위 발생'), (13, 6, 'GUIDE', '곤충 채집', NULL),
(14, 6, 'SHOP', '곤충 상점', NULL), (15, 6, 'EVENT', '곤충 떼 사건', '이벤트 무작위 발생'),
(16, 7, 'SHOP', '탈것 상점', NULL), (17, 8, 'SHOP', '판매 가능', '아이템 판매 상점'),
(18, 9, 'SHOP', '인테리어 샵', '판매 물품 변경 : 토요일 6시'), (19, 10, 'SHOP', '부띠끄', '판매 물품 변경 : 매일 6시'),
(20, 11, 'SHOP', '프렌즈 & 뮤직', NULL), (21, 12, 'SHOP', '잡화점', NULL),
(22, 13, 'QUEST', '주간 퀘스트', NULL), (23, 14, 'SHOP', '트렌드 상점', NULL),
(24, 14, 'EVENT', '트렌드 이벤트', '시즌별 이벤트 진행'), (25, 22, 'EVENT', '바바 낚시 사건', '이벤트 진행');

-- 3-3. Role Items
INSERT INTO role_items (role_id, item_name) VALUES 
(2, '꽃 씨앗'), (2, '작물 씨앗'), (2, '재배 상자'), (2, '비료'), (2, '성장 촉진제'),
(4, '낚시대'), (4, '미끼'), (4, '어항'), (4, '특수 아이템'),
(8, '식재료'), (8, '레시피'), (8, '주방용품 도면'),
(10, '펫'), (10, '펫 먹이'), (10, '펫 의상'), (10, '펫 용품'), (10, '자동 급식기'),
(14, '채집통'), (14, '포충망'), (14, '특수 아이템'),
(16, '자전거'), (16, '오토바이'), (16, '승용차'),
(17, '골드 거래'), (17, '희귀 아이템'),
(18, '가구'), (18, '카페트'), (18, '벽지'), (18, '건축 자재'),
(19, '의류'), (19, '장신구'), (19, '메이크업'),
(20, '이모티콘'), (20, '악기'), (20, '녹음기'),
(21, '다양한 잡화'),
(23, '눈조각'), (23, '계절 아이템');

-- 3-4. Villager Gifts
INSERT INTO villager_gifts (villager_id, item_name, is_loved) VALUES 
(1, '희귀 꽃', TRUE), (1, '씨앗', TRUE), (1, '작물', TRUE), (1, '곤충', TRUE),
(2, '모든 물고기', TRUE), (2, '해산물', TRUE), (2, '낚시 용품', TRUE), (2, '쓰레기', FALSE), (2, '광석', FALSE),
(3, '요리된 음식', TRUE), (3, '희귀 식재료', TRUE),
(4, '해산물 부케', TRUE), (4, '쓰레기', FALSE),
(5, '고품질 새 사진', TRUE);

-- [Phase 4] Geographic Data
-- 4-1. Map Pins
INSERT INTO map_pins (category, name, icon_url, map_x, map_y, link_url, description) VALUES 
('villager', '블랑코', '/images/npc/NPC_icon_블랑코.png', 5800, 3900, '/wiki/others/villagers', '원예 멘토 & 상점 주인'),
('villager', '바냐', '/images/npc/NPC_icon_바냐.png', 6200, 3500, '/wiki/others/villagers', '낚시 멘토'),
('villager', '마시모', '/images/npc/NPC_icon_마시모.png', 5600, 3500, '/wiki/others/villagers', '요리 멘토'),
('villager', '앤드류', '/images/npc/NPC_icon_앤드류.png', 5500, 4200, '/wiki/others/villagers', '공방 & 제작 멘토'),
('villager', '에릭', '/images/npc/NPC_icon_에릭.png', 6000, 4500, '/wiki/others/villagers', '시청 직원'),
('villager', '도로시', '/images/npc/NPC_icon_도로시.png', 5000, 3800, '/wiki/others/villagers', '패션 상점'),
('villager', '카칭', '/images/npc/NPC_icon_카칭.png', 5200, 3400, '/wiki/others/villagers', '잡화점'),
('villager', '수집가', '/images/npc/NPC_icon_수집가.png', 6500, 3000, '/wiki/others/villagers', '박물관'),
('villager', '버블', '/images/npc/NPC_icon_버블.png', 4800, 4000, '/wiki/others/villagers', '미용실'),
('villager', '조안 여사', '/images/npc/NPC_icon_조안_여사.png', 4500, 2500, '/wiki/others/villagers', '펫 멘토'),
('villager', '베일리', '/images/npc/NPC_icon_베일리.png', 4500, 2600, '/wiki/others/villagers', '새 관찰 멘토'),
('villager', '나니와', '/images/npc/NPC_icon_나니와.png', 5300, 3300, '/wiki/others/villagers', '곤충 채집 멘토'),
('villager', '알버트 2세', '/images/npc/NPC_icon_알버트_2세.png', 2000, 4000, '/wiki/others/villagers', '골드 상인'),
('villager', '밥 아저씨', '/images/npc/NPC_icon_밥_아저씨.png', 4900, 3700, '/wiki/others/villagers', '인테리어 상인'),
('villager', '애니', '/images/npc/NPC_icon_애니.png', 3000, 3000, '/wiki/others/villagers', '프렌즈 상점 주인'),
('villager', '아타라', '/images/npc/NPC_icon_아타라.png', 3200, 3200, '/wiki/others/villagers', '퀘스트 매니저'),
('villager', '애쥬어', '/images/npc/NPC_icon_애쥬어.png', 3100, 3300, '/wiki/others/villagers', '트랜드 상인'),
('villager', '패티', '/images/npc/NPC_icon_패티.png', 2500, 5000, '/wiki/others/villagers', '순록탑 주변'),
('villager', '버니', '/images/npc/NPC_icon_버니.png', 4000, 5500, '/wiki/others/villagers', '풍차 꽃밭'),
('villager', '윌', '/images/npc/NPC_icon_윌.png', 3500, 2500, '/wiki/others/villagers', '마을'),
('villager', '장난꾸러기', '/images/npc/NPC_icon_장난꾸러기.png', 3600, 2600, '/wiki/others/villagers', '마을 골목'),
('villager', '해리', '/images/npc/NPC_icon_해리.png', 3700, 2700, '/wiki/others/villagers', '마을'),
('villager', '빌', '/images/npc/NPC_icon_빌.png', 6800, 2000, '/wiki/others/villagers', '부두 이벤트 NPC'),
('animal', '판다', '/images/collections/animals/wild_animal_판다.png', 3000, 3000, '/wiki/collections/animal', '좋아하는 날씨: 비'),
('animal', '카피바라', '/images/collections/animals/wild_animal_카피바라.png', 5000, 1500, '/wiki/collections/animal', '좋아하는 날씨: 비'),
('animal', '토끼', '/images/collections/animals/wild_animal_토끼.png', 1500, 5000, '/wiki/collections/animal', '좋아하는 날씨: 맑음'),
('animal', '여우', '/images/collections/animals/wild_animal_여우.png', 500, 3000, '/wiki/collections/animal', '좋아하는 날씨: 무지개'),
('animal', '해달', '/images/collections/animals/wild_animal_해달.png', 3000, 500, '/wiki/collections/animal', '좋아하는 날씨: 비'),
('animal', '담비', '/images/collections/animals/wild_animal_담비.png', 5000, 5000, '/wiki/collections/animal', '좋아하는 날씨: 무지개'),
('animal', '꽃사슴', '/images/collections/animals/wild_animal_꽃사슴.png', 5500, 3000, '/wiki/collections/animal', '좋아하는 날씨: 맑음'),
('animal', '알파카', '/images/collections/animals/wild_animal_알파카.png', 1000, 1000, '/wiki/collections/animal', '좋아하는 날씨: 맑음');

-- [Phase 5] Post-processing
COMMIT;
