-- 유저별 수집도감 DB 동기화 opt-in 플래그
-- 기본값 FALSE: 로그인해도 localStorage만 사용
-- TRUE: 체크리스트를 DB에 저장해 다른 기기에서도 동일하게 보임

ALTER TABLE users
    ADD COLUMN checklist_sync_enabled BOOLEAN NOT NULL DEFAULT FALSE;
