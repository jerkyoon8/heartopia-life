-- 1. 새로운 컬럼 추가 (기본적으로 맵에 표시되지 않도록 묶어둠)
ALTER TABLE forageable_collections ADD COLUMN show_on_map BOOLEAN DEFAULT FALSE;

-- 2. 기존 하드코딩 되어있던 맵 전용 17가지 채집물만 명시적으로 보여지게 (TRUE) 업데이트
UPDATE forageable_collections 
SET show_on_map = TRUE 
WHERE name IN (
    '검은 트러플', '광석', '그물버섯', '느타리버섯',
    '대나무', '돌', '라즈베리', '블루베리', '사과',
    '양송이버섯', '귤 (오렌지)', '표고버섯', '희귀 목재',
    '야생 고사리', '산마늘', '산우엉', '산겨자'
);
