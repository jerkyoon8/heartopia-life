package com.heartopia.wiki.template;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class MapInitialLoadPerformanceTemplateTest {

    private static final Path RESOURCE_ROOT = Path.of("src", "main", "resources");

    @Test
    @DisplayName("지도별로 필요한 마스터 데이터 카테고리만 선언한다")
    void mapConfigDeclaresSupportedDataCategories() throws IOException {
        String mapState = read("static/js/map/map-state.js");

        assertTrue(mapState.contains("dataCategories: ['forageable', 'fish', 'bird', 'insect', 'animal', 'villager']"));
        assertTrue(mapState.contains("dataCategories: ['forageable', 'animal']"));
        assertTrue(mapState.contains("getActiveDataCategories"));
    }

    @Test
    @DisplayName("기본 지도는 원본보다 작은 WebP 서비스를 사용한다")
    void townMapUsesCompressedWebpAsset() throws IOException {
        Path original = RESOURCE_ROOT.resolve("static/images/map/heartopia-map.png");
        Path webp = RESOURCE_ROOT.resolve("static/images/map/heartopia-map.webp");
        String mapState = read("static/js/map/map-state.js");

        assertTrue(Files.exists(webp));
        assertTrue(Files.size(webp) < Files.size(original) / 5);
        assertTrue(mapState.contains("imageUrl: '/images/map/heartopia-map.webp'"));
    }

    @Test
    @DisplayName("지도 이미지와 초기 데이터 요청은 병렬로 시작한다")
    void imageAndInitialDataLoadInParallel() throws IOException {
        String mapCore = read("static/js/map/map-core.js");

        int imagePromise = mapCore.indexOf("const imageReadyPromise");
        int dataPromise = mapCore.indexOf("const initialDataPromise");
        int combinedWait = mapCore.indexOf("Promise.all([imageReadyPromise, initialDataPromise])");

        assertTrue(imagePromise >= 0);
        assertTrue(dataPromise >= 0);
        assertTrue(combinedWait > imagePromise);
        assertTrue(combinedWait > dataPromise);
    }

    @Test
    @DisplayName("활성 지도 카테고리로 마스터 API 요청을 선택한다")
    void requestsOnlyActiveMapMasterData() throws IOException {
        String mapCore = read("static/js/map/map-core.js");

        assertTrue(mapCore.contains("window.MapApp.getActiveDataCategories()"));
        assertTrue(mapCore.contains("requestedCategories.map"));
        assertTrue(mapCore.contains("MASTER_DATA_SOURCES[category]"));
        assertFalse(mapCore.contains("new Date().getTime()"));
    }

    @Test
    @DisplayName("초기 카테고리 목록은 한 번만 렌더링한다")
    void rendersInitialCategoryListOnce() throws IOException {
        String mapCore = read("static/js/map/map-core.js");
        String initializationBlock = between(
                mapCore,
                "Promise.all([imageReadyPromise, initialDataPromise])",
                "state.map.on('click'");

        assertEquals(1, count(initializationBlock, "ui.renderCategoryList();"));
    }

    @Test
    @DisplayName("초기 숨김 마커는 Leaflet 지도에 붙이지 않는다")
    void doesNotAttachInitiallyHiddenMarkers() throws IOException {
        String mapCore = read("static/js/map/map-core.js");
        String createMarker = between(mapCore, "function createMarker", "// Global listener");

        assertFalse(createMarker.contains("}).addTo(map);"));
        assertTrue(createMarker.contains("const shouldBeVisible"));
        assertTrue(createMarker.contains("if (shouldBeVisible) marker.addTo(map);"));
    }

    @Test
    @DisplayName("구역 조회 실패는 초기화 호출자에게 전파한다")
    void zoneLoadReturnsDataAndPropagatesFailures() throws IOException {
        String mapApi = read("static/js/map/map-api.js");

        assertTrue(mapApi.contains("if (!res.ok) throw new Error('Zone 로드 실패')"));
        assertTrue(mapApi.contains("return window.MapApp.state.allZones"));
        assertTrue(mapApi.contains("throw e;"));
    }

    private String read(String relativePath) throws IOException {
        return Files.readString(RESOURCE_ROOT.resolve(relativePath), StandardCharsets.UTF_8);
    }

    private String between(String source, String start, String end) {
        int startIndex = source.indexOf(start);
        int endIndex = source.indexOf(end, startIndex);
        assertTrue(startIndex >= 0, "시작 문자열을 찾을 수 없습니다: " + start);
        assertTrue(endIndex > startIndex, "종료 문자열을 찾을 수 없습니다: " + end);
        return source.substring(startIndex, endIndex);
    }

    private int count(String source, String needle) {
        int count = 0;
        int index = 0;
        while ((index = source.indexOf(needle, index)) >= 0) {
            count++;
            index += needle.length();
        }
        return count;
    }
}
