-- 실행 시점: ID 기반 체크리스트 코드 배포 및 사용자 키 이전 SQL 실행 후.
-- 필요한 권한: SELECT, UPDATE. legacy_checklist_name은 절대 수정하지 않는다.

START TRANSACTION;

-- 대상 행을 잠가 사전 검증과 UPDATE 사이의 변경을 막는다.
SELECT id
FROM sea_cleaning_collections
WHERE id IN (1, 6, 8, 10, 11, 14)
ORDER BY id
FOR UPDATE;

SELECT
    SUM(CASE
        WHEN id = 1 AND name = '손상된 조개껍데기' THEN 1
        WHEN id = 6 AND name = '은빛 대합' THEN 1
        WHEN id = 8 AND name = '뱃머리 벚꽃조개' THEN 1
        WHEN id = 10 AND name = '사프란 대왕조개' THEN 1
        WHEN id = 11 AND name = '가는줄갯고둥' THEN 1
        WHEN id = 14 AND name = '등롱 화염고둥' THEN 1
        ELSE 0
    END),
    SUM(CASE
        WHEN id = 1 AND legacy_checklist_name = '손상된 조개껍데기' THEN 1
        WHEN id = 6 AND legacy_checklist_name = '은빛 대합' THEN 1
        WHEN id = 8 AND legacy_checklist_name = '뱃머리 벚꽃조개' THEN 1
        WHEN id = 10 AND legacy_checklist_name = '사프란 대왕조개' THEN 1
        WHEN id = 11 AND legacy_checklist_name = '가는줄갯고둥' THEN 1
        WHEN id = 14 AND legacy_checklist_name = '등롱 화염고둥' THEN 1
        ELSE 0
    END),
    SUM(CASE
        WHEN id = 1 AND name = '손상된 바닷조개' THEN 1
        WHEN id = 6 AND name = '개굴잠쟁이' THEN 1
        WHEN id = 8 AND name = '프로라 텔린조개' THEN 1
        WHEN id = 10 AND name = '크로세아 클램' THEN 1
        WHEN id = 11 AND name = '무명올각시실꼬리고둥' THEN 1
        WHEN id = 14 AND name = '노빌리스 두순고둥' THEN 1
        ELSE 0
    END)
INTO @expected_old_count, @legacy_name_count, @already_applied_count
FROM sea_cleaning_collections
WHERE id IN (1, 6, 8, 10, 11, 14);

SELECT COUNT(*)
INTO @new_name_conflict_count
FROM sea_cleaning_collections
WHERE name IN (
    '손상된 바닷조개',
    '개굴잠쟁이',
    '프로라 텔린조개',
    '크로세아 클램',
    '무명올각시실꼬리고둥',
    '노빌리스 두순고둥'
)
  AND id NOT IN (1, 6, 8, 10, 11, 14);

-- 최초 실행 기대값: 6, 6, 0, 0. 재실행 기대값: 0, 6, 0, 6.
SELECT
    @expected_old_count AS expected_old_count,
    @legacy_name_count AS legacy_name_count,
    @new_name_conflict_count AS new_name_conflict_count,
    @already_applied_count AS already_applied_count;

-- 최초 실행의 세 가지 사전 조건이 모두 맞을 때만 6건을 한 문장으로 변경한다.
-- 조건이 다르면 일부만 바꾸지 않고 updated_rows=0이 된다.
UPDATE sea_cleaning_collections
SET name = CASE id
    WHEN 1 THEN '손상된 바닷조개'
    WHEN 6 THEN '개굴잠쟁이'
    WHEN 8 THEN '프로라 텔린조개'
    WHEN 10 THEN '크로세아 클램'
    WHEN 11 THEN '무명올각시실꼬리고둥'
    WHEN 14 THEN '노빌리스 두순고둥'
    ELSE name
END
WHERE id IN (1, 6, 8, 10, 11, 14)
  AND @expected_old_count = 6
  AND @legacy_name_count = 6
  AND @new_name_conflict_count = 0;

SET @updated_rows = ROW_COUNT();

COMMIT;

-- 최초 실행 기대값: updated_rows=6. 재실행이면 updated_rows=0과 already applied가 정상이다.
SELECT @updated_rows AS updated_rows;

SELECT
    CASE
        WHEN COUNT(*) = 6 AND @updated_rows = 6 THEN 'applied'
        WHEN COUNT(*) = 6 AND @updated_rows = 0 THEN 'already applied'
        ELSE 'NOT APPLIED: verify preflight counts'
    END AS migration_status
FROM sea_cleaning_collections
WHERE (id = 1 AND name = '손상된 바닷조개' AND legacy_checklist_name = '손상된 조개껍데기')
   OR (id = 6 AND name = '개굴잠쟁이' AND legacy_checklist_name = '은빛 대합')
   OR (id = 8 AND name = '프로라 텔린조개' AND legacy_checklist_name = '뱃머리 벚꽃조개')
   OR (id = 10 AND name = '크로세아 클램' AND legacy_checklist_name = '사프란 대왕조개')
   OR (id = 11 AND name = '무명올각시실꼬리고둥' AND legacy_checklist_name = '가는줄갯고둥')
   OR (id = 14 AND name = '노빌리스 두순고둥' AND legacy_checklist_name = '등롱 화염고둥');

SELECT id, name, legacy_checklist_name
FROM sea_cleaning_collections
WHERE id IN (1, 6, 8, 10, 11, 14)
ORDER BY id;
