package com.heartopia.wiki.template;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;

class GaafishLocalStorageMigrationTemplateTest {

    @Test
    void localStorageMigrationsRunBeforeLoginMergeRequests() throws IOException {
        String commonHead = new ClassPathResource("templates/fragments/common-head.html")
                .getContentAsString(StandardCharsets.UTF_8);

        int checklistScript = commonHead.indexOf("/js/checklist-key-migration.js");
        int petFoodScript = commonHead.indexOf("/js/pet-food-name-migration.js");
        int checklistMigration = commonHead.indexOf("migrateGaafishChecklistStorage");
        int petFoodMigration = commonHead.indexOf("migrateGaafishPetFoodStorage");
        int checklistMerge = commonHead.indexOf("fetch('/api/user/checklist/migrate'");
        int petFoodMerge = commonHead.indexOf("fetch('/api/user/pet-food/migrate'");

        assertThat(checklistScript).isGreaterThanOrEqualTo(0).isLessThan(checklistMigration);
        assertThat(petFoodScript).isGreaterThanOrEqualTo(0).isLessThan(petFoodMigration);
        assertThat(checklistMigration).isLessThan(checklistMerge);
        assertThat(petFoodMigration).isLessThan(petFoodMerge);
    }
}
