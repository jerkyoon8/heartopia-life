package com.heartopia.wiki.sql;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;

class VisitorMapperSqlTest {

    @Test
    void todayAndWeeklyCountsUseOneConditionalAggregateQuery() throws IOException {
        String mapper = resource("mapper/VisitorMapper.xml");

        assertThat(mapper)
                .contains("id=\"getVisitorSummary\"")
                .contains("CASE WHEN visit_date = CURDATE() THEN visit_count ELSE 0 END")
                .contains("visit_date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)")
                .doesNotContain("id=\"getWeeklyTotal\"")
                .doesNotContain("id=\"getTodayTotal\"");
    }

    private String resource(String path) throws IOException {
        try (InputStream input = getClass().getClassLoader().getResourceAsStream(path)) {
            assertThat(input).as("resource %s", path).isNotNull();
            return new String(input.readAllBytes(), StandardCharsets.UTF_8);
        }
    }
}
