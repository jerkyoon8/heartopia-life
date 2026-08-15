-- 1단계(코드 배포 전): 바다청소 ID 키 전환 직전 이름을 영구 별칭으로 고정한다.
-- 중요: 조개 이름을 변경하기 전, 새 애플리케이션 코드를 배포하기 전에 실행한다.
-- 대상: MySQL 8.0 / heartopia_db

ALTER TABLE sea_cleaning_collections
    ADD COLUMN legacy_checklist_name VARCHAR(100) NULL
        COMMENT 'ID 키 전환 직전 체크리스트 이름. 이후 이름 변경 시 수정 금지'
        AFTER name;

UPDATE sea_cleaning_collections
SET legacy_checklist_name = name
WHERE legacy_checklist_name IS NULL;

CREATE UNIQUE INDEX uq_sea_cleaning_legacy_checklist_name
    ON sea_cleaning_collections (legacy_checklist_name);

-- 실행 후 기대값: 0
SELECT COUNT(*) AS missing_legacy_names
FROM sea_cleaning_collections
WHERE legacy_checklist_name IS NULL;
