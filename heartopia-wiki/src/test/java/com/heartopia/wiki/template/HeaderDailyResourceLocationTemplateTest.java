package com.heartopia.wiki.template;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class HeaderDailyResourceLocationTemplateTest {

    private static final Path RESOURCE_ROOT = Path.of("src", "main", "resources");

    @Test
    @DisplayName("헤더는 시계 왼쪽에 날짜 없는 두 자원 위치를 표시한다")
    void headerRendersCurrentLocationsWithoutDate() throws IOException {
        String header = read("templates/fragments/header.html");

        int locations = header.indexOf("id=\"headerDailyResourceLocations\"");
        int clock = header.indexOf("id=\"headerWeatherButton\"");
        assertTrue(locations >= 0 && locations < clock);
        assertTrue(header.contains("id=\"headerFluoriteLocation\""));
        assertTrue(header.contains("id=\"headerOakLocation\""));
        assertTrue(header.contains("@{/images/header/fluorite.webp}"));
        assertTrue(header.contains("@{/images/header/oak.webp}"));
        assertTrue(header.indexOf("id=\"headerOakLocation\"")
                < header.indexOf("id=\"headerFluoriteLocation\""));
        assertTrue(Files.exists(RESOURCE_ROOT.resolve("static/images/header/fluorite.webp")));
        assertTrue(Files.exists(RESOURCE_ROOT.resolve("static/images/header/oak.webp")));
        assertFalse(header.contains("id=\"headerDailyResourceDate\""));
        assertTrue(header.contains("@{/wiki/admin/daily-resource-locations}"));
        assertTrue(header.contains("/js/header-daily-resources.js"));
    }

    @Test
    @DisplayName("위치 스크립트는 공개 API와 오전 6시 및 탭 복귀 갱신을 사용한다")
    void scriptRefreshesAtGameDayBoundary() throws IOException {
        String script = read("static/js/header-daily-resources.js");

        assertTrue(script.contains("fetch('/api/daily-resource-locations/current'"));
        assertTrue(script.contains("setUTCHours(6, 0, 0, 0)"));
        assertTrue(script.contains("visibilitychange"));
        assertTrue(script.contains("Asia/Seoul"));
    }

    @Test
    @DisplayName("관리자 화면은 날짜와 허용된 위치 유형만 입력한다")
    void adminPageProvidesStructuredScheduleForm() throws IOException {
        String template = read("templates/wiki/admin-daily-resource-locations.html");

        assertTrue(template.contains("type=\"date\""));
        assertTrue(template.contains("value=\"HOUSE_FRONT\""));
        assertTrue(template.contains("value=\"RUINS\""));
        assertTrue(template.contains("name=\"fluoriteHouseNumber\""));
        assertTrue(template.contains("name=\"oakHouseNumber\""));
        assertTrue(template.contains("/wiki/admin/daily-resource-locations/save"));
        assertTrue(template.contains("/wiki/admin/daily-resource-locations/delete"));
    }

    @Test
    @DisplayName("SQL은 날짜 유일성과 두 위치 유형 제약을 정의한다")
    void sqlConstrainsDailyLocationRows() throws IOException {
        String sql = read("sql/20260730_create_daily_resource_locations.sql");

        assertTrue(sql.contains("CREATE TABLE IF NOT EXISTS daily_resource_locations"));
        assertTrue(sql.contains("UNIQUE KEY uk_daily_resource_location_game_date (game_date)"));
        assertTrue(sql.contains("HOUSE_FRONT"));
        assertTrue(sql.contains("RUINS"));
        assertTrue(sql.contains("fluorite_house_number"));
        assertTrue(sql.contains("oak_house_number"));
        assertTrue(sql.contains("is_active BOOLEAN NOT NULL DEFAULT TRUE"));

        String mapper = read("mapper/DailyResourceLocationMapper.xml");
        assertTrue(mapper.contains("SET is_active = FALSE"));
        assertFalse(mapper.contains("DELETE FROM daily_resource_locations"));
    }

    private String read(String relativePath) throws IOException {
        return Files.readString(RESOURCE_ROOT.resolve(relativePath), StandardCharsets.UTF_8);
    }
}
