package com.heartopia.wiki.sql;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class EventSettingsMapperSqlTest {

    @Test
    void normalizesEventNameCollationBeforeUnion() throws IOException {
        String mapper = new ClassPathResource("mapper/EventSettingsMapper.xml")
                .getContentAsString(StandardCharsets.UTF_8);

        List<String> eventNameQueries = mapper.lines()
                .map(String::trim)
                .filter(line -> line.startsWith("SELECT TRIM(event_name)") && line.contains("_collections"))
                .toList();

        assertThat(eventNameQueries).hasSize(10);
        assertThat(eventNameQueries)
                .allSatisfy(query -> assertThat(query).contains("COLLATE utf8mb4_unicode_ci"));
    }
}
