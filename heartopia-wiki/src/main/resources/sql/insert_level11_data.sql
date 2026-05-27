-- =====================================================
-- 11레벨 이상 신규 수집품 데이터 삽입 스크립트 (가이드 정리 시트 기준)
-- 1. fish_collections (13종)
-- 2. bug_collections (11종)
-- 3. bird_collections (13종)
-- 4. cooking_collections (21종)
-- 5. cooking_ingredients (요리별 상세 재료 매핑)
-- 실행 전: --default-character-set=utf8mb4 설정 권장
-- =====================================================

-- =====================================================
-- 1. fish_collections 데이터 삽입
-- =====================================================
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size, image_url, event_name) VALUES
('호수', '초원 호수', '골드아로와나', 11, NULL, '00 - 12', 395, 592, 790, 1580, 3160, 'S', '/images/collections/fish/골드아로와나.png', NULL),
('호수', '온천산 호수', '사자머리 금붕어', 11, NULL, '풀타임', 395, 592, 790, 1580, 3160, 'S', '/images/collections/fish/사자머리 금붕어.png', NULL),
('바다', '바다 낚시', '고래상어', 11, NULL, '00-12 / 18-24', 850, 1275, 1700, 3400, 6800, 'Gold', '/images/collections/fish/고래상어.png', NULL),
('바다', '잔잔한 바다', '줄자돔', 11, NULL, '12 - 24', 610, 915, 1220, 2440, 4880, 'M', '/images/collections/fish/줄자돔.png', NULL),
('바다', '고래바다', '바다거북', 12, NULL, '12 - 24', 850, 1275, 1700, 3400, 6800, 'L', '/images/collections/fish/바다거북.png', NULL),
('호수', '군교 호수', '엔젤피시', 12, NULL, '00-06 / 18-24', 850, 1275, 1700, 3400, 6800, 'M', '/images/collections/fish/엔젤피시.png', NULL),
('호수', '숲속 호수', '베타', 12, NULL, '12 - 24', 395, 592, 790, 1580, 3160, 'S', '/images/collections/fish/베타.png', NULL),
('바다', '구해', '만새기', 12, NULL, '06 - 18', 850, 1275, 1700, 3400, 6800, 'L', '/images/collections/fish/만새기.png', NULL),
('바다', '바다 낚시', '해파리', 12, NULL, '00-06 / 12-24', 850, 1275, 1700, 3400, 6800, 'Gold', '/images/collections/fish/해파리.png', NULL),
('바다', '구해', '양쥐돔', 13, NULL, '00-06 / 12-24', 610, 915, 1220, 2440, 4880, 'M', '/images/collections/fish/양쥐돔.png', NULL),
('바다', '고래바다', '쏠배감펭', 13, NULL, '00 - 12', 610, 915, 1220, 2440, 4880, 'M', '/images/collections/fish/쏠배감펭.png', NULL),
('바다', '잔잔한 바다', '아주르담셀', 14, NULL, '12 - 24', 395, 592, 790, 1580, 3160, 'S', '/images/collections/fish/아주르담셀.png', NULL),
('바다', '동해', '서호주 드림 아로와나', 14, NULL, '06 - 24', 610, 915, 1220, 2440, 4880, 'M', '/images/collections/fish/서호주 드림 아로와나.png', NULL);

-- =====================================================
-- 2. bug_collections 데이터 삽입
-- =====================================================
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, image_url, event_name) VALUES
('호수', '근교 호숫가', '알렉산더 비단나비', 11, NULL, '00-06 / 18-24', 240, 360, 480, 960, 1920, '/images/collections/bug/알렉산더 비단나비.png', NULL),
('꽃밭', '고래산', '십삼성 무당벌레', 11, NULL, '12 - 24', 440, 660, 880, 1760, 3520, '/images/collections/bug/십삼성 무당벌레.png', NULL),
('온천산', '온천산 유적', '난초사마귀', 11, NULL, '06 - 18', 515, 772, 1030, 2060, 4120, '/images/collections/bug/난초사마귀.png', NULL),
('온천산', '온천산 온천', '박주가리 메뚜기', 12, NULL, '06 - 18', 370, 555, 740, 1480, 2960, '/images/collections/bug/박주가리 메뚜기.png', NULL),
('꽃밭', '풍차꽃밭', '삼색청띠 제비나비', 12, NULL, '00-12 / 18-24', 240, 360, 480, 960, 1920, '/images/collections/bug/삼색청띠 제비나비.png', NULL),
('초원', '초원 호숫가', '불꽃날개 잠자리', 12, NULL, '06 - 18', 295, 442, 590, 1180, 2360, '/images/collections/bug/불꽃날개 잠자리.png', NULL),
('숲', '순록 탑', '골리앗 대왕꽃무지', 12, NULL, '00-06 / 18-24', 440, 660, 880, 1760, 3520, '/images/collections/bug/골리앗 대왕꽃무지.png', NULL),
('온천산', '화산호수', '데이다미아 몰포나비', 13, NULL, '12 - 24', 480, 720, 960, 1920, 3840, '/images/collections/bug/데이다미아 몰포나비.png', NULL),
('호수', '근교호수', '차이넨시스 물잠자리', 13, NULL, '12 - 24', 590, 885, 1180, 2360, 4720, '/images/collections/bug/차이넨시스 물잠자리.png', NULL),
('꽃밭', '고래산', '유리날개나비', 14, NULL, '12 - 24', 480, 720, 960, 1920, 3840, '/images/collections/bug/유리날개나비.png', NULL),
('숲', '숲속 섬', '푸른민달팽이', 14, NULL, '풀타임', 590, 885, 1180, 2360, 4720, '/images/collections/bug/푸른민달팽이.png', NULL);

-- =====================================================
-- 3. bird_collections 데이터 삽입
-- =====================================================
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, type, image_url, event_name, distance, stretch_time) VALUES
('이벤트', '새들의 복귀 사건', '백공작', 11, NULL, '풀타임', 37, 150, 300, 600, 1200, '공작', '/images/collections/bird/백공작.png', NULL, '≤5m', '무지개 12~18'),
('근교', NULL, '푸른머리 비둘기', 11, NULL, '00-06 / 12-24', 37, 150, 300, 600, 900, '비둘기', '/images/collections/bird/푸른머리 비둘기.png', NULL, '3m', '무지개 12~24'),
('온천산', '온천산 호숫가', '가창오리', 11, NULL, '풀타임', 45, 180, 360, 720, 1440, '오리', '/images/collections/bird/가창오리.png', NULL, '≤3m', '무지개 12~18'),
('꽃밭', '풍차꽃밭', '쇠찌르레기', 11, NULL, '풀타임', 30, 120, 240, 480, 720, '찌르레기', '/images/collections/bird/쇠찌르레기.png', NULL, '3m', '무지개 18~24'),
('바다', '잔잔한 바다', '푸른발 얼간이새', 12, NULL, '풀타임', 45, 180, 360, 720, 1440, '얼간이새', '/images/collections/bird/푸른발 얼간이새.png', NULL, '≤3m', '무지개 12~18'),
('온천산', '온천산 호숫가', '붉은눈섭핀치', 12, NULL, '풀타임', 45, 180, 360, 720, 1440, '핀치', '/images/collections/bird/붉은눈섭핀치.png', NULL, '3m', '무지개 18~24'),
('바다', '고래바다 해변', '코뿔바다오리', 12, NULL, '00-12 / 18-24', 45, 180, 360, 720, 1440, '바다오리', '/images/collections/bird/코뿔바다오리.png', NULL, '3m', '무지개 06~12'),
('숲', '영혼의 참나무 숲', '흰올빼미', 12, NULL, '12 - 24', 65, 260, 520, 1040, 2080, '올빼미', '/images/collections/bird/흰올빼미.png', NULL, '4m', '무지개 18~24'),
('호수', '근교 호수', '큰 고니', 13, NULL, '풀타임', 65, 260, 520, 1040, 2080, '고니', '/images/collections/bird/큰 고니.png', NULL, '≤5m', '무지개 18~24'),
('이벤트', '새들의 복귀 사건', '흑공작', 13, NULL, '풀타임', 37, 150, 300, 600, 1200, '공작', '/images/collections/bird/흑공작.png', NULL, '≤5m', '무지개 12~18'),
('호수', '근교 호수', '흑고니', 13, NULL, '풀타임', 65, 260, 520, 1040, 2080, '고니', '/images/collections/bird/흑고니.png', NULL, '≤5m', '무지개 18~24'),
('호수', '초원 호숫가', '먹황새', 14, NULL, '06-12 / 12-24', 65, 260, 520, 1040, 2080, '황새', '/images/collections/bird/먹황새.png', NULL, '≤5m', '무지개 18~24'),
('숲', '점핑 플랫폼', '안경올빼미', 14, NULL, '00 - 12', 65, 260, 520, 1040, 2080, '올빼미', '/images/collections/bird/안경올빼미.png', NULL, '≤4m', '무지개 18~24');

-- =====================================================
-- 4. cooking_collections 데이터 삽입
-- =====================================================
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url, event_name) VALUES
('새우 아보카도 컵', 13, '아무 가재 (2), 아보카도 (2)', 6400, 1560, 2340, 3120, 6240, 12480, '/images/items/cook/새우 아보카도 컵.png', NULL),
('치즈 새우와 집게발 튀김', 13, '아무 킹크랩 (2), 아무 가재 (2)', 6400, 1440, 2160, 2880, 5760, 11520, '/images/items/cook/치즈 새우와 집게발 튀김.png', NULL),
('고급 애프터눈 티 세트', 12, '치즈케이크 (2), 진한 홍차 (2)', 6400, 2970, 4455, 5940, 11880, 23760, '/images/items/cook/고급 애프터눈 티 세트.png', NULL),
('밀크세이크', 11, '우유 (2), 아무 과일 (2)', 6400, 400, 600, 800, 1600, 3200, '/images/items/cook/밀크세이크.png', NULL),
('블루베리 밀크세이크', 11, '우유 (2), 블루베리 (2)', NULL, 400, 600, 800, 1600, 3200, '/images/items/cook/블루베리 밀크세이크.png', NULL),
('라즈베리 밀크세이크', 11, '우유 (2), 라즈베리 (2)', NULL, 440, 660, 880, 1760, 3520, '/images/items/cook/라즈베리 밀크세이크.png', NULL),
('사과 밀크세이크', 11, '우유 (2), 사과 (2)', NULL, 450, 675, 900, 1800, 3600, '/images/items/cook/사과 밀크세이크.png', NULL),
('오렌지 밀크세이크', 11, '우유 (2), 오렌지 (2)', NULL, 450, 675, 900, 1800, 3600, '/images/items/cook/오렌지 밀크세이크.png', NULL),
('파인애플 밀크세이크', 11, '우유 (2), 파인애플 (2)', NULL, 440, 660, 880, 1760, 3520, '/images/items/cook/파인애플 밀크세이크.png', NULL),
('말차 밀크세이크', 11, '우유 (2), 말차가루 (2)', NULL, 840, 1260, 1680, 3360, 6720, '/images/items/cook/말차 밀크세이크.png', NULL),
('딸기 밀크세이크', 11, '우유 (2), 딸기 (2)', NULL, 1090, 1635, 2180, 4360, 8720, '/images/items/cook/딸기 밀크세이크.png', NULL),
('포도 밀크세이크', 11, '우유 (2), 포도 (2)', NULL, 1300, 1950, 2600, 5200, 10400, '/images/items/cook/포도 밀크세이크.png', NULL),
('초코 밀크세이크', 11, '우유 (2), 코코아 콩 (2)', NULL, 1000, 1500, 2000, 4000, 8000, '/images/items/cook/초코 밀크세이크.png', NULL),
('진한 홍차', 11, '홍차 (4)', 6400, 840, 1260, 1680, 3360, 6720, '/images/items/cook/진한 홍차.png', NULL),
('밀크티', 11, '홍차 (2), 우유 (2)', NULL, 840, 1260, 1680, 3360, 6720, '/images/items/cook/밀크티.png', NULL),
('코코아 밀크티', 11, '홍차 (2), 우유 (1), 코코아 콩 (1)', NULL, 1120, 1680, 2240, 4480, 8960, '/images/items/cook/코코아 밀크티.png', NULL),
('상큼한 그린티', 12, '녹차 잎 (4)', 6400, 500, 750, 1000, 2000, 4000, '/images/items/cook/상큼한 그린티.png', NULL),
('상큼한 그린 밀크티', 12, '녹차 잎 (2), 우유 (2)', NULL, 500, 750, 1000, 2000, 4000, '/images/items/cook/상큼한 그린 밀크티.png', NULL),
('말차 그린 밀크티', 12, '녹차 잎 (2), 우유 (1), 말차가루 (1)', NULL, 700, 1050, 1400, 2800, 5600, '/images/items/cook/말차 그린 밀크티.png', NULL),
('국화차', 12, '녹차 잎 (2), 흰색 데이지 (2)', NULL, 600, 900, 1200, 2400, 4800, '/images/items/cook/국화차.png', NULL),
('로즈티', 12, '녹차 잎 (2), 빨간 장미 (2)', NULL, 1930, 2895, 3860, 7720, 15440, '/images/items/cook/로즈티.png', NULL);

-- =====================================================
-- 5. cooking_ingredients 데이터 삽입 (상세 재료 매핑)
-- =====================================================
-- 새우 아보카도 컵 (아무 가재 2, 아보카도 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '아무 가재', 2, 'fish' FROM cooking_collections WHERE name = '새우 아보카도 컵';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '아보카도', 2, 'crop' FROM cooking_collections WHERE name = '새우 아보카도 컵';

-- 치즈 새우와 집게발 튀김 (아무 킹크랩 2, 아무 가재 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '아무 킹크랩', 2, 'fish' FROM cooking_collections WHERE name = '치즈 새우와 집게발 튀김';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '아무 가재', 2, 'fish' FROM cooking_collections WHERE name = '치즈 새우와 집게발 튀김';

-- 고급 애프터눈 티 세트 (치즈케이크 2, 진한 홍차 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '치즈케이크', 2, 'cook' FROM cooking_collections WHERE name = '고급 애프터눈 티 세트';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '진한 홍차', 2, 'cook' FROM cooking_collections WHERE name = '고급 애프터눈 티 세트';

-- 밀크세이크 (우유 2, 아무 과일 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 2, 'forageable' FROM cooking_collections WHERE name = '밀크세이크';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '아무 과일', 2, 'forageable' FROM cooking_collections WHERE name = '밀크세이크';

-- 블루베리 밀크세이크 (우유 2, 블루베리 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 2, 'forageable' FROM cooking_collections WHERE name = '블루베리 밀크세이크';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '블루베리', 2, 'crop' FROM cooking_collections WHERE name = '블루베리 밀크세이크';

-- 라즈베리 밀크세이크 (우유 2, 라즈베리 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 2, 'forageable' FROM cooking_collections WHERE name = '라즈베리 밀크세이크';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '라즈베리', 2, 'crop' FROM cooking_collections WHERE name = '라즈베리 밀크세이크';

-- 사과 밀크세이크 (우유 2, 사과 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 2, 'forageable' FROM cooking_collections WHERE name = '사과 밀크세이크';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '사과', 2, 'crop' FROM cooking_collections WHERE name = '사과 밀크세이크';

-- 오렌지 밀크세이크 (우유 2, 오렌지 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 2, 'forageable' FROM cooking_collections WHERE name = '오렌지 밀크세이크';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '오렌지', 2, 'crop' FROM cooking_collections WHERE name = '오렌지 밀크세이크';

-- 파인애플 밀크세이크 (우유 2, 파인애플 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 2, 'forageable' FROM cooking_collections WHERE name = '파인애플 밀크세이크';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '파인애플', 2, 'crop' FROM cooking_collections WHERE name = '파인애플 밀크세이크';

-- 말차 밀크세이크 (우유 2, 말차가루 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 2, 'forageable' FROM cooking_collections WHERE name = '말차 밀크세이크';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '말차가루', 2, 'forageable' FROM cooking_collections WHERE name = '말차 밀크세이크';

-- 딸기 밀크세이크 (우유 2, 딸기 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 2, 'forageable' FROM cooking_collections WHERE name = '딸기 밀크세이크';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '딸기', 2, 'crop' FROM cooking_collections WHERE name = '딸기 밀크세이크';

-- 포도 밀크세이크 (우유 2, 포도 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 2, 'forageable' FROM cooking_collections WHERE name = '포도 밀크세이크';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '포도', 2, 'crop' FROM cooking_collections WHERE name = '포도 밀크세이크';

-- 초코 밀크세이크 (우유 2, 코코아 콩 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 2, 'forageable' FROM cooking_collections WHERE name = '초코 밀크세이크';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '코코아 콩', 2, 'crop' FROM cooking_collections WHERE name = '초코 밀크세이크';

-- 진한 홍차 (홍차 4)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '홍차', 4, 'crop' FROM cooking_collections WHERE name = '진한 홍차';

-- 밀크티 (홍차 2, 우유 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '홍차', 2, 'crop' FROM cooking_collections WHERE name = '밀크티';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 2, 'forageable' FROM cooking_collections WHERE name = '밀크티';

-- 코코아 밀크티 (홍차 2, 우유 1, 코코아 콩 1)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '홍차', 2, 'crop' FROM cooking_collections WHERE name = '코코아 밀크티';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 1, 'forageable' FROM cooking_collections WHERE name = '코코아 밀크티';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '코코아 콩', 1, 'crop' FROM cooking_collections WHERE name = '코코아 밀크티';

-- 상큼한 그린티 (녹차 잎 4)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '녹차 잎', 4, 'crop' FROM cooking_collections WHERE name = '상큼한 그린티';

-- 상큼한 그린 밀크티 (녹차 잎 2, 우유 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '녹차 잎', 2, 'crop' FROM cooking_collections WHERE name = '상큼한 그린 밀크티';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 2, 'forageable' FROM cooking_collections WHERE name = '상큼한 그린 밀크티';

-- 말차 그린 밀크티 (녹차 잎 2, 우유 1, 말차가루 1)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '녹차 잎', 2, 'crop' FROM cooking_collections WHERE name = '말차 그린 밀크티';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '우유', 1, 'forageable' FROM cooking_collections WHERE name = '말차 그린 밀크티';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '말차가루', 1, 'forageable' FROM cooking_collections WHERE name = '말차 그린 밀크티';

-- 국화차 (녹차 잎 2, 흰색 데이지 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '녹차 잎', 2, 'crop' FROM cooking_collections WHERE name = '국화차';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '흰색 데이지', 2, 'flower' FROM cooking_collections WHERE name = '국화차';

-- 로즈티 (녹차 잎 2, 빨간 장미 2)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '녹차 잎', 2, 'crop' FROM cooking_collections WHERE name = '로즈티';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity, item_type)
SELECT id, '빨간 장미', 2, 'flower' FROM cooking_collections WHERE name = '로즈티';
