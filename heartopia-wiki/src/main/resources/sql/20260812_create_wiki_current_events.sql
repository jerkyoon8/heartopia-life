-- 도감에서 기본 노출할 현재 진행 이벤트 목록
-- 애플리케이션 실행 전에 대상 DB에 적용한다.
-- 테이블 생성 후 환경에 맞는 권한 파일도 반드시 실행한다.
-- 로컬: 20260812_grant_wiki_current_events_local.sql
-- 운영 Docker: 20260812_grant_wiki_current_events_production.sql

CREATE TABLE IF NOT EXISTS wiki_current_events (
    event_name VARCHAR(100) NOT NULL PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
