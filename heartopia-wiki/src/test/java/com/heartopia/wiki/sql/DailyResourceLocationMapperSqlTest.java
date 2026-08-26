package com.heartopia.wiki.sql;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;

class DailyResourceLocationMapperSqlTest {

    @Test
    void cleanupPhysicallyDeletesOnlyDatesBeforeCurrentGameDate() throws IOException {
        String mapper = resource("mapper/DailyResourceLocationMapper.xml")
                .replaceAll("\\s+", " ");

        assertThat(mapper)
                .contains("<delete id=\"deleteBeforeGameDate\">")
                .contains("DELETE FROM daily_resource_locations WHERE game_date &lt; #{gameDate}")
                .doesNotContain("WHERE game_date &lt;= #{gameDate}");
    }

    private String resource(String path) throws IOException {
        try (InputStream input = getClass().getClassLoader().getResourceAsStream(path)) {
            assertThat(input).as("resource %s", path).isNotNull();
            return new String(input.readAllBytes(), StandardCharsets.UTF_8);
        }
    }
}
