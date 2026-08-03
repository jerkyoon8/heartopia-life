package com.heartopia.wiki.template;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

class WikiMobileLayoutTemplateTest {

    @Test
    void mobileHomeUsesCompactFourColumnCards() throws IOException {
        String template = new ClassPathResource("templates/wiki/wiki.html")
                .getContentAsString(StandardCharsets.UTF_8);

        assertThat(template)
                .containsPattern("(?s)@media \\(max-width: 576px\\).*?\\.quick-access-section\\s*\\{.*?display: grid;.*?grid-template-columns: repeat\\(2, minmax\\(0, 1fr\\)\\);")
                .containsPattern("(?s)@media \\(max-width: 576px\\).*?\\.wiki-grid\\s*\\{.*?grid-template-columns: repeat\\(4, minmax\\(0, 1fr\\)\\);")
                .contains("min-height: 84px;")
                .containsPattern("(?s)\\.card-count:not\\(\\.card-status\\)\\s*\\{.*?display: none;")
                .contains("grid-template-rows: auto auto 1fr auto;");
    }
}
