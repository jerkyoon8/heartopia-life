-- 3단계(코드 배포 후): 서버 체크리스트의 이름 기반 바다청소 키를 ID 키로 이동한다.
-- 새 코드는 이 SQL 실행 전에도 구형 키를 읽을 수 있으므로 코드 배포 직후 실행한다.
-- 대상: MySQL 8.0 / heartopia_db

START TRANSACTION;

-- 기존 일반 별점 키를 ID 키로 병합한다. 양쪽 키가 있으면 높은 별점을 보존한다.
INSERT INTO user_checklist (user_id, item_key, star_rating, updated_at)
SELECT uc.user_id,
       CONCAT('sea_cleaning_id_', sc.id),
       uc.star_rating,
       NOW()
FROM user_checklist uc
JOIN sea_cleaning_collections sc
  ON uc.item_key = CONCAT('sea_cleaning_', sc.legacy_checklist_name)
ON DUPLICATE KEY UPDATE
    star_rating = GREATEST(user_checklist.star_rating, VALUES(star_rating)),
    updated_at = NOW();

-- 기존 명인 키도 같은 ID로 병합한다.
INSERT INTO user_checklist (user_id, item_key, star_rating, updated_at)
SELECT uc.user_id,
       CONCAT('mastery_sea_cleaning_id_', sc.id),
       uc.star_rating,
       NOW()
FROM user_checklist uc
JOIN sea_cleaning_collections sc
  ON uc.item_key = CONCAT('mastery_sea_cleaning_', sc.legacy_checklist_name)
ON DUPLICATE KEY UPDATE
    star_rating = GREATEST(user_checklist.star_rating, VALUES(star_rating)),
    updated_at = NOW();

-- ID 키가 만들어진 뒤에만 구형 키를 제거한다.
DELETE uc
FROM user_checklist uc
JOIN sea_cleaning_collections sc
  ON uc.item_key = CONCAT('sea_cleaning_', sc.legacy_checklist_name)
  OR uc.item_key = CONCAT('mastery_sea_cleaning_', sc.legacy_checklist_name);

COMMIT;

-- 실행 후 기대값: 0
SELECT COUNT(*) AS remaining_legacy_user_keys
FROM user_checklist uc
JOIN sea_cleaning_collections sc
  ON uc.item_key = CONCAT('sea_cleaning_', sc.legacy_checklist_name)
  OR uc.item_key = CONCAT('mastery_sea_cleaning_', sc.legacy_checklist_name);
