# 수집도감 & 쿠폰 DB 영속화 배포 노트

서버에 반영할 때 이 순서 그대로 실행.

---

## 아키텍처 개요 (중요)

**수집도감은 opt-in 기반 DB 동기화 구조.**

- 비로그인 / 로그인+동기화OFF (기본값): localStorage만 사용, DB 건드리지 않음
- 로그인+동기화ON: DB가 단일 진실. localStorage 사용 안 함.
- 동기화 토글은 헤더 프로필 드롭다운에서 유저가 명시적으로 켜야 동작

쿠폰은 로그인 시 자동 마이그레이션 (기존 구조 유지).

---

## 1. 테이블 생성 (아직 없으면)

### 로컬
```bash
# MySQL Workbench 또는 CLI에서 heartopia_db 선택 후 실행
source heartopia-wiki/src/main/resources/sql/create_user_copied_coupons.sql
source heartopia-wiki/src/main/resources/sql/create_user_checklist.sql
```

### 서버 (Docker)
```bash
docker exec -i deploy-db-1 mysql -u root -p'!Dx11src02' --default-character-set=utf8mb4 heartopia_db \
  < heartopia-wiki/src/main/resources/sql/create_user_copied_coupons.sql

docker exec -i deploy-db-1 mysql -u root -p'!Dx11src02' --default-character-set=utf8mb4 heartopia_db \
  < heartopia-wiki/src/main/resources/sql/create_user_checklist.sql
```

---

## 2. users 테이블에 sync 플래그 컬럼 추가 (신규)

```sql
ALTER TABLE users
    ADD COLUMN checklist_sync_enabled BOOLEAN NOT NULL DEFAULT FALSE;
```

### 로컬
```bash
source heartopia-wiki/src/main/resources/sql/alter_users_add_checklist_sync.sql
```

### 서버 (Docker)
```bash
docker exec -i deploy-db-1 mysql -u root -p'!Dx11src02' --default-character-set=utf8mb4 heartopia_db \
  < heartopia-wiki/src/main/resources/sql/alter_users_add_checklist_sync.sql
```

> `users` 테이블은 이미 wiki_user가 SELECT/UPDATE 권한을 가진 상태이므로 추가 GRANT 불필요.

---

## 3. wiki_user 권한 부여 (필수)

`wiki_user`는 기본적으로 신규 테이블에 DELETE/INSERT 권한이 없다.
**권한 없으면 동기화ON 유저의 체크 해제가 DB에 반영 안 됨.**

root 계정으로 접속 후 실행:

```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON heartopia_db.user_checklist TO 'wiki_user'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON heartopia_db.user_copied_coupons TO 'wiki_user'@'%';
FLUSH PRIVILEGES;
```

> ⚠️ `'wiki_user'@'localhost'`가 아니라 `'wiki_user'@'%'` 사용.
> `@'localhost'`로 실행하면 "새 유저 생성 시도"로 인식돼 `Error 1410` 발생.

### 서버 (Docker)
```bash
docker exec -i deploy-db-1 mysql -u root -p'!Dx11src02' -e "
GRANT SELECT, INSERT, UPDATE, DELETE ON heartopia_db.user_checklist TO 'wiki_user'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON heartopia_db.user_copied_coupons TO 'wiki_user'@'%';
FLUSH PRIVILEGES;
"
```

---

## 4. 검증

```sql
-- 권한 확인
SHOW GRANTS FOR 'wiki_user'@'%';

-- 테이블/컬럼 존재 확인
SHOW TABLES LIKE 'user_checklist';
SHOW TABLES LIKE 'user_copied_coupons';
DESCRIBE users;
-- checklist_sync_enabled 컬럼이 보여야 함 (tinyint(1), default 0)
```

---

## 5. 관련 코드 변경

이번 배포에 함께 들어가는 수정 (SQL만 돌려서는 동작 안 함):

**백엔드:**
- `model/User.java` — `checklistSyncEnabled` 필드 추가
- `dto/oauth2/CustomOAuth2User.java` — `isChecklistSyncEnabled()` getter
- `mapper/UserMapper.java` + `UserMapper.xml` — `updateChecklistSyncEnabled` 추가
- `service/UserChecklistService.java` — `toggleSync` 메서드
- `controller/UserChecklistController.java` — `PUT /api/user/checklist/sync` 엔드포인트

**프론트:**
- `static/js/checklist-core.js` — sync 모드면 localStorage 무시
- `static/js/checklist.js` / `checklist-sync.js` — `syncEnabled` 플래그 기반 DB 동작
- `templates/fragments/common-head.html` — sync 플래그를 ChecklistCore init 전에 주입
- `templates/fragments/header.html` — 프로필 드롭다운에 동기화 토글 UI + 토스트
- `templates/wiki/codes.html` — 쿠폰 API 응답에 `res.ok` 체크

---

## 6. 유저 동작 시나리오

| 상태 | 데이터 저장 위치 | 비고 |
|------|-----------------|------|
| 비로그인 | localStorage | DB 호출 없음 |
| 로그인, 동기화 OFF (기본) | localStorage | DB 호출 없음. 프로필 드롭다운에 토글 노출 |
| 동기화 ON 전환 시 | localStorage → DB 1회 업로드 후 localStorage 삭제 | 확인 대화상자 거침 |
| 로그인, 동기화 ON | DB만 | 모든 체크/별점 즉시 DB 반영 |
| 동기화 OFF 전환 시 | DB 그대로 유지 + localStorage에 현재 DB 상태 복사 | 다시 켜면 복구 가능 |

---

## 7. 기타 메모

- `user_copied_coupons.copied_at` 컬럼은 현재 사용 안 됨.
  만료 쿠폰 삭제 방식으로 운영할 예정이라 추후 제거 가능.
- 쿠폰은 `coupon_name` 기반 저장. 관리자가 코드명 수정 시 기존 복사 기록은 orphan 됨.
- 동기화 토글 변경 시 페이지 리로드됨 (세션의 User 객체 갱신용).
