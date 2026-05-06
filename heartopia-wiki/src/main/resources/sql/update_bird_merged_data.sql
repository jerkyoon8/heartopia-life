-- =====================================================
-- bird_collections: docs/birds_merged_inferred.md 기반 distance, stretch_time 데이터 적재
-- 매칭 전략: 양쪽 이름의 공백 모두 제거 후 비교 (DB 이름은 절대 변경하지 않음)
-- 대상: 63개 (md의 Lv1~10 표. Lv11~14는 distance/stretch_time 빈 값이라 제외)
-- 사전 조건: alter_bird_distance_stretch.sql 먼저 실행됨
-- 실행: docker exec -i deploy-db-1 mysql ... --default-character-set=utf8mb4 heartopia_db < 이파일
-- 실행 결과 출력에서 "0 rows affected" 보이면 = 그 줄의 이름이 DB에 없음. 사용자 검수 필요.
-- =====================================================

UPDATE bird_collections SET distance='2m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('굴뚝새', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('꼬까울새', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('노랑배박새', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('멋쟁이새', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('분홍 가슴비둘기', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('얼룩비둘기', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('염주비둘기', ' ', '');
UPDATE bird_collections SET distance='2m',  stretch_time='상시' WHERE REPLACE(name, ' ', '') = REPLACE('오목눈이', ' ', '');
UPDATE bird_collections SET distance='5m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('청공작', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('청금강앵무', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('청둥오리', ' ', '');
UPDATE bird_collections SET distance='4m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('큰홍학', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('푸른머리되새', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('동고비', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('바다갈매기', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('분홍목 녹색비둘기', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('빨간머리 때까치', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('수염오목눈이', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('웡가비둘기', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('홍머리오리', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('검은턱 오목눈이', ' ', '');
UPDATE bird_collections SET distance='2m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('녹자작', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('오두앵갈매기', ' ', '');
UPDATE bird_collections SET distance='4m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('유럽가마우지', ' ', '');
UPDATE bird_collections SET distance='3m', stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('유럽꾀꼬리', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('호사북방오리', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('홍금강앵무', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('황오리', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('노란머리 바우어새', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('솔양진이', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('알락할미새', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('은계', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='상시 비/무지개, 새호루라기 0~6' WHERE REPLACE(name, ' ', '') = REPLACE('황금 과일비둘기', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('회색머리 붉은참새', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('흰비오리', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('검정 제비갈매기', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('노랑배딱새', ' ', '');
UPDATE bird_collections SET distance='4m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('올리브비둘기', ' ', '');
UPDATE bird_collections SET distance='3m', stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('유럽벌잡이새', ' ', '');
UPDATE bird_collections SET distance='4m', stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('작은홍학', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='18~24' WHERE REPLACE(name, ' ', '') = REPLACE('초록금강앵무', ' ', '');
UPDATE bird_collections SET distance='4m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('붉은뺨 가마우지', ' ', '');
UPDATE bird_collections SET distance='4m',  stretch_time='18~24' WHERE REPLACE(name, ' ', '') = REPLACE('칡부엉이', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('콩새', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('황금 가슴비둘기', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('잠부과일 비둘기', ' ', '');
UPDATE bird_collections SET distance='3m', stretch_time='6~18' WHERE REPLACE(name, ' ', '') = REPLACE('제비갈매기', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('푸른박새', ' ', '');
UPDATE bird_collections SET distance='4m',  stretch_time='6~24' WHERE REPLACE(name, ' ', '') = REPLACE('황조롱이', ' ', '');
UPDATE bird_collections SET distance='3m', stretch_time='18~24' WHERE REPLACE(name, ' ', '') = REPLACE('히아신스 금강앵무', ' ', '');
UPDATE bird_collections SET distance='3m', stretch_time='18~24' WHERE REPLACE(name, ' ', '') = REPLACE('동부 파랑새', ' ', '');
UPDATE bird_collections SET distance='4m', stretch_time='18~24' WHERE REPLACE(name, ' ', '') = REPLACE('매', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='12~24' WHERE REPLACE(name, ' ', '') = REPLACE('분홍비둘기', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='12~24' WHERE REPLACE(name, ' ', '') = REPLACE('홍방울새', ' ', '');
UPDATE bird_collections SET distance='3m', stretch_time='18~24' WHERE REPLACE(name, ' ', '') = REPLACE('극락풍금조', ' ', '');
UPDATE bird_collections SET distance='5m',  stretch_time='무지개 12~18' WHERE REPLACE(name, ' ', '') = REPLACE('녹공작', ' ', '');
UPDATE bird_collections SET distance='4m', stretch_time='12~18' WHERE REPLACE(name, ' ', '') = REPLACE('아메리카홍학', ' ', '');
UPDATE bird_collections SET distance='4m',  stretch_time='12~18' WHERE REPLACE(name, ' ', '') = REPLACE('황제 가마우지', ' ', '');
UPDATE bird_collections SET distance='3m', stretch_time='12~18' WHERE REPLACE(name, ' ', '') = REPLACE('흰머리오리', ' ', '');
UPDATE bird_collections SET distance='4m',  stretch_time='18~24' WHERE REPLACE(name, ' ', '') = REPLACE('비둘기 조롱이', ' ', '');
UPDATE bird_collections SET distance='4m', stretch_time='18~24' WHERE REPLACE(name, ' ', '') = REPLACE('수리부엉이', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='18~24' WHERE REPLACE(name, ' ', '') = REPLACE('아조레스 멋쟁이새', ' ', '');
UPDATE bird_collections SET distance='3m',  stretch_time='18~24' WHERE REPLACE(name, ' ', '') = REPLACE('파랑딱새', ' ', '');

-- =====================================================
-- 검증: 적용된 행 수가 63개여야 함. 다르면 매칭 실패한 이름이 있음.
-- 위 UPDATE 출력에서 "0 rows affected"로 표시된 줄을 찾아서 검수.
-- =====================================================
SELECT
    COUNT(*) AS total_updated,
    63 AS expected
  FROM bird_collections
 WHERE distance IS NOT NULL;
