-- 바다 청소 도감
-- 실행 전: --default-character-set=utf8mb4 설정 권장
-- 이미지 파일명 예외 매칭:
--   루시나 조개 -> 루시나 조개.webp
--   미니 거미고둥 -> 미니 거미 고둥.webp
--   라파고둥 -> 라파고둥.webp
-- 숙련도는 info.txt 하단 값을 사용한다. 상단의 명인 값은 별도 정보이므로 여기에서 사용하지 않는다.
-- 시간대 기준: 새벽 0~6, 오전 6~12, 오후 12~18, 저녁 18~24

CREATE TABLE IF NOT EXISTS sea_cleaning_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE COMMENT '바다 청소 수집품 이름',
    level INT NULL COMMENT '도감 레벨',
    time VARCHAR(100) NOT NULL DEFAULT '미공개' COMMENT '등장 시간',
    weather VARCHAR(100) NOT NULL DEFAULT '미공개' COMMENT '날씨 조건',
    location VARCHAR(100) NOT NULL DEFAULT '미공개' COMMENT '획득 장소',
    proficiency INT NULL COMMENT '숙련도',
    gold_price_1 INT NULL COMMENT '알버트 JR 판매 골드 1성',
    gold_price_2 INT NULL COMMENT '알버트 JR 판매 골드 2성',
    gold_price_3 INT NULL COMMENT '알버트 JR 판매 골드 3성',
    gold_price_4 INT NULL COMMENT '알버트 JR 판매 골드 4성',
    gold_price_5 INT NULL COMMENT '알버트 JR 판매 골드 5성',
    image_url VARCHAR(255) NULL COMMENT '이미지 경로',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '정렬 순서',
    event_name VARCHAR(100) NULL DEFAULT NULL COMMENT '이벤트명',
    mastery_beginner_max INT NULL COMMENT '명인/숙련 단계: 초보 최대값',
    mastery_intro_min INT NULL COMMENT '명인/숙련 단계: 입문 최소값',
    mastery_expert_min INT NULL COMMENT '명인/숙련 단계: 전문가 최소값',
    mastery_master_min INT NULL COMMENT '명인/숙련 단계: 명인 최소값',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_sea_cleaning_level (level),
    INDEX idx_sea_cleaning_event_name (event_name),
    INDEX idx_sea_cleaning_sort_order (sort_order)
);

ALTER TABLE sea_cleaning_collections ALTER COLUMN event_name SET DEFAULT NULL;

INSERT INTO sea_cleaning_collections (
    name, level, time, weather, location, proficiency,
    gold_price_1, gold_price_2, gold_price_3, gold_price_4, gold_price_5,
    image_url, sort_order, event_name,
    mastery_beginner_max, mastery_intro_min, mastery_expert_min, mastery_master_min
) VALUES
    ('손상된 조개껍데기', 1, '상시', '상시', '바다 청소', NULL, 2, 4, 6, 8, 16, '/images/others/sea-cleaning/손상된 조개껍데기.webp', 1, NULL, NULL, NULL, NULL, NULL),
    ('고토이 심해고둥', 1, '0~12 / 18~24', '상시', '바다 청소', 85, 50, 100, 150, 200, 400, '/images/others/sea-cleaning/고토이 심해고둥.webp', 2, NULL, NULL, NULL, NULL, NULL),
    ('루시나 조개', 1, '0~6 / 12~24', '상시', '바다 청소', 60, 85, 170, 255, 340, 680, '/images/others/sea-cleaning/루시나 조개.webp', 3, NULL, NULL, NULL, NULL, NULL),
    ('미니 거미고둥', 1, '0~18', '상시', '바다 청소', 85, 50, 100, 150, 200, 400, '/images/others/sea-cleaning/미니 거미 고둥.webp', 4, NULL, NULL, NULL, NULL, NULL),
    ('개구리소라', 1, '0~6 / 12~24', '상시', '바다 청소', 85, 50, 100, 150, 200, 400, '/images/others/sea-cleaning/개구리소라.webp', 5, NULL, NULL, NULL, NULL, NULL),
    ('은빛 대합', 1, '0~18', '상시', '바다 청소', 75, 65, 130, 195, 260, 520, '/images/others/sea-cleaning/은빛 대합.webp', 6, NULL, NULL, NULL, NULL, NULL),
    ('요카별고둥', 1, '미공개', '미공개', '미공개', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL),
    ('난초뿔고둥', 2, '0~6 / 12~24', '상시', '바다 청소', 75, 65, 130, 195, 260, 520, '/images/others/sea-cleaning/난초뿔고둥.webp', 8, NULL, NULL, NULL, NULL, NULL),
    ('뱃머리 벚꽃조개', 2, '0~18', '상시', '바다 청소', 60, 85, 170, 255, 340, 680, '/images/others/sea-cleaning/뱃머리 벚꽃조개.webp', 9, NULL, NULL, NULL, NULL, NULL),
    ('매끈투구고둥', 2, '미공개', '미공개', '미공개', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, NULL),
    ('흰꽈리조개', 3, '미공개', '미공개', '미공개', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11, NULL, NULL, NULL, NULL, NULL),
    ('흰작은가시고둥', 3, '0~6 / 12~24', '상시', '바다 청소', 85, 50, 100, 150, 200, 400, '/images/others/sea-cleaning/흰작은가시고둥.webp', 12, NULL, NULL, NULL, NULL, NULL),
    ('사프란 대왕조개', 3, '0~18', '상시', '바다 청소', 75, 65, 130, 195, 260, 520, '/images/others/sea-cleaning/사프란 대왕조개.webp', 13, NULL, NULL, NULL, NULL, NULL),
    ('가는줄갯고둥', 4, '0~6 / 12~24', '상시', '바다 청소', 75, 65, 130, 195, 260, 520, '/images/others/sea-cleaning/가는줄갯고둥.webp', 14, NULL, NULL, NULL, NULL, NULL),
    ('해시계고둥', 4, '0~12 / 18~24', '상시', '바다 청소', 60, 85, 170, 255, 340, 680, '/images/others/sea-cleaning/해시계고둥.webp', 15, NULL, NULL, NULL, NULL, NULL),
    ('사마귀알고둥', 4, '0~12 / 18~24', '상시', '바다 청소', 75, 65, 130, 195, 260, 520, '/images/others/sea-cleaning/사마귀알고둥.webp', 16, NULL, NULL, NULL, NULL, NULL),
    ('등롱 화염고둥', 5, '미공개', '미공개', '미공개', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17, NULL, NULL, NULL, NULL, NULL),
    ('라티악시스 마와', 5, '0~6 / 12~24', '상시', '바다 청소', NULL, 50, 100, 150, 200, 400, '/images/others/sea-cleaning/라티악시스 마와.webp', 18, NULL, NULL, NULL, NULL, NULL),
    ('라파고둥', 5, '0~6 / 12~24', '상시', '바다 청소', NULL, 85, 170, 255, 340, 680, '/images/others/sea-cleaning/라파고둥.webp', 19, NULL, NULL, NULL, NULL, NULL),
    ('꽃송이 원뿔고둥', 6, '미공개', '미공개', '미공개', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20, NULL, NULL, NULL, NULL, NULL),
    ('카누 두루마리고둥', 6, '0~12 / 18~24', '상시', '바다 청소', NULL, 65, 130, 195, 260, 520, NULL, 21, NULL, NULL, NULL, NULL, NULL) AS new
ON DUPLICATE KEY UPDATE
    level = new.level,
    time = new.time,
    weather = new.weather,
    location = new.location,
    proficiency = new.proficiency,
    gold_price_1 = new.gold_price_1,
    gold_price_2 = new.gold_price_2,
    gold_price_3 = new.gold_price_3,
    gold_price_4 = new.gold_price_4,
    gold_price_5 = new.gold_price_5,
    image_url = new.image_url,
    sort_order = new.sort_order,
    event_name = new.event_name,
    mastery_beginner_max = new.mastery_beginner_max,
    mastery_intro_min = new.mastery_intro_min,
    mastery_expert_min = new.mastery_expert_min,
    mastery_master_min = new.mastery_master_min;
