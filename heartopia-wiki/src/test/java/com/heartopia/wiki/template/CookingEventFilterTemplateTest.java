package com.heartopia.wiki.template;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

class CookingEventFilterTemplateTest {

    @Test
    void providesDaveTheDiverQuickFilterInsteadOfSanrioQuickFilter() throws IOException {
        String template = new ClassPathResource("templates/wiki/items/cooking.html")
                .getContentAsString(StandardCharsets.UTF_8);

        assertThat(template)
                .contains("id=\"btn-dave-event\"")
                .contains("fa-swimmer")
                .contains("데더다만 표시")
                .contains("{ button: btnDave, eventName: '데이브 더 다이버' }")
                .doesNotContain("id=\"btn-sanrio-event\"")
                .doesNotContain("SANRIO만 표시");
    }
}
