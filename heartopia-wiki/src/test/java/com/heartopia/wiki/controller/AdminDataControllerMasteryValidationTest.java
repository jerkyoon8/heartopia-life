package com.heartopia.wiki.controller;

import com.heartopia.wiki.model.FishCollection;
import com.heartopia.wiki.service.CollectionService;
import com.heartopia.wiki.service.FileUploadService;
import com.heartopia.wiki.service.GiftCodeService;
import org.junit.jupiter.api.Test;
import org.springframework.http.ResponseEntity;

import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

class AdminDataControllerMasteryValidationTest {

    @Test
    void invalidMasteryInputReturnsBadRequestWithoutUpdatingTheCollection() {
        CollectionService collectionService = mock(CollectionService.class);
        AdminDataController controller = new AdminDataController(
                collectionService,
                mock(GiftCodeService.class),
                mock(FileUploadService.class));
        FishCollection fish = new FishCollection();
        fish.setMasteryBeginnerMax(10);

        assertThatThrownBy(() -> controller.updateFish(fish, null, null))
                .isInstanceOf(IllegalArgumentException.class);
        verify(collectionService, never()).updateFish(fish);

        ResponseEntity<Map<String, String>> response = controller.handleInvalidAdminInput(
                new IllegalArgumentException("명인 수치 오류"));
        assertThat(response.getStatusCode().value()).isEqualTo(400);
        assertThat(response.getBody()).containsEntry("message", "명인 수치 오류");
    }
}
