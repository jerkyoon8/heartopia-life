package com.heartopia.wiki.template;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.assertFalse;

class DynamicMapResourceTemplateTest {

    private static final Path RESOURCE_ROOT = Path.of("src", "main", "resources");

    @Test
    @DisplayName("모든 지도는 고정 변동 자원 카테고리를 로드한다")
    void mapsLoadDynamicResourceCategory() throws IOException {
        String state = read("static/js/map/map-state.js");
        String core = read("static/js/map/map-core.js");

        assertTrue(state.contains("dynamic_resource: {"));
        assertTrue(state.contains("'dynamic_resource'"));
        assertTrue(state.contains("masterDynamicResources"));
        assertTrue(core.contains("/wiki/map/api/dynamic-resources"));
    }

    @Test
    @DisplayName("관리자는 지도에서 변동 자원을 등록할 수 있다")
    void adminCanOpenDynamicResourceForm() throws IOException {
        String template = read("templates/wiki/map.html");
        String ui = read("static/js/map/map-ui.js");
        String api = read("static/js/map/map-api.js");

        assertTrue(template.contains("id=\"dynamicResourceModal\""));
        assertTrue(template.contains("id=\"dynamicResourceForm\""));
        assertTrue(ui.contains("dynamic-resource-add-btn"));
        assertTrue(ui.contains("enterPlacementMode(template, true)"));
        assertTrue(ui.contains("categoryVisible.dynamic_resource = true"));
        assertTrue(ui.contains("itemVisible[`dynamic_resource:${resource.name}`] = true"));
        assertTrue(api.contains("createDynamicResource"));
    }

    @Test
    @DisplayName("변동 자원 목록은 이름별 핀 수와 연속 배치를 지원한다")
    void dynamicResourceUsesMultiLocationBehavior() throws IOException {
        String ui = read("static/js/map/map-ui.js");

        assertTrue(ui.contains("category === 'dynamic_resource'"));
        assertTrue(ui.contains("state.masterDynamicResources"));
        assertTrue(ui.contains("pinCount"));
    }

    @Test
    @DisplayName("변동 자원 이미지는 프리셋 또는 파일 업로드로 등록한다")
    void dynamicResourceSupportsImagePresetsAndUpload() throws IOException {
        String template = read("templates/wiki/map.html");
        String ui = read("static/js/map/map-ui.js");
        String api = read("static/js/map/map-api.js");
        String controller = readJava("controller/MapController.java");

        assertTrue(template.contains("value=\"/images/map/dynamic-resources/pink-bubble.webp\""));
        assertTrue(template.contains("value=\"/images/map/dynamic-resources/fluorite.webp\""));
        assertTrue(template.contains("value=\"/images/map/dynamic-resources/oak.webp\""));
        assertTrue(template.contains("id=\"dynamicResourceImageFile\""));
        assertTrue(ui.contains("new FormData()"));
        assertTrue(api.contains("body: formData"));
        assertTrue(controller.contains("MultipartFile imageFile"));
    }

    @Test
    @DisplayName("지도 최초 로드는 변동 자원만 표시한다")
    void initialMapVisibilityShowsOnlyDynamicResources() throws IOException {
        String core = read("static/js/map/map-core.js");

        assertTrue(core.contains("const defaultVisible = ['dynamic_resource']"));
        assertTrue(core.contains("const showAllByDefault = false"));
    }

    @Test
    @DisplayName("일일 자원 위치는 지도 자동 핀을 생성하거나 교체하지 않는다")
    void dailyResourceDoesNotCreateMapPins() throws IOException {
        String header = read("static/js/header-daily-resources.js");
        String core = read("static/js/map/map-core.js");
        String ui = read("static/js/map/map-ui.js");

        assertFalse(header.contains("daily-resource-locations-updated"));
        assertFalse(core.contains("pin.systemGenerated"));
        assertFalse(core.contains("replaceDailyResourcePins"));
        assertFalse(ui.contains("pin.systemGenerated === true"));
        assertTrue(ui.contains("dynamic-resource-add-btn"));
        assertTrue(ui.contains("enterPlacementMode(template, true)"));
    }

    private String read(String relativePath) throws IOException {
        return Files.readString(RESOURCE_ROOT.resolve(relativePath), StandardCharsets.UTF_8);
    }

    private String readJava(String relativePath) throws IOException {
        return Files.readString(Path.of("src", "main", "java", "com", "heartopia", "wiki").resolve(relativePath), StandardCharsets.UTF_8);
    }
}
