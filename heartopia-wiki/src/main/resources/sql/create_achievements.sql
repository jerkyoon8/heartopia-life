-- ============================================================
-- achievements 테이블 생성 + 데이터 삽입
-- ============================================================
use heartopia_db;

CREATE TABLE IF NOT EXISTS achievements (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    categories  VARCHAR(100)  NOT NULL COMMENT '카테고리 (쉼표 구분, 예: 숨겨진,낚시)',
    name        VARCHAR(100)  NOT NULL UNIQUE COMMENT '업적 이름',
    cond        VARCHAR(255)  NOT NULL COMMENT '달성 조건',
    title       VARCHAR(100)  NOT NULL COMMENT '획득 칭호',
    tip         TEXT          NULL     COMMENT '상세 팁/설명 (detail 페이지 전용)',
    image_url   VARCHAR(255)  NULL     COMMENT '이미지 경로',
    sort_order  INT           DEFAULT 0
);

-- ============================================================
-- 일반 업적 (44개)
-- ============================================================

-- 낚시 (9개)
INSERT IGNORE INTO achievements (categories, name, cond, title, tip, image_url, sort_order) VALUES
('낚시', '두 손 가득', '낚시 취미 레벨 10 달성', '어부지리 승자', NULL, '/images/achievements/두 손 가득.webp', 1),
('낚시', '비경의 어부', '(바다 낚시 사건) 신비한 항로 10회 발동', '어부', NULL, '/images/achievements/비경의 어부.webp', 2),
('낚시', '어획 축복', '(바다 낚시 사건) 물고기 떼 100회 발동', '축복', NULL, '/images/achievements/어획 축복.webp', 3),
('낚시', '강인한 세일러', '100KG 이상 물고기 연속 2회 낚시 성공', '낚싯줄', NULL, '/images/achievements/강인한 세일러.webp', 4),
('낚시', '월척 두 마리', '1분 안에 5성 물고기 2마리 낚시 성공', '물수리', NULL, '/images/achievements/월척 두 마리.webp', 5),
('낚시', '대형 수확기', '100KG 이상 물고기 누적 50마리 낚시', '통발', NULL, '/images/achievements/대형 수확기.webp', 6),
('낚시', '상어의 기세', '한 번의 (바다 낚시 사건)에서 금색 물고기 그림자에서 상어 3마리 낚기', '상어 우리', NULL, '/images/achievements/상어의 기세.webp', 7),
('낚시', '파도를 부르는 자', '한 번의 (바다 낚시 사건)에서 물고기 떼 3회 발동', '파도를 부르는 자', NULL, '/images/achievements/파도를 부르는 자.webp', 8),
('낚시', '별빛 어부', '한 번의 (바다 낚시 사건)에서 5성 물고기 4마리 낚기', '낚시 고수', NULL, '/images/achievements/별빛 어부.webp', 9);

-- 요리 (2개)
INSERT IGNORE INTO achievements (categories, name, cond, title, tip, image_url, sort_order) VALUES
('요리', '마을 요리왕', '요리 취미 10레벨 달성', '주방장', NULL, '/images/achievements/마을 요리왕.webp', 10),
('요리', '신속완벽', '60초 안에 5성 요리 2개 제작 성공', '주방 타이머', NULL, '/images/achievements/신속완벽.webp', 11);

-- 새 관찰 (5개)
INSERT IGNORE INTO achievements (categories, name, cond, title, tip, image_url, sort_order) VALUES
('새 관찰', '새 언어 전문가', '새 관찰 취미 10레벨 달성', '새 언어 전문가', NULL, '/images/achievements/새 언어 전문가.webp', 12),
('새 관찰', '구름 속 방문객', '(새 관찰 사건) 추가 스테이지 10회 발동', '하늘', NULL, '/images/achievements/구름 속 방문객.webp', 13),
('새 관찰', '바람과의 공명', '(새 관찰 사건) 새 떼 누적 100회 발동', '공명', NULL, '/images/achievements/바람과의 공명.webp', 14),
('새 관찰', '고성방가', '한 번의 (새 관찰 사건)에서 새 떼 3회 발동', '깃털', NULL, '/images/achievements/고성방가.webp', 15),
('새 관찰', '결정적 순간', '한 번의 (새 관찰 사건)에서 5성 정보 카드 10장 획득', '순간', NULL, '/images/achievements/결정적 순간.webp', 16);

-- 곤충 채집 (6개)
INSERT IGNORE INTO achievements (categories, name, cond, title, tip, image_url, sort_order) VALUES
('곤충 채집', '곤충 사령관', '곤충 채집 취미 10레벨 달성', '곤충 전문가', NULL, '/images/achievements/곤충 사령관.webp', 17),
('곤충 채집', '비경 추적자', '(곤충 유인 사건) 히든 스테이지 누적 10회 발동', '탐험', NULL, '/images/achievements/비경 추적자.webp', 18),
('곤충 채집', '곤충 군단장', '(곤충 유인 사건) 곤충 떼 누적 100회 발동', '벌레 떼', NULL, '/images/achievements/곤충 군단장.webp', 19),
('곤충 채집', '곤충 수확기', '한 번의 곤충 채집으로 곤충 3마리 잡기 성공', '트리플 버블', NULL, '/images/achievements/곤충 수확기.webp', 20),
('곤충 채집', '월척 다섯 벌레', '한 번의 (곤충 유인 사건) 5성 곤충 5마리 잡기 성공', '곤충왕', NULL, '/images/achievements/월척 다섯 벌레.webp', 21),
('곤충 채집', '인간형 곤충 유인기', '한 번의 (곤충 유인 사건) 벌레 떼 4회 발동', '곤충 유인기', NULL, '/images/achievements/인간형 곤충 유인기.webp', 22);

-- 원예 (3개)
INSERT IGNORE INTO achievements (categories, name, cond, title, tip, image_url, sort_order) VALUES
('원예', '초록손', '원예 취미 10레벨 달성', '원예사', NULL, '/images/achievements/초록손.webp', 23),
('원예', '대풍작', '풍작 시 5성 농작물 수확 성공', '풍작', NULL, '/images/achievements/대풍작.webp', 24),
('원예', '무지개의 행운', '한 번의 광범위 물 주기로 무지개 축복 2번 발동', '행운왕', NULL, '/images/achievements/무지개의 행운.webp', 25);

-- 고양이/강아지 (4개)
INSERT IGNORE INTO achievements (categories, name, cond, title, tip, image_url, sort_order) VALUES
('고양이/강아지', '에이스 집사', '고양이 키우기 취미 10레벨 달성', '냥이 집사', NULL, '/images/achievements/에이스 집사.webp', 26),
('고양이/강아지', '냥냥 레스토랑', '누적 5마리의 고양이에게 좋아하는 음식 각각 1번씩 주기', '고양이 사료', NULL, '/images/achievements/냥냥 레스토랑.webp', 27),
('고양이/강아지', '에이스 훈련사', '강아지 키우기 취미 10레벨 달성', '강아지 친구', NULL, '/images/achievements/에이스 훈련사.webp', 28),
('고양이/강아지', '강아지 식당', '누적 3마리에게 좋아하는 음식 각각 1번씩 주기', '강아지 사료', NULL, '/images/achievements/강아지 식당.webp', 29);

-- 생활 (12개)
INSERT IGNORE INTO achievements (categories, name, cond, title, tip, image_url, sort_order) VALUES
('생활', '타운키퍼', '타운키퍼 30레벨 달성하기', '타운키퍼', NULL, '/images/achievements/타운키퍼.webp', 30),
('생활', '수집가', '전문 수집가 레벨 달성', '수집가', NULL, '/images/achievements/수집가.webp', 31),
('생활', '로켓 스폰서', '알버트 2세에게 누적 판매 50만 골드 획득', '로켓', NULL, '/images/achievements/로켓 스폰서.webp', 32),
('생활', '퍼즐 예술가', '퍼즐 꿈에서 퍼즐 예술가 달성', '퍼즐', NULL, '/images/achievements/퍼즐 예술가.webp', 33),
('생활', '동물의 이웃', '동물 8마리에게 친밀도 레벨 10 달성', '새로운 이웃', NULL, '/images/achievements/동물의 이웃.webp', 34),
('생활', '스타더스트 수집가', '별똥별 조각 60개 수집', '별따기', NULL, '/images/achievements/스타더스트 수집가.webp', 35),
('생활', '동물 사육사', '동물 8마리에게 좋아하는 음식 해금', '미식', NULL, '/images/achievements/동물 사육사.webp', 36),
('생활', '멈추지 않는 붓', '글쓰기 꿈에서 신 달성', '글쓰기', NULL, '/images/achievements/멈추지 않는 붓.webp', 37),
('생활', '골든 레코드판', '음악 꿈에서 골든 레코드판 달성', '음악', NULL, '/images/achievements/골든 레코드판.webp', 38),
('생활', '얼음 위 요정', '피겨 스케이팅 꿈이 얼음 위 요정에 도달', '스케이팅', NULL, '/images/achievements/얼음 위 요정.webp', 39),
('생활', '올뉴 시공 비버', '건축 대회 누적 4회 참여, 작품이 전시 기간에 진입함', '건설', NULL, '/images/achievements/올뉴 시공 비버.webp', 40),
('생활', '서포트 비버', '건축 대회에 참여하여 한 팀을 위해 새싹 5000개 누적 비축', '후방지원', NULL, '/images/achievements/서포트 비버.webp', 41);

-- 이벤트 (3개)
INSERT IGNORE INTO achievements (categories, name, cond, title, tip, image_url, sort_order) VALUES
('이벤트', '모래 조각 예술가', '모래 조각 5레벨 달성', '모래 조각가', NULL, '/images/achievements/모래 조각 예술가.webp', 42),
('이벤트', '과일 쌓기', '호박 조각 5레벨 달성', '호박 머리', NULL, '/images/achievements/과일 쌓기.webp', 43),
('이벤트', '눈의 왕', '눈 조각 5레벨 달성', '눈의 왕', NULL, '/images/achievements/눈의 왕.webp', 44);

-- ============================================================
-- 히든 업적 (14개)
-- ============================================================

INSERT IGNORE INTO achievements (categories, name, cond, title, tip, image_url, sort_order) VALUES
('숨겨진', '미식 외교관', '음식 100번 공유', '구원투수', NULL, '/images/achievements/미식 외교관.webp', 45),
('숨겨진', '수리 전문가', '수리키트 100번 공유', '복구', NULL, '/images/achievements/수리 전문가.webp', 46),
('숨겨진', '베스트셀러 작가', '창작한 책이 누적 1000회 독립 구매 달성', '베스트셀러', NULL, '/images/achievements/베스트셀러 작가.webp', 47),
('숨겨진', '대문호', '10편의 작품 보유 및 각 편마다 독자 200명 보유', '문호', NULL, '/images/achievements/대문호.webp', 48),
('숨겨진', '도서 수집가', '500권의 서로 다른 책 보유', '책벌레', NULL, '/images/achievements/도서 수집가.webp', 49),
('숨겨진', '인기 스타', '집 좋아요 100번 받기', '라이징 스타', NULL, '/images/achievements/인기 스타.webp', 50),
('숨겨진', '곤충 채집 파티', '에어 꿀벌 유인기 100번 공유', '곤충 유인 전문가', NULL, '/images/achievements/곤충 채집 파티.webp', 51),
('숨겨진', '덤불 도매상', '위장 덤불 100번 공유', '추천', NULL, '/images/achievements/덤불 도매상.webp', 52),
('숨겨진', '레인보우 자원봉사자', '무지개 꽃다발 50번 공유', '무지개꽃', NULL, '/images/achievements/레인보우 자원봉사자.webp', 53),
('숨겨진', '온천 친구', '친구와 온천 들어가기', '온천',
 '온천산에는 들어가면 스태미나가 회복되는 얕은 온천이 존재하는데, 여기에 친구와 함께 들어가면 된다.',
 '/images/achievements/온천 친구.webp', 54),
('숨겨진', '유성 아래의 우정', '친구와 함께 유성 아래에서 소원 빌기', '쌍둥이 별',
 '유성우가 내릴 때마다 등장하는 히든 NPC 도리스에게 소원 빌기 리액션을 구매한 뒤, 친구와 가까이 붙어서 해당 리액션을 함께 사용하면 달성된다.',
 '/images/achievements/유성 아래의 우정.webp', 55),
('숨겨진', '로맨틱 아이스 프렌드', '유성우 아래에서 친구와 손을 잡고 스케이팅 하기', '더블 스케이팅', NULL, '/images/achievements/로맨틱 아이스 프렌드.webp', 56),
('숨겨진,낚시', '바다낚시 그랜드 슬램', '바다낚시 사건의 모든 칭호 획득 총 8개', '바다낚시꾼',
 '개인 목표: 물고기 5마리 이상 낚기
단체 목표: 함께 물고기 20마리 이상 낚기

결과 화면 칭호
- 바다낚시 수다쟁이: 채팅을 가장 많이 한 유저
- 가장 빠른 낚시꾼: 물고기 5마리를 가장 빠르게 낚은 유저
- 바다 요리사: 음식을 가장 많이 먹은 유저
- 만선 귀환: 가장 먼저 물고기를 15마리 이상 잡은 유저
- 물고기의 친구: 가장 먼저 미끼를 5회 이상 사용한 유저
- 사진 우선: 가장 먼저 친구가 낚시하는 모습을 촬영한 유저
- 바다 뮤지션: 가장 먼저 아무 악기나 연주한 유저
- 버블 마스터: 버블을 가장 많이 터뜨린 유저',
 '/images/achievements/바다낚시 그랜드 슬램.webp', 57),
('숨겨진,곤충 채집', '온천산의 곤충왕', '곤충 유인 사건의 모든 칭호 획득 총 7개', '곤충 채집왕',
 '개인 목표: 곤충 10마리 이상 잡기
단체 목표: 함께 곤충 50마리 이상 잡기

결과 화면 칭호
- 순찰대: 개인 목표를 가장 먼저 달성한 유저
- 여치: 가장 먼저 채팅을 5회 이상 한 유저
- 먹보 벌레: 가장 먼저 음식을 3회 이상 먹은 유저
- 곤충 채집 애호가: 가장 먼저 아무 악기나 연주한 유저
- 곤충 사진사: 가장 먼저 곤충의 사진을 촬영한 유저
- 곤충 포획자: 가장 먼저 곤충을 50마리 이상 포획한 유저
- 나니와 수제자: 곤충을 50마리 이상 포획하고 전체 포획 수 1위를 기록한 유저',
 '/images/achievements/온천산의 곤충왕.webp', 58);
