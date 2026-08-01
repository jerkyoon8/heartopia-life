package com.heartopia.wiki.template;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class SeaCleaningTemplateTest {

    private static final Path TEMPLATE = Path.of(
            "src", "main", "resources", "templates", "wiki", "others", "sea-cleaning.html");

    @Test
    @DisplayName("바다 청소 카드는 입력된 장소만 표시한다")
    void rendersLocationOnCollectionCards() throws IOException {
        String template = Files.readString(TEMPLATE, StandardCharsets.UTF_8);

        assertTrue(template.contains("<span class=\"wiki-item-tag\">"));
        assertTrue(template.contains("item.location != null and !item.location.isBlank() and item.location != '미공개' and item.location != '바다 청소'"));
        assertTrue(template.contains("th:text=\"${item.location}\""));
        assertFalse(template.contains("<td class=\"stat-label\">장소</td>"));
        assertFalse(template.contains("class=\"wiki-item-tag location-link\""));
    }
}
