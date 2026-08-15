package com.heartopia.wiki.template;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AdminMasteryInputTemplateTest {

    private static final List<String> SUPPORTED_TEMPLATES = List.of(
            "templates/wiki/collections/fish.html",
            "templates/wiki/collections/bug.html",
            "templates/wiki/collections/bird.html",
            "templates/wiki/items/cooking.html",
            "templates/wiki/items/flowers.html",
            "templates/wiki/items/crops.html",
            "templates/wiki/others/sea-cleaning.html");

    private static final List<String> MASTERY_FIELDS = List.of(
            "masteryBeginnerMax",
            "masteryIntroMin",
            "masteryExpertMin",
            "masteryMasterMin");

    @Test
    void supportedAdminFormsExposeAllMasteryInputsAndEditValues() throws IOException {
        for (String resourcePath : SUPPORTED_TEMPLATES) {
            String template = read(resourcePath);

            assertThat(template).as(resourcePath).contains("data-mastery-fields");
            assertThat(template).as(resourcePath).contains("name=\"masteryFieldsPresent\" value=\"true\"");
            for (String field : MASTERY_FIELDS) {
                assertThat(template)
                        .as(resourcePath + " input " + field)
                        .contains("name=\"" + field + "\"");
                assertThat(template)
                        .as(resourcePath + " edit payload " + field)
                        .contains("&quot;" + field + "&quot;");
            }
        }
    }

    @Test
    void animalAndForageableRemainOutsideMasteryAdminScope() throws IOException {
        assertThat(read("templates/wiki/collections/animal.html")).doesNotContain("data-mastery-fields");
        assertThat(read("templates/wiki/collections/forageable.html")).doesNotContain("data-mastery-fields");
    }

    @Test
    void collectionMapperPersistsMasteryOnSixMissingInsertAndUpdateStatements() throws IOException {
        String mapper = read("mapper/CollectionMapper.xml");
        for (String id : List.of("Fish", "Bug", "Bird", "Cooking", "Flower", "Crop")) {
            assertStatementContainsAllFields(mapper, "insert" + id, "</insert>");
            assertStatementContainsAllFields(mapper, "update" + id, "</update>");
        }
        assertThat(mapper)
                .contains("<if test=\"masteryFieldsPresent == true\">")
                .contains("<update id=\"updateSeaCleaning\">");
    }

    @Test
    void seaCleaningEditPayloadDoesNotExposeEventName() throws IOException {
        String template = read("templates/wiki/others/sea-cleaning.html");
        assertThat(template)
                .doesNotContain("name=\"eventName\"")
                .doesNotContain("&quot;eventName&quot;")
                .doesNotContain("item.eventName");
    }

    @Test
    void sharedAdminScriptValidatesMasteryGroups() throws IOException {
        assertThat(read("static/js/admin-data.js"))
                .contains("data-mastery-fields")
                .contains("명인 수치는 네 칸을 모두 입력하거나 모두 비워야 합니다.")
                .contains("초보자부터 명인까지 수치를 작은 값부터 입력해 주세요.")
                .contains("validateMasteryFields(form, true)")
                .contains("validateMasteryFields(form);");
    }

    private void assertStatementContainsAllFields(String mapper, String id, String closingTag) {
        int start = mapper.indexOf("id=\"" + id + "\"");
        int end = mapper.indexOf(closingTag, start);
        assertThat(start).as(id + " statement exists").isGreaterThanOrEqualTo(0);
        assertThat(end).as(id + " statement closes").isGreaterThan(start);
        String statement = mapper.substring(start, end);
        assertThat(statement).as(id)
                .contains("mastery_beginner_max")
                .contains("mastery_intro_min")
                .contains("mastery_expert_min")
                .contains("mastery_master_min")
                .contains("#{masteryBeginnerMax}")
                .contains("#{masteryIntroMin}")
                .contains("#{masteryExpertMin}")
                .contains("#{masteryMasterMin}");
    }

    private String read(String resourcePath) throws IOException {
        return new ClassPathResource(resourcePath).getContentAsString(StandardCharsets.UTF_8);
    }
}
