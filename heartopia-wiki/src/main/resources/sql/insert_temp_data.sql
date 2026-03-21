-- Insert Dream Light/Dark event data from temp directories

select * from map_pins;
select * from fish_collections;
select * from bug_collections;


-- 1. Fish
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size, image_url, event_name)
VALUES 
('바다', '고래 바다', '감색 감독 난쟁이문어', 1, NULL, NULL, 100, 150, 200, 400, 800, 'S', '/images/collections/fish/감색 감독 난쟁이문어.png', '꿈의 명암'),
('바다', '고래 바다', '감색 감독 참문어', 1, NULL, NULL, 215, 322, 430, 860, 1720, 'M', '/images/collections/fish/감색 감독 참문어.png', '꿈의 명암'),
('바다', '고래 바다', '감청색 감독 난쟁이문어', 1, NULL, NULL, 100, 150, 200, 400, 800, 'S', '/images/collections/fish/감청색 감독 난쟁이문어.png', '꿈의 명암'),
('바다', '고래 바다', '청록색 감독 난쟁이문어', 1, NULL, NULL, 100, 150, 200, 400, 800, 'S', '/images/collections/fish/청록색 감독 난쟁이문어.png', '꿈의 명암');

-- 2. Bug
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, image_url, event_name)
VALUES
('꽃밭', '풍차꽃밭', '스크립터 보라 호박벌', 1, NULL, NULL, 110, 165, 220, 440, 880, '/images/collections/bug/스크립터 보라 호박벌.png', '꿈의 명암'),
('꽃밭', '풍차꽃밭', '스크립터 분홍 호박벌', 1, NULL, NULL, 110, 165, 220, 440, 880, '/images/collections/bug/스크립터 분홍 보학벌.png', '꿈의 명암'),
('꽃밭', '고래산', '스크립터 빨강 호박벌', 1, NULL, NULL, 110, 165, 220, 440, 880, '/images/collections/bug/스크립터 빨강 호박벌.png', '꿈의 명암'),
('꽃밭', '보라빛 해변', '스크립터 초록 호박벌', 1, NULL, NULL, 110, 165, 220, 440, 880, '/images/collections/bug/스크립터 초록 호박벌.png', '꿈의 명암');

-- 3. Forageable
INSERT INTO forageable_collections (name, location, price, energy, image_url, event_name)
VALUES
('야생 고사리', '숲', 5, NULL, '/images/collections/forage/야생 고사리.png', '꿈의 명암'),
('산마늘', '온천산', 5, NULL, '/images/collections/forage/산마늘.png', '꿈의 명암'),
('산우엉', '꽃밭', 5, NULL, '/images/collections/forage/산우엉.png', '꿈의 명암'),
('산겨자', '어촌', 5, NULL, '/images/collections/forage/산겨자.png', '꿈의 명암');



-- 4. Map Pins (forageables)
INSERT INTO map_pins (category, name, icon_url, map_x, map_y) VALUES
('forageable', '야생 고사리', '/images/collections/forage/야생 고사리.png', 1000, 1000),
('forageable', '산마늘', '/images/collections/forage/산마늘.png', 1100, 1000),
('forageable', '산우엉', '/images/collections/forage/산우엉.png', 1200, 1000),
('forageable', '산겨자', '/images/collections/forage/산겨자.png', 1300, 1000);
