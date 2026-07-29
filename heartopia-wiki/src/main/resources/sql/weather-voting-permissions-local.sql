-- 로컬 MySQL 날씨 제보 테이블 권한
-- root 등 GRANT OPTION이 있는 관리자 계정으로 실행한다.
-- 로컬 개발 환경의 wiki_user 계정 Host가 '%'인 경우에만 사용한다.
-- 운영에서는 이 파일의 계정명을 고정 사용하지 말고 deploy/.env의 MYSQL_USER를 확인한다.

SELECT User, Host
FROM mysql.user
WHERE User = 'wiki_user';

GRANT SELECT, INSERT, UPDATE, DELETE
    ON heartopia_db.weather_votes
    TO 'wiki_user'@'%';

GRANT SELECT, INSERT, UPDATE, DELETE
    ON heartopia_db.weather_vote_history
    TO 'wiki_user'@'%';

-- MySQL 8.0에서 GRANT는 즉시 반영되므로 FLUSH PRIVILEGES는 필요하지 않다.

SHOW GRANTS FOR 'wiki_user'@'%';
