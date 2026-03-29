-- =====================================================
-- 0329 신규 수집품 데이터 삽입
-- 새 5종 (신사 비둘기 시리즈), 벌레 1종, 작물 1종
-- 실행 전: --default-character-set=utf8mb4 필수
-- =====================================================

-- =====================================================
-- 1. bird_collections — 신사 비둘기 5종 (배우 비둘기 사건)
-- =====================================================
INSERT INTO bird_collections (name, level, type, location, sub_location, weather, time, price_1, price_2, price_3, price_4, price_5, image_url, event_name) VALUES
('신사 무늬 비둘기', 1, '비둘기', '이벤트', '배우 비둘기 사건', NULL, NULL, 17, 68, 136, 272, 544, '/images/collections/bird/신사 무늬 비둘기.png', '배우 비둘기 사건'),
('신사 초록 비둘기', 1, '비둘기', '숲', '점핑 플랫폼', NULL, NULL, 15, 60, 120, 240, 480, '/images/collections/bird/신사 초록 비둘기.png', '배우 비둘기 사건'),
('신사 파랑 비둘기', 1, '비둘기', '숲', '영혼의 참나무 숲', NULL, NULL, 15, 60, 120, 240, 480, '/images/collections/bird/신사 파랑 비둘기.png', '배우 비둘기 사건'),
('신사 회색 비둘기', 1, '비둘기', '숲', '순록탑', NULL, NULL, 15, 60, 120, 240, 480, '/images/collections/bird/신사 회색 비둘기.png', '배우 비둘기 사건'),
('신사 빨강 비둘기', 1, '비둘기', '숲', '숲속 섬', NULL, NULL, 15, 60, 120, 240, 480, '/images/collections/bird/신사 빨강 비둘기.png', '배우 비둘기 사건');

-- =====================================================
-- 2. bug_collections — 스크립터 금색 호박벌 (스크립터 벌 사건)
-- 1성=165, 2성=247, 3성~5성 1.5배 패턴 적용
-- =====================================================
INSERT INTO bug_collections (name, level, location, sub_location, weather, time, price_1, price_2, price_3, price_4, price_5, image_url, event_name) VALUES
('스크립터 금색 호박벌', 1, '이벤트', '스크립터 벌 사건', NULL, NULL, 165, 247, 370, 555, 832, '/images/collections/bug/스크립터 금색 호박벌.png', '스크립터 벌 사건');

-- =====================================================
-- 3. crop_collections — 로메인
-- 씨앗구매가 10원, 씨앗판매가 5원, 재배시간 15분
-- 판매가 30/40/50/60/70원
-- =====================================================
INSERT INTO crop_collections (name, location, price_1, price_2, price_3, price_4, price_5, level, growth_time, seed_buy_price, seed_sell_price, image_url) VALUES
('로메인', NULL, 30, 40, 50, 60, 70, 1, '15 min', 10, 5, '/images/collections/crop/로메인.png');
