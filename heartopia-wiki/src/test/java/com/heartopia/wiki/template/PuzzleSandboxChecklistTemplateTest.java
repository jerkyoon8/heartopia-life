package com.heartopia.wiki.template;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

class PuzzleSandboxChecklistTemplateTest {

    @Test
    void puzzleAndSandboxPagesProvideStableChecklistControls() throws IOException {
        String puzzles = read("templates/wiki/others/puzzles.html");
        String sandbox = read("templates/wiki/others/sandbox.html");

        assertThat(puzzles)
                .contains("id=\"btn-hide-collected\"")
                .contains("class=\"wiki-item-card sync-item\"")
                .contains("th:data-sync-key=\"'puzzle_id_' + ${puzzle.id}\"")
                .contains("data-supports-star-rating=\"false\"")
                .contains("<button type=\"button\" class=\"sync-check-btn\"");

        assertThat(sandbox)
                .contains("id=\"btn-hide-collected\"")
                .contains("class=\"wiki-item-card sync-item\"")
                .contains("th:data-sync-key=\"'sandbox_id_' + ${item.id}\"")
                .contains("data-supports-star-rating=\"false\"")
                .contains("<button type=\"button\" class=\"sync-check-btn\"");
    }

    @Test
    void checklistHubIncludesPuzzleAndSandboxCategories() throws IOException {
        String controller = readJava("controller/WikiController.java");
        String checklist = read("templates/wiki/checklist.html");

        assertThat(controller)
                .contains("model.addAttribute(\"puzzleList\"")
                .contains("model.addAttribute(\"sandboxList\"");
        assertThat(checklist)
                .contains("data-target=\"puzzle\"")
                .contains("data-target=\"sandbox\"")
                .contains("data-key=|puzzle_id_${item.id}|")
                .contains("data-key=|sandbox_id_${item.id}|");
    }

    @Test
    void homeCardsExposeProgressMetadataForEveryChecklistCategory() throws IOException {
        String controller = readJava("controller/WikiController.java");
        String home = read("templates/wiki/wiki.html");

        assertThat(controller)
                .contains("\"fish_\"")
                .contains("\"bug_\"")
                .contains("\"bird_\"")
                .contains("\"flower_\"")
                .contains("\"crop_\"")
                .contains("\"cooking_\"")
                .contains("\"sea_cleaning_id_\"")
                .contains("\"achievement_\"")
                .contains("\"puzzle_id_\"")
                .contains("\"sandbox_id_\"");
        assertThat(home)
                .contains("item.checklistPrefix")
                .contains("data-checklist-prefix")
                .contains("data-total")
                .contains("card-progress");
    }

    private String read(String path) throws IOException {
        return new ClassPathResource(path).getContentAsString(StandardCharsets.UTF_8);
    }

    private String readJava(String path) throws IOException {
        return Files.readString(
                Path.of("src/main/java/com/heartopia/wiki").resolve(path),
                StandardCharsets.UTF_8);
    }
}
