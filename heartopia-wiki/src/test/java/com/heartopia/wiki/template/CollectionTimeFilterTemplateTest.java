package com.heartopia.wiki.template;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

class CollectionTimeFilterTemplateTest {

    @Test
    void collectionTableRowsExposeTimeUsedByTheSharedFilter() throws IOException {
        assertTableRowTimeAttribute("templates/wiki/collections/fish.html", "fish");
        assertTableRowTimeAttribute("templates/wiki/collections/bug.html", "bug");
        assertTableRowTimeAttribute("templates/wiki/collections/bird.html", "bird");
    }

    private void assertTableRowTimeAttribute(String resourcePath, String itemName) throws IOException {
        String template = new ClassPathResource(resourcePath)
                .getContentAsString(StandardCharsets.UTF_8);
        int rowStart = template.indexOf("class=\"wiki-table-row\"");

        assertThat(rowStart)
                .as("%s must contain a wiki table row", resourcePath)
                .isGreaterThanOrEqualTo(0);

        int rowTagEnd = template.indexOf('>', rowStart);
        assertThat(rowTagEnd)
                .as("%s table row start tag must be closed", resourcePath)
                .isGreaterThan(rowStart);

        String rowStartTag = template.substring(rowStart, rowTagEnd);
        assertThat(rowStartTag)
                .as("%s table rows must expose time to WikiFilter", resourcePath)
                .contains("th:data-time=\"${" + itemName + ".time}\"");
    }
}
