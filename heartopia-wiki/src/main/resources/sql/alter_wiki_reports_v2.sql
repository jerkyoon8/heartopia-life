-- 관리자 답변 기능 추가 (문의하기 게시판 Q&A 지원)
-- 주의: 1회만 실행할 것

ALTER TABLE wiki_reports ADD COLUMN admin_reply TEXT DEFAULT NULL;
ALTER TABLE wiki_reports ADD COLUMN replied_at DATETIME DEFAULT NULL;
