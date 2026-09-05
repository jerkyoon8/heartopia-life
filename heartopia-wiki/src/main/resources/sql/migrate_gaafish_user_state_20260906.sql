-- Production target: heartopia_db (MySQL 8, utf8mb4)
-- Guarded one-time migration based on the 2026-09-06 production preflight.
DELIMITER //
CREATE PROCEDURE migrate_gaafish_user_state_20260906()
BEGIN
DECLARE old_checklist_count INT DEFAULT 0;
DECLARE target_collision_count INT DEFAULT 0;
DECLARE old_pet_count INT DEFAULT 0;

START TRANSACTION;

CREATE TEMPORARY TABLE tmp_gaafish_key_map (old_key VARCHAR(100) PRIMARY KEY, new_key VARCHAR(100) NOT NULL);
INSERT INTO tmp_gaafish_key_map (old_key, new_key) VALUES
('fish_갈색 얼룩 동갈치', 'fish_갈색 얼룩 가아피쉬'),
('fish_검은 얼룩 동갈치', 'fish_검은 얼룩 가아피쉬'),
('fish_연금색 동갈치', 'fish_연금색 가아피쉬'),
('fish_은색 동갈치', 'fish_은색 가아피쉬'),
('cooking_선인장 갈색 얼룩 동갈치 수프', 'cooking_선인장 갈색 얼룩 가아피쉬 수프'),
('cooking_선인장 검은 얼룩 동갈치 수프', 'cooking_선인장 검은 얼룩 가아피쉬 수프'),
('cooking_선인장 연금색 동갈치 수프', 'cooking_선인장 연금색 가아피쉬 수프'),
('cooking_선인장 은색 동갈치 수프', 'cooking_선인장 은색 가아피쉬 수프'),
('cooking_선인장 황금 동갈치 수프', 'cooking_선인장 황금 가아피쉬 수프'),
('mastery_fish_갈색 얼룩 동갈치', 'mastery_fish_갈색 얼룩 가아피쉬'),
('mastery_fish_검은 얼룩 동갈치', 'mastery_fish_검은 얼룩 가아피쉬'),
('mastery_fish_연금색 동갈치', 'mastery_fish_연금색 가아피쉬'),
('mastery_fish_은색 동갈치', 'mastery_fish_은색 가아피쉬'),
('mastery_cooking_선인장 갈색 얼룩 동갈치 수프', 'mastery_cooking_선인장 갈색 얼룩 가아피쉬 수프'),
('mastery_cooking_선인장 검은 얼룩 동갈치 수프', 'mastery_cooking_선인장 검은 얼룩 가아피쉬 수프'),
('mastery_cooking_선인장 연금색 동갈치 수프', 'mastery_cooking_선인장 연금색 가아피쉬 수프'),
('mastery_cooking_선인장 은색 동갈치 수프', 'mastery_cooking_선인장 은색 가아피쉬 수프'),
('mastery_cooking_선인장 황금 동갈치 수프', 'mastery_cooking_선인장 황금 가아피쉬 수프');

SELECT COUNT(*) INTO old_checklist_count FROM user_checklist u JOIN tmp_gaafish_key_map m ON m.old_key = u.item_key;
IF old_checklist_count <> 317 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'unexpected old checklist count'; END IF;
SELECT COUNT(*) INTO target_collision_count FROM user_checklist old_row JOIN tmp_gaafish_key_map m ON m.old_key = old_row.item_key JOIN user_checklist new_row ON new_row.user_id = old_row.user_id AND new_row.item_key = m.new_key;
IF target_collision_count <> 0 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'checklist target collision detected'; END IF;

INSERT INTO user_checklist (user_id, item_key, star_rating, updated_at)
SELECT u.user_id, m.new_key, u.star_rating, u.updated_at FROM user_checklist u JOIN tmp_gaafish_key_map m ON m.old_key = u.item_key;
IF ROW_COUNT() <> old_checklist_count THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'checklist insert count mismatch'; END IF;
DELETE u FROM user_checklist u JOIN tmp_gaafish_key_map m ON m.old_key = u.item_key;
IF ROW_COUNT() <> old_checklist_count THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'checklist delete count mismatch'; END IF;

-- Pre-scan confirmed every old occurrence is a customFoods[].name value.
SELECT COUNT(*) INTO old_pet_count FROM user_pet_food WHERE pets_json LIKE '%동갈치%';
IF old_pet_count <> 1 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'unexpected pet row count'; END IF;
UPDATE user_pet_food SET pets_json = REPLACE(pets_json, '동갈치', '가아피쉬') WHERE pets_json LIKE '%동갈치%' AND JSON_VALID(pets_json) = 1;
IF ROW_COUNT() <> old_pet_count THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'pet update count mismatch'; END IF;

IF (SELECT COUNT(*) FROM user_checklist WHERE item_key LIKE '%동갈치%') <> 0 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'old checklist keys remain'; END IF;
IF (SELECT COUNT(*) FROM user_pet_food WHERE pets_json LIKE '%동갈치%') <> 0 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'old pet values remain'; END IF;
IF (SELECT COUNT(*) FROM user_pet_food WHERE JSON_VALID(pets_json) = 0) <> 0 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'invalid pet JSON detected'; END IF;

COMMIT;
END //
DELIMITER ;

CALL migrate_gaafish_user_state_20260906();
DROP PROCEDURE migrate_gaafish_user_state_20260906;
