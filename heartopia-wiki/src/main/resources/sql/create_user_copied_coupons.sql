-- 유저별 복사한 쿠폰 기록 테이블
CREATE TABLE IF NOT EXISTS user_copied_coupons (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id    BIGINT       NOT NULL,
    coupon_name VARCHAR(100) NOT NULL,
    copied_at  DATETIME     DEFAULT NOW(),
    UNIQUE KEY uq_user_coupon (user_id, coupon_name),
    CONSTRAINT fk_ucc_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
