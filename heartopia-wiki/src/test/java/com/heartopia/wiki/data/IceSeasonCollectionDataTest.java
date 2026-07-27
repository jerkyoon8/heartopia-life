package com.heartopia.wiki.data;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

class IceSeasonCollectionDataTest {

    private static final String SQL_PATH = "sql/20260727_insert_ice_season_collections.sql";

    private static final List<String> EXPECTED_NAMES = List.of(
            "무",
            "히말라야양귀비",
            "얼음컵 커피",
            "얼음컵 라떼",
            "갈은 무와 스테이크",
            "무 크림 수프",
            "오리지널 슈가파우더 팬케이크",
            "블루베리 슈가파우더 팬케이크",
            "라즈베리 슈가파우더 팬케이크",
            "사과 슈가파우더 팬케이크",
            "오렌지 슈가파우더 팬케이크",
            "오로라 만찬",
            "겨울 옷 큰홍학",
            "겨울 옷 청둥오리",
            "겨울 옷 흰비오리",
            "겨울 옷 홍머리오리",
            "겨울 옷 원앙",
            "얼음 결정 진주네발나비",
            "얼음 결정 삼색청띠제비나비",
            "얼음 결정 알렉산더비단나비",
            "얼음 결정 슬코스키몰포나비",
            "얼음 결정 멜포메네길쭉나비",
            "얼음 결정 킹크랩",
            "얼음 결정 개복치",
            "얼음 결정 복어",
            "얼음 결정 해마",
            "얼음 결정 고래상어");

    @Test
    void migrationContainsAllIceSeasonRowsAndIsRepeatable() throws IOException {
        String sql = readSql();

        assertThat(sql).contains("START TRANSACTION;", "COMMIT;");
        assertThat(countMatches(sql, Pattern.compile("(?m)^\\('[^']+'"))).isEqualTo(27);
        assertThat(countMatches(sql, Pattern.compile("(?m)^INSERT INTO cooking_ingredients"))).isEqualTo(35);

        for (String name : EXPECTED_NAMES) {
            assertThat(sql)
                    .as("collection row for %s", name)
                    .containsPattern("(?m)^\\('" + Pattern.quote(name) + "',");
        }
    }

    @Test
    void migrationContainsConfirmedFiveStarPriceSets() throws IOException {
        String sql = readSql();
        Map<String, String> expectedPriceFragments = Map.ofEntries(
                Map.entry("무", "30, 45, 60, 120, 240"),
                Map.entry("히말라야양귀비", "100, 150, 200, 400, 800"),
                Map.entry("얼음컵 커피", "280, 420, 560, 1120, 2240"),
                Map.entry("얼음컵 라떼", "280, 420, 560, 1120, 2240"),
                Map.entry("갈은 무와 스테이크", "630, 945, 1260, 2520, 5040"),
                Map.entry("무 크림 수프", "340, 510, 680, 1360, 2720"),
                Map.entry("오리지널 슈가파우더 팬케이크", "330, 495, 660, 1320, 2640"),
                Map.entry("라즈베리 슈가파우더 팬케이크", "350, 525, 700, 1400, 2800"),
                Map.entry("사과 슈가파우더 팬케이크", "360, 540, 720, 1440, 2880"),
                Map.entry("오로라 만찬", "1630, 2445, 3260, 6520, 13040"),
                Map.entry("겨울 옷 원앙", "22, 90, 180, 360, 720"),
                Map.entry("겨울 옷 큰홍학", "20, 80, 160, 320, 640"),
                Map.entry("겨울 옷 청둥오리", "17, 70, 140, 280, 560"),
                Map.entry("얼음 결정 진주네발나비", "60, 90, 120, 240, 480"),
                Map.entry("얼음 결정 멜포메네길쭉나비", "90, 135, 180, 360, 720"),
                Map.entry("얼음 결정 킹크랩", "215, 322, 430, 860, 1720"),
                Map.entry("얼음 결정 개복치", "210, 315, 420, 840, 1680"),
                Map.entry("얼음 결정 복어", "155, 232, 310, 620, 1240"),
                Map.entry("얼음 결정 해마", "100, 150, 200, 400, 800"),
                Map.entry("얼음 결정 고래상어", "320, 480, 640, 1280, 2560"));

        expectedPriceFragments.forEach((name, prices) -> assertThat(sql)
                .as("five-star prices for %s", name)
                .containsPattern("(?m)^\\('" + Pattern.quote(name) + "',.*" + Pattern.quote(prices)));
    }

    @Test
    void everyInsertedImageIsABundledWebpResource() throws IOException {
        String sql = readSql();
        Matcher matcher = Pattern.compile("'(/images/[^']+\\.webp)'").matcher(sql);
        java.util.Set<String> imagePaths = new java.util.LinkedHashSet<>();

        while (matcher.find()) {
            imagePaths.add(matcher.group(1));
        }

        assertThat(imagePaths).hasSize(27);
        for (String imagePath : imagePaths) {
            ClassPathResource image = new ClassPathResource("static" + imagePath);
            assertThat(image.exists())
                    .as("bundled image %s", imagePath)
                    .isTrue();
            String webpHeader;
            try (var input = image.getInputStream()) {
                webpHeader = new String(input.readNBytes(12), StandardCharsets.US_ASCII);
            }
            assertThat(webpHeader)
                    .as("real WebP header for %s", imagePath)
                    .startsWith("RIFF")
                    .endsWith("WEBP");
        }
    }

    private String readSql() throws IOException {
        return new ClassPathResource(SQL_PATH).getContentAsString(StandardCharsets.UTF_8);
    }

    private long countMatches(String value, Pattern pattern) {
        return pattern.matcher(value).results().count();
    }
}
