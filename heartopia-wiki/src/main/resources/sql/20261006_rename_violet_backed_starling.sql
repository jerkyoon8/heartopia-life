-- Target: heartopia_db, MySQL 8.0, utf8mb4. Manual execution only.
-- Back up bird_collections id=77 and both old/new checklist keys first.
-- Coordinate with the migration-enabled application release; pause checklist writes
-- during execution. Repeat after old tabs have drained to remove late legacy writes.
-- Image URLs, IDs and all other catalog attributes remain unchanged.
DELIMITER //
CREATE PROCEDURE rename_violet_backed_starling_20261006()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        DROP TEMPORARY TABLE IF EXISTS tmp_starling_checklist;
        RESIGNAL;
    END;

    START TRANSACTION;
    IF (SELECT COUNT(*) FROM bird_collections WHERE id = 77
        AND name IN ('쇠찌르레기', '보라등찌르레기')) <> 1
       OR (SELECT COUNT(*) FROM bird_collections WHERE id <> 77
        AND name IN ('쇠찌르레기', '보라등찌르레기')) <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Starling catalog precondition failed';
    END IF;

    UPDATE bird_collections SET name = '보라등찌르레기'
    WHERE id = 77 AND name = '쇠찌르레기';

    CREATE TEMPORARY TABLE tmp_starling_checklist AS
    SELECT user_id,
           CASE item_key
               WHEN 'bird_쇠찌르레기' THEN 'bird_보라등찌르레기'
               WHEN 'mastery_bird_쇠찌르레기' THEN 'mastery_bird_보라등찌르레기'
               ELSE item_key
           END AS new_key,
           MAX(star_rating) AS star_rating,
           MAX(updated_at) AS updated_at
    FROM user_checklist
    WHERE item_key IN ('bird_쇠찌르레기', 'bird_보라등찌르레기',
                       'mastery_bird_쇠찌르레기', 'mastery_bird_보라등찌르레기')
    GROUP BY user_id, new_key;

    INSERT INTO user_checklist (user_id, item_key, star_rating, updated_at)
    SELECT user_id, new_key, star_rating, updated_at FROM tmp_starling_checklist
    ON DUPLICATE KEY UPDATE
        star_rating = GREATEST(user_checklist.star_rating, VALUES(star_rating)),
        updated_at = GREATEST(user_checklist.updated_at, VALUES(updated_at));

    IF EXISTS (SELECT 1 FROM tmp_starling_checklist expected
        LEFT JOIN user_checklist actual
          ON actual.user_id = expected.user_id AND actual.item_key = expected.new_key
        WHERE actual.user_id IS NULL OR actual.star_rating < expected.star_rating) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Starling checklist preservation failed';
    END IF;

    DELETE FROM user_checklist
    WHERE item_key IN ('bird_쇠찌르레기', 'mastery_bird_쇠찌르레기');

    IF EXISTS (SELECT 1 FROM user_checklist
        WHERE item_key IN ('bird_쇠찌르레기', 'mastery_bird_쇠찌르레기')) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Legacy starling keys remain';
    END IF;

    DROP TEMPORARY TABLE tmp_starling_checklist;
    COMMIT;
END //
DELIMITER ;

CALL rename_violet_backed_starling_20261006();
DROP PROCEDURE rename_violet_backed_starling_20261006;

-- Expected: one row, id=77, new name; image_url identical to the backup.
SELECT * FROM bird_collections WHERE id = 77;
-- Expected: 0.
SELECT COUNT(*) AS legacy_key_count FROM user_checklist
WHERE item_key IN ('bird_쇠찌르레기', 'mastery_bird_쇠찌르레기');
