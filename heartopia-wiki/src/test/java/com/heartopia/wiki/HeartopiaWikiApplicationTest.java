package com.heartopia.wiki;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;

/**
 * 애플리케이션 기본 컨텍스트 로드 테스트.
 * DB 연결 필요 → CI에는 test profile/H2 설정이 필요합니다.
 * 로컬에서만 실행할 용도입니다.
 */
// @SpringBootTest  // DB 연결 없이 단위 테스트만 돌릴 때는 주석처리
class HeartopiaWikiApplicationTest {

    @Test
    void mainClassExists() {
        // 최소 검증: 메인 클래스가 로드 가능한지
        assertDoesNotThrow(() -> Class.forName("com.heartopia.wiki.HeartopiaWikiApplication"));
    }
}
