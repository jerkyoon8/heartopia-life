-- 관리자 6시간 단위 날씨 예약. MySQL 8.0에서 애플리케이션 배포 전에 적용한다.

CREATE TABLE IF NOT EXISTS weather_schedules (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    forecast_date DATE NOT NULL,
    slot_hour TINYINT NOT NULL,
    weather_code VARCHAR(32) NOT NULL,
    source_weather_ids VARCHAR(64) NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_weather_schedule_date_slot (forecast_date, slot_hour),
    KEY idx_weather_schedule_active_range (is_active, forecast_date, slot_hour),
    CONSTRAINT chk_weather_schedule_slot_hour
        CHECK (slot_hour IN (0, 6, 12, 18)),
    CONSTRAINT chk_weather_schedule_code
        CHECK (weather_code IN (
            'SUNNY', 'RAIN', 'RAINBOW', 'METEOR_SHOWER', 'HEATWAVE', 'SNOW', 'AURORA'
        ))
);
