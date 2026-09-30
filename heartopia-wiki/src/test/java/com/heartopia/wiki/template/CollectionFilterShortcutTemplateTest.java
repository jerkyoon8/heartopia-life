package com.heartopia.wiki.template;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

class CollectionFilterShortcutTemplateTest {

    @Test
    void fishBugAndBirdExposeWeatherAndLevelShortcuts() throws IOException {
        for (String category : new String[] { "fish", "bug", "bird" }) {
            String template = new ClassPathResource("templates/wiki/collections/" + category + ".html")
                    .getContentAsString(StandardCharsets.UTF_8);

            assertThat(template)
                    .as(category + " collection filters")
                    .contains("id=\"btn-include-always-weather\" checked")
                    .contains("data-select-level-up-to=\"10\"")
                    .contains("th:each=\"i : ${#numbers.sequence(1, 14)}\"");
        }
    }
}
