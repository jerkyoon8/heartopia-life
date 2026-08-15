-- 바다청소는 시즌 도감이 아니므로 과거에 저장된 이벤트명을 제거한다.
-- 로컬·운영 환경에서 반복 실행할 수 있다.
UPDATE sea_cleaning_collections
SET event_name = NULL
WHERE event_name IS NOT NULL;

-- 기대 결과: remaining_event_names = 0
SELECT COUNT(*) AS remaining_event_names
FROM sea_cleaning_collections
WHERE event_name IS NOT NULL;
