package com.heartopia.wiki.template;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

class PetManagementTemplateTest {

    @Test
    void petPageProvidesNameEditingAndHotelStatusControls() throws IOException {
        String template = petTemplate();

        assertThat(template)
                .contains("id=\"petRenameForm\"")
                .contains("id=\"petRenameInput\"")
                .contains("id=\"editPetNameBtn\"")
                .contains("id=\"hotelStatusCheckbox\"")
                .contains("pet-hotel-badge");
    }

    @Test
    void petProfilesNormalizeAndCreateHotelStatus() throws IOException {
        String template = petTemplate();

        assertThat(template)
                .contains("inHotel: pet.inHotel === true")
                .contains("inHotel: false")
                .contains("게임 내 캐릭터당 호텔 정원은 5마리")
                .doesNotContain("HOTEL_CAPACITY")
                .doesNotContain("hotelPetCount");
    }

    @Test
    void selectedPetCanMoveLeftAndRightAndPersistItsDisplayOrder() throws IOException {
        String template = petTemplate();

        assertThat(template)
                .contains("id=\"movePetLeftBtn\"")
                .contains("id=\"movePetRightBtn\"")
                .contains("moveSelectedPet(-1)")
                .contains("moveSelectedPet(1)")
                .contains("function moveSelectedPet(offset)")
                .contains("[state.pets[currentIndex], state.pets[targetIndex]]")
                .contains("saveProfiles();")
                .contains("moveLeftButton.disabled = currentIndex <= 0")
                .contains("moveRightButton.disabled = currentIndex < 0 || currentIndex >= state.pets.length - 1");
    }

    private String petTemplate() throws IOException {
        return new ClassPathResource("templates/wiki/others/pets.html")
                .getContentAsString(StandardCharsets.UTF_8);
    }
}
