package com.heartopia.wiki.sql;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class WhaleSeasonAchievementsSqlTest {

    @Test
    void insertsTheFourProvidedSeaCleaningAchievements() throws IOException {
        String sql = readSql();

        assertThat(sql)
                .contains("('바다 청소', '넘실대는 해류'")
                .contains("('바다 청소', '사각지대 없음'")
                .contains("('바다 청소', '자격증 취득'")
                .contains("('바다 청소', '바다 정화 전문가'")
                .contains("'밀집'")
                .contains("'비경'")
                .contains("'장애물 제거'")
                .contains("'바다'");
    }

    @Test
    void turnsTheSlashNoteIntoAReadableTipAndUsesMatchingImages() throws IOException {
        String sql = readSql();

        assertThat(sql)
                .contains("바다 청소 취미 5레벨에 열리는 바다집(해저 메사)에서 생태 어군 25레벨을 달성하면 획득할 수 있습니다.")
                .doesNotContain("/바다청소")
                .contains("/images/achievements/넘실대는 해류.webp")
                .contains("/images/achievements/사각지대 없음.webp")
                .contains("/images/achievements/자격증 취득.webp")
                .contains("/images/achievements/바다 정화 전문가.webp");
    }

    @Test
    void isIdempotentAndIncludesADeploymentVerificationQuery() throws IOException {
        String sql = readSql();

        assertThat(sql)
                .contains("ON DUPLICATE KEY UPDATE")
                .contains("sort_order = VALUES(sort_order)")
                .contains("WHERE name IN (")
                .contains("ORDER BY sort_order ASC");
    }

    @Test
    void shipsFourRealWebpImagesAtTheSqlPaths() throws IOException {
        List<String> names = List.of("넘실대는 해류", "사각지대 없음", "자격증 취득", "바다 정화 전문가");

        for (String name : names) {
            ClassPathResource image = new ClassPathResource("static/images/achievements/" + name + ".webp");
            assertThat(image.exists()).as(name + " image").isTrue();
            try (var input = image.getInputStream()) {
                byte[] header = input.readNBytes(12);
                assertThat(new String(header, 0, 4, StandardCharsets.US_ASCII)).isEqualTo("RIFF");
                assertThat(new String(header, 8, 4, StandardCharsets.US_ASCII)).isEqualTo("WEBP");
            }
        }
    }

    private String readSql() throws IOException {
        return new ClassPathResource("sql/20260819_add_whale_season_achievements.sql")
                .getContentAsString(StandardCharsets.UTF_8);
    }
}
