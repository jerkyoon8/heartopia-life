
-- 모래 조각 도감
CREATE TABLE IF NOT EXISTS sandbox_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE COMMENT '모래 조각 이름',
    level INT NULL COMMENT '요구 레벨',
    time VARCHAR(100) NOT NULL COMMENT '시간',
    weather VARCHAR(100) NOT NULL COMMENT '날씨',
    shape VARCHAR(100) NOT NULL COMMENT '조형물 힌트',
    shape_image_url VARCHAR(255) NULL COMMENT '조형물 이미지 경로',
    dialogue_option VARCHAR(100) NULL COMMENT '대화 선택지',
    price INT NULL COMMENT '판매가',
    image_url VARCHAR(255) NULL COMMENT '이미지 경로',
    sort_order INT NOT NULL DEFAULT 0,
    event_name VARCHAR(100) NULL DEFAULT NULL
);

SET @add_shape_image_url_sql := (
    SELECT IF(
        COUNT(*) = 0,
        'ALTER TABLE sandbox_collections ADD COLUMN shape_image_url VARCHAR(255) NULL COMMENT ''조형물 이미지 경로'' AFTER shape',
        'DO 0'
    )
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'sandbox_collections'
      AND COLUMN_NAME = 'shape_image_url'
);
PREPARE add_shape_image_url_stmt FROM @add_shape_image_url_sql;
EXECUTE add_shape_image_url_stmt;
DEALLOCATE PREPARE add_shape_image_url_stmt;

ALTER TABLE sandbox_collections
    MODIFY COLUMN event_name VARCHAR(100) NULL DEFAULT NULL;

INSERT INTO sandbox_collections
    (name, level, time, weather, shape, shape_image_url, dialogue_option, price, image_url, sort_order, event_name)
VALUES
    ('실패', 1, '상시', '상시', '모양이 나온 뒤 틀린 선택지를 고르면 실패', NULL, NULL, 140, '/images/others/sandbox/07_제작실패.webp', 1, NULL),
    ('자동차', 1, '상시', '상시', '납작한 사다리꼴 모래 더미', '/images/others/sandbox/shapes/01_계단형_블록_A.png', '미니자동차', 155, '/images/others/sandbox/02_자동차.webp', 2, NULL),
    ('개구리', 1, '상시', '상시', '납작한 사다리꼴 모래 더미', '/images/others/sandbox/shapes/01_계단형_블록_A.png', '웅크린 개구리', 155, '/images/others/sandbox/03_청개구리.webp', 3, NULL),
    ('소라게', 1, '12:00~24:00', '상시', '납작한 사다리꼴 모래 더미', '/images/others/sandbox/shapes/01_계단형_블록_A.png', '게', 165, '/images/others/sandbox/06_소라게.webp', 4, NULL),
    ('오리', 1, '상시', '상시', '납작한 사다리꼴 모래 더미', '/images/others/sandbox/shapes/01_계단형_블록_A.png', '오리', 155, '/images/others/sandbox/01_노란오리.webp', 5, NULL),
    ('토끼', 1, '상시', '상시', '낮고 둥근 원통형 모래 더미', '/images/others/sandbox/shapes/03_원기둥형_블록.png', '앉은 토끼', 155, '/images/others/sandbox/04_토끼.webp', 6, NULL),
    ('등대', 1, '00:00~06:00 / 18:00~24:00', '상시', '낮고 둥근 원통형 모래 더미', '/images/others/sandbox/shapes/03_원기둥형_블록.png', '등대', 165, '/images/others/sandbox/05_등대.webp', 7, NULL),
    ('배', 2, '상시', '상시', '납작한 각기둥 모양 모래 더미', '/images/others/sandbox/shapes/02_각기둥형_블록.png', '유람선', 190, '/images/others/sandbox/08_배.webp', 8, NULL),
    ('아기곰', 2, '상시', '상시', '납작한 각기둥 모양 모래 더미', '/images/others/sandbox/shapes/02_각기둥형_블록.png', '곰', 190, '/images/others/sandbox/12_곰.webp', 9, NULL),
    ('갈매기', 3, '상시', '상시', '높고 큰 계단형 모래 더미', '/images/others/sandbox/shapes/04_계단형_블록_B.png', '바다갈매기', 225, '/images/others/sandbox/11_갈매기.webp', 10, NULL),
    ('고래', 3, '상시', '상시', '높고 큰 계단형 모래 더미', '/images/others/sandbox/shapes/04_계단형_블록_B.png', '고래', 225, '/images/others/sandbox/09_고래.webp', 11, NULL),
    ('북극곰', 4, '상시', '상시', '높은 원기둥형 모래더미', '/images/others/sandbox/shapes/03_원기둥형_블록.png', '앉은 북극곰', 225, '/images/others/sandbox/10_북극곰.webp', 12, NULL),
    ('모아이', 4, '상시', '상시', '높은 원기둥형 모래더미', '/images/others/sandbox/shapes/03_원기둥형_블록.png', '석상', 225, '/images/others/sandbox/13_모아이거상.webp', 13, NULL),
    ('선인장', 5, '상시', '비/무지개', '높은 원기둥형 모래더미', '/images/others/sandbox/shapes/03_원기둥형_블록.png', NULL, 280, '/images/others/sandbox/14_선인장.webp', 14, NULL),
    ('근육고양이', 5, '상시', '무지개', '높고 큰 계단형 모래 더미', '/images/others/sandbox/shapes/04_계단형_블록_B.png', NULL, 280, '/images/others/sandbox/15_고양이.webp', 15, NULL) AS new
ON DUPLICATE KEY UPDATE
    level = new.level,
    time = new.time,
    weather = new.weather,
    shape = new.shape,
    shape_image_url = new.shape_image_url,
    dialogue_option = new.dialogue_option,
    price = new.price,
    image_url = new.image_url,
    sort_order = new.sort_order,
    event_name = new.event_name;

UPDATE sandbox_collections
SET event_name = NULL
WHERE event_name = '고래 시즌';
