-- =====================================================
-- bird_collections: distance, stretch_time 컬럼 추가
-- 새 도감 확장 데이터 (docs/birds_merged_inferred.md) 적재용
-- 실행 전: --default-character-set=utf8mb4 필수
-- =====================================================

ALTER TABLE bird_collections
    ADD COLUMN distance VARCHAR(20) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '낚시/관찰 거리 (예: 3m, ≤3m)',
    ADD COLUMN stretch_time VARCHAR(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '스트레치 시간대 (예: 6~24, 상시 비/무지개)';
