CREATE TABLE IF NOT EXISTS villagers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    sub_title VARCHAR(150),
    image_url VARCHAR(255),
    location VARCHAR(100),
    unlock_condition VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS villager_roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    villager_id BIGINT,
    role_type VARCHAR(50), -- GUIDE, SHOP, EVENT, QUEST
    title VARCHAR(150),    -- Shop Name, Event Name, Quest Title
    description TEXT,      -- Hobby desc, Event desc, Quest details
    FOREIGN KEY (villager_id) REFERENCES villagers(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS role_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_id BIGINT,
    item_name VARCHAR(100),
    FOREIGN KEY (role_id) REFERENCES villager_roles(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS villager_gifts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    villager_id BIGINT,
    item_name VARCHAR(100),
    is_loved BOOLEAN, -- true for Loved, false for Disliked
    FOREIGN KEY (villager_id) REFERENCES villagers(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS map_pins (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50),
    name VARCHAR(100),
    icon_url VARCHAR(255),
    map_x INT DEFAULT 0,
    map_y INT DEFAULT 0,
    link_url VARCHAR(255),
    description TEXT
);
