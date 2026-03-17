use heartopia_db;

CREATE TABLE IF NOT EXISTS fish_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(50),
    sub_location VARCHAR(100),
    name VARCHAR(50),
    level INT,
    weather VARCHAR(50),
    time VARCHAR(50),
    price_1 INT, price_2 INT, price_3 INT, price_4 INT, price_5 INT,
    size VARCHAR(20)
);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '전체', '민물배스', 1, NULL, NULL, 75, 112, 150, 300, 600, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '전체', '왕새우', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '전체, 인어집어기 사용하여 반짝이는 파란 그림자', '틸라피아', 1, NULL, NULL, 320, 480, 640, 1280, 2560, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '얕은 강', '바벨', 1, NULL, NULL, 75, 112, 150, 300, 600, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '얕은 강', '큰가시고기', 7, '비/무지개', NULL, 150, 225, 300, 600, 1200, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '고요한 강', '미노우', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '고요한 강', '민물대구', 4, NULL, '12~24', 230, 345, 460, 920, 1840, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '고요한 강', '첨연어', 6, '무지개', NULL, 150, 225, 300, 600, 1200, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '거목 강', '하늘종개', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '거목 강', '민물잰더', 3, '해/무지개', NULL, 230, 345, 460, 920, 1840, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '거목 강', '레드벨리피라냐', 4, NULL, NULL, 230, 345, 460, 920, 1840, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '거목 강', '후첸', 9, '무지개', '0~6 / 12~24', 380, 570, 760, 1520, 3040, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '노을 강', '큰얼룩배스', 1, NULL, NULL, 50, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('강', '노을 강', '유럽잉어', 4, '해/무지개', '12~24', 230, 345, 460, 920, 1840, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '전체', '유럽처브', 1, NULL, NULL, 75, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '전체', '유럽백조어', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '전체, 인어집어기 사용하여 반짝이는 파란 그림자', '유럽참개구리', 1, NULL, NULL, 320, 480, 640, 1280, 2560, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '숲속 호수', '텐치', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '숲속 호수', '머드개복치', 2, NULL, '6~24', 100, 150, 200, 400, 800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '숲속 호수', '유럽민물가재', 3, NULL, '0~12 / 18~24', 100, 150, 200, 400, 800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '숲속 호수', '큰입배스', 4, '해/무지개', NULL, 230, 345, 460, 920, 1840, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '숲속 호수', '큰진주조개', 6, '무지개', NULL, 380, 570, 760, 1520, 3040, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '숲속 호수', '북유럽파란가재', 8, NULL, '0~6  / 18~24', 250, 375, 500, 1000, 2000, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '숲속 호수', '북극곤들매기', 10, '비/무지개', '12~24', 610, 915, 1220, 2440, 4880, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '숲속 호수', '버들붕어', 12, '비/무지개', '12~24', 0, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '근교 호수', '붕어', 1, NULL, NULL, 75, 112, 150, 300, 600, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '근교 호수', '백조어', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '근교 호수', '돌마자', 2, NULL, NULL, 100, 150, 200, 400, 800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '근교 호수', '홍합', 3, '비/무지개', NULL, 100, 150, 200, 400, 800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '근교 호수', '민물게', 4, NULL, NULL, 100, 150, 200, 400, 800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '근교 호수', '루드', 5, NULL, NULL, 150, 225, 300, 600, 1200, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '근교 호수', '사루기', 6, NULL, NULL, 230, 345, 460, 920, 1840, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '근교 호수', '줄무늬송사리', 7, '해/무지개', '0~6 / 12~24', 150, 225, 300, 600, 1200, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '근교 호수', '펄고기', 8, '해/무지개', '0~12', 250, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '근교 호수', '강꼬치고기', 9, '비/무지개', '0~6  / 18~24', 610, 915, 1220, 2440, 4880, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '근교 호수', '엔젤피쉬', 12, '무지개', '0~6 / 18~24', 0, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '온천산 호수', '극지연어', 1, NULL, NULL, 105, 157, 210, 420, 840, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '온천산 호수', '매화농어', 2, NULL, '12~24', 100, 150, 200, 400, 800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '온천산 호수', '올챙이', 3, '비/무지개', NULL, 100, 150, 200, 400, 800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '온천산 호수', '둑중개', 7, '비/무지개', '6~24', 150, 225, 300, 600, 1200, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '온천산 호수', '펌프킨시드', 9, '해/무지개', '6~24', 250, 375, 500, 1000, 2000, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '온천산 호수', '블루길', 10, '해/무지개', '0~6 / 18~24', 395, 592, 790, 1580, 3160, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '온천산 호수', '라이언헤드', 11, '무지개', NULL, 0, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '초원 호수', '바다빙어', 2, NULL, NULL, 100, 150, 200, 400, 800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '초원 호수', '나비잉어', 4, '비/무지개', NULL, 320, 480, 640, 1280, 2560, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '초원 호수', '송어', 5, '해/무지개', '0~6 / 18~24', 230, 345, 460, 920, 1840, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '초원 호수', '유럽메기', 10, '해/무지개', '0~6 / 18~24', 610, 915, 1220, 2440, 4880, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('호수', '초원 호수', '금룡어', 11, '무지개', '0~12 / 18~24', 0, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '전체', '정어리', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '전체', '배스', 1, NULL, NULL, 75, 112, 150, 300, 600, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '전체', '가다랑어', 1, NULL, NULL, 210, 315, 420, 840, 1680, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '전체, 인어집어기 사용하여 반짝이는 파란 그림자', '대서양은상어', 2, NULL, NULL, 320, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '잔잔한 바다', '갈치', 1, NULL, NULL, 105, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '잔잔한 바다', '노란전갱이', 3, NULL, NULL, 155, 232, 310, 620, 1240, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '잔잔한 바다', '대서양난쟁이문어', 4, NULL, NULL, 150, 225, 300, 600, 1200, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '잔잔한 바다', '유럽가재', 5, NULL, '0~6 / 18~24', 230, 345, 460, 920, 1840, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '잔잔한 바다', '검은점돔', 7, '비/무지개', '0~6 / 18~24', 230, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '잔잔한 바다', '참다랑어', 9, '무지개', '6~18', 850, 1275, 1700, 3400, 6800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '잔잔한 바다', '자리돔', 11, '해/무지개', '12~24', 0, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '동해', '바다새우', 1, NULL, NULL, 50, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '동해', '소라게', 3, NULL, NULL, 100, 150, 200, 400, 800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '동해', '망둥어', 4, NULL, '6~18', 150, 225, 300, 600, 1200, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '동해', '등불성대', 6, '무지개', NULL, 380, 570, 760, 1520, 3040, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '동해', '해덕대구', 8, '해/무지개', '0~6 / 12~24', 230, 345, 460, 920, 1840, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '동해', '개복치', 9, NULL, '0~12', 850, 1275, 1700, 3400, 6800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '고래바다', '전갱이', 1, NULL, NULL, 50, 75, 100, 200, 400, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '고래바다', '해마', 3, NULL, '0~18', 100, 150, 200, 400, 800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '고래바다', '대서양연어', 4, NULL, '0~6 / 12~24', 155, 232, 310, 620, 1240, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '고래바다', '대서양고등어', 5, '해/무지개', '12~24', 150, 225, 300, 600, 1200, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '고래바다', '황새치', 10, '무지개', '6~18', 850, 1275, 1700, 3400, 6800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '고래바다', '바다거북', 12, '무지개', '12~24', 0, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '구해', '바다가시고기', 2, NULL, NULL, 50, 75, 100, 200, 400, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '구해', '흰동가리', 3, NULL, NULL, 100, 150, 200, 400, 800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '구해', '유럽가자미', 4, NULL, '0~6 / 18~24', 230, 345, 460, 920, 1840, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '구해', '복어', 6, NULL, '12~24', 230, 345, 460, 920, 1840, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '구해', '유럽장어', 7, '무지개', '6~24', 380, 570, 760, 1520, 3040, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '구해', '귀상어', 10, '무지개', '0~6 / 18~24', 850, 1275, 1700, 3400, 6800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '구해', '만새기', 12, '무지개', '6~18', 0, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '구해', '블루탱', 13, '비/무지개', '0~6 / 12~24', 0, 0, 0, 0, 0, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '바다낚시 사건', '노랑촉수', 2, NULL, NULL, 320, 480, 640, 1280, 2560, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '바다낚시 사건', '아귀', 3, NULL, NULL, 320, 480, 640, 1280, 2560, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '바다낚시 사건', '참문어', 4, NULL, NULL, 320, 480, 640, 1280, 2560, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '바다낚시 사건', '대문짝넙치', 4, NULL, NULL, 320, 480, 640, 1280, 2560, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '바다낚시 사건', '유럽날오징어', 5, NULL, NULL, 320, 480, 640, 1280, 2560, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '바다낚시 사건', '두툽상어', 6, NULL, NULL, 535, 802, 1070, 2140, 4280, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '바다낚시 사건', '산갈치', 7, NULL, '6~18', 535, 802, 1070, 2140, 4280, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '바다낚시 사건', '황금킹크랩', 8, '무지개', NULL, 850, 1275, 1700, 3400, 6800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '바다낚시 사건', '달고기', 9, NULL, '0~6 / 18~24', 850, 1275, 1700, 3400, 6800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '바다낚시 사건', '청상아리', 10, '무지개', '6~18', 850, 1275, 1700, 3400, 6800, NULL);
INSERT INTO fish_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5, size) VALUES ('바다', '바다낚시 사건', '고래상어', 11, '해/무지개', '0~12 / 18~24', 0, 0, 0, 0, 0, NULL);

select * from fish_collections;

CREATE TABLE IF NOT EXISTS bird_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(50),
    sub_location VARCHAR(100),
    name VARCHAR(50),
    level INT,
    weather VARCHAR(50),
    time VARCHAR(50),
    price_1 INT, price_2 INT, price_3 INT, price_4 INT, price_5 INT
);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('물가', NULL, '큰홍학', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('호수', NULL, '청둥오리', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('강', NULL, '홍머리오리', 2, NULL, NULL, 17, 68, 136, 272, 544);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('강', NULL, '호사북방오리', 3, NULL, NULL, 17, 68, 136, 272, 544);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('해변', NULL, '바다갈매기', 2, NULL, NULL, 17, 68, 136, 272, 544);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('바다', NULL, '유럽가마우지', 3, NULL, NULL, 17, 68, 136, 272, 544);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('블랑코 머리 위', NULL, '오목눈이', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('새들의 복귀 사건', NULL, '청금강앵무', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('새들의 복귀 사건', NULL, '청공작', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('새들의 복귀 사건', NULL, '홍금강앵무', 3, NULL, NULL, 15, 60, 120, 240, 480);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('새들의 복귀 사건', NULL, '초록금강앵무', 5, '해/무지개', NULL, 15, 60, 120, 240, 480);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('새들의 복귀 사건', NULL, '히아신스금강앵무', 7, '비/무지개', NULL, 65, 260, 520, 1040, 2080);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('홈', NULL, '염주비둘기', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('홈', NULL, '유럽꾀꼬리', 3, NULL, NULL, 15, 60, 120, 240, 480);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '모든 숲', '굴뚝새', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '모든 숲', '웡가비둘기', 2, NULL, NULL, 15, 60, 120, 240, 480);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '순록탑', '황조롱이', 7, '해/무지개', NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '순록탑', '수리부엉이', 10, '비/무지개', NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '영혼의 참나무 숲', '노란머리바우어새', 4, NULL, NULL, 17, 68, 136, 272, 544);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '영혼의 참나무 숲', '홍방울새', 8, NULL, NULL, 22, 90, 180, 360, 720);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '영혼의 참나무 숲', '흰올빼미', 12, NULL, '12~24', 65, 260, 520, 1040, 2080);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '숲속 섬', '솔양진이', 4, NULL, NULL, 17, 68, 136, 272, 544);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '숲속 호수', '흰비오리', 4, NULL, NULL, 17, 68, 136, 272, 544);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '숲속 호수', '작은홍학', 5, '비/무지개', NULL, 27, 108, 216, 432, 864);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '점핑플랫폼', '검은턱오목눈이', 3, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '점핑플랫폼', '파랑딱새', 10, '무지개', NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '점핑플랫폼', '안경 올빼미', 14, NULL, '0~12', 65, 260, 520, 1040, 2080);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '동해 해변', '제비갈매기', 7, '무지개', NULL, 22, 90, 180, 360, 720);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '도심', '꼬까울새', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '도심', '분홍가슴비둘기', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '도시 근교', '멋쟁이새', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '도시 근교', '빨간머리때까치', 2, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '도시 근교', '잠부과일비둘기', 7, NULL, NULL, 27, 108, 216, 432, 864);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '도시 근교', '동부파랑새', 8, '비/무지개', NULL, 22, 90, 180, 360, 720);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '근교 호수', '황오리', 3, NULL, NULL, 17, 68, 136, 272, 544);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '근교 호수', '큰고니', 13, '해/무지개', NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '근교 호수', '흑고니', 13, '비/무지개', NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '교외 (근교 바깥)', '극락풍금조', 9, '무지개', NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '교외 (근교 바깥)', '푸른머리비둘기', 11, '해/무지개', '0~6 / 12~24', 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '전체', '얼룩비둘기', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '전체', '동고비', 2, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '어촌광장', '회색머리붉은참새', 4, '해/무지개', NULL, 17, 68, 136, 272, 544);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '부두', '노랑배딱새', 5, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '동쪽 부두', '황금가슴비둘기', 6, NULL, NULL, 27, 108, 216, 432, 864);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '등대', '녹자작', 3, NULL, NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '등대', '아조레스멋쟁이새', 10, '무지개', NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '잔잔한 바다', '황제가마우지', 9, NULL, NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '잔잔한 바다', '푸른발얼가니새', 12, '비/무지개', NULL, 65, 260, 520, 1040, 2080);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '전체', '푸른머리되새', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '전체', '분홍목녹색비둘기', 2, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '고래산', '분홍비둘기', 8, NULL, NULL, 27, 108, 216, 432, 864);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '고래바다 / 구해', '붉은뺨가마우지', 6, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '고래바다 해변', '오두앵갈매기', 3, NULL, NULL, 17, 68, 136, 272, 544);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '고래바다 해변', '코뿔바다오리', 12, '해/무지개', '0~12 / 18~24', 65, 260, 520, 1040, 2080);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '보라빛해변', '알락할미새', 4, NULL, NULL, 17, 68, 136, 272, 544);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '보라빛해변', '아메리카홍학', 9, '무지개', NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '풍차꽃밭', '황금과일비둘기', 4, NULL, NULL, 22, 90, 180, 360, 720);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '풍차꽃밭', '푸른박새', 7, NULL, NULL, 22, 90, 180, 360, 720);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '풍차꽃밭', '쇠찌르레기', 11, NULL, NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '초원 호수', '먹황새', 14, NULL, '0~6 / 12~24', 65, 260, 520, 1040, 2080);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '전체', '노랑배박새', 1, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '전체', '수염오목눈이', 2, NULL, NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '온천', '올리브비둘기', 5, NULL, NULL, 27, 108, 216, 432, 864);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '온천', '매', 8, '비/무지개', NULL, 65, 260, 520, 1040, 2080);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '화산 호수', '콩새', 6, NULL, NULL, 15, 60, 120, 240, 480);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '화산 호수', '붉은눈썹핀치', 12, '무지개', NULL, 65, 260, 520, 1040, 2080);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '바위절벽', '칡부엉이', 6, '해/무지개', NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '유적', '은계', 4, NULL, NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '유적', '비둘기조롱이', 10, NULL, NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '온천산 호수', '유럽벌잡이새', 5, '비/무지개', NULL, 10, 40, 80, 160, 320);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '온천산 호수', '흰머리오리', 9, '비/무지개', NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '온천산 호수', '가창오리', 11, '무지개', NULL, 47, 190, 380, 760, 1520);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '구해 해변', '검정제비갈매기', 5, NULL, NULL, 17, 68, 136, 272, 544);
INSERT INTO bird_collections (location, sub_location, name, level, weather, time, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '구해 해변', '잉카제비갈매기', 11, '비/무지개', '6~24', 47, 190, 380, 760, 1520);

CREATE TABLE IF NOT EXISTS bug_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(50),
    sub_location VARCHAR(100),
    name VARCHAR(50),
    level INT,
    weather VARCHAR(50),
    time VARCHAR(50),
    max_stars INT,
    price_1 INT, price_2 INT, price_3 INT, price_4 INT, price_5 INT
);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('예외', '유인기 필요', '슬코스키몰포나비', 1, '-', '-', 5, 300, 1200, 2400, 4800, 9600);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('물가', '-', '큰고추잠자리', 1, '-', '-', 5, 63, 252, 504, 1008, 2016);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('강변', '-', '밀잠자리', 4, '비/무지개', '-', 5, 93, 372, 744, 1488, 2976);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('이벤트', '유인사건', '아폴로모시나비', 1, '-', '-', 5, 265, 1060, 2120, 4240, 8480);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('이벤트', '유인사건', '붉은고리호랑나비', 1, '-', '-', 5, 280, 1120, 2240, 4480, 8960);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('이벤트', '유인사건', '분홍색철써기', 3, '-', '-', 5, 295, 1180, 2360, 4720, 9440);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('이벤트', '유인사건', '흰마녀밤나방', 5, '해/무지개', '-', 5, 485, 1940, 3880, 7760, 15520);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('이벤트', '유인사건', '왕나비', 7, '비/무지개', '-', 5, 1000, 4000, 8000, 16000, 32000);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('이벤트', '유인사건', '무지개사슴벌레', 9, '-', '-', 5, 710, 2840, 5680, 11360, 22720);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('홈', '-', '별노린재', 1, '-', '-', 5, 55, 220, 440, 880, 1760);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('홈', '-', '파란꽃풍뎅이', 2, '비/무지개', '-', 5, 93, 372, 744, 1488, 2976);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('홈', '-', '붉은목제비나비', 3, '-', '0~6 / 18~24', 5, 138, 552, 1104, 2208, 4416);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '전체', '호랑나비', 1, '-', '-', 5, 40, 160, 320, 640, 1280);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '전체', '말벌호랑하늘소', 2, '-', '-', 5, 85, 340, 680, 1360, 2720);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '순록탑', '흰점꼬리털벌', 3, '-', '6~24', 5, 130, 520, 1040, 2080, 4160);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '순록탑', '이색무당벌레', 5, '비/무지개', '0~6 / 12~24', 5, 175, 700, 1400, 2800, 5600);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '순록탑', '헤쿠바몰포나비', 10, '무지개', '6~18', 5, 300, 1200, 2400, 4800, 9600);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '순록탑', '나선주머니나방', 10, '해/무지개', '0~6 / 18~24', 5, 220, 880, 1760, 3520, 7040);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '영혼참나무', '매미', 4, '-', '0~6 / 12~24', 5, 95, 380, 760, 1520, 3040);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '영혼참나무', '메넬라우스나비', 7, '해/무지개', '6~24', 5, 415, 1660, 3320, 6640, 13280);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '영혼참나무', '이사벨라나방', 8, '해/무지개', '12~24', 5, 375, 1500, 3000, 6000, 12000);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '영혼참나무', '왕사슴벌레', 9, '비/무지개', '0~6 / 18~24', 5, 620, 2480, 4960, 9920, 19840);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '숲속섬', '고산수염하늘소', 5, '무지개', '-', 5, 205, 820, 1640, 3280, 6560);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '숲속호수', '물잠자리', 6, '비/무지개', '-', 5, 130, 520, 1040, 2080, 4160);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '점핑플랫폼', '산악사슴벌레', 6, '비/무지개', '6~24', 5, 550, 2200, 4400, 8800, 17600);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('숲', '점핑플랫폼', '황금보석풍뎅이', 7, '해/무지개', '12~24', 5, 470, 1880, 3760, 7520, 15040);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '도심', '유럽갈고리나비', 1, '-', '-', 5, 40, 160, 320, 640, 1280);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '도심', '연푸른부전나비', 2, '-', '-', 5, 70, 280, 560, 1120, 2240);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '근교', '멧노랑나비', 1, '-', '-', 5, 40, 160, 320, 640, 1280);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '근교', '칠성무당벌레', 2, '비/무지개', '-', 5, 85, 340, 680, 1360, 2720);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '근교', '긴꼬리산누에나방', 3, '해/무지개', '6~24', 5, 145, 580, 1160, 2320, 4640);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '근교', '큰줄무늬메뚜기', 4, '해/무지개', '0~6 / 12~24', 5, 48, 192, 384, 768, 1536);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '근교', '녹색날개호랑나비', 6, '-', '0~12 / 18~24', 5, 213, 852, 1704, 3408, 6816);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '근교', '혜성꼬리나방', 8, '해/무지개', '0~6 / 18~24', 5, 775, 3100, 6200, 12400, 24800);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('도시', '근교호수', '넉점박이잠자리', 2, '비/무지개', '-', 5, 93, 372, 744, 1488, 2976);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '전체', '배추흰나비', 1, '-', '-', 5, 40, 160, 320, 640, 1280);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '전체', '망치다리메뚜기', 2, '-', '-', 5, 70, 280, 560, 1120, 2240);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '어촌광장', '개미', 3, '-', '-', 5, 50, 200, 400, 800, 1600);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '어촌광장', '장수풍뎅이', 8, '해/무지개', '0~6 / 18~24', 5, 480, 1920, 3840, 7680, 15360);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '어촌광장', '푸른곰벌', 9, '무지개', '0~6 / 12~24', 5, 45, 180, 360, 720, 1440);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '부두', '표범무늬네발나비', 4, '비/무지개', '0~12 / 18~24', 5, 138, 552, 1104, 2208, 4416);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('어촌', '등대', '파란노린재', 6, '-', '6~18', 5, 45, 180, 360, 720, 1440);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '전체', '아스파라거스벌레', 1, '-', '-', 5, 55, 220, 440, 880, 1760);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '전체', '호박벌', 2, '-', '-', 5, 100, 400, 800, 1600, 3200);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '전체', '진주네발나비', 9, '비/무지개', '0~12', 5, 310, 1240, 2480, 4960, 9920);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '고래산', '보라네발나비', 3, '해/무지개', '0~6 / 12~24', 5, 130, 520, 1040, 2080, 4160);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '고래산', '보라벌', 5, '해/무지개', '-', 5, 67, 268, 536, 1072, 2144);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '고래산', '보석꽃풍뎅이', 7, '비/무지개', '6~18', 5, 470, 1880, 3760, 7520, 15040);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '보라해변', '여치', 3, '-', '-', 5, 48, 192, 384, 768, 1536);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '보라해변', '피카소노린재', 8, '해/무지개', '0~6 / 18~24', 5, 530, 2120, 4240, 8480, 16960);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '보라해변', '헬레나몰포나비', 10, '무지개', '6~18', 5, 300, 1200, 2400, 4800, 9600);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('꽃밭', '풍차꽃밭', '공작나비', 5, '-', '-', 5, 198, 792, 1584, 3168, 6336);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '전체', '오아시스메뚜기', 2, '-', '-', 5, 115, 460, 920, 1840, 3680);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '전체', '녹색호랑풍뎅이', 2, '-', '-', 5, 78, 312, 624, 1248, 2496);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '온천', '홍날개', 3, '-', '-', 5, 123, 492, 984, 1968, 3936);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '온천', '신선나비', 5, '해/무지개', '0~18', 5, 265, 1060, 2120, 4240, 8480);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '화산호수', '사성무당벌레', 4, '비/무지개', '-', 5, 123, 492, 984, 1968, 3936);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '화산호수', '헤라클레스풍뎅이', 10, '해/무지개', '12~24', 5, 575, 2300, 4600, 9200, 18400);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '바위절벽', '무지개사마귀', 4, '해/무지개', '0~6 / 12~24', 5, 160, 640, 1280, 2560, 5120);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '바위절벽', '은빛보석풍뎅이', 6, '해/무지개', '0~18', 5, 440, 1760, 3520, 7040, 14080);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '유적', '파푸아사마귀', 5, '해/무지개', '-', 5, 515, 2060, 4120, 8240, 16480);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '유적', '티폰쇠똥구리', 7, '-', '0~18', 5, 420, 1680, 3360, 6720, 13440);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '유적', '악마꽃사마귀', 9, '비/무지개', '12~24', 5, 800, 3200, 6400, 12800, 25600);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('온천산', '온천산호수', '찔레잠자리', 7, '무지개', '0~6 / 12~24', 5, 925, 3700, 7400, 14800, 29600);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('미정', '-', '알렉산드라비단제비나비', 11, '해/무지개', '0~6 / 18~24', 5, 250, 1000, 2000, 4000, 8000);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('미정', '-', '아틀라스장수풍뎅이', 11, '무지개', '0~6 / 12~24', 5, 775, 3100, 6200, 12400, 24800);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('미정', '-', '십삼점무당벌레', 11, '무지개', '12~24', 5, 150, 600, 1200, 2400, 4800);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('미정', '-', '난초사마귀', 11, '비/무지개', '8~18', 5, 1150, 4600, 9200, 18400, 36800);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('미정', '-', '장미청띠제비나비', 12, '비/무지개', '6~12/18~24', 5, 310, 1240, 2480, 4960, 9920);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('미정', '-', '골리앗대왕꽃무지', 12, '무지개', '0~6 / 18~24', 5, 850, 3400, 6800, 13600, 27200);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('미정', '-', '유대하늘소', 12, '비/무지개', '6~18', 5, 1035, 4140, 8280, 16560, 33120);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('미정', '-', '불꽃잠자리', 12, '무지개', '6~18', 5, 925, 3700, 7400, 14800, 29600);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('미정', '-', '몰포나비(몽환나비)', 13, '무지개', '12~24', 5, 415, 1660, 3320, 6640, 13280);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('미정', '-', '화려한색날개잠자리', 13, '비/무지개', '12~24', 5, 925, 3700, 7400, 14800, 29600);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('미정', '-', '투명날개나비', 14, '무지개', '12~24', 5, 655, 2620, 5240, 10480, 20960);
INSERT INTO bug_collections (location, sub_location, name, level, weather, time, max_stars, price_1, price_2, price_3, price_4, price_5) VALUES ('미정', '-', '초록달팽이', 14, '비/무지개', '-', 5, 50, 200, 400, 800, 1600);