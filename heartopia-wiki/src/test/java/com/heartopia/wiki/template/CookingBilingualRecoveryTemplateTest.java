package com.heartopia.wiki.template;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

class CookingBilingualRecoveryTemplateTest {

    @Test
    void cookingListShowsRecoveryBelowPriceWithoutEnglishNames() throws IOException {
        String template = resource("templates/wiki/items/cooking.html");

        assertThat(template)
                .contains("item.recoveries")
                .contains("item.hasRecoveryData()")
                .contains("cooking-recovery-panel")
                .contains("회복량 정보 없음")
                .contains("<p class=\"small fw-bold mb-1\"><i class=\"fas fa-bolt me-1\"")
                .doesNotContain("item.englishName")
                .doesNotContain("name=\"englishName\"");
        assertThat(template.indexOf("priceDisplay(${item.prices})"))
                .isLessThan(template.indexOf("<div class=\"cooking-recovery-panel\""));
    }

    @Test
    void cookingDetailShowsRecoveryAfterPriceWithoutEnglishName() throws IOException {
        String template = resource("templates/wiki/detail.html");

        assertThat(template)
                .contains("item.recoveries")
                .contains("detail-recovery-grid")
                .contains("등급별 회복량")
                .doesNotContain("item.englishName");
        assertThat(template.indexOf("등급별 판매가"))
                .isLessThan(template.indexOf("등급별 회복량"));
    }

    @Test
    void cookingAdminFormCanEditAllRecoveryGradesWithoutEnglishName() throws IOException {
        String template = resource("templates/wiki/items/cooking.html");

        assertThat(template).doesNotContain("name=\"englishName\"");
        for (int grade = 1; grade <= 5; grade++) {
            assertThat(template).contains("name=\"recovery" + grade + "\"");
        }
    }

    private String resource(String path) throws IOException {
        return new ClassPathResource(path).getContentAsString(StandardCharsets.UTF_8);
    }
}
