CREATE TABLE IF NOT EXISTS user_checklist (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT       NOT NULL,
    item_key    VARCHAR(100) NOT NULL,
    star_rating TINYINT      NOT NULL DEFAULT 0,
    updated_at  DATETIME     DEFAULT NOW() ON UPDATE NOW(),
    UNIQUE KEY uq_user_checklist (user_id, item_key),
    CONSTRAINT fk_uch_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
