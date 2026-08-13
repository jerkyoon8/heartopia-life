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
                    .contains("fragments/wiki-components :: quickEventFilter")
                    .contains("fragments/wiki-components :: eventFilter")
                    .contains("/js/wiki-filter.js?v=2.9")
                    .contains("{ id: 'eventFilter', dataKey: 'event', type: 'event-multi' }")
                    .contains("th:data-event=");
        }
    }

    @Test
    void sharedFilterProvidesGeneralAndAdminQuickEventValues() throws IOException {
        String components = read("templates/fragments/wiki-components.html");
        String commonHead = read("templates/fragments/common-head.html");
        String commonCss = read("static/css/common.css");

        assertThat(components)
                .contains("th:fragment=\"quickEventFilter\"")
                .contains("id=\"quickEventOnlyToggle\"")
                .contains("class=\"quick-event-controls quick-event-split-control\"")
                .contains("class=\"quick-event-toggle-button\"")
                .contains("class=\"quick-event-toggle-state\"")
                .contains("class=\"filter-multi-select-wrapper quick-event-picker\"")
                .contains("class=\"quick-event-value\"")
                .contains("class=\"event-general-options\"")
                .contains("이벤트만 보기");

        assertThat(commonCss)
                .contains(".quick-event-split-control")
                .contains(".quick-event-toggle-button:has(input:checked)")
                .contains("[data-theme='dark'] .quick-event-toggle-button:has(input:checked)")
                .contains(".quick-event-toggle-state::before")
                .contains("content: \"OFF\"")
                .contains("content: \"ON\"")
                .contains("width: min(100%, 340px)")
                .contains("width: min(320px, calc(100vw - 32px))")
                .doesNotContain(".quick-event-controls {\n        flex-wrap: wrap;");

        String script = read("static/js/wiki-filter.js");
        assertThat(script)
                .doesNotContain("if (quickValues.length === 0) return;")
                .doesNotContain("quickToggle.disabled = quickValues.length === 0")
                .contains("quickDropdown.classList.toggle('show')");
        assertThat(commonHead).contains("/css/common.css(v=2.1)");
    }

    @Test
    void adminCanConfigureCurrentAndQuickEventsSeparately() throws IOException {
        String admin = read("templates/wiki/admin-event-settings.html");

        assertThat(admin)
                .contains("name=\"currentEventNames\"")
                .contains("name=\"quickEventNames\"")
                .contains("name=\"eventSettingsVersion\" value=\"2\"")
                .contains("상단 빠른 선택에 표시할 이벤트")
                .doesNotContain("name=\"eventNames\"");
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
