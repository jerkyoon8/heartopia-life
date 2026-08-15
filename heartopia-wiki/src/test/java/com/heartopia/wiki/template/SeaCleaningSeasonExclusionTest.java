package com.heartopia.wiki.template;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;

class SeaCleaningSeasonExclusionTest {

    @Test
    void seaCleaningTemplateHasNoEventFilterAndSupportsLevelsThroughEight() throws IOException {
        String template = read("templates/wiki/others/sea-cleaning.html");

        assertThat(template)
                .doesNotContain("fragments/wiki-components :: quickEventFilter")
                .doesNotContain("fragments/wiki-components :: eventFilter")
                .doesNotContain("{ id: 'eventFilter', dataKey: 'event', type: 'event-multi' }")
                .doesNotContain("th:data-event=")
                .doesNotContain("name=\"eventName\"")
                .contains("${#numbers.sequence(1, 8)}");
    }

    @Test
    void seaCleaningPersistenceAndGlobalEventDiscoveryIgnoreEventNames() throws IOException {
        String collections = read("mapper/CollectionMapper.xml");
        String events = read("mapper/EventSettingsMapper.xml");
        String insert = statement(collections, "<insert id=\"insertSeaCleaning\"", "</insert>");
        String update = statement(collections, "<update id=\"updateSeaCleaning\"", "</update>");

        assertThat(insert)
                .doesNotContain("event_name")
                .doesNotContain("#{eventName}");
        assertThat(update)
                .contains("event_name=NULL")
                .doesNotContain("#{eventName}");
        assertThat(events).doesNotContain("FROM sea_cleaning_collections");
    }

    @Test
    void dataCleanupSqlClearsAndVerifiesAllLegacyEventNames() throws IOException {
        String sql = read("sql/20260815_clear_sea_cleaning_event_names.sql");

        assertThat(sql)
                .contains("UPDATE sea_cleaning_collections")
                .contains("SET event_name = NULL")
                .contains("WHERE event_name IS NOT NULL")
                .contains("remaining_event_names")
                .contains("COUNT(*)");
    }

    private String statement(String source, String startMarker, String endMarker) {
        int start = source.indexOf(startMarker);
        int end = source.indexOf(endMarker, start);
        return source.substring(start, end + endMarker.length());
    }

    private String read(String resourcePath) throws IOException {
        return new ClassPathResource(resourcePath).getContentAsString(StandardCharsets.UTF_8);
    }
}
