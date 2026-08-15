package com.heartopia.wiki.template;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;

class AchievementHideCollectedTemplateTest {

    @Test
    void achievementCardAndTableRowDeclareNonStarCollectionBehavior() throws IOException {
        String template = new ClassPathResource("templates/wiki/others/achievements.html")
                .getContentAsString(StandardCharsets.UTF_8);

        assertThat(template)
                .contains("class=\"wiki-item-card sync-item\"")
                .contains("class=\"wiki-table-row\"")
                .contains("th:data-sync-key=\"'achievement_' + ${achievement.name}\"");
        assertThat(countOccurrences(template, "data-supports-star-rating=\"false\""))
                .isEqualTo(2);
        assertThat(countOccurrences(template, "th:data-sync-key=\"'achievement_' + ${achievement.name}\""))
                .isEqualTo(2);
    }

    private int countOccurrences(String source, String target) {
        return (source.length() - source.replace(target, "").length()) / target.length();
    }
}
