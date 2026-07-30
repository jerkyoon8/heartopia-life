package com.heartopia.wiki.template;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertTrue;

class AnimalSecondMapTemplateTest {

    private static final Path RESOURCE_ROOT = Path.of("src", "main", "resources");

    @Test
    @DisplayName("동물 관리자 모달은 고래낙하 협곡을 명시적 위치 선택지로 제공한다")
    void animalAdminModalProvidesSecondMapLocation() throws IOException {
        String animalTemplate = read("templates/wiki/collections/animal.html");

        assertTrue(animalTemplate.contains("list=\"animalLocationOptions\""));
        assertTrue(animalTemplate.contains("<datalist id=\"animalLocationOptions\">"));
        assertTrue(animalTemplate.contains("<option value=\"고래낙하 협곡\">"));
    }

    @Test
    @DisplayName("고래낙하 협곡 동물의 지도 링크는 두 번째 지도를 연다")
    void animalLocationLinkTargetsSecondMap() throws IOException {
        String animalTemplate = read("templates/wiki/collections/animal.html");
        String detailTemplate = read("templates/wiki/detail.html");

        assertTrue(animalTemplate.contains("animal.location == '고래낙하 협곡'"));
        assertTrue(animalTemplate.contains("mapKey='second'"));
        assertTrue(detailTemplate.contains("category == 'animal' and item.location == '고래낙하 협곡'"));
        assertTrue(detailTemplate.contains("mapKey='second'"));
    }

    @Test
    @DisplayName("두 번째 지도는 고래낙하 협곡 이름을 사용한다")
    void secondMapUsesCanonicalLabel() throws IOException {
        String mapTemplate = read("templates/wiki/map.html");
        String mapState = read("static/js/map/map-state.js");

        assertTrue(mapTemplate.contains("고래낙하 협곡"));
        assertTrue(mapState.contains("label: '고래낙하 협곡'"));
        assertTrue(mapState.contains("description: '고래 탐사 시즌 지도'"));
    }

    @Test
    @DisplayName("미배치 동물은 마스터 데이터로 핀 배치 템플릿을 만든다")
    void unplacedAnimalCreatesPlacementTemplate() throws IOException {
        String mapUi = read("static/js/map/map-ui.js");

        assertTrue(mapUi.contains("state.masterAnimals.find"));
        assertTrue(mapUi.contains("mapKey: state.activeMapKey || 'town'"));
        assertTrue(mapUi.contains("category: 'animal'"));
        assertTrue(mapUi.contains("ui.enterPlacementMode(template, false)"));
    }

    @Test
    @DisplayName("고래낙하 협곡 지도는 전체 표시 상태로 시작한다")
    void secondMapStartsWithAllItemsVisible() throws IOException {
        String mapCore = read("static/js/map/map-core.js");
        String mapTemplate = read("templates/wiki/map.html");

        assertTrue(mapCore.contains("const showAllByDefault = state.activeMapKey === 'second'"));
        assertTrue(mapCore.contains("state.categoryVisible[pin.category] = showAllByDefault"));
        assertTrue(mapCore.contains("state.categoryVisible[cat] = showAllByDefault"));
        assertTrue(mapCore.contains("state.zoneVisible[zoneEntry.zoneKey] = true"));
        assertTrue(mapTemplate.contains("map-core.js(v=1.21)"));
    }

    private String read(String relativePath) throws IOException {
        return Files.readString(RESOURCE_ROOT.resolve(relativePath), StandardCharsets.UTF_8);
    }
}
