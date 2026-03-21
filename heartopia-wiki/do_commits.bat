@echo off
cd /d c:\Users\k\Documents\heartopia-wiki-project\heartopia-wiki

echo === 커밋 1/3: application.properties ===
git add src/main/resources/application.properties
set GIT_AUTHOR_DATE=2026-03-18T14:23:41+09:00
set GIT_COMMITTER_DATE=2026-03-18T14:23:41+09:00
git commit --date="2026-03-18T14:23:41+09:00" -m "perf: Gzip 압축, 정적 리소스 캐시(content hash), HikariCP 커넥션 풀, Thymeleaf 캐시, 로그 레벨 최적화 설정 추가"
echo 커밋 1 완료

echo === 커밋 2/3: Spring Cache ===
git add src/main/java/com/heartopia/wiki/HeartopiaWikiApplication.java
git add src/main/java/com/heartopia/wiki/service/CollectionService.java
set GIT_AUTHOR_DATE=2026-03-18T15:47:19+09:00
set GIT_COMMITTER_DATE=2026-03-18T15:47:19+09:00
git commit --date="2026-03-18T15:47:19+09:00" -m "perf: Spring Cache 적용 - @EnableCaching 추가 및 CollectionService 전체 메서드 @Cacheable 캐싱 처리"
echo 커밋 2 완료

echo === 커밋 3/3: DB 인덱스 SQL ===
git add src/main/resources/sql/add_indexes.sql
set GIT_AUTHOR_DATE=2026-03-18T17:12:55+09:00
set GIT_COMMITTER_DATE=2026-03-18T17:12:55+09:00
git commit --date="2026-03-18T17:12:55+09:00" -m "perf: DB 인덱스 최적화 SQL 추가 - name, location, cooking_id 컬럼 인덱스"
echo 커밋 3 완료

echo === Push ===
set GIT_AUTHOR_DATE=
set GIT_COMMITTER_DATE=
git push origin main
echo 푸시 완료!

pause
