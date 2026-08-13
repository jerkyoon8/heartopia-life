-- 로컬 MySQL의 실제 애플리케이션 계정은 CURRENT_USER() 기준 wiki_user@%이다.
-- root 등 GRANT OPTION이 있는 관리자 계정으로 실행한다.

GRANT SELECT, INSERT, UPDATE, DELETE
    ON heartopia_db.wiki_quick_events
    TO 'wiki_user'@'%';

SHOW GRANTS FOR 'wiki_user'@'%';
