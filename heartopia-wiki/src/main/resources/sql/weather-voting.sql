-- 아시아 서버 참여형 날씨 제보
-- MySQL 8.0 / 실행 전 users 테이블이 존재해야 한다.
-- 테이블 생성 후 애플리케이션 계정 권한도 반드시 적용해야 한다.
-- 로컬: weather-voting-permissions-local.sql
-- 운영: deploy/.env의 MYSQL_USER 계정에 실제 Host 기준으로 같은 권한을 부여한다.


CREATE TABLE IF NOT EXISTS weather_votes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    forecast_date DATE NOT NULL,
    slot_hour TINYINT NOT NULL COMMENT '-1=날짜 기본값, 0/6/12/18=6시간 상세 구간',
    weather_code VARCHAR(32) NOT NULL COMMENT 'SUNNY, RAIN, RAINBOW, METEOR_SHOWER, HEATWAVE',
    vote_weight TINYINT NOT NULL DEFAULT 1 COMMENT '일반 사용자=1, 관리자=5',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_weather_votes_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_weather_votes_slot
        CHECK (slot_hour IN (-1, 0, 6, 12, 18)),
    CONSTRAINT chk_weather_votes_code
        CHECK (weather_code IN ('SUNNY', 'RAIN', 'RAINBOW', 'METEOR_SHOWER', 'HEATWAVE')),
    CONSTRAINT chk_weather_votes_weight
        CHECK (vote_weight IN (1, 5)),
    UNIQUE KEY uk_weather_vote_user_slot (user_id, forecast_date, slot_hour),
    KEY idx_weather_vote_tally (forecast_date, slot_hour, weather_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS weather_vote_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    forecast_date DATE NOT NULL,
    slot_hour TINYINT NOT NULL,
    previous_weather_code VARCHAR(32) NOT NULL,
    new_weather_code VARCHAR(32) NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_weather_vote_history_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    KEY idx_weather_vote_history_changed_at (changed_at),
    KEY idx_weather_vote_history_user_slot (user_id, forecast_date, slot_hour)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
