-- =====================================================
-- 빙설 시즌 도감 데이터 27종
-- MySQL 8.0 / utf8mb4
-- 취미 '눈 조각'은 사용자 요청에 따라 제외
-- =====================================================

SET NAMES utf8mb4;
START TRANSACTION;

-- 재실행 시 이번 대상 요리의 관계형 재료를 먼저 정리한다.
DELETE ci
FROM cooking_ingredients ci
JOIN cooking_collections cc ON cc.id = ci.cooking_id
WHERE cc.name IN (
    '얼음컵 커피', '얼음컵 라떼', '갈은 무와 스테이크', '무 크림 수프',
    '오리지널 슈가파우더 팬케이크', '블루베리 슈가파우더 팬케이크',
    '라즈베리 슈가파우더 팬케이크', '사과 슈가파우더 팬케이크',
    '오렌지 슈가파우더 팬케이크', '오로라 만찬'
);

DELETE FROM cooking_collections WHERE name IN (
    '얼음컵 커피', '얼음컵 라떼', '갈은 무와 스테이크', '무 크림 수프',
    '오리지널 슈가파우더 팬케이크', '블루베리 슈가파우더 팬케이크',
    '라즈베리 슈가파우더 팬케이크', '사과 슈가파우더 팬케이크',
    '오렌지 슈가파우더 팬케이크', '오로라 만찬'
);
DELETE FROM crop_collections WHERE name = '무';
DELETE FROM flower_collections WHERE name = '히말라야양귀비';
DELETE FROM bird_collections WHERE name IN (
    '겨울 옷 큰홍학', '겨울 옷 청둥오리', '겨울 옷 흰비오리', '겨울 옷 홍머리오리', '겨울 옷 원앙'
);
DELETE FROM bug_collections WHERE name IN (
    '얼음 결정 진주네발나비', '얼음 결정 삼색청띠제비나비', '얼음 결정 알렉산더비단나비',
    '얼음 결정 슬코스키몰포나비', '얼음 결정 멜포메네길쭉나비'
);
DELETE FROM fish_collections WHERE name IN (
    '얼음 결정 킹크랩', '얼음 결정 개복치', '얼음 결정 복어', '얼음 결정 해마', '얼음 결정 고래상어'
);

-- 1. 작물
INSERT INTO crop_collections (
    name, location, price_1, price_2, price_3, price_4, price_5,
    level, growth_time, seed_buy_price, seed_sell_price, image_url, event_name
) VALUES
('무', '이벤트', 30, 45, 60, 120, 240, 1, '15분', 10, NULL, '/images/collections/crop/무.webp', '빙설 시즌');

-- 2. 꽃
-- 성장 시간, 씨앗 구매가와 판매가는 사용자 제공값이다.
INSERT INTO flower_collections (
    name, price_1, price_2, price_3, price_4, price_5,
    level, growth_time, seed_buy_price, seed_sell_price, image_url, event_name
) VALUES
('히말라야양귀비', 100, 150, 200, 400, 800, 1, '1일', 100, NULL, '/images/flowers/히말라야양귀비.webp', '빙설 시즌');

-- 3. 요리
INSERT INTO cooking_collections (
    name, ingredients, price_1, price_2, price_3, price_4, price_5,
    image_url, level, event_name
) VALUES
('얼음컵 커피', '슈가파우더 (1), 커피 원두 (3)', 280, 420, 560, 1120, 2240, '/images/items/cook/cook_얼음컵 커피.webp', 1, '빙설 시즌'),
('얼음컵 라떼', '슈가파우더 (1), 커피 원두 (1), 우유 (2)', 280, 420, 560, 1120, 2240, '/images/items/cook/cook_얼음컵 라떼.webp', 1, '빙설 시즌'),
('갈은 무와 스테이크', '고기 (2), 버터 (1), 무 (1)', 630, 945, 1260, 2520, 5040, '/images/items/cook/cook_갈은 무와 스테이크.webp', 1, '빙설 시즌'),
('무 크림 수프', '우유 (1), 버터 (1), 무 (2)', 340, 510, 680, 1360, 2720, '/images/items/cook/cook_무 크림 수프.webp', 1, '빙설 시즌'),
('오리지널 슈가파우더 팬케이크', '달걀 (1), 우유 (1), 슈가파우더 (1), 블루베리 (1)', 330, 495, 660, 1320, 2640, '/images/items/cook/cook_오리지널 슈가파우더 팬케이크.webp', 1, '빙설 시즌'),
('블루베리 슈가파우더 팬케이크', '달걀 (1), 우유 (1), 슈가파우더 (1), 블루베리 (1)', 330, 495, 660, 1320, 2640, '/images/items/cook/cook_블루베리 슈가파우더 팬케이크.webp', 1, '빙설 시즌'),
('라즈베리 슈가파우더 팬케이크', '달걀 (1), 우유 (1), 슈가파우더 (1), 라즈베리 (1)', 350, 525, 700, 1400, 2800, '/images/items/cook/cook_라즈베리 슈가파우더 팬케이크.webp', 1, '빙설 시즌'),
('사과 슈가파우더 팬케이크', '달걀 (1), 우유 (1), 슈가파우더 (1), 사과 (1)', 360, 540, 720, 1440, 2880, '/images/items/cook/cook_사과 슈가파우더 팬케이크.webp', 1, '빙설 시즌'),
('오렌지 슈가파우더 팬케이크', '달걀 (1), 우유 (1), 슈가파우더 (1), 오렌지 (1)', 360, 540, 720, 1440, 2880, '/images/items/cook/cook_오렌지 슈가파우더 팬케이크.webp', 1, '빙설 시즌'),
('오로라 만찬', '갈은 무와 스테이크 (1), 무 크림 수프 (1), 얼음컵 커피 (1), 사과 슈가파우더 팬케이크 (1)', 1630, 2445, 3260, 6520, 13040, '/images/items/cook/cook_오로라 만찬.webp', 1, '빙설 시즌');

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '슈가파우더', 1 FROM cooking_collections WHERE name = '얼음컵 커피' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '커피 원두', 3 FROM cooking_collections WHERE name = '얼음컵 커피' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '슈가파우더', 1 FROM cooking_collections WHERE name = '얼음컵 라떼' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '커피 원두', 1 FROM cooking_collections WHERE name = '얼음컵 라떼' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '우유', 2 FROM cooking_collections WHERE name = '얼음컵 라떼' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '고기', 2 FROM cooking_collections WHERE name = '갈은 무와 스테이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '버터', 1 FROM cooking_collections WHERE name = '갈은 무와 스테이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '무', 1 FROM cooking_collections WHERE name = '갈은 무와 스테이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '우유', 1 FROM cooking_collections WHERE name = '무 크림 수프' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '버터', 1 FROM cooking_collections WHERE name = '무 크림 수프' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '무', 2 FROM cooking_collections WHERE name = '무 크림 수프' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '달걀', 1 FROM cooking_collections WHERE name = '오리지널 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '우유', 1 FROM cooking_collections WHERE name = '오리지널 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '슈가파우더', 1 FROM cooking_collections WHERE name = '오리지널 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '블루베리', 1 FROM cooking_collections WHERE name = '오리지널 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '달걀', 1 FROM cooking_collections WHERE name = '블루베리 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '우유', 1 FROM cooking_collections WHERE name = '블루베리 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '슈가파우더', 1 FROM cooking_collections WHERE name = '블루베리 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '블루베리', 1 FROM cooking_collections WHERE name = '블루베리 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '달걀', 1 FROM cooking_collections WHERE name = '라즈베리 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '우유', 1 FROM cooking_collections WHERE name = '라즈베리 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '슈가파우더', 1 FROM cooking_collections WHERE name = '라즈베리 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '라즈베리', 1 FROM cooking_collections WHERE name = '라즈베리 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '달걀', 1 FROM cooking_collections WHERE name = '사과 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '우유', 1 FROM cooking_collections WHERE name = '사과 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '슈가파우더', 1 FROM cooking_collections WHERE name = '사과 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '사과', 1 FROM cooking_collections WHERE name = '사과 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '달걀', 1 FROM cooking_collections WHERE name = '오렌지 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '우유', 1 FROM cooking_collections WHERE name = '오렌지 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '슈가파우더', 1 FROM cooking_collections WHERE name = '오렌지 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '오렌지', 1 FROM cooking_collections WHERE name = '오렌지 슈가파우더 팬케이크' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '갈은 무와 스테이크', 1 FROM cooking_collections WHERE name = '오로라 만찬' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '무 크림 수프', 1 FROM cooking_collections WHERE name = '오로라 만찬' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '얼음컵 커피', 1 FROM cooking_collections WHERE name = '오로라 만찬' AND event_name = '빙설 시즌';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity)
SELECT id, '사과 슈가파우더 팬케이크', 1 FROM cooking_collections WHERE name = '오로라 만찬' AND event_name = '빙설 시즌';

-- 4. 새
-- 원본 price는 2성 기준: 1성=floor(0.25배), 3/4/5성=2/4/8배.
INSERT INTO bird_collections (
    name, level, type, location, sub_location, weather, time,
    price_1, price_2, price_3, price_4, price_5,
    distance, stretch_time, image_url, event_name
) VALUES
('겨울 옷 큰홍학', 1, '홍학', '도시', '근교 호숫가', '상시', '상시', 20, 80, 160, 320, 640, NULL, '비: 낮/저녁/새벽', '/images/collections/bird/bird_겨울 옷 큰홍학.webp', '빙설 시즌'),
('겨울 옷 청둥오리', 1, '오리', '도시', '근교 호수', '상시', '상시', 17, 70, 140, 280, 560, NULL, '비: 낮/저녁/새벽', '/images/collections/bird/bird_겨울 옷 청둥오리.webp', '빙설 시즌'),
('겨울 옷 흰비오리', 1, '오리', '도시', '근교 호수', '상시', '상시', 17, 70, 140, 280, 560, NULL, '비: 낮/저녁/새벽', '/images/collections/bird/bird_겨울 옷 흰비오리.webp', '빙설 시즌'),
('겨울 옷 홍머리오리', 1, '오리', '도시', '근교 호수', '상시', '상시', 17, 70, 140, 280, 560, NULL, '비: 낮/저녁/새벽', '/images/collections/bird/bird_겨울 옷 홍머리오리.webp', '빙설 시즌'),
('겨울 옷 원앙', 1, '오리', '이벤트', '겨울 기록 채집 사건', '상시', '상시', 22, 90, 180, 360, 720, NULL, '비: 낮/저녁/새벽', '/images/collections/bird/bird_겨울 옷 원앙.webp', '빙설 시즌');

-- 5. 곤충
INSERT INTO bug_collections (
    name, level, location, sub_location, weather, time,
    price_1, price_2, price_3, price_4, price_5, image_url, event_name
) VALUES
('얼음 결정 진주네발나비', 1, '숲', '점핑 플랫폼', '상시', '상시', 60, 90, 120, 240, 480, '/images/collections/bug/bug_얼음 결정 진주네발나비.webp', '빙설 시즌'),
('얼음 결정 삼색청띠제비나비', 1, '숲', '영혼의 참나무 숲', '상시', '상시', 60, 90, 120, 240, 480, '/images/collections/bug/bug_얼음 결정 삼색청띠제비나비.webp', '빙설 시즌'),
('얼음 결정 알렉산더비단나비', 1, '숲', '순록탑', '상시', '상시', 60, 90, 120, 240, 480, '/images/collections/bug/bug_얼음 결정 알렉산더비단나비.webp', '빙설 시즌'),
('얼음 결정 슬코스키몰포나비', 1, '숲', '순록탑', '상시', '상시', 60, 90, 120, 240, 480, '/images/collections/bug/bug_얼음 결정 슬코스키몰포나비.webp', '빙설 시즌'),
('얼음 결정 멜포메네길쭉나비', 1, '이벤트', '얼음 결정 나비 사건', '상시', '상시', 90, 135, 180, 360, 720, '/images/collections/bug/bug_얼음 결정 멜포메네길쭉나비.webp', '빙설 시즌');

-- 6. 물고기
INSERT INTO fish_collections (
    name, level, location, sub_location, weather, time,
    price_1, price_2, price_3, price_4, price_5, size, image_url, event_name
) VALUES
('얼음 결정 킹크랩', 1, '바다', '구해', '상시', '상시', 215, 322, 430, 860, 1720, 'L', '/images/collections/fish/fish_얼음 결정 킹크랩.webp', '빙설 시즌'),
('얼음 결정 개복치', 1, '바다', '구해', '상시', '상시', 210, 315, 420, 840, 1680, 'L', '/images/collections/fish/fish_얼음 결정 개복치.webp', '빙설 시즌'),
('얼음 결정 복어', 1, '바다', '구해', '상시', '상시', 155, 232, 310, 620, 1240, 'M', '/images/collections/fish/fish_얼음 결정 복어.webp', '빙설 시즌'),
('얼음 결정 해마', 1, '바다', '구해', '상시', '상시', 100, 150, 200, 400, 800, 'M', '/images/collections/fish/fish_얼음 결정 해마.webp', '빙설 시즌'),
('얼음 결정 고래상어', 1, '이벤트', '얼음 결정 물고기 사건', '상시', '상시', 320, 480, 640, 1280, 2560, 'L', '/images/collections/fish/fish_얼음 결정 고래상어.webp', '빙설 시즌');

COMMIT;

-- 예상 결과: crop 1, flower 1, cooking 10, bird 5, bug 5, fish 5
SELECT 'crop' AS category, COUNT(*) AS item_count FROM crop_collections WHERE event_name = '빙설 시즌'
UNION ALL
SELECT 'flower', COUNT(*) FROM flower_collections WHERE event_name = '빙설 시즌'
UNION ALL
SELECT 'cooking', COUNT(*) FROM cooking_collections WHERE event_name = '빙설 시즌'
UNION ALL
SELECT 'bird', COUNT(*) FROM bird_collections WHERE event_name = '빙설 시즌'
UNION ALL
SELECT 'bug', COUNT(*) FROM bug_collections WHERE event_name = '빙설 시즌'
UNION ALL
SELECT 'fish', COUNT(*) FROM fish_collections WHERE event_name = '빙설 시즌';
