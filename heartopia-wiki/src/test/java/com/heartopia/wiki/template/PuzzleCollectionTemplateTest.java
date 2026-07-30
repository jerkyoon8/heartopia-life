package com.heartopia.wiki.template;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PuzzleCollectionTemplateTest {

    private static final Path PROJECT_ROOT = Path.of("").toAbsolutePath();
    private static final Path RESOURCE_ROOT = PROJECT_ROOT.resolve("src/main/resources");

    @Test
    @DisplayName("퍼즐 페이지는 이름 검색과 분류·크기 필터를 제공한다")
    void puzzlePageProvidesSearchAndFilters() throws IOException {
        String template = readResource("templates/wiki/others/puzzles.html");

        assertTrue(template.contains("${puzzleList}"));
        assertTrue(template.contains("id=\"searchInput\""));
        assertTrue(template.contains("data-filter=\"category\""));
        assertTrue(template.contains("data-filter=\"size\""));
        assertTrue(template.contains("<option value=\"고래 탐사 시즌\">고래 탐사 시즌</option>"));
        assertTrue(template.contains("th:data-category=\"${puzzle.category}\""));
        assertTrue(template.contains("th:data-size=\"${puzzle.size}\""));
        assertTrue(template.contains("id=\"noResults\""));
        assertTrue(template.contains("loading=\"lazy\""));
        assertTrue(template.contains("class=\"btn-filter-toggle\""));
        assertTrue(template.contains("id=\"advancedFilters\""));
        assertTrue(template.contains("class=\"filter-advanced-tier\""));
        assertTrue(template.contains("class=\"advanced-section\""));
        assertTrue(template.contains("class=\"advanced-controls-box\""));
        assertTrue(template.contains("class=\"filter-select-wrapper\""));
        assertTrue(template.contains("id=\"sortGroup\""));
        assertTrue(template.contains("id=\"viewToggle\""));
    }

    @Test
    @DisplayName("퍼즐 페이지는 이미지와 한국어 핵심 정보를 표시한다")
    void puzzlePageRendersMatchedFields() throws IOException {
        String template = readResource("templates/wiki/others/puzzles.html");

        assertTrue(template.contains("th:src=\"${puzzle.imageUrl}\""));
        assertTrue(template.contains("th:text=\"${puzzle.name}\""));
        assertTrue(template.contains("th:text=\"${puzzle.category}\""));
        assertTrue(template.contains("th:text=\"${puzzle.size}\""));
        assertTrue(template.contains("th:text=\"${puzzle.acquisitionMethod}\""));
        assertTrue(template.contains("puzzle.purchasePrice"));
    }

    @Test
    @DisplayName("컨트롤러는 퍼즐 목록 라우트와 메인 기타 정보 카드를 연결한다")
    void controllerLinksPuzzlePage() throws IOException {
        String controller = Files.readString(
                PROJECT_ROOT.resolve("src/main/java/com/heartopia/wiki/controller/WikiController.java"),
                StandardCharsets.UTF_8
        );

        assertTrue(controller.contains("new CategoryItemDto(\"퍼즐\""));
        assertTrue(controller.contains("\"/wiki/others/puzzles\""));
        assertTrue(controller.contains("@GetMapping(\"/others/puzzles\")"));
        assertTrue(controller.contains("model.addAttribute(\"puzzleList\""));
        assertTrue(controller.contains("collectionService.getPuzzleCount()"));
    }

    @Test
    @DisplayName("퍼즐 초기 SQL은 고래 탐사 시즌을 포함한 데이터 90개를 포함한다")
    void seedSqlContainsNinetyMatchedPuzzles() throws IOException {
        String sql = readResource("sql/20260729_create_puzzle_collections.sql");
        Matcher matcher = Pattern.compile("^\\s*\\(\\d+,\\s*\\d+,", Pattern.MULTILINE).matcher(sql);
        int count = 0;
        while (matcher.find()) {
            count++;
        }

        assertEquals(90, count);
        assertTrue(sql.contains("(1, 1, '일반', '시청'"));
        assertTrue(sql.contains("(57, 59, '동물', '판다 홀로 앉기'"));
        assertTrue(sql.contains("(80, 82, '동물', '알파카 여행'"));
        assertTrue(sql.contains("(99, 99, '고래 탐사 시즌', '환상 고래낙하'"));
        assertTrue(sql.contains("'고래 탐사 시즌-트렌드 상점', '3,760 토큰', '/images/others/puzzles/099_환상 고래낙하.webp'"));
        assertTrue(sql.contains("(108, 108, '고래 탐사 시즌', '고래 뱃머리'"));
        assertTrue(sql.contains("'고래 탐사 시즌-트렌드 상점', '1,200 토큰', '/images/others/puzzles/108_고래 뱃머리.webp'"));
        assertFalse(sql.contains("'시즌한정'"));
    }

    @Test
    @DisplayName("기존 DB 패치는 고래 시즌을 분류에 반영한다")
    void whaleCategoryMigrationUpdatesExistingPuzzleRows() throws IOException {
        String migration = readResource("sql/20260730_update_puzzle_whale_category.sql");
        String model = Files.readString(
                PROJECT_ROOT.resolve("src/main/java/com/heartopia/wiki/model/PuzzleCollection.java"),
                StandardCharsets.UTF_8
        );
        String mapper = readResource("mapper/CollectionMapper.xml");

        assertTrue(migration.contains("category = '고래 탐사 시즌'"));
        assertTrue(migration.contains("acquisition_method = '고래 탐사 시즌-트렌드 상점'"));
        assertTrue(migration.contains("CONCAT(REPLACE(purchase_price, ' 토큰', ''), ' 토큰')"));
        assertFalse(model.contains("private String eventName;"));
        assertTrue(mapper.contains("id, image_id, catalog_order, category, name, english_name, size"));
    }

    private String readResource(String relativePath) throws IOException {
        return Files.readString(RESOURCE_ROOT.resolve(relativePath), StandardCharsets.UTF_8);
    }
}
