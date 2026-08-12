package com.heartopia.wiki.template;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

class CookingEventFilterTemplateTest {

    @Test
    void usesSharedEventMultiSelectInsteadOfDedicatedQuickFilters() throws IOException {
        String template = new ClassPathResource("templates/wiki/items/cooking.html")
                .getContentAsString(StandardCharsets.UTF_8);

        assertThat(template)
                .contains("fragments/wiki-components :: eventFilter")
                .contains("{ id: 'eventFilter', dataKey: 'event', type: 'event-multi' }")
                .doesNotContain("id=\"btn-dave-event\"")
                .doesNotContain("데더다만 표시")
                .doesNotContain("id=\"btn-block-city-event\"")
                .doesNotContain("id=\"btn-sanrio-event\"")
                .doesNotContain("SANRIO만 표시");
    }
}
