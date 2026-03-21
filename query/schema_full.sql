SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------------------------
-- 1. NPC 관련 테이블 (Villagers, Roles, Items, Gifts)
-- ------------------------------------------------------

DROP TABLE IF EXISTS `villager_gifts`;
DROP TABLE IF EXISTS `role_items`;
DROP TABLE IF EXISTS `villager_roles`;
DROP TABLE IF EXISTS `villagers`;

CREATE TABLE `villagers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_title` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unlock_condition` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `villager_roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `villager_id` bigint DEFAULT NULL,
  `role_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `villager_id` (`villager_id`),
  CONSTRAINT `villager_roles_ibfk_1` FOREIGN KEY (`villager_id`) REFERENCES `villagers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `role_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `role_items_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `villager_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `villager_gifts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `villager_id` bigint DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_loved` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `villager_id` (`villager_id`),
  CONSTRAINT `villager_gifts_ibfk_1` FOREIGN KEY (`villager_id`) REFERENCES `villagers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------
-- 2. 수집물 관련 테이블 (Fish, Bird, Bug, Animal, Cooking, Crops, Flowers, Forageables)
-- ------------------------------------------------------

DROP TABLE IF EXISTS `cooking_ingredients`;
DROP TABLE IF EXISTS `cooking_collections`;
DROP TABLE IF EXISTS `fish_collections`;
DROP TABLE IF EXISTS `bird_collections`;
DROP TABLE IF EXISTS `bug_collections`;
DROP TABLE IF EXISTS `animal_collections`;
DROP TABLE IF EXISTS `crop_collections`;
DROP TABLE IF EXISTS `flower_collections`;
DROP TABLE IF EXISTS `forageable_collections`;

CREATE TABLE `fish_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `location` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_location` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int DEFAULT NULL,
  `weather` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_1` int DEFAULT NULL,
  `price_2` int DEFAULT NULL,
  `price_3` int DEFAULT NULL,
  `price_4` int DEFAULT NULL,
  `price_5` int DEFAULT NULL,
  `size` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `bird_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `location` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_location` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int DEFAULT NULL,
  `weather` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_1` int DEFAULT NULL,
  `price_2` int DEFAULT NULL,
  `price_3` int DEFAULT NULL,
  `price_4` int DEFAULT NULL,
  `price_5` int DEFAULT NULL,
  `type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `bug_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `location` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_location` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int DEFAULT NULL,
  `weather` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_1` int DEFAULT NULL,
  `price_2` int DEFAULT NULL,
  `price_3` int DEFAULT NULL,
  `price_4` int DEFAULT NULL,
  `price_5` int DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `animal_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `favorite_food` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `favorite_weather` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `cooking_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int DEFAULT NULL,
  `ingredients` text COLLATE utf8mb4_unicode_ci,
  `buy_price` int DEFAULT NULL,
  `price_1` int DEFAULT NULL,
  `price_2` int DEFAULT NULL,
  `price_3` int DEFAULT NULL,
  `price_4` int DEFAULT NULL,
  `price_5` int DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `cooking_ingredients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cooking_id` int NOT NULL,
  `ingredient_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `item_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ci_cooking` (`cooking_id`),
  CONSTRAINT `fk_ci_cooking` FOREIGN KEY (`cooking_id`) REFERENCES `cooking_collections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `crop_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_1` int DEFAULT NULL,
  `price_2` int DEFAULT NULL,
  `price_3` int DEFAULT NULL,
  `price_4` int DEFAULT NULL,
  `price_5` int DEFAULT NULL,
  `level` int DEFAULT NULL,
  `growth_time` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seed_buy_price` int DEFAULT NULL,
  `seed_sell_price` int DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_crop_name` (`name`),
  KEY `idx_crop_location` (`location`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `flower_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_1` int DEFAULT NULL,
  `price_2` int DEFAULT NULL,
  `price_3` int DEFAULT NULL,
  `price_4` int DEFAULT NULL,
  `price_5` int DEFAULT NULL,
  `level` int DEFAULT NULL,
  `growth_time` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seed_buy_price` int DEFAULT NULL,
  `seed_sell_price` int DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_flower_name` (`name`),
  KEY `idx_flower_location` (`location`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `forageable_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` int DEFAULT '0',
  `energy` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `show_on_map` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------
-- 3. 기타 테이블 (Maps, Reports, Stats, Gift Codes)
-- ------------------------------------------------------

DROP TABLE IF EXISTS `map_pins`;
DROP TABLE IF EXISTS `location_zones`;
DROP TABLE IF EXISTS `wiki_reports`;
DROP TABLE IF EXISTS `gift_code`;
DROP TABLE IF EXISTS `visitor_stats`;

CREATE TABLE `map_pins` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `map_x` int DEFAULT '0',
  `map_y` int DEFAULT '0',
  `link_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=462 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `location_zones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `zone_key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '고유 키 (예: 거목강, 온천산)',
  `display_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '표시 이름 (예: 거목 강)',
  `polygon_points` json DEFAULT NULL COMMENT '맵 픽셀 좌표 [[x1,y1],[x2,y2],...]',
  `color` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#4dabf7' COMMENT '폴리곤 색상',
  `parent_zone_key` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '상위 zone 키 (NULL이면 최상위)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `zone_key` (`zone_key`)
) ENGINE=InnoDB AUTO_INCREMENT=260 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `wiki_reports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reporter_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reporter_email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `gift_code` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rewards` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVE',
  `expiration_date` date DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_name` (`code_name`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `visitor_stats` (
  `visit_date` date NOT NULL,
  `visit_count` int DEFAULT '0',
  PRIMARY KEY (`visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
