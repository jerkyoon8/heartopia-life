-- 로컬 MySQL 전용. root 등 GRANT OPTION이 있는 관리자 계정으로 실행한다.
-- 애플리케이션 오류의 CURRENT_USER()가 'wiki_user'@'localhost'일 때 사용한다.

GRANT SELECT, INSERT, UPDATE, DELETE
    ON heartopia_db.wiki_current_events
    TO 'wiki_user'@'localhost';

-- MySQL 8.0에서 GRANT는 즉시 반영되므로 FLUSH PRIVILEGES는 필요하지 않다.
SHOW GRANTS FOR 'wiki_user'@'localhost';
