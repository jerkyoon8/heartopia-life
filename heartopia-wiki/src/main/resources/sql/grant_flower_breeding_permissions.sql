-- 운영/로컬 DB 계정 권한 설정용.
-- create_flower_breeding_schema.sql에는 섞지 말고, 권한 부족 에러가 날 때만 DB 관리자 계정으로 실행한다.
--
-- Error Code: 1410 ("You are not allowed to create a user with GRANT")가 나면
-- 1) 현재 접속 계정이 권한 부여 권한(GRANT OPTION)이 없거나
-- 2) 'wiki_user'@'localhost' 계정이 실제로 없다는 뜻이다.
--
-- 먼저 관리자 계정(root 등)으로 아래를 확인한다.
-- SELECT CURRENT_USER();
-- SELECT user, host FROM mysql.user WHERE user = 'wiki_user';
--
-- wiki_user가 '%' host로만 존재하면 아래 GRANT의 'localhost'를 '%'로 바꿔 실행한다.
-- wiki_user가 아예 없으면 관리자 계정으로 먼저 생성한다.
-- CREATE USER IF NOT EXISTS 'wiki_user'@'localhost' IDENTIFIED BY '기존_또는_새_DB_PASSWORD';

GRANT SELECT, INSERT, UPDATE, DELETE ON heartopia_db.flower_variants TO 'wiki_user'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON heartopia_db.flower_breeding_rules TO 'wiki_user'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON heartopia_db.flower_breeding_rule_options TO 'wiki_user'@'%';