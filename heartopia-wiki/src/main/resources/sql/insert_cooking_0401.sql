
SELECT * FROM cooking_collections;

-- 기존 오염 데이터 삭제
DELETE FROM cooking_ingredients WHERE cooking_id IN (
    SELECT id FROM cooking_collections WHERE event_name = '꿈의 명암' AND name IN (
        '짭짤한 팝콘통', '캐러멜 팝콘통', '살사 소스 웨이브 감자칩', '짭조름한 더블 버킷', '달콤한 듀얼 팝콘통',
        '로메인 타코', '나물 로메인 타코', '야생 고사리 로메인 타코', '산마늘 로메인 타코', '산우엉 로메인 타코', '산겨자 로메인 타코',
        '봄날 과일 홍차', '봄날 사과 홍차', '봄날 오렌지 홍차', '봄날 블루베리 홍차', '봄날 라즈베리 홍차', '봄날 딸기 홍차', '봄날 포도 홍차', '봄날 파인애플 홍차',
        '화려한 관람 세트', '프리미엄 관람 세트'
    )
);

DELETE FROM cooking_collections WHERE event_name = '꿈의 명암' AND name IN ('짭짤한 팝콘통', '캐러멜 팝콘통', '살사 소스 웨이브 감자칩', '짭조름한 더블 버킷', '달콤한 듀얼 팝콘통', '로메인 타코', '나물 로메인 타코', '야생 고사리 로메인 타코', '산마늘 로메인 타코', '산우엉 로메인 타코', '산겨자 로메인 타코', '봄날 과일 홍차', '봄날 사과 홍차', '봄날 오렌지 홍차', '봄날 블루베리 홍차', '봄날 라즈베리 홍차', '봄날 딸기 홍차', '봄날 포도 홍차', '봄날 파인애플 홍차', '화려한 관람 세트', '프리미엄 관람 세트');

-- 1. 아이템 기본 정보 삽입
INSERT INTO cooking_collections (name, ingredients, price_1, price_2, price_3, price_4, price_5, image_url, level, event_name) VALUES
('짭짤한 팝콘통', '옥수수 (1), 버섯 (1), 버터 (2)', 900, 1350, 1800, 3600, 7200, '/images/items/cook/짭짤한 팝콘통.png', 1, '꿈의 명암'),
('캐러멜 팝콘통', '옥수수 (1), 봄날 카라멜 슈가 (2), 버터 (1)', 820, 1230, 1640, 3280, 6560, '/images/items/cook/캐러멜 팝콘통.png', 1, '꿈의 명암'),
('살사 소스 웨이브 감자칩', '감자 (2), 살사 소스 (1)', 280, 420, 560, 1120, 2240, '/images/items/cook/살사 소스 웨이브 감자칩.png', 1, '꿈의 명암'),
('짭조름한 더블 버킷', '짭짤한 팝콘통 (1), 살사 소스 웨이브 감자칩 (1)', 1230, 2965, 3580, 6040, 10960, '/images/items/cook/짭조름한 더블 버킷.png', 1, '꿈의 명암'),
('달콤한 듀얼 팝콘통', '캐러멜 팝콘통 (1), 살사 소스 웨이브 감자칩 (1)', 1150, 1725, 2300, 4600, 9200, '/images/items/cook/달콤한 듀얼 팝콘통.png', 1, '꿈의 명암'),
('로메인 타코', '로메인 (2), 살사 소스 (1), 달걀 (1)', 260, 390, 520, 1040, 2080, '/images/items/cook/로메인 타코.png', 1, '꿈의 명암'),
('나물 로메인 타코', '나물 (2), 로메인 타코 (1)', 330, 495, 660, 1320, 2640, '/images/items/cook/나물 로메인 타코.png', 1, '꿈의 명암'),
('야생 고사리 로메인 타코', '야생 고사리 (2), 로메인 타코 (1)', 330, 495, 660, 1320, 2640, '/images/items/cook/야생 고사리 로메인 타코.png', 1, '꿈의 명암'),
('산마늘 로메인 타코', '산마늘 (2), 로메인 타코 (1)', 330, 495, 660, 1320, 2640, '/images/items/cook/산마늘 로메인 타코.png', 1, '꿈의 명암'),
('산우엉 로메인 타코', '산우엉 (2), 로메인 타코 (1)', 330, 495, 660, 1320, 2640, '/images/items/cook/산우엉 로메인 타코.png', 1, '꿈의 명암'),
('산겨자 로메인 타코', '산겨자 (2), 로메인 타코 (1)', 330, 495, 660, 1320, 2640, '/images/items/cook/산겨자 로메인 타코.png', 1, '꿈의 명암'),
('봄날 과일 홍차', '홍차 (1), 과일 (1), 봄날 카라멜 슈가 (2)', 460, 690, 920, 1840, 3680, '/images/items/cook/봄날 과일 홍차.png', 1, '꿈의 명암'),
('봄날 사과 홍차', '홍차 (1), 사과 (1), 봄날 카라멜 슈가 (2)', 480, 720, 960, 1920, 3840, '/images/items/cook/봄날 사과 홍차.png', 1, '꿈의 명암'),
('봄날 오렌지 홍차', '홍차 (1), 오렌지 (1), 봄날 카라멜 슈가 (2)', 480, 720, 960, 1920, 3840, '/images/items/cook/봄날 오렌지 홍차.png', 1, '꿈의 명암'),
('봄날 블루베리 홍차', '홍차 (1), 블루베리 (1), 봄날 카라멜 슈가 (2)', 460, 690, 920, 1840, 3680, '/images/items/cook/봄날 블루베리 홍차.png', 1, '꿈의 명암'),
('봄날 라즈베리 홍차', '홍차 (1), 라즈베리 (1), 봄날 카라멜 슈가 (2)', 480, 720, 960, 1920, 3840, '/images/items/cook/봄날 라즈베리 홍차.png', 1, '꿈의 명암'),
('봄날 딸기 홍차', '홍차 (1), 딸기 (1), 봄날 카라멜 슈가 (2)', 800, 1200, 1600, 3200, 6400, '/images/items/cook/봄날 딸기 홍차.png', 1, '꿈의 명암'),
('봄날 포도 홍차', '홍차 (1), 포도 (1), 봄날 카라멜 슈가 (2)', 910, 1365, 1820, 3640, 7280, '/images/items/cook/봄날 포도 홍차.png', 1, '꿈의 명암'),
('봄날 파인애플 홍차', '홍차 (1), 파인애플 (1), 봄날 카라멜 슈가 (2)', 480, 720, 960, 1920, 3840, '/images/items/cook/봄날 파인애플 홍차.png', 1, '꿈의 명암'),
('화려한 관람 세트', '봄날 과일 홍차 (1), 달콤한 듀얼 팝콘통 (1), 나물 로메인 타코 (1)', 1960, 2940, 3920, 7840, 15680, '/images/items/cook/화려한 관람 세트.png', 1, '꿈의 명암'),
('프리미엄 관람 세트', '봄날 과일 홍차 (1), 짭조름한 더블 버킷 (1), 나물 로메인 타코 (2)', 2370, 3555, 4740, 9480, 18960, '/images/items/cook/프리미엄 관람 세트.png', 1, '꿈의 명암');

-- 2. 개별 재료 관계 매핑 (예쁜 UI 뱃지용)
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '옥수수', 1 FROM cooking_collections WHERE name = '짭짤한 팝콘통' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '버섯', 1 FROM cooking_collections WHERE name = '짭짤한 팝콘통' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '버터', 2 FROM cooking_collections WHERE name = '짭짤한 팝콘통' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '옥수수', 1 FROM cooking_collections WHERE name = '캐러멜 팝콘통' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '봄날 카라멜 슈가', 2 FROM cooking_collections WHERE name = '캐러멜 팝콘통' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '버터', 1 FROM cooking_collections WHERE name = '캐러멜 팝콘통' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '감자', 2 FROM cooking_collections WHERE name = '살사 소스 웨이브 감자칩' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '살사 소스', 1 FROM cooking_collections WHERE name = '살사 소스 웨이브 감자칩' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '짭짤한 팝콘통', 1 FROM cooking_collections WHERE name = '짭조름한 더블 버킷' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '살사 소스 웨이브 감자칩', 1 FROM cooking_collections WHERE name = '짭조름한 더블 버킷' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '캐러멜 팝콘통', 1 FROM cooking_collections WHERE name = '달콤한 듀얼 팝콘통' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '살사 소스 웨이브 감자칩', 1 FROM cooking_collections WHERE name = '달콤한 듀얼 팝콘통' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '로메인', 2 FROM cooking_collections WHERE name = '로메인 타코' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '살사 소스', 1 FROM cooking_collections WHERE name = '로메인 타코' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '달걀', 1 FROM cooking_collections WHERE name = '로메인 타코' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '나물', 2 FROM cooking_collections WHERE name = '나물 로메인 타코' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '로메인 타코', 1 FROM cooking_collections WHERE name = '나물 로메인 타코' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '야생 고사리', 2 FROM cooking_collections WHERE name = '야생 고사리 로메인 타코' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '로메인 타코', 1 FROM cooking_collections WHERE name = '야생 고사리 로메인 타코' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '산마늘', 2 FROM cooking_collections WHERE name = '산마늘 로메인 타코' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '로메인 타코', 1 FROM cooking_collections WHERE name = '산마늘 로메인 타코' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '산우엉', 2 FROM cooking_collections WHERE name = '산우엉 로메인 타코' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '로메인 타코', 1 FROM cooking_collections WHERE name = '산우엉 로메인 타코' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '산겨자', 2 FROM cooking_collections WHERE name = '산겨자 로메인 타코' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '로메인 타코', 1 FROM cooking_collections WHERE name = '산겨자 로메인 타코' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '홍차', 1 FROM cooking_collections WHERE name = '봄날 과일 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '과일', 1 FROM cooking_collections WHERE name = '봄날 과일 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '봄날 카라멜 슈가', 2 FROM cooking_collections WHERE name = '봄날 과일 홍차' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '홍차', 1 FROM cooking_collections WHERE name = '봄날 사과 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '사과', 1 FROM cooking_collections WHERE name = '봄날 사과 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '봄날 카라멜 슈가', 2 FROM cooking_collections WHERE name = '봄날 사과 홍차' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '홍차', 1 FROM cooking_collections WHERE name = '봄날 오렌지 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '오렌지', 1 FROM cooking_collections WHERE name = '봄날 오렌지 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '봄날 카라멜 슈가', 2 FROM cooking_collections WHERE name = '봄날 오렌지 홍차' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '홍차', 1 FROM cooking_collections WHERE name = '봄날 블루베리 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '블루베리', 1 FROM cooking_collections WHERE name = '봄날 블루베리 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '봄날 카라멜 슈가', 2 FROM cooking_collections WHERE name = '봄날 블루베리 홍차' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '홍차', 1 FROM cooking_collections WHERE name = '봄날 라즈베리 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '라즈베리', 1 FROM cooking_collections WHERE name = '봄날 라즈베리 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '봄날 카라멜 슈가', 2 FROM cooking_collections WHERE name = '봄날 라즈베리 홍차' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '홍차', 1 FROM cooking_collections WHERE name = '봄날 딸기 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '딸기', 1 FROM cooking_collections WHERE name = '봄날 딸기 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '봄날 카라멜 슈가', 2 FROM cooking_collections WHERE name = '봄날 딸기 홍차' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '홍차', 1 FROM cooking_collections WHERE name = '봄날 포도 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '포도', 1 FROM cooking_collections WHERE name = '봄날 포도 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '봄날 카라멜 슈가', 2 FROM cooking_collections WHERE name = '봄날 포도 홍차' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '홍차', 1 FROM cooking_collections WHERE name = '봄날 파인애플 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '파인애플', 1 FROM cooking_collections WHERE name = '봄날 파인애플 홍차' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '봄날 카라멜 슈가', 2 FROM cooking_collections WHERE name = '봄날 파인애플 홍차' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '봄날 과일 홍차', 1 FROM cooking_collections WHERE name = '화려한 관람 세트' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '달콤한 듀얼 팝콘통', 1 FROM cooking_collections WHERE name = '화려한 관람 세트' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '나물 로메인 타코', 1 FROM cooking_collections WHERE name = '화려한 관람 세트' AND event_name = '꿈의 명암';

INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '봄날 과일 홍차', 1 FROM cooking_collections WHERE name = '프리미엄 관람 세트' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '짭조름한 더블 버킷', 1 FROM cooking_collections WHERE name = '프리미엄 관람 세트' AND event_name = '꿈의 명암';
INSERT INTO cooking_ingredients (cooking_id, ingredient_name, quantity) SELECT id, '나물 로메인 타코', 2 FROM cooking_collections WHERE name = '프리미엄 관람 세트' AND event_name = '꿈의 명암';
