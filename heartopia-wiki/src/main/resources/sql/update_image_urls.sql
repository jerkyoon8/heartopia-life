-- 두근두근타운(Heartopia) 물고기, 곤충, 새 기본 도감 이미지 경로 일괄 업데이트
-- 정적 자원으로 다운로드된 로컬 이미지 자원(webp)을 참조하도록 image_url을 업데이트합니다.
-- 주의: '꿈의 명암' 등 별도로 관리되는 특수 이벤트 아이템은 기존 이미지 경로(png)를 유지하기 위해 event_name 조건이 추가되었습니다.
use heartopia_db;

-- 1. 물고기 이미지 업데이트
UPDATE fish_collections
SET image_url = CONCAT('/images/collections/fish/fish_', name, '.webp')
WHERE event_name IS NULL OR event_name = '';

-- 2. 곤충(벌레) 이미지 업데이트
UPDATE bug_collections
SET image_url = CONCAT('/images/collections/bug/bug_', name, '.webp')
WHERE event_name IS NULL OR event_name = '';

-- 3. 새 이미지 업데이트
UPDATE bird_collections
SET image_url = CONCAT('/images/collections/bird/bird_', name, '.webp')
WHERE event_name IS NULL OR event_name = '';

-- 4. 요리 이미지 업데이트
-- 참고: 요리의 경우 파이썬 스크립트를 통해 모든 아이템(이벤트 포함)을 'cook_이름.webp'로 다운로드했으므로 조건 필터를 걸지 않습니다.
UPDATE cooking_collections
SET image_url = CONCAT('/images/items/cook/cook_', name, '.webp');
