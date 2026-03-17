-- =========================================================
-- Heartopia Wiki - Full Database Schema
-- Last Updated: 2026-03-18 (Updated with DROP TABLE for full sync)
-- Description: 일관된 도감 데이터 및 테이블 구조 관리를 위한 통합 스키마 정의
-- =========================================================

CREATE DATABASE IF NOT EXISTS heartopia_db;
USE heartopia_db;

-- 외래 키 체크 해제 (테이블 드롭을 위해)
SET FOREIGN_KEY_CHECKS = 0;

-- 1. 물고기 도감 (Fish Collections)
DROP TABLE IF EXISTS fish_collections;
CREATE TABLE fish_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(100),
    sub_location VARCHAR(100),
    name VARCHAR(100) NOT NULL UNIQUE,
    level INT,
    weather VARCHAR(100),
    time VARCHAR(100),
    price_1 INT DEFAULT 0,
    price_2 INT DEFAULT 0,
    price_3 INT DEFAULT 0,
    price_4 INT DEFAULT 0,
    price_5 INT DEFAULT 0,
    size VARCHAR(50),
    image_url VARCHAR(255)
);

-- 2. 조류 도감 (Bird Collections)
DROP TABLE IF EXISTS bird_collections;
CREATE TABLE bird_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(100),
    sub_location VARCHAR(100),
    name VARCHAR(100) NOT NULL UNIQUE,
    level INT,
    weather VARCHAR(100),
    time VARCHAR(100),
    price_1 INT DEFAULT 0,
    price_2 INT DEFAULT 0,
    price_3 INT DEFAULT 0,
    price_4 INT DEFAULT 0,
    price_5 INT DEFAULT 0,
    type VARCHAR(50) COMMENT '조류 유형 (예: 소형, 중형)',
    image_url VARCHAR(255)
);

-- 3. 곤충 도감 (Bug Collections)
DROP TABLE IF EXISTS bug_collections;
CREATE TABLE bug_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(100),
    sub_location VARCHAR(100),
    name VARCHAR(100) NOT NULL UNIQUE,
    level INT,
    weather VARCHAR(100),
    time VARCHAR(100),
    max_stars INT DEFAULT 5,
    price_1 INT DEFAULT 0,
    price_2 INT DEFAULT 0,
    price_3 INT DEFAULT 0,
    price_4 INT DEFAULT 0,
    price_5 INT DEFAULT 0,
    image_url VARCHAR(255)
);

-- 4. 동물 도감 (Animal Collections)
DROP TABLE IF EXISTS animal_collections;
CREATE TABLE animal_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100),
    description TEXT,
    favorite_food VARCHAR(100),
    favorite_weather VARCHAR(100),
    image_url VARCHAR(255)
);

-- 5. 요리 도감 (Cooking Collections)
DROP TABLE IF EXISTS cooking_collections;
CREATE TABLE cooking_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    level INT,
    ingredients TEXT COMMENT '재료 요약 텍스트',
    buy_price INT DEFAULT 0,
    price_1 INT DEFAULT 0,
    price_2 INT DEFAULT 0,
    price_3 INT DEFAULT 0,
    price_4 INT DEFAULT 0,
    price_5 INT DEFAULT 0,
    image_url VARCHAR(255)
);

-- 6. 요리 상세 재료 (Cooking Ingredients)
DROP TABLE IF EXISTS cooking_ingredients;
CREATE TABLE cooking_ingredients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cooking_id INT NOT NULL,
    ingredient_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    item_type VARCHAR(30) DEFAULT NULL COMMENT '연관 아이템 타입 (crop, fish 등)',
    item_id INT DEFAULT NULL COMMENT '연관 아이템의 PK',
    CONSTRAINT fk_ci_cooking FOREIGN KEY (cooking_id) REFERENCES cooking_collections(id) ON DELETE CASCADE
);

-- 7. 채집물 도감 (Forageable Collections)
DROP TABLE IF EXISTS forageable_collections;
CREATE TABLE forageable_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100),
    price INT DEFAULT 0,
    energy INT DEFAULT 0,
    image_url VARCHAR(255)
);

-- 8. 작물 도감 (Crop Collections)
DROP TABLE IF EXISTS crop_collections;
CREATE TABLE crop_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    level INT,
    growth_time VARCHAR(50),
    seed_buy_price INT DEFAULT 0,
    seed_sell_price INT DEFAULT 0,
    price_1 INT DEFAULT 0,
    price_2 INT DEFAULT 0,
    price_3 INT DEFAULT 0,
    price_4 INT DEFAULT 0,
    price_5 INT DEFAULT 0,
    image_url VARCHAR(255)
);

-- 9. 꽃 도감 (Flower Collections)
DROP TABLE IF EXISTS flower_collections;
CREATE TABLE flower_collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    level INT,
    growth_time VARCHAR(50),
    seed_buy_price INT DEFAULT 0,
    seed_sell_price INT DEFAULT 0,
    price_1 INT DEFAULT 0,
    price_2 INT DEFAULT 0,
    price_3 INT DEFAULT 0,
    price_4 INT DEFAULT 0,
    price_5 INT DEFAULT 0,
    image_url VARCHAR(255)
);

-- 10. 주민 정보 (Villagers)
DROP TABLE IF EXISTS villagers;
CREATE TABLE villagers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    sub_title VARCHAR(150),
    image_url VARCHAR(255),
    location VARCHAR(100),
    unlock_condition VARCHAR(255)
);

DROP TABLE IF EXISTS villager_roles;
CREATE TABLE villager_roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    villager_id BIGINT,
    role_type VARCHAR(50), -- GUIDE, SHOP, EVENT, QUEST
    title VARCHAR(150),
    description TEXT,
    FOREIGN KEY (villager_id) REFERENCES villagers(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS role_items;
CREATE TABLE role_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_id BIGINT,
    item_name VARCHAR(100),
    FOREIGN KEY (role_id) REFERENCES villager_roles(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS villager_gifts;
CREATE TABLE villager_gifts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    villager_id BIGINT,
    item_name VARCHAR(100),
    is_loved BOOLEAN,
    FOREIGN KEY (villager_id) REFERENCES villagers(id) ON DELETE CASCADE
);

-- 11. 지도 핀 (Map Pins)
DROP TABLE IF EXISTS map_pins;
CREATE TABLE map_pins (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50),
    name VARCHAR(100),
    icon_url VARCHAR(255),
    map_x INT DEFAULT 0,
    map_y INT DEFAULT 0,
    link_url VARCHAR(255),
    description TEXT
);

-- 12. 위치 구역 (Location Zones)
DROP TABLE IF EXISTS location_zones;
CREATE TABLE location_zones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    zone_key VARCHAR(50) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    polygon_points JSON NULL,
    color VARCHAR(20) NOT NULL DEFAULT '#4dabf7',
    parent_zone_key VARCHAR(50) NULL
);

-- 13. 오류 신고 (Wiki Reports)
DROP TABLE IF EXISTS wiki_reports;
CREATE TABLE wiki_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    reporter_name VARCHAR(100) NOT NULL,
    reporter_email VARCHAR(100),
    message TEXT NOT NULL,
    source_url VARCHAR(255),
    item_name VARCHAR(100),
    password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 14. 기프트 코드 (Gift Codes)
DROP TABLE IF EXISTS gift_code;
CREATE TABLE gift_code (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code_name VARCHAR(50) NOT NULL UNIQUE,
    rewards VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    expiration_date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 15. 방문자 통계 (Visitor Stats)
DROP TABLE IF EXISTS visitor_stats;
CREATE TABLE visitor_stats (
    visit_date DATE PRIMARY KEY,
    visit_count INT NOT NULL DEFAULT 0
);

-- 외래 키 체크 복구
SET FOREIGN_KEY_CHECKS = 1;
