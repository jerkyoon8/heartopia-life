-- 운영 Docker MySQL 전용. root 등 GRANT OPTION이 있는 관리자 계정으로 실행한다.
-- 현재 운영 deploy/.env의 MYSQL_USER는 wiki_usedasr이다.
-- 계정명을 정리하기 전까지 실제 애플리케이션 접속 계정과 동일하게 유지한다.

GRANT SELECT, INSERT, UPDATE, DELETE
    ON heartopia_db.wiki_current_events
    TO 'wiki_usedasr'@'%';

-- MySQL 8.0에서 GRANT는 즉시 반영되므로 FLUSH PRIVILEGES는 필요하지 않다.
SHOW GRANTS FOR 'wiki_usedasr'@'%';
