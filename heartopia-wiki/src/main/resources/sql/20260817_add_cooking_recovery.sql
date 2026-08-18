-- Adds verified 1-5 star recovery values to cooking.
-- Apply this migration BEFORE deploying code that selects the new columns.
-- Recovery values absent from the source remain NULL; no values are inferred.
-- English names intentionally remain outside the service database.

ALTER TABLE cooking_collections
    ADD COLUMN recovery_1 INT NULL AFTER price_5,
    ADD COLUMN recovery_2 INT NULL AFTER recovery_1,
    ADD COLUMN recovery_3 INT NULL AFTER recovery_2,
    ADD COLUMN recovery_4 INT NULL AFTER recovery_3,
    ADD COLUMN recovery_5 INT NULL AFTER recovery_4;

START TRANSACTION;

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '사과 진주 미니케이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '블루베리 진주 미니케이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '사과 잼 오징어구이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '블루베리 잼 오징어구이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '잼 오징어구이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '파인애플 잼 오징어구이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '스타프루트 잼 오징어구이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '딸기 잼 오징어구이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '오렌지 진주 미니케이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '바다의 향연';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '오션 에이드';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '라즈베리 진주 미니케이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '조개 진주 미니케이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '스타프루트 잼';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '스타프루트 진주 미니케이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '토마토 해산물 수프';

UPDATE cooking_collections
SET
    recovery_1 = 40,
    recovery_2 = 48,
    recovery_3 = 56,
    recovery_4 = 64,
    recovery_5 = NULL
WHERE name = '반쵸 추천 바다포도 계란덮밥';

UPDATE cooking_collections
SET
    recovery_1 = 45,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '반쵸 추천 새우튀김 특초밥';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '시나모롤 크레페';

UPDATE cooking_collections
SET
    recovery_1 = 80,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '쿠로미 크레페';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '마이멜로디 크레페';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '사과 잼';

UPDATE cooking_collections
SET
    recovery_1 = 10,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '괴상한 음식';

UPDATE cooking_collections
SET
    recovery_1 = 10,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '괴상한 음료';

UPDATE cooking_collections
SET
    recovery_1 = 80,
    recovery_2 = 96,
    recovery_3 = 112,
    recovery_4 = 128,
    recovery_5 = 160
WHERE name = '검은 트러플 파이';

UPDATE cooking_collections
SET
    recovery_1 = 48,
    recovery_2 = 58,
    recovery_3 = 67,
    recovery_4 = 77,
    recovery_5 = 96
WHERE name = '블루 롤케이크';

UPDATE cooking_collections
SET
    recovery_1 = 22,
    recovery_2 = 26,
    recovery_3 = 31,
    recovery_4 = 35,
    recovery_5 = 44
WHERE name = '블루베리 잼';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '양송이버섯 파이';

UPDATE cooking_collections
SET
    recovery_1 = 80,
    recovery_2 = 96,
    recovery_3 = 112,
    recovery_4 = 128,
    recovery_5 = 160
WHERE name = '초콜릿 소스';

UPDATE cooking_collections
SET
    recovery_1 = 40,
    recovery_2 = 48,
    recovery_3 = 56,
    recovery_4 = 64,
    recovery_5 = 80
WHERE name = '커피';

UPDATE cooking_collections
SET
    recovery_1 = 40,
    recovery_2 = 48,
    recovery_3 = 56,
    recovery_4 = 64,
    recovery_5 = 80
WHERE name = '카페라떼';

UPDATE cooking_collections
SET
    recovery_1 = 55,
    recovery_2 = 66,
    recovery_3 = 77,
    recovery_4 = 88,
    recovery_5 = 110
WHERE name = '부활절 이스터에그 파티';

UPDATE cooking_collections
SET
    recovery_1 = 20,
    recovery_2 = 24,
    recovery_3 = 28,
    recovery_4 = 32,
    recovery_5 = 40
WHERE name = '부활절 달걀';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '바다 아스파라거스 새우 볶음밥';

UPDATE cooking_collections
SET
    recovery_1 = 40,
    recovery_2 = 48,
    recovery_3 = 56,
    recovery_4 = 64,
    recovery_5 = 80
WHERE name = '포도 잼';

UPDATE cooking_collections
SET
    recovery_1 = 50,
    recovery_2 = 60,
    recovery_3 = 70,
    recovery_4 = 80,
    recovery_5 = 100
WHERE name = '잔디 케이크';

UPDATE cooking_collections
SET
    recovery_1 = 50,
    recovery_2 = 60,
    recovery_3 = 70,
    recovery_4 = 80,
    recovery_5 = 100
WHERE name = '부활절 초록 달걀';

UPDATE cooking_collections
SET
    recovery_1 = 48,
    recovery_2 = 58,
    recovery_3 = 67,
    recovery_4 = 77,
    recovery_5 = 96
WHERE name = '그린 롤케이크';

UPDATE cooking_collections
SET
    recovery_1 = 15,
    recovery_2 = 18,
    recovery_3 = 21,
    recovery_4 = 24,
    recovery_5 = 30
WHERE name = '구운 양송이버섯';

UPDATE cooking_collections
SET
    recovery_1 = 15,
    recovery_2 = 18,
    recovery_3 = 21,
    recovery_4 = 24,
    recovery_5 = 30
WHERE name = '구운 버섯';

UPDATE cooking_collections
SET
    recovery_1 = 15,
    recovery_2 = 18,
    recovery_3 = 21,
    recovery_4 = 24,
    recovery_5 = 30
WHERE name = '구운 느타리버섯';

UPDATE cooking_collections
SET
    recovery_1 = 15,
    recovery_2 = 18,
    recovery_3 = 21,
    recovery_4 = 24,
    recovery_5 = 30
WHERE name = '구운 그물버섯';

UPDATE cooking_collections
SET
    recovery_1 = 15,
    recovery_2 = 18,
    recovery_3 = 21,
    recovery_4 = 24,
    recovery_5 = 30
WHERE name = '구운 표고버섯';

UPDATE cooking_collections
SET
    recovery_1 = 15,
    recovery_2 = 18,
    recovery_3 = 21,
    recovery_4 = 24,
    recovery_5 = 30
WHERE name = '베지 샐러드';

UPDATE cooking_collections
SET
    recovery_1 = 48,
    recovery_2 = 58,
    recovery_3 = 67,
    recovery_4 = 77,
    recovery_5 = 96
WHERE name = '스카이 롤케이크';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '오렌지 잼';

UPDATE cooking_collections
SET
    recovery_1 = 22,
    recovery_2 = 26,
    recovery_3 = 31,
    recovery_4 = 35,
    recovery_5 = 44
WHERE name = '믹스 잼';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '버섯 파이';

UPDATE cooking_collections
SET
    recovery_1 = 15,
    recovery_2 = 18,
    recovery_3 = 21,
    recovery_4 = 24,
    recovery_5 = 30
WHERE name = '온천란';

UPDATE cooking_collections
SET
    recovery_1 = 20,
    recovery_2 = 24,
    recovery_3 = 28,
    recovery_4 = 32,
    recovery_5 = 40
WHERE name = '부활절 주황 달걀';

UPDATE cooking_collections
SET
    recovery_1 = 48,
    recovery_2 = 58,
    recovery_3 = 67,
    recovery_4 = 77,
    recovery_5 = 96
WHERE name = '오렌지 롤케이크';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '오리지널 롤케이크';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '느타리버섯 파이';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '그물버섯 파이';

UPDATE cooking_collections
SET
    recovery_1 = 40,
    recovery_2 = 48,
    recovery_3 = 56,
    recovery_4 = 64,
    recovery_5 = 80
WHERE name = '파인애플 잼';

UPDATE cooking_collections
SET
    recovery_1 = 50,
    recovery_2 = 60,
    recovery_3 = 70,
    recovery_4 = 80,
    recovery_5 = 100
WHERE name = '부활절 보라 달걀';

UPDATE cooking_collections
SET
    recovery_1 = 30,
    recovery_2 = 36,
    recovery_3 = 42,
    recovery_4 = 48,
    recovery_5 = 60
WHERE name = '라즈베리 잼';

UPDATE cooking_collections
SET
    recovery_1 = 48,
    recovery_2 = 58,
    recovery_3 = 67,
    recovery_4 = 77,
    recovery_5 = 96
WHERE name = '레드 롤케이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '바다포도 표고버섯 달걀찜';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '표고버섯 파이';

UPDATE cooking_collections
SET
    recovery_1 = 40,
    recovery_2 = 48,
    recovery_3 = 56,
    recovery_4 = 64,
    recovery_5 = 80
WHERE name = '딸기 잼';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '케첩';

UPDATE cooking_collections
SET
    recovery_1 = 48,
    recovery_2 = 58,
    recovery_3 = 67,
    recovery_4 = 77,
    recovery_5 = 96
WHERE name = '퍼플 롤케이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '미역 완자탕';

UPDATE cooking_collections
SET
    recovery_1 = 48,
    recovery_2 = 58,
    recovery_3 = 67,
    recovery_4 = 77,
    recovery_5 = 96
WHERE name = '옐로우 롤케이크';

UPDATE cooking_collections
SET
    recovery_1 = 50,
    recovery_2 = 60,
    recovery_3 = 70,
    recovery_4 = 80,
    recovery_5 = 90
WHERE name = '치즈케이크';

UPDATE cooking_collections
SET
    recovery_1 = 40,
    recovery_2 = 48,
    recovery_3 = 56,
    recovery_4 = 64,
    recovery_5 = 80
WHERE name = '피시 앤 칩스';

UPDATE cooking_collections
SET
    recovery_1 = 50,
    recovery_2 = 60,
    recovery_3 = 70,
    recovery_4 = 80,
    recovery_5 = 90
WHERE name = '훈제 연어 베이글';

UPDATE cooking_collections
SET
    recovery_1 = 90,
    recovery_2 = 108,
    recovery_3 = 126,
    recovery_4 = 144,
    recovery_5 = 180
WHERE name = '검은 트러플 크림 파스타';

UPDATE cooking_collections
SET
    recovery_1 = 60,
    recovery_2 = 72,
    recovery_3 = 84,
    recovery_4 = 96,
    recovery_5 = 120
WHERE name = '컨트리 스튜';

UPDATE cooking_collections
SET
    recovery_1 = 40,
    recovery_2 = 48,
    recovery_3 = 56,
    recovery_4 = 64,
    recovery_5 = 80
WHERE name = '씨푸드 덮밥';

UPDATE cooking_collections
SET
    recovery_1 = 80,
    recovery_2 = 96,
    recovery_3 = 112,
    recovery_4 = 128,
    recovery_5 = 160
WHERE name = '미트소스 파스타';

UPDATE cooking_collections
SET
    recovery_1 = 70,
    recovery_2 = 84,
    recovery_3 = 98,
    recovery_4 = 112,
    recovery_5 = 140
WHERE name = '씨푸드 피자';

UPDATE cooking_collections
SET
    recovery_1 = 70,
    recovery_2 = 84,
    recovery_3 = 98,
    recovery_4 = 112,
    recovery_5 = 140
WHERE name = '애플파이';

UPDATE cooking_collections
SET
    recovery_1 = 55,
    recovery_2 = 66,
    recovery_3 = 77,
    recovery_4 = 88,
    recovery_5 = 99
WHERE name = '당근 케이크';

UPDATE cooking_collections
SET
    recovery_1 = 80,
    recovery_2 = 96,
    recovery_3 = 112,
    recovery_4 = 128,
    recovery_5 = 160
WHERE name = '콘스프';

UPDATE cooking_collections
SET
    recovery_1 = 65,
    recovery_2 = 78,
    recovery_3 = 91,
    recovery_4 = 104,
    recovery_5 = 130
WHERE name = '럭셔리 씨푸드 플래터';

UPDATE cooking_collections
SET
    recovery_1 = 65,
    recovery_2 = 78,
    recovery_3 = 91,
    recovery_4 = 104,
    recovery_5 = 130
WHERE name = '티라미수';

UPDATE cooking_collections
SET
    recovery_1 = 20,
    recovery_2 = 30,
    recovery_3 = 35,
    recovery_4 = 40,
    recovery_5 = 50
WHERE name = '잉글리시 애프터눈 티';

UPDATE cooking_collections
SET
    recovery_1 = 100,
    recovery_2 = 120,
    recovery_3 = 140,
    recovery_4 = 160,
    recovery_5 = 200
WHERE name = '캠핑 세트';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '북유럽파란가재 냉채';

UPDATE cooking_collections
SET
    recovery_1 = 30,
    recovery_2 = 36,
    recovery_3 = 42,
    recovery_4 = 48,
    recovery_5 = 60
WHERE name = '랍스터 냉채';

UPDATE cooking_collections
SET
    recovery_1 = 75,
    recovery_2 = 90,
    recovery_3 = 105,
    recovery_4 = 120,
    recovery_5 = 150
WHERE name = '미트버거';

UPDATE cooking_collections
SET
    recovery_1 = 75,
    recovery_2 = 90,
    recovery_3 = 105,
    recovery_4 = 120,
    recovery_5 = 150
WHERE name = '미트소스 가지 그라탱';

UPDATE cooking_collections
SET
    recovery_1 = 75,
    recovery_2 = 90,
    recovery_3 = 105,
    recovery_4 = 120,
    recovery_5 = 150
WHERE name = '캔들라이트 디너';

UPDATE cooking_collections
SET
    recovery_1 = 100,
    recovery_2 = 120,
    recovery_3 = 140,
    recovery_4 = 160,
    recovery_5 = 200
WHERE name = '황금 킹크랩';

UPDATE cooking_collections
SET
    recovery_1 = 90,
    recovery_2 = 108,
    recovery_3 = 126,
    recovery_4 = 144,
    recovery_5 = 180
WHERE name = '킹크랩 찜';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '사과 밀크세이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '블루베리 밀크세이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '코코아 밀크티';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '초코 밀크세이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '포도 밀크세이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '오렌지 밀크세이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '말차 밀크세이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '진한 홍차';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '밀크티';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '밀크세이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '파인애플 밀크세이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '라즈베리 밀크세이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '딸기 밀크세이크';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '국화차';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '고급 애프터눈 티 세트';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '상큼한 그린 밀크티';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '상큼한 그린티';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '말차 그린 밀크티';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '로즈티';

UPDATE cooking_collections
SET
    recovery_1 = 80,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '치즈 새우와 집게발 튀김';

UPDATE cooking_collections
SET
    recovery_1 = 96,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '새우 아보카도 컵';

UPDATE cooking_collections
SET
    recovery_1 = 50,
    recovery_2 = 60,
    recovery_3 = 70,
    recovery_4 = 80,
    recovery_5 = 100
WHERE name = '캐러멜 팝콘통';

UPDATE cooking_collections
SET
    recovery_1 = 60,
    recovery_2 = 72,
    recovery_3 = 84,
    recovery_4 = 96,
    recovery_5 = NULL
WHERE name = '디럭스 관람 세트';

UPDATE cooking_collections
SET
    recovery_1 = 30,
    recovery_2 = 36,
    recovery_3 = 42,
    recovery_4 = 48,
    recovery_5 = 60
WHERE name = '로메인 타코';

UPDATE cooking_collections
SET
    recovery_1 = 26,
    recovery_2 = 31,
    recovery_3 = 36,
    recovery_4 = 41,
    recovery_5 = 52
WHERE name = '살사 벌집 웨이브 감자칩';

UPDATE cooking_collections
SET
    recovery_1 = 95,
    recovery_2 = 114,
    recovery_3 = 133,
    recovery_4 = 152,
    recovery_5 = 190
WHERE name = '솔티 듀얼 통';

UPDATE cooking_collections
SET
    recovery_1 = 60,
    recovery_2 = 72,
    recovery_3 = 84,
    recovery_4 = 96,
    recovery_5 = 120
WHERE name = '솔티 팝콘통';

UPDATE cooking_collections
SET
    recovery_1 = 45,
    recovery_2 = 54,
    recovery_3 = 63,
    recovery_4 = 72,
    recovery_5 = 90
WHERE name = '봄날 라즈베리 홍차';

UPDATE cooking_collections
SET
    recovery_1 = 45,
    recovery_2 = 54,
    recovery_3 = 63,
    recovery_4 = 72,
    recovery_5 = 90
WHERE name = '봄날 사과 홍차';

UPDATE cooking_collections
SET
    recovery_1 = 45,
    recovery_2 = 54,
    recovery_3 = 63,
    recovery_4 = 72,
    recovery_5 = 90
WHERE name = '봄날 블루베리 홍차';

UPDATE cooking_collections
SET
    recovery_1 = 45,
    recovery_2 = 54,
    recovery_3 = 63,
    recovery_4 = 72,
    recovery_5 = 90
WHERE name = '봄날 과일 홍차';

UPDATE cooking_collections
SET
    recovery_1 = 65,
    recovery_2 = 78,
    recovery_3 = 91,
    recovery_4 = 104,
    recovery_5 = 130
WHERE name = '봄날 포도 홍차';

UPDATE cooking_collections
SET
    recovery_1 = 45,
    recovery_2 = 54,
    recovery_3 = 63,
    recovery_4 = 72,
    recovery_5 = 90
WHERE name = '봄날 오렌지 홍차';

UPDATE cooking_collections
SET
    recovery_1 = 45,
    recovery_2 = 54,
    recovery_3 = 63,
    recovery_4 = 72,
    recovery_5 = 90
WHERE name = '봄날 파인애플 홍차';

UPDATE cooking_collections
SET
    recovery_1 = 60,
    recovery_2 = 72,
    recovery_3 = 84,
    recovery_4 = 96,
    recovery_5 = 120
WHERE name = '봄날 딸기 홍차';

UPDATE cooking_collections
SET
    recovery_1 = 60,
    recovery_2 = 72,
    recovery_3 = 84,
    recovery_4 = 96,
    recovery_5 = NULL
WHERE name = '프리미엄 관람 세트';

UPDATE cooking_collections
SET
    recovery_1 = 90,
    recovery_2 = 108,
    recovery_3 = 126,
    recovery_4 = 144,
    recovery_5 = 180
WHERE name = '스위트 듀얼 통';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '야생 고사리 로메인 타코';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '산우엉 로메인 타코';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '산마늘 로메인 타코';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '산겨자 로메인 타코';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '나물 로메인 타코';

UPDATE cooking_collections
SET
    recovery_1 = 85,
    recovery_2 = 102,
    recovery_3 = 119,
    recovery_4 = 136,
    recovery_5 = NULL
WHERE name = '하트 강아지';

UPDATE cooking_collections
SET
    recovery_1 = 45,
    recovery_2 = 54,
    recovery_3 = 63,
    recovery_4 = 72,
    recovery_5 = 90
WHERE name = '몰티즈 카눌레';

UPDATE cooking_collections
SET
    recovery_1 = 45,
    recovery_2 = 54,
    recovery_3 = 63,
    recovery_4 = 72,
    recovery_5 = 90
WHERE name = '몰티즈 콘파나';

UPDATE cooking_collections
SET
    recovery_1 = 35,
    recovery_2 = 42,
    recovery_3 = 49,
    recovery_4 = 56,
    recovery_5 = 70
WHERE name = '리트리버 카눌레';

UPDATE cooking_collections
SET
    recovery_1 = 45,
    recovery_2 = 54,
    recovery_3 = 63,
    recovery_4 = 72,
    recovery_5 = 90
WHERE name = '리트리버 콘파나';

UPDATE cooking_collections
SET
    recovery_1 = 40,
    recovery_2 = 48,
    recovery_3 = 56,
    recovery_4 = 64,
    recovery_5 = 80
WHERE name = '사각 노른자 고기 쫑즈';

UPDATE cooking_collections
SET
    recovery_1 = 25,
    recovery_2 = 30,
    recovery_3 = 35,
    recovery_4 = 40,
    recovery_5 = 50
WHERE name = '사각 쌀 쫑즈';

UPDATE cooking_collections
SET
    recovery_1 = 25,
    recovery_2 = 30,
    recovery_3 = 35,
    recovery_4 = 40,
    recovery_5 = 50
WHERE name = '사각 팥소 쫑즈';

UPDATE cooking_collections
SET
    recovery_1 = 40,
    recovery_2 = 48,
    recovery_3 = 56,
    recovery_4 = 64,
    recovery_5 = 80
WHERE name = '삼각 노른자 고기 쫑즈';

UPDATE cooking_collections
SET
    recovery_1 = 25,
    recovery_2 = 30,
    recovery_3 = 35,
    recovery_4 = 40,
    recovery_5 = 50
WHERE name = '삼각 쌀 쫑즈';

UPDATE cooking_collections
SET
    recovery_1 = 25,
    recovery_2 = 30,
    recovery_3 = 35,
    recovery_4 = 40,
    recovery_5 = 50
WHERE name = '삼각 통팥 쫑즈';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '사과 버베나 스페셜 파이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '블루베리 버베나 스페셜 파이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 패티 검은 트러플버섯 버거';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 그릇 사과 빙수';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 그릇 블루베리 빙수';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 그릇 프루티 빙수';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 그릇 포도 빙수';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 그릇 오렌지 빙수';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 그릇 파인애플 빙수';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 그릇 라즈베리 빙수';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 그릇 딸기 빙수';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 패티 양송이버섯 버거';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 재미 세트';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 패티 머시룸 버거';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 패티 느타리버섯 버거';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 패티 그물버섯 버거';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '브릭 패티 표고버섯 버거';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '프루티 버베나 스페셜 파이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '포도 버베나 스페셜 파이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '오렌지 버베나 스페셜 파이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '파인애플 버베나 스페셜 파이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '라즈베리 버베나 스페셜 파이';

UPDATE cooking_collections
SET
    recovery_1 = NULL,
    recovery_2 = NULL,
    recovery_3 = NULL,
    recovery_4 = NULL,
    recovery_5 = NULL
WHERE name = '딸기 버베나 스페셜 파이';

UPDATE cooking_collections
SET
    recovery_1 = 20,
    recovery_2 = 24,
    recovery_3 = 28,
    recovery_4 = 32,
    recovery_5 = 40
WHERE name = '무지개 하트 캔디';

UPDATE cooking_collections
SET
    recovery_1 = 20,
    recovery_2 = 24,
    recovery_3 = 28,
    recovery_4 = 32,
    recovery_5 = 40
WHERE name = '무지개 심쿵 젤리';

UPDATE cooking_collections
SET
    recovery_1 = 25,
    recovery_2 = 30,
    recovery_3 = 35,
    recovery_4 = 40,
    recovery_5 = 50
WHERE name = '사과 슈가파우더 팬케이크';

UPDATE cooking_collections
SET
    recovery_1 = 40,
    recovery_2 = 48,
    recovery_3 = 56,
    recovery_4 = 64,
    recovery_5 = 80
WHERE name = '오로라 만찬';

UPDATE cooking_collections
SET
    recovery_1 = 25,
    recovery_2 = 30,
    recovery_3 = 35,
    recovery_4 = 40,
    recovery_5 = 50
WHERE name = '블루베리 슈가파우더 팬케이크';

UPDATE cooking_collections
SET
    recovery_1 = 25,
    recovery_2 = 30,
    recovery_3 = 35,
    recovery_4 = 40,
    recovery_5 = 50
WHERE name = '무 크림 수프';

UPDATE cooking_collections
SET
    recovery_1 = 20,
    recovery_2 = 24,
    recovery_3 = 28,
    recovery_4 = 32,
    recovery_5 = 40
WHERE name = '얼음컵 커피';

UPDATE cooking_collections
SET
    recovery_1 = 20,
    recovery_2 = 24,
    recovery_3 = 28,
    recovery_4 = 32,
    recovery_5 = 40
WHERE name = '얼음컵 라떼';

UPDATE cooking_collections
SET
    recovery_1 = 25,
    recovery_2 = 30,
    recovery_3 = 35,
    recovery_4 = 40,
    recovery_5 = 50
WHERE name = '오렌지 슈가파우더 팬케이크';

UPDATE cooking_collections
SET
    recovery_1 = 25,
    recovery_2 = 30,
    recovery_3 = 35,
    recovery_4 = 40,
    recovery_5 = 50
WHERE name = '오리지널 슈가파우더 팬케이크';

UPDATE cooking_collections
SET
    recovery_1 = 25,
    recovery_2 = 30,
    recovery_3 = 35,
    recovery_4 = 40,
    recovery_5 = 50
WHERE name = '라즈베리 슈가파우더 팬케이크';

UPDATE cooking_collections
SET
    recovery_1 = 40,
    recovery_2 = 48,
    recovery_3 = 56,
    recovery_4 = 64,
    recovery_5 = 80
WHERE name = '갈은 무와 스테이크';

COMMIT;

-- Verification: expected 176 total rows and 111 rows with numeric recovery.
SELECT
    COUNT(*) AS total_rows,
    SUM(recovery_1 IS NOT NULL) AS recovery_rows
FROM cooking_collections;
