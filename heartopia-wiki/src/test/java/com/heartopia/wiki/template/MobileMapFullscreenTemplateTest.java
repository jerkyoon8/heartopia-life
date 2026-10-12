package com.heartopia.wiki.template;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertTrue;

class MobileMapFullscreenTemplateTest {

    private static final Path RESOURCE_ROOT = Path.of("src", "main", "resources");

    @Test
    @DisplayName("모바일 지도는 접근 가능한 전체화면 전환 버튼을 제공한다")
    void mobileMapProvidesAccessibleFullscreenToggle() throws IOException {
        String template = read("templates/wiki/map.html");

        assertTrue(template.contains("id=\"mapFullscreenToggle\""));
        assertTrue(template.contains("aria-pressed=\"false\""));
        assertTrue(template.contains("class=\"fullscreen-label\">전체화면"));
    }

    @Test
    @DisplayName("모바일 기본 지도는 짧고 전체화면 상태는 viewport를 채운다")
    void mobileMapHasCompactAndFullscreenLayouts() throws IOException {
        String css = read("static/css/map.css");

        assertTrue(css.contains("height: clamp(300px, 44vh, 420px)"));
        assertTrue(css.contains(".map-layout.is-mobile-fullscreen"));
        assertTrue(css.contains("height: 100dvh"));
        assertTrue(css.contains("body.map-fullscreen-open"));
    }

    @Test
    @DisplayName("전체화면 전환은 Leaflet과 접근성 및 브라우저 탐색 상태를 동기화한다")
    void fullscreenToggleSynchronizesMapAndNavigationState() throws IOException {
        String mapCore = read("static/js/map/map-core.js");

        assertTrue(mapCore.contains("mapFullscreenToggle"));
        assertTrue(mapCore.contains("state.map.invalidateSize"));
        assertTrue(mapCore.contains("state.map.fitBounds(mapBounds)"));
        assertTrue(mapCore.contains("event.key === 'Escape'"));
        assertTrue(mapCore.contains("window.addEventListener('popstate'"));
        assertTrue(mapCore.contains("aria-pressed"));
    }

    @Test
    @DisplayName("지도 템플릿은 변경된 CSS와 JavaScript 캐시 버전을 사용한다")
    void mapTemplateUsesUpdatedAssetVersions() throws IOException {
        String template = read("templates/wiki/map.html");

        assertTrue(template.contains("map.css(v=1.3)"));
        assertTrue(template.contains("map-core.js(v=1.26)"));
    }

    private String read(String relativePath) throws IOException {
        return Files.readString(RESOURCE_ROOT.resolve(relativePath), StandardCharsets.UTF_8);
    }
}
