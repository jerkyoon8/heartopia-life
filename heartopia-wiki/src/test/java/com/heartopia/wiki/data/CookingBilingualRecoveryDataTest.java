package com.heartopia.wiki.data;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

class CookingBilingualRecoveryDataTest {

    private static final String SQL_PATH =
            "sql/20260817_add_cooking_recovery.sql";

    @Test
    void migrationAddsRecoveryColumnsWithoutPersistingEnglishNames() throws IOException {
        String sql = new ClassPathResource(SQL_PATH).getContentAsString(StandardCharsets.UTF_8);

        assertThat(sql)
                .contains("recovery_1 INT")
                .contains("recovery_2 INT")
                .contains("recovery_3 INT")
                .contains("recovery_4 INT")
                .contains("recovery_5 INT")
                .contains("START TRANSACTION")
                .contains("COMMIT")
                .doesNotContain("english_name");
        assertThat(count(sql, Pattern.compile("(?m)^UPDATE cooking_collections$"))).isEqualTo(175);
        assertThat(count(sql, Pattern.compile("(?m)^    recovery_1 = [0-9]+,"))).isEqualTo(111);
    }

    @Test
    void cookingMapperReadsAndWritesRecoveryWithoutEnglishName() throws IOException {
        String mapper = new ClassPathResource("mapper/CollectionMapper.xml")
                .getContentAsString(StandardCharsets.UTF_8);

        assertThat(mapper)
                .contains("recovery_1, recovery_2, recovery_3, recovery_4, recovery_5")
                .contains("#{recovery1}, #{recovery2}, #{recovery3}, #{recovery4}, #{recovery5}")
                .contains("recovery_1=#{recovery1}")
                .doesNotContain("id, name, english_name, level")
                .doesNotContain("#{englishName}");
    }

    @Test
    void englishKoreanNamesRemainInReferenceMarkdownOnly() throws IOException {
        String reference = Files.readString(
                Path.of("_workspace/recipe_detail_matching_results/cooking_name_ko_en_reference.md"),
                StandardCharsets.UTF_8);

        assertThat(reference)
                .contains("서비스 DB/UI에 넣지 않는 데이터 검증용 참고자료")
                .contains("| 한글명 | 영문명 | 레벨 | 회복량(1★~5★) |");
        assertThat(count(reference, Pattern.compile("(?m)^\\| .* \\| .* \\| (?:[0-9]+|-) \\| .* \\|$")))
                .isEqualTo(175);
    }

    private int count(String value, Pattern pattern) {
        int count = 0;
        Matcher matcher = pattern.matcher(value);
        while (matcher.find()) count++;
        return count;
    }
}
