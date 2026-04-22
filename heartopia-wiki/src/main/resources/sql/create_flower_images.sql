-- flower_images 테이블 생성: 꽃 1개당 여러 이미지(레벨별/변종별) 저장
-- flower_collections.id는 INT이므로 flower_id도 INT로 맞춤
CREATE TABLE IF NOT EXISTS flower_images (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    flower_id  INT          NOT NULL,
    image_url  VARCHAR(500) NOT NULL,
    sort_order INT          NOT NULL DEFAULT 0,
    CONSTRAINT fk_flower_images_flower
        FOREIGN KEY (flower_id) REFERENCES flower_collections(id) ON DELETE CASCADE,
    INDEX idx_flower_images_flower_id (flower_id)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON heartopia_db.flower_images TO 'wiki_user'@'localhost';
FLUSH PRIVILEGES;