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
    @DisplayName("헤더에 시간 날씨 요약과 예보 및 제보 화면이 존재한다")
    void rendersWeatherSummaryAndPanels() throws IOException {
        String header = read("templates/fragments/header.html");

        assertTrue(header.contains("id=\"headerWeatherButton\""));
        assertTrue(header.contains("id=\"weatherForecastPanel\""));
        assertTrue(header.contains("id=\"weatherVoteModal\""));
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
    @DisplayName("날씨 스크립트는 공개 조회와 CSRF 배치 제출을 사용한다")
    void weatherScriptUsesForecastAndBatchVoteApis() throws IOException {
        String script = read("static/js/header-weather.js");

        assertTrue(script.contains("fetch('/api/weather/forecast'"));
        assertTrue(script.contains("fetch('/api/weather/votes'"));
        assertTrue(script.contains("csrfHeader"));
        assertTrue(script.contains("votes:"));
        assertTrue(script.contains("Date.UTC("));
        assertTrue(script.contains("getUTCDay()"));
        assertTrue(script.contains("trapModalFocus"));
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
