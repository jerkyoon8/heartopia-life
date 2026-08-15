package com.heartopia.wiki.template;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;

class SeaCleaningChecklistKeyTemplateTest {

    @Test
    void seaCleaningViewsRenderStableAndLegacyChecklistKeys() throws IOException {
        String collection = read("templates/wiki/others/sea-cleaning.html");
        String checklist = read("templates/wiki/checklist.html");

        assertThat(collection)
                .contains("'sea_cleaning_id_' + ${item.id}")
                .contains("data-legacy-sync-key")
                .contains("item.legacyChecklistName");
        assertThat(checklist)
                .contains("data-key=|sea_cleaning_id_${item.id}|")
                .contains("data-legacy-sync-key")
                .contains("item.legacyChecklistName");
        assertThat(collection).doesNotContain("'sea_cleaning_' + ${item.name}");
        assertThat(checklist).doesNotContain("data-key=|sea_cleaning_${item.name}|");
    }

    @Test
    void mapperLoadsLegacyNameWithoutUpdatingIt() throws IOException {
        String mapper = read("mapper/CollectionMapper.xml");
        String updateStatement = mapper.substring(
                mapper.indexOf("<update id=\"updateSeaCleaning\">"),
                mapper.indexOf("</update>", mapper.indexOf("<update id=\"updateSeaCleaning\">")));

        assertThat(mapper).contains("legacy_checklist_name");
        assertThat(updateStatement).doesNotContain("legacy_checklist_name");
    }

    @Test
    void migrationAddsLegacyNameBeforeMigratingBothKeyKinds() throws IOException {
        String preDeploy = read("sql/20260815_add_sea_cleaning_legacy_checklist_name.sql");
        String postDeploy = read("sql/20260815_migrate_sea_cleaning_user_checklist_keys.sql");

        assertThat(preDeploy)
                .contains("ADD COLUMN legacy_checklist_name")
                .contains("SET legacy_checklist_name = name");
        assertThat(postDeploy)
                .contains("CONCAT('sea_cleaning_id_', sc.id)")
                .contains("CONCAT('mastery_sea_cleaning_id_', sc.id)")
                .contains("GREATEST")
                .contains("DELETE uc");
    }

    private String read(String resourcePath) throws IOException {
        return new ClassPathResource(resourcePath).getContentAsString(StandardCharsets.UTF_8);
    }
}
