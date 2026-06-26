CREATE TABLE IF NOT EXISTS user_pet_food (
    user_id    BIGINT   NOT NULL PRIMARY KEY,
    pets_json  LONGTEXT NOT NULL,
    updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT fk_upf_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
