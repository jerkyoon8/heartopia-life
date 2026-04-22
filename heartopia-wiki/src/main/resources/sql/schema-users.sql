CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    provider VARCHAR(50) NOT NULL COMMENT 'google, naver 등',
    provider_id VARCHAR(255) NOT NULL COMMENT '소셜 로그인 고유 식별자',
    email VARCHAR(255) COMMENT '사용자 이메일',
    nickname VARCHAR(100) NOT NULL COMMENT '표시 이름',
    role VARCHAR(50) NOT NULL DEFAULT 'ROLE_USER' COMMENT '권한 (ROLE_USER, ROLE_ADMIN)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_provider_id (provider, provider_id)
);
