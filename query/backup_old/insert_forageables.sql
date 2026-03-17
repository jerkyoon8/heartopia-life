CREATE TABLE IF NOT EXISTS forageable_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    price INT DEFAULT 0,
    energy VARCHAR(50),
    image_url VARCHAR(255)
);

INSERT INTO forageable_collections (name, location, price, energy, image_url) VALUES
('송이버섯', 'Forest (Spirit Oak Pine)', 0, '+5', '/images/collections/forage/matsutake.png'),
('관목 가지', 'Bushes', 5, NULL, '/images/collections/forage/branch.png'),
('목재', 'Tree', 6, NULL, '/images/collections/forage/timber.png'),
('대나무', 'Bamboo', 7, NULL, '/images/collections/forage/bamboo.png'),
('돌', 'Home', 8, NULL, '/images/collections/forage/stone.png'),
('고급 목재', 'Tree', 12, NULL, '/images/collections/forage/quality_timber.png'),
('광석', 'Home', 14, NULL, '/images/collections/forage/ore.png'),
('블루베리', 'Home', 16, '+5', '/images/collections/forage/blueberry.png'),
('표고버섯', 'Fishing Village', 16, '+5', '/images/collections/forage/shiitake.png'),
('이상한 표고버섯 (검정)', 'Fishing Village', 16, NULL, '/images/collections/forage/bizarre_shiitake_black.png'),
('이상한 표고버섯 (빨강)', 'Fishing Village', 16, NULL, '/images/collections/forage/bizarre_shiitake_red.png'),
('이상한 표고버섯 (파랑)', 'Fishing Village', 16, NULL, '/images/collections/forage/bizarre_shiitake_blue.png'),
('양송이버섯', 'Flower Field', 16, '+5', '/images/collections/forage/button_mushroom.png'),
('이상한 양송이버섯 (파랑)', 'Flower Field', 16, NULL, '/images/collections/forage/bizarre_button_mushroom_blue.png'),
('이상한 양송이버섯 (핑크)', 'Flower Field', 16, NULL, '/images/collections/forage/bizarre_button_mushroom_pink.png'),
('이상한 양송이버섯 (초록)', 'Flower Field', 16, NULL, '/images/collections/forage/bizarre_button_mushroom_green.png'),
('그물버섯', 'Forest', 16, '+5', '/images/collections/forage/penny_bun.png'),
('이상한 그물버섯 (보라)', 'Forest', 16, NULL, '/images/collections/forage/bizarre_penny_bun_purple.png'),
('이상한 그물버섯 (빨강)', 'Forest', 16, NULL, '/images/collections/forage/bizarre_penny_bun_red.png'),
('이상한 그물버섯 (핑크)', 'Forest', 16, NULL, '/images/collections/forage/bizarre_penny_bun_pink.png'),
('느타리버섯', 'Onsen Mountain', 16, '+5', '/images/collections/forage/oyster_mushroom.png'),
('이상한 느타리버섯 (핑크)', 'Onsen Mountain', 16, NULL, '/images/collections/forage/bizarre_oyster_mushroom_pink.png'),
('이상한 느타리버섯 (보라)', 'Onsen Mountain', 16, NULL, '/images/collections/forage/bizarre_oyster_mushroom_purple.png'),
('이상한 느타리버섯 (주황)', 'Onsen Mountain', 16, NULL, '/images/collections/forage/bizarre_oyster_mushroom_orange.png'),
('라즈베리', 'Home', 26, '+7', '/images/collections/forage/raspberry.png'),
('사과', 'Home', 28, '+8', '/images/collections/forage/apple.png'),
('귤 (오렌지)', 'Home', 28, '+8', '/images/collections/forage/mandarin.png'),
('희귀 목재', 'Gigantic Tree in the Suburb', 50, NULL, '/images/collections/forage/rare_timber.png'),
('검은 트러플', 'Forest (Forest Island)', 99, '+25', '/images/collections/forage/black_truffle.png'),
('방랑하는 오크 목재', 'Roaming Oak-Oak', 150, NULL, '/images/collections/forage/roaming_oak_timber.png'),
('완벽한 형석', 'Fluorite Mine', 150, NULL, '/images/collections/forage/flawless_fluorite.png'),
('별똥별 조각', 'Meteor Shower (Meteorite Ore)', 150, NULL, '/images/collections/forage/starfall_shard.png');


-- 이미지 경로 업데이트 SQL
UPDATE forageable_collections SET image_url = '/images/collections/forage/관목 가지.png' WHERE name = '관목 가지';
UPDATE forageable_collections SET image_url = '/images/collections/forage/목재.png' WHERE name = '목재';
UPDATE forageable_collections SET image_url = '/images/collections/forage/대나무.png' WHERE name = '대나무';
UPDATE forageable_collections SET image_url = '/images/collections/forage/돌.png' WHERE name = '돌';
UPDATE forageable_collections SET image_url = '/images/collections/forage/고급 목재.png' WHERE name = '고급 목재';
UPDATE forageable_collections SET image_url = '/images/collections/forage/광석.png' WHERE name = '광석';
UPDATE forageable_collections SET image_url = '/images/collections/forage/블루베리.png' WHERE name = '블루베리';
UPDATE forageable_collections SET image_url = '/images/collections/forage/표고버섯.png' WHERE name = '표고버섯';
UPDATE forageable_collections SET image_url = '/images/collections/forage/이상한 표고버섯(회색).png' WHERE name = '이상한 표고버섯 (검정)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/이상한 표고버섯(빨강).png' WHERE name = '이상한 표고버섯 (빨강)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/이상한 표고버섯(하늘).png' WHERE name = '이상한 표고버섯 (파랑)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/양송이버섯.png' WHERE name = '양송이버섯';
UPDATE forageable_collections SET image_url = '/images/collections/forage/이상한 양송이 버섯(파랑).png' WHERE name = '이상한 양송이버섯 (파랑)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/이상한 양송이 버섯(핑크).png' WHERE name = '이상한 양송이버섯 (핑크)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/이상한 양송이 버섯(초록).png' WHERE name = '이상한 양송이버섯 (초록)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/그물버섯.png' WHERE name = '그물버섯';
UPDATE forageable_collections SET image_url = '/images/collections/forage/이상한 그물버섯(파랑).png' WHERE name = '이상한 그물버섯 (보라)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/이상한 그물버섯(빨강).png' WHERE name = '이상한 그물버섯 (빨강)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/이상한 그물버섯(핑크).png' WHERE name = '이상한 그물버섯 (핑크)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/느타리버섯.png' WHERE name = '느타리버섯';
UPDATE forageable_collections SET image_url = '/images/collections/forage/이상한 느타리버섯(핑크).png' WHERE name = '이상한 느타리버섯 (핑크)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/이상한 느타리버섯(파랑).png' WHERE name = '이상한 느타리버섯 (보라)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/이상한 느타리버섯(주황).png' WHERE name = '이상한 느타리버섯 (주황)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/라즈베리.png' WHERE name = '라즈베리';
UPDATE forageable_collections SET image_url = '/images/collections/forage/사과.png' WHERE name = '사과';
UPDATE forageable_collections SET image_url = '/images/collections/forage/오렌지.png' WHERE name = '귤 (오렌지)';
UPDATE forageable_collections SET image_url = '/images/collections/forage/희귀 목재.png' WHERE name = '희귀 목재';
UPDATE forageable_collections SET image_url = '/images/collections/forage/검은 트러플.png' WHERE name = '검은 트러플';

-- 이미지가 없는 항목은 명시적으로 null 처리 (생성이 안 된 경우 대비)
UPDATE forageable_collections SET image_url = NULL WHERE name IN ('송이버섯', '방랑하는 오크 목재', '완벽한 형석', '별똥별 조각');

-- [1단계] 기존 중복 데이터 삭제 (테이블 초기화)
TRUNCATE TABLE forageable_collections;
-- 만약 TRUNCATE 권한 에러가 발생하면 아래 DELETE 문을 사용해 보세요:
-- DELETE FROM forageable_collections WHERE id > 0;

-- [2단계] 정확한 32개 데이터 등록 (이름, 이미지 경로 매칭 완료)
INSERT INTO forageable_collections (name, location, price, energy, image_url) VALUES
('송이버섯', 'Forest (Spirit Oak Pine)', 0, '+5', NULL),
('관목 가지', 'Bushes', 5, NULL, '/images/collections/forage/관목 가지.png'),
('목재', 'Tree', 6, NULL, '/images/collections/forage/목재.png'),
('대나무', 'Bamboo', 7, NULL, '/images/collections/forage/대나무.png'),
('돌', 'Home', 8, NULL, '/images/collections/forage/돌.png'),
('고급 목재', 'Tree', 12, NULL, '/images/collections/forage/고급 목재.png'),
('광석', 'Home', 14, NULL, '/images/collections/forage/광석.png'),
('블루베리', 'Home', 16, '+5', '/images/collections/forage/블루베리.png'),
('표고버섯', 'Fishing Village', 16, '+5', '/images/collections/forage/표고버섯.png'),
('이상한 표고버섯 (검정)', 'Fishing Village', 16, NULL, '/images/collections/forage/이상한 표고버섯(회색).png'),
('이상한 표고버섯 (빨강)', 'Fishing Village', 16, NULL, '/images/collections/forage/이상한 표고버섯(빨강).png'),
('이상한 표고버섯 (파랑)', 'Fishing Village', 16, NULL, '/images/collections/forage/이상한 표고버섯(하늘).png'),
('양송이버섯', 'Flower Field', 16, '+5', '/images/collections/forage/양송이버섯.png'),
('이상한 양송이버섯 (파랑)', 'Flower Field', 16, NULL, '/images/collections/forage/이상한 양송이 버섯(파랑).png'),
('이상한 양송이버섯 (핑크)', 'Flower Field', 16, NULL, '/images/collections/forage/이상한 양송이 버섯(핑크).png'),
('이상한 양송이버섯 (초록)', 'Flower Field', 16, NULL, '/images/collections/forage/이상한 양송이 버섯(초록).png'),
('그물버섯', 'Forest', 16, '+5', '/images/collections/forage/그물버섯.png'),
('이상한 그물버섯 (보라)', 'Forest', 16, NULL, '/images/collections/forage/이상한 그물버섯(파랑).png'),
('이상한 그물버섯 (빨강)', 'Forest', 16, NULL, '/images/collections/forage/이상한 그물버섯(빨강).png'),
('이상한 그물버섯 (핑크)', 'Forest', 16, NULL, '/images/collections/forage/이상한 그물버섯(핑크).png'),
('느타리버섯', 'Onsen Mountain', 16, '+5', '/images/collections/forage/느타리버섯.png'),
('이상한 느타리버섯 (핑크)', 'Onsen Mountain', 16, NULL, '/images/collections/forage/이상한 느타리버섯(핑크).png'),
('이상한 느타리버섯 (보라)', 'Onsen Mountain', 16, NULL, '/images/collections/forage/이상한 느타리버섯(파랑).png'),
('이상한 느타리버섯 (주황)', 'Onsen Mountain', 16, NULL, '/images/collections/forage/이상한 느타리버섯(주황).png'),
('라즈베리', 'Home', 26, '+7', '/images/collections/forage/라즈베리.png'),
('사과', 'Home', 28, '+8', '/images/collections/forage/사과.png'),
('귤 (오렌지)', 'Home', 28, '+8', '/images/collections/forage/오렌지.png'),
('희귀 목재', 'Gigantic Tree in the Suburb', 50, NULL, '/images/collections/forage/희귀 목재.png'),
('검은 트러플', 'Forest (Forest Island)', 99, '+25', '/images/collections/forage/검은 트러플.png'),
('방랑하는 오크 목재', 'Roaming Oak-Oak', 150, NULL, NULL),
('완벽한 형석', 'Fluorite Mine', 150, NULL, NULL),
('별똥별 조각', 'Meteor Shower (Meteorite Ore)', 150, NULL, NULL);
