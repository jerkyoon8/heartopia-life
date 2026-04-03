USE heartopia_db;
CREATE TABLE notice (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 초기 공지 하나 삽입
INSERT INTO notice (title, content, is_active) VALUES ('꿈의 명암 요리 정보도 추가되었습니다', '꿈의 명암 요리 정보도 추가되었습니다...', TRUE);

INSERT INTO gift_code (code_name, rewards, status, expiration_date, created_at, updated_at)
VALUES ('a4k9m7q2r6', '소원별 5개, 향수 3개, 비료 10개', 'SOON', '2026-04-01', NOW(), NOW());