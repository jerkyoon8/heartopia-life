package com.heartopia.wiki.sql;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class WeatherScheduleSqlTest {
    private static final Path SQL_ROOT = Path.of("src", "main", "resources", "sql");

    @Test
    @DisplayName("200일 seed는 800개 슬롯이며 멱등 갱신을 사용한다")
    void seedContainsFourSlotsForTwoHundredDays() throws IOException {
        String sql = Files.readString(
                SQL_ROOT.resolve("20260908_seed_weather_schedules_200d.sql"),
                StandardCharsets.UTF_8);

        assertEquals(800, sql.split("\\n    \\('20", -1).length - 1);
        assertTrue(sql.contains("('2026-09-08', 0,"));
        assertTrue(sql.contains("('2027-03-26', 18,"));
        assertTrue(sql.contains("ON DUPLICATE KEY UPDATE"));
        assertTrue(sql.contains("source_weather_ids = new.source_weather_ids"));
    }
}
