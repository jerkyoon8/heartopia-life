-- 고래 시즌 바다 청소 업적 4종 추가
-- 대상: heartopia_db (MySQL 8.0, utf8mb4)
-- 반복 실행 시 achievements.name 유니크 키를 기준으로 최신 제공 자료로 갱신한다.

INSERT INTO achievements (categories, name, cond, title, tip, image_url, sort_order) VALUES
('바다 청소', '넘실대는 해류', '임의 해저 메사의 생태 어군 레벨이 ''넘실대는 해류'' 달성', '밀집',
 '바다 청소 취미 5레벨에 열리는 바다집(해저 메사)에서 생태 어군 25레벨을 달성하면 획득할 수 있습니다.',
 '/images/achievements/넘실대는 해류.webp', 59),
('바다 청소', '사각지대 없음', '바다 청소 사건의 숨겨진 단계를 누적 10회 발동한다.', '비경', NULL,
 '/images/achievements/사각지대 없음.webp', 60),
('바다 청소', '자격증 취득', '바다 청소 사건에서 거대 오염물 제거 누적 60회 참여한다.', '장애물 제거', NULL,
 '/images/achievements/자격증 취득.webp', 61),
('바다 청소', '바다 정화 전문가', '바다 청소 취미 10레벨 달성', '바다', NULL,
 '/images/achievements/바다 정화 전문가.webp', 62)
ON DUPLICATE KEY UPDATE
    categories = VALUES(categories),
    cond = VALUES(cond),
    title = VALUES(title),
    tip = VALUES(tip),
    image_url = VALUES(image_url),
    sort_order = VALUES(sort_order);

-- 검증: 4행이 정렬 순서 59~62와 바다 청소 카테고리로 조회되어야 한다.
SELECT id, categories, name, cond, title, tip, image_url, sort_order
FROM achievements
WHERE name IN ('넘실대는 해류', '사각지대 없음', '자격증 취득', '바다 정화 전문가')
ORDER BY sort_order ASC;
