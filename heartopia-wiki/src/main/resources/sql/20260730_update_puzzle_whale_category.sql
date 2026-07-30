-- 고래 탐사 시즌 퍼즐 99~108번 분류 및 상점 정보 패치
-- 적용 대상: MySQL 8.0 / 기존 puzzle_collections 설치 DB

UPDATE puzzle_collections
SET category = '고래 탐사 시즌',
    acquisition_method = '고래 탐사 시즌-트렌드 상점',
    purchase_price = CONCAT(REPLACE(purchase_price, ' 토큰', ''), ' 토큰')
WHERE catalog_order BETWEEN 99 AND 108;
