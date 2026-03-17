use heartopia_db;

CREATE TABLE IF NOT EXISTS cooking_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    level INT,
    ingredients TEXT,
    buy_price INT DEFAULT NULL,
    price_1 INT DEFAULT NULL,
    price_2 INT DEFAULT NULL,
    price_3 INT DEFAULT NULL,
    price_4 INT DEFAULT NULL,
    price_5 INT DEFAULT NULL,
    image_url VARCHAR(255) DEFAULT NULL
);


INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('베지 샐러드', 1, '아무 채소 (2)', NULL, 90, 135, 180, 360, 720, '/images/items/cook/베지 샐러드.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('믹스 잼', 1, '혼합 과일 (4)', NULL, 160, 240, 320, 640, 1280, '/images/items/cook/믹스 잼.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('라즈베리 잼', 1, '라즈베리 (4)', NULL, 250, 375, 500, 1000, 2000, '/images/items/cook/라즈베리 잼.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('케첩', 1, '토마토 (4)', NULL, 180, 270, 360, 720, 1440, '/images/items/cook/케첩.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('블루베리 잼', 1, '블루베리 (4)', NULL, 170, 255, 340, 680, 1360, '/images/items/cook/블루베리 잼.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('사과 잼', 1, '사과 (4)', NULL, 270, 405, 540, 1080, 2160, '/images/items/cook/사과 잼.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('오렌지 잼', 1, '오렌지 (4)', NULL, 270, 405, 540, 1080, 2160, '/images/items/cook/오렌지 잼.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('괴상한 음식', 1, '아무 음식 (1)', NULL, 30, NULL, NULL, NULL, NULL, '/images/items/cook/괴상한 음식.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('괴상한 음료', 1, '아무 음료 (1)', NULL, 30, NULL, NULL, NULL, NULL, '/images/items/cook/괴상한 음료.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('딸기 잼', 1, '딸기 (4)', NULL, 1580, 2370, 3160, 6320, 12640, '/images/items/cook/딸기 잼.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('파인애플 잼', 1, '파인애플 (4)', NULL, 380, 570, 760, 1520, 3040, '/images/items/cook/파인애플 잼.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('포도 잼', 1, '포도 (4)', NULL, 2020, 3030, 4040, 8080, 16160, '/images/items/cook/포도 잼.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('초콜릿 소스', 1, '코코아 (4)', NULL, NULL, NULL, NULL, NULL, NULL, '/images/items/cook/초콜릿 소스.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('피시 앤 칩스', 1, '아무 생선 (2), 감자 (2)', NULL, 310, 465, 620, 1240, 2480, '/images/items/cook/피시 앤 칩스.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('치즈케이크', 1, '치즈 (1), 우유 (1), 밀 (1)', NULL, 480, 720, 960, 1920, 3840, '/images/items/cook/치즈케이크.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('오리지널 롤케이크', 1, '달걀 (1), 우유 (1), 아무 설탕 (2)', NULL, NULL, NULL, NULL, NULL, NULL, '/images/items/cook/오리지널 롤케이크.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('퍼플 롤케이크', 1, '달걀 (1), 우유 (1), 보라 설탕 (2)', NULL, 570, 855, 1140, 2280, 4560, '/images/items/cook/퍼플 롤케이크.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('레드 롤케이크', 1, '달걀 (1), 우유 (1), 빨간 설탕 (2)', NULL, 570, 855, 1140, 2280, 4560, '/images/items/cook/레드 롤케이크.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('오렌지 롤케이크', 1, '달걀 (1), 우유 (1), 주황 설탕 (2)', NULL, 570, 855, 1140, 2280, 4560, '/images/items/cook/오렌지 롤케이크.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('옐로우 롤케이크', 1, '달걀 (1), 우유 (1), 노란 설탕 (2)', NULL, 570, 855, 1140, 2280, 4560, '/images/items/cook/옐로우 롤케이크.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('그린 롤케이크', 1, '달걀 (1), 우유 (1), 초록 설탕 (2)', NULL, 570, 855, 1140, 2280, 4560, '/images/items/cook/그린 롤케이크.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('스카이 롤케이크', 1, '달걀 (1), 우유 (1), 파란 설탕 (2)', NULL, 570, 855, 1140, 2280, 4560, '/images/items/cook/스카이 롤케이크.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('블루 롤케이크', 1, '달걀 (1), 우유 (1), 남색 설탕 (2)', NULL, 570, 855, 1140, 2280, 4560, '/images/items/cook/블루 롤케이크.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('버섯 파이', 1, '아무 버섯 (2), 밀 (1), 달걀 (1)', NULL, 500, 750, 1000, 2000, 4000, '/images/items/cook/버섯 파이.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('느타리버섯 파이', 1, '느타리버섯 (2), 밀 (1), 달걀 (1)', NULL, 500, 750, 1000, 2000, 4000, '/images/items/cook/느타리버섯 파이.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('표고버섯 파이', 1, '표고버섯 (2), 밀 (1), 달걀 (1)', NULL, 500, 750, 1000, 2000, 4000, '/images/items/cook/표고버섯 파이.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('양송이버섯 파이', 1, '양송이버섯 (2), 밀 (1), 달걀 (1)', NULL, 500, 750, 1000, 2000, 4000, '/images/items/cook/양송이버섯 파이.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('그물버섯 파이', 1, '그물버섯 (2), 밀 (1), 달걀 (1)', NULL, 500, 750, 1000, 2000, 4000, '/images/items/cook/그물버섯 파이.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('검은 트러플 파이', 1, '블랙 트러플 (2), 밀 (1), 달걀 (1)', NULL, 830, 1245, 1660, 3320, 6640, '/images/items/cook/검은 트러플 파이.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('구운 버섯', 1, '아무 버섯 (4)', NULL, 180, 270, 360, 720, 1440, '/images/items/cook/구운 버섯.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('구운 느타리버섯', 1, '느타리버섯 (4)', NULL, 180, 270, 360, 720, 1440, '/images/items/cook/구운 느타리버섯.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('구운 표고버섯', 1, '표고버섯 (4)', NULL, 180, 270, 360, 720, 1440, '/images/items/cook/구운 표고버섯.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('구운 양송이버섯', 1, '양송이버섯 (4)', NULL, 180, 270, 360, 720, 1440, '/images/items/cook/구운 양송이버섯.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('구운 그물버섯', 1, '그물버섯 (4)', NULL, 180, 270, 360, 720, 1440, '/images/items/cook/구운 그물버섯.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('커피', 2, '커피 콩 (4)', NULL, 290, 435, 580, 1160, 2320, '/images/items/cook/커피.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('카페라떼', 2, '커피 콩 (2), 우유 (2)', NULL, 300, 450, 600, 1200, 2400, '/images/items/cook/카페라떼.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('훈제 연어 베이글', 2, '아무 생선 (1), 치즈 (1), 아무 채소 (1), 밀 (1)', NULL, 520, 780, 1040, 2080, 4160, '/images/items/cook/훈제 연어 베이글.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('씨푸드 덮밥', 3, '아무 조개류 (2), 밀 (1), 토마토 (1)', NULL, 490, 735, 980, 1960, 3920, '/images/items/cook/씨푸드 덮밥.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('컨트리 스튜', 3, '토마토 (1), 감자 (1), 상추 (1)', NULL, 640, 960, 1280, 2560, 5120, '/images/items/cook/컨트리 스튜.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('검은 트러플 크림 파스타', 3, '블랙 트러플 (1), 밀 (2), 우유 (1)', NULL, 900, 1350, 1800, 3600, 7200, '/images/items/cook/검은 트러플 크림 파스타.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('씨푸드 피자', 4, '치즈 (1), 케첩 (1), 밀 (1), 아무 생선 (1)', NULL, 780, 1170, 1560, 3120, 6240, '/images/items/cook/씨푸드 피자.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('미트소스 파스타', 4, '고기 (1), 밀 (1), 토마토 (1), 치즈 (1)', NULL, 670, 1005, 1340, 2680, 5360, '/images/items/cook/미트소스 파스타.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('애플파이', 5, '사과 (1), 밀 (1), 달걀 (1), 버터 (1)', NULL, 730, 1095, 1460, 2920, 5840, '/images/items/cook/애플파이.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('당근 케이크', 5, '달걀 (1), 밀 (1), 당근 (2)', NULL, 840, 1260, 1680, 3360, 6720, '/images/items/cook/당근 케이크.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('콘수프', 5, '우유 (1), 버터 (1), 옥수수 (2)', NULL, 1340, 2010, 2680, 5360, 10720, '/images/items/cook/콘수프.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('럭셔리 씨푸드 플래터', 6, '유럽민물가재 (2), 아무 생선 (2)', NULL, 410, 615, 820, 1640, 3280, '/images/items/cook/럭셔리 씨푸드 플래터.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('티라미수', 6, '커피 원두 (1), 달걀 (1), 우유 (1), 치즈 (1)', NULL, 530, 795, 1060, 2120, 4240, '/images/items/cook/티라미수.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('캠핑 세트', 7, '아무 커피 (1), 씨푸드 피자 (1), 애플파이 (1), 피시 앤 칩스 (1)', NULL, 2260, 3390, 4520, 9040, 18080, '/images/items/cook/캠핑 세트.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('잉글리시 애프터눈 티', 7, '티라미수 (1), 아무 잼재료 (1)', NULL, 710, 1065, 1420, 2840, 5680, '/images/items/cook/잉글리시 애프터눈 티.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('미트버거', 8, '밀 (1), 상추 (1), 고기 (1), 케첩 (1)', NULL, 1350, 2025, 2700, 5400, 10800, '/images/items/cook/미트버거.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('랍스터 냉채', 8, '아무 랍스터 (3), 상추 (1)', NULL, 850, 1275, 1700, 3400, 6800, '/images/items/cook/랍스터 냉채.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('미트소스 가지 그라탱', 9, '가지 (1), 고기 (1), 식용유 (1), 케첩 (1)', NULL, 1230, 1845, 2460, 4920, 9840, '/images/items/cook/미트소스 가지 그라탱.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('캔들라이트 디너', 9, '베지 샐러드 (1), 훈재 연어 베이글 (1), 씨푸드 덮밥 (1), 티라미수 (1)', NULL, 1760, 2640, 3520, 7040, 14080, '/images/items/cook/캔들라이트 디너.png');
INSERT INTO cooking_collections (name, level, ingredients, buy_price, price_1, price_2, price_3, price_4, price_5, image_url) VALUES ('킹크랩 찜', 10, '아무 킹크랩 (3), 버터 (1)', NULL, 1987, 2980, 3974, 7948, 15896, '/images/items/cook/킹크랩 찜.png');

