-- 문의하기 게시판 기능 확장에 따른 테이블 변경 (이메일 삭제, 공개 여부 추가)
-- 주의: 해당 스크립트는 IF NOT EXISTS 등의 조건을 지원하지 않으므로, 1회만 실행해야 합니다.

ALTER TABLE wiki_reports DROP COLUMN reporter_email;
ALTER TABLE wiki_reports ADD COLUMN is_public BOOLEAN DEFAULT FALSE;
ALTER TABLE wiki_reports ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;
