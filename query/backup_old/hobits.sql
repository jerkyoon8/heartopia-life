USE heartopia_db;

-- 낚시 정보 테이블
CREATE TABLE IF NOT EXISTS fishing_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '물고기 이름',
    description TEXT COMMENT '도감 설명',
    location VARCHAR(100) COMMENT '출현 장소',
    time_range VARCHAR(50) COMMENT '출현 시간',
    season VARCHAR(50) COMMENT '출현 계절',
    weather VARCHAR(50) COMMENT '날씨 조건',
    sell_price INT DEFAULT 0 COMMENT '판매 가격',
    difficulty INT DEFAULT 1 COMMENT '난이도 (1-5)',
    image_path VARCHAR(255) COMMENT '이미지 경로',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);



-- 곤충 정보 테이블
CREATE TABLE IF NOT EXISTS bug_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '곤충 이름',
    description TEXT COMMENT '도감 설명',
    location VARCHAR(100) COMMENT '채집 장소',
    time_range VARCHAR(50) COMMENT '활동 시간',
    weather VARCHAR(50) COMMENT '날씨 조건',
    sell_price INT DEFAULT 0 COMMENT '판매 가격',
    image_path VARCHAR(255) COMMENT '이미지 경로',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 요리 정보 테이블
CREATE TABLE IF NOT EXISTS cooking_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '요리 이름',
    description TEXT COMMENT '설명',
    ingredients TEXT COMMENT '재료 목록',
    energy_recovery INT DEFAULT 0 COMMENT '에너지 회복량',
    buff_effect VARCHAR(100) COMMENT '버프 효과',
    sell_price INT DEFAULT 0 COMMENT '판매 가격',
    image_path VARCHAR(255) COMMENT '이미지 경로',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 주민 정보 테이블
CREATE TABLE IF NOT EXISTS villager_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '주민 이름',
    job VARCHAR(100) COMMENT '직업',
    birthday VARCHAR(50) COMMENT '생일',
    favorite_gifts TEXT COMMENT '사랑하는 선물',
    hated_gifts TEXT COMMENT '싫어하는 선물',
    image_path VARCHAR(255) COMMENT '이미지 경로',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 확인용 쿼리
SELECT 'Setup Complete' AS Status;
