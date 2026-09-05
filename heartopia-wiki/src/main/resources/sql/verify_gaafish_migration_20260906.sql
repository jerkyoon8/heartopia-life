SELECT id, name, image_url FROM fish_collections
WHERE id IN (124,125,126,127,128) ORDER BY id;

SELECT id, name, ingredients, image_url FROM cooking_collections
WHERE id IN (224,236,239,240,242) ORDER BY id;

SELECT 'old_fish_name' AS check_name, COUNT(*) AS actual FROM fish_collections WHERE name LIKE '%동갈치%'
UNION ALL SELECT 'old_cooking_name', COUNT(*) FROM cooking_collections WHERE name LIKE '%동갈치%'
UNION ALL SELECT 'old_cooking_ingredients', COUNT(*) FROM cooking_collections WHERE ingredients LIKE '%동갈치%'
UNION ALL SELECT 'old_checklist_key', COUNT(*) FROM user_checklist WHERE item_key LIKE '%동갈치%'
UNION ALL SELECT 'old_pet_json', COUNT(*) FROM user_pet_food WHERE pets_json LIKE '%동갈치%'
UNION ALL SELECT 'old_fish_image_url_expected', COUNT(*) FROM fish_collections WHERE image_url LIKE '%동갈치%'
UNION ALL SELECT 'old_cooking_image_url_expected', COUNT(*) FROM cooking_collections WHERE image_url LIKE '%동갈치%'
UNION ALL SELECT 'invalid_pet_json', COUNT(*) FROM user_pet_food WHERE JSON_VALID(pets_json) = 0;

SELECT item_key, COUNT(*) AS rows_count, COUNT(DISTINCT user_id) AS users_count,
       MIN(star_rating) AS min_star, MAX(star_rating) AS max_star
FROM user_checklist
WHERE item_key LIKE '%가아피쉬%'
GROUP BY item_key ORDER BY item_key;
