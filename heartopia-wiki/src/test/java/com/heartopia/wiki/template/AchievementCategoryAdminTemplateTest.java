package com.heartopia.wiki.template;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;

class AchievementCategoryAdminTemplateTest {

    @Test
    void exposesNewCategoriesInPublicFilterAndAdminForm() throws IOException {
        String template = readTemplate();

        assertThat(template)
                .contains("data-value=\"바다 청소\"")
                .contains("data-value=\"숨바꼭질 파티\"")
                .contains("name=\"categories\"")
                .contains("data-achievement-category-option=\"바다 청소\"")
                .contains("data-achievement-category-option=\"숨바꼭질 파티\"")
                .contains("data-achievement-categories");
    }

    @Test
    void editPayloadAndFormIncludeAllEditableAchievementFields() throws IOException {
        String template = readTemplate();

        assertThat(template)
                .contains("th:data-item-categories=\"${achievement.categories}\"")
                .contains("th:data-item-tip=\"${achievement.tip}\"")
                .contains("th:data-item-sort-order=\"${achievement.sortOrder}\"")
                .contains("name=\"tip\"")
                .contains("name=\"sortOrder\"")
                .contains("/js/admin-data.js?v=1.4")
                .doesNotContain("th:data-item=\"${");
    }

    private String readTemplate() throws IOException {
        return new ClassPathResource("templates/wiki/others/achievements.html")
                .getContentAsString(StandardCharsets.UTF_8);
    }
}
