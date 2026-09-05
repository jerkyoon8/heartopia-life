-- Production target: heartopia_db (MySQL 8, utf8mb4)
-- Guarded one-time migration. Any unexpected row count rolls back the transaction.
-- image_url is intentionally excluded from every UPDATE.
DELIMITER //
CREATE PROCEDURE migrate_gaafish_catalog_20260906()
BEGIN
START TRANSACTION;

UPDATE fish_collections SET name = '갈색 얼룩 가아피쉬' WHERE id = 124 AND name = '갈색 얼룩 동갈치';
IF ROW_COUNT() <> 1 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'fish 124 precondition failed'; END IF;
UPDATE fish_collections SET name = '검은 얼룩 가아피쉬' WHERE id = 125 AND name = '검은 얼룩 동갈치';
IF ROW_COUNT() <> 1 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'fish 125 precondition failed'; END IF;
UPDATE fish_collections SET name = '연금색 가아피쉬' WHERE id = 126 AND name = '연금색 동갈치';
IF ROW_COUNT() <> 1 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'fish 126 precondition failed'; END IF;
UPDATE fish_collections SET name = '은색 가아피쉬' WHERE id = 127 AND name = '은색 동갈치';
IF ROW_COUNT() <> 1 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'fish 127 precondition failed'; END IF;

UPDATE cooking_collections SET name = '선인장 검은 얼룩 가아피쉬 수프', ingredients = REPLACE(ingredients, '검은 얼룩 동갈치', '검은 얼룩 가아피쉬') WHERE id = 224 AND name = '선인장 검은 얼룩 동갈치 수프';
IF ROW_COUNT() <> 1 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'cooking 224 precondition failed'; END IF;
UPDATE cooking_collections SET name = '선인장 연금색 가아피쉬 수프', ingredients = REPLACE(ingredients, '연금색 동갈치', '연금색 가아피쉬') WHERE id = 236 AND name = '선인장 연금색 동갈치 수프';
IF ROW_COUNT() <> 1 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'cooking 236 precondition failed'; END IF;
UPDATE cooking_collections SET name = '선인장 갈색 얼룩 가아피쉬 수프', ingredients = REPLACE(ingredients, '갈색 얼룩 동갈치', '갈색 얼룩 가아피쉬') WHERE id = 239 AND name = '선인장 갈색 얼룩 동갈치 수프';
IF ROW_COUNT() <> 1 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'cooking 239 precondition failed'; END IF;
UPDATE cooking_collections SET name = '선인장 은색 가아피쉬 수프', ingredients = REPLACE(ingredients, '은색 동갈치', '은색 가아피쉬') WHERE id = 240 AND name = '선인장 은색 동갈치 수프';
IF ROW_COUNT() <> 1 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'cooking 240 precondition failed'; END IF;
UPDATE cooking_collections SET name = '선인장 황금 가아피쉬 수프', ingredients = REPLACE(ingredients, '황금 동갈치', '황금 가아피쉬') WHERE id = 242 AND name = '선인장 황금 동갈치 수프';
IF ROW_COUNT() <> 1 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'cooking 242 precondition failed'; END IF;

IF (SELECT COUNT(*) FROM fish_collections WHERE name LIKE '%동갈치%') <> 0 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'old fish names remain'; END IF;
IF (SELECT COUNT(*) FROM cooking_collections WHERE name LIKE '%동갈치%' OR ingredients LIKE '%동갈치%') <> 0 THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'old cooking values remain'; END IF;

COMMIT;
END //
DELIMITER ;

CALL migrate_gaafish_catalog_20260906();
DROP PROCEDURE migrate_gaafish_catalog_20260906;
