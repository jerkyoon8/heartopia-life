-- 도감 상단의 빠른 이벤트 선택 후보 목록
-- 애플리케이션 배포 전에 대상 DB에 적용하고 환경별 권한 SQL도 실행한다.

CREATE TABLE IF NOT EXISTS wiki_quick_events (
    event_name VARCHAR(100) NOT NULL PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
