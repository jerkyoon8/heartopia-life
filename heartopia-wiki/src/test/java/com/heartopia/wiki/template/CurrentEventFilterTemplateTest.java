package com.heartopia.wiki.template;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class CurrentEventFilterTemplateTest {

    private static final List<String> EVENT_COLLECTION_TEMPLATES = List.of(
            "templates/wiki/collections/fish.html",
            "templates/wiki/collections/bug.html",
            "templates/wiki/collections/bird.html",
            "templates/wiki/collections/animal.html",
            "templates/wiki/collections/forageable.html",
            "templates/wiki/items/cooking.html",
            "templates/wiki/items/flowers.html",
            "templates/wiki/items/crops.html",
            "templates/wiki/others/sandbox.html",
            "templates/wiki/others/sea-cleaning.html");

    @Test
    void allEventCollectionsUseTheSharedMultiSelectFilter() throws IOException {
        for (String resourcePath : EVENT_COLLECTION_TEMPLATES) {
            String template = read(resourcePath);

            assertThat(template)
                    .as(resourcePath)
                    .contains("fragments/wiki-components :: eventFilter")
                    .contains("{ id: 'eventFilter', dataKey: 'event', type: 'event-multi' }")
                    .contains("th:data-event=");
        }
    }

    @Test
    void legacySingleEventSwitchesAreRemoved() throws IOException {
        for (String resourcePath : EVENT_COLLECTION_TEMPLATES) {
            assertThat(read(resourcePath))
                    .as(resourcePath)
                    .doesNotContain("btn-block-city-event")
                    .doesNotContain("btn-dave-event");
        }
    }

    @Test
    void tableRowsExposeEventDataWhereTableViewExists() throws IOException {
        for (String resourcePath : EVENT_COLLECTION_TEMPLATES) {
            String template = read(resourcePath);
            int rowStart = template.indexOf("class=\"wiki-table-row");
            if (rowStart < 0) {
                continue;
            }

            int rowTagEnd = template.indexOf('>', rowStart);
            assertThat(template.substring(rowStart, rowTagEnd))
                    .as(resourcePath)
                    .contains("th:data-event=");
        }
    }

    private String read(String resourcePath) throws IOException {
        return new ClassPathResource(resourcePath).getContentAsString(StandardCharsets.UTF_8);
    }
}
