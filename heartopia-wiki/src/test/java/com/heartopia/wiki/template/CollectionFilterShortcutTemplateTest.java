package com.heartopia.wiki.template;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

class CollectionFilterShortcutTemplateTest {

    @Test
    void fishBugAndBirdExposeWeatherMultiSelectAndLevelRange() throws IOException {
        for (String category : new String[] { "fish", "bug", "bird" }) {
            String template = new ClassPathResource("templates/wiki/collections/" + category + ".html")
                    .getContentAsString(StandardCharsets.UTF_8);

            assertThat(template)
                    .as(category + " collection filters")
                    .contains("id=\"btn-include-always-weather\" checked")
                    .contains("id=\"weatherFilter\"")
                    .contains("id=\"levelRangeStart\"")
                    .contains("id=\"levelRangeEnd\"")
                    .contains("class=\"level-range-apply\"")
                    .doesNotContain("data-select-level-up-to=\"10\"")
                    .doesNotContain("only-무지개")
                    .contains("th:each=\"i : ${#numbers.sequence(1, 14)}\"");
        }
    }

    @Test
    void shortcutPagesRequestNewScriptAndStyleCacheKeys() throws IOException {
        for (String category : new String[] { "fish", "bug", "bird" }) {
            String template = new ClassPathResource("templates/wiki/collections/" + category + ".html")
                    .getContentAsString(StandardCharsets.UTF_8);
            assertThat(template)
                    .as(category + " must not reuse a year-long cached filter script")
                    .contains("/js/wiki-filter.js?v=2.10");
        }

        String commonHead = new ClassPathResource("templates/fragments/common-head.html")
                .getContentAsString(StandardCharsets.UTF_8);
        assertThat(commonHead).contains("@{/css/common.css(v=2.3)}");
    }
}
