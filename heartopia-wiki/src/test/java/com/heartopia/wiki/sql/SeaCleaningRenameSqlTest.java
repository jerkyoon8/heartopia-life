package com.heartopia.wiki.sql;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;

class SeaCleaningRenameSqlTest {

    @Test
    void renamesTheSixRequestedItemsByStableId() throws IOException {
        String sql = readSql();

        assertThat(sql)
                .contains("WHEN 1 THEN '손상된 바닷조개'")
                .contains("WHEN 6 THEN '개굴잠쟁이'")
                .contains("WHEN 8 THEN '프로라 텔린조개'")
                .contains("WHEN 10 THEN '크로세아 클램'")
                .contains("WHEN 11 THEN '무명올각시실꼬리고둥'")
                .contains("WHEN 14 THEN '노빌리스 두순고둥'")
                .contains("WHERE id IN (1, 6, 8, 10, 11, 14)");
    }

    @Test
    void validatesExpectedRowsAndPreventsPartialUpdates() throws IOException {
        String sql = readSql();

        assertThat(sql)
                .contains("FOR UPDATE")
                .contains("expected_old_count")
                .contains("legacy_name_count")
                .contains("new_name_conflict_count")
                .contains("@expected_old_count = 6")
                .contains("@legacy_name_count = 6")
                .contains("@new_name_conflict_count = 0")
                .contains("SET @updated_rows = ROW_COUNT()")
                .contains("START TRANSACTION")
                .contains("COMMIT");
    }

    @Test
    void preservesLegacyChecklistNamesAndSupportsAlreadyAppliedState() throws IOException {
        String sql = readSql();

        assertThat(sql)
                .doesNotContain("SET legacy_checklist_name")
                .contains("already_applied_count")
                .contains("'already applied'")
                .contains("SELECT id, name, legacy_checklist_name")
                .contains("'사프란 대왕조개'");
    }

    private String readSql() throws IOException {
        return new ClassPathResource("sql/20260815_rename_sea_cleaning_collections.sql")
                .getContentAsString(StandardCharsets.UTF_8);
    }
}
