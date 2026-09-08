package com.heartopia.wiki.template;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class HeaderWeatherTemplateTest {

    private static final Path RESOURCE_ROOT = Path.of("src", "main", "resources");

    @Test
    @DisplayName("도감 메뉴는 도감, 취미, 기타정보 세 분류의 링크를 제공한다")
    void rendersThreeSectionEncyclopediaMegaMenu() throws IOException {
        String header = read("templates/fragments/header.html");

        assertTrue(header.contains(">도감</a>"));
        assertFalse(header.contains(">컬렉션</a>"));
        assertFalse(header.contains(">아이템들</a>"));
        assertFalse(header.contains(">기타</a>"));
        assertTrue(header.contains("<h5>도감</h5>"));
        assertTrue(header.contains("<h5>취미</h5>"));
        assertTrue(header.contains("<h5>기타정보</h5>"));

        assertTrue(header.contains("@{/wiki/collections/fish}"));
        assertTrue(header.contains("@{/wiki/collections/bug}"));
        assertTrue(header.contains("@{/wiki/collections/bird}"));
        assertTrue(header.contains("@{/wiki/collections/animal}"));
        assertTrue(header.contains("@{/wiki/items/cooking}"));
        assertTrue(header.contains("@{/wiki/items/crops}"));
        assertTrue(header.contains("@{/wiki/items/flowers}"));
        assertTrue(header.contains("@{/wiki/collections/forageable}"));
        assertTrue(header.contains("@{/wiki/others/villagers}"));
        assertTrue(header.contains("@{/wiki/others/sandbox}"));
        assertTrue(header.contains("@{/wiki/others/sea-cleaning}"));
        assertTrue(header.contains("@{/wiki/others/pets}"));
        assertTrue(header.contains("@{/wiki/others/puzzles}"));
    }

    @Test
    @DisplayName("헤더에 시간 날씨 요약과 예보 화면만 존재한다")
    void rendersWeatherSummaryAndPanels() throws IOException {
        String header = read("templates/fragments/header.html");

        assertTrue(header.contains("id=\"headerWeatherButton\""));
        assertTrue(header.contains("id=\"weatherForecastPanel\""));
        assertFalse(header.contains("id=\"weatherVoteModal\""));
        assertFalse(header.contains("id=\"weatherVoteStart\""));
        assertFalse(header.contains("로그인 후 제보할 수 있어요"));
        assertTrue(header.contains("@{/wiki/admin/weather-schedules}"));
        assertTrue(header.contains("/js/header-weather.js"));
    }

    @Test
    @DisplayName("날씨 아이콘 다섯 종만 포함하고 자원 아이콘은 포함하지 않는다")
    void includesOnlyWeatherAssets() throws IOException {
        Path weatherDir = RESOURCE_ROOT.resolve("static/images/weather");

        assertTrue(Files.exists(weatherDir.resolve("sunny.webp")));
        assertTrue(Files.exists(weatherDir.resolve("rain.webp")));
        assertTrue(Files.exists(weatherDir.resolve("rainbow.webp")));
        assertTrue(Files.exists(weatherDir.resolve("meteor-shower.webp")));
        assertTrue(Files.exists(weatherDir.resolve("heatwave.webp")));
        assertFalse(Files.exists(weatherDir.resolve("oak.webp")));
        assertFalse(Files.exists(weatherDir.resolve("fluorite.webp")));
    }

    @Test
    @DisplayName("날씨 스크립트는 공개 조회만 사용하고 제보 코드를 포함하지 않는다")
    void weatherScriptUsesReadOnlyForecastApi() throws IOException {
        String script = read("static/js/header-weather.js");
        String controller = Files.readString(
                Path.of("src", "main", "java", "com", "heartopia", "wiki", "controller",
                        "WeatherForecastController.java"),
                StandardCharsets.UTF_8);

        assertTrue(script.contains("fetch('/api/weather/forecast'"));
        assertFalse(script.contains("fetch('/api/weather/votes'"));
        assertFalse(script.contains("csrfHeader"));
        assertFalse(script.contains("votes:"));
        assertTrue(script.contains("Date.UTC("));
        assertTrue(script.contains("getUTCDay()"));
        assertFalse(script.contains("trapModalFocus"));
        assertTrue(script.contains("SNOW: { label: '눈'"));
        assertTrue(script.contains("AURORA: { label: '오로라'"));
        assertFalse(controller.contains("@PostMapping"));
        assertFalse(controller.contains("/votes"));
    }

    @Test
    @DisplayName("독립 날씨 예약 화면과 SQL은 6시간 슬롯 계약을 제공한다")
    void weatherScheduleUsesIndependentTableAndAdminForm() throws IOException {
        String template = read("templates/wiki/admin-weather-schedules.html");
        String sql = read("sql/20260908_create_weather_schedules.sql");
        String mapper = read("mapper/WeatherScheduleMapper.xml");

        assertTrue(template.contains("name=\"forecastDate\""));
        assertTrue(template.contains("name=\"slotHour\""));
        assertTrue(template.contains("name=\"weatherCode\""));
        assertTrue(template.contains("/wiki/admin/weather-schedules/save"));
        assertTrue(template.contains("/wiki/admin/weather-schedules/delete"));
        assertTrue(sql.contains("CREATE TABLE IF NOT EXISTS weather_schedules"));
        assertTrue(sql.contains("CHECK (slot_hour IN (0, 6, 12, 18))"));
        assertTrue(sql.contains("UNIQUE KEY uk_weather_schedule_date_slot"));
        assertTrue(mapper.contains("FROM weather_schedules"));
    }

    @Test
    @DisplayName("숨긴 날씨 패널과 제보 모달은 포인터 입력을 가로채지 않는다")
    void hiddenWeatherLayersStayHidden() throws IOException {
        String css = read("static/css/common.css");

        assertTrue(css.contains(".weather-vote-modal[hidden]"));
        assertTrue(css.contains(".weather-panel[hidden]"));
        assertTrue(css.contains("display: none;"));
    }

    private String read(String relativePath) throws IOException {
        return Files.readString(RESOURCE_ROOT.resolve(relativePath), StandardCharsets.UTF_8);
    }
}
