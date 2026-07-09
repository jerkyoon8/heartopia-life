-- Applies mastery values that were skipped because source names did not exactly
-- match current production DB names. Run after update_mastery_values.sql.
-- `북어` is intentionally excluded: no matching fish_collections row exists.

UPDATE fish_collections
SET mastery_beginner_max = 30, mastery_intro_min = 30, mastery_expert_min = 90, mastery_master_min = 180
WHERE id = 70 AND name = '북극곤들매기';

UPDATE bug_collections
SET mastery_beginner_max = 200, mastery_intro_min = 200, mastery_expert_min = 600, mastery_master_min = 1200
WHERE id = 9 AND name = '오아시스메뚜기';

UPDATE bug_collections
SET mastery_beginner_max = 200, mastery_intro_min = 200, mastery_expert_min = 600, mastery_master_min = 1200
WHERE id = 18 AND name = '넉점박이잠자리';

UPDATE bug_collections
SET mastery_beginner_max = 120, mastery_intro_min = 120, mastery_expert_min = 360, mastery_master_min = 720
WHERE id = 24 AND name = '흰점꼬리털벌';

UPDATE bug_collections
SET mastery_beginner_max = 120, mastery_intro_min = 120, mastery_expert_min = 360, mastery_master_min = 720
WHERE id = 32 AND name = '밀잠자리';

UPDATE bird_collections
SET mastery_beginner_max = 240, mastery_intro_min = 240, mastery_expert_min = 720, mastery_master_min = 1440
WHERE id = 29 AND name = '노란머리바우어새';

UPDATE bird_collections
SET mastery_beginner_max = 240, mastery_intro_min = 240, mastery_expert_min = 720, mastery_master_min = 1440
WHERE id = 44 AND name = '붉은뺨가마우지';

UPDATE bird_collections
SET mastery_beginner_max = 100, mastery_intro_min = 100, mastery_expert_min = 300, mastery_master_min = 600
WHERE id = 60 AND name = '아조레스멋쟁이새';

UPDATE cooking_collections
SET mastery_beginner_max = 120, mastery_intro_min = 120, mastery_expert_min = 360, mastery_master_min = 720
WHERE id = 25 AND name = '느타리버섯 파이';

UPDATE cooking_collections
SET mastery_beginner_max = 160, mastery_intro_min = 160, mastery_expert_min = 480, mastery_master_min = 960
WHERE id = 10 AND name = '딸기 잼';

UPDATE cooking_collections
SET mastery_beginner_max = 160, mastery_intro_min = 160, mastery_expert_min = 480, mastery_master_min = 960
WHERE id = 18 AND name = '레드 롤케이크';

UPDATE cooking_collections
SET mastery_beginner_max = 160, mastery_intro_min = 160, mastery_expert_min = 480, mastery_master_min = 960
WHERE id = 124 AND name = '몰티즈 콘파나';

UPDATE cooking_collections
SET mastery_beginner_max = 160, mastery_intro_min = 160, mastery_expert_min = 480, mastery_master_min = 960
WHERE id = 2 AND name = '믹스 잼';

UPDATE cooking_collections
SET mastery_beginner_max = 160, mastery_intro_min = 160, mastery_expert_min = 480, mastery_master_min = 960
WHERE id = 114 AND name = '부활절 이스터에그 파티';

UPDATE cooking_collections
SET mastery_beginner_max = 160, mastery_intro_min = 160, mastery_expert_min = 480, mastery_master_min = 960
WHERE id = 6 AND name = '사과 잼';

UPDATE cooking_collections
SET mastery_beginner_max = 120, mastery_intro_min = 120, mastery_expert_min = 360, mastery_master_min = 720
WHERE id = 45 AND name = '콘스프';

UPDATE cooking_collections
SET mastery_beginner_max = 80, mastery_intro_min = 80, mastery_expert_min = 240, mastery_master_min = 480
WHERE id = 121 AND name = '북유럽파란가재 냉채';

UPDATE cooking_collections
SET mastery_beginner_max = 60, mastery_intro_min = 60, mastery_expert_min = 180, mastery_master_min = 360
WHERE id = 119 AND name = '황금 킹크랩';
