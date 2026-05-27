-- 2026-05-27 채집물 4종 맵 핀 및 맵 노출 제거 패치

-- 1) forageable_collections 테이블에서 4종의 show_on_map 플래그를 FALSE로 설정 (도감 서식지 텍스트는 정상 유지하기 위함)
UPDATE forageable_collections
SET show_on_map = FALSE
WHERE name IN ('야생 고사리', '산마늘', '산우엉', '산겨자');

-- 2) map_pins 테이블에서 4종의 지도 핀 데이터를 완전히 삭제
DELETE FROM map_pins
WHERE category = 'forageable' AND name IN ('야생 고사리', '산마늘', '산우엉', '산겨자');
