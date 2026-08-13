package com.heartopia.wiki.controller;

import com.heartopia.wiki.service.EventSettingsService;
import org.junit.jupiter.api.Test;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.web.servlet.mvc.support.RedirectAttributesModelMap;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

class EventSettingsControllerTest {

    private final EventSettingsService service = mock(EventSettingsService.class);
    private final EventSettingsController controller = new EventSettingsController(service);

    @Test
    void adminPageProvidesCurrentAndQuickSelectionsSeparately() {
        when(service.getAvailableEventNames()).thenReturn(List.of("고래 탐사 시즌", "빙설 시즌"));
        when(service.getCurrentEventNames()).thenReturn(List.of("고래 탐사 시즌"));
        when(service.getQuickEventNames()).thenReturn(List.of("고래 탐사 시즌", "빙설 시즌"));
        ExtendedModelMap model = new ExtendedModelMap();

        assertThat(controller.adminPage(model)).isEqualTo("wiki/admin-event-settings");
        assertThat(model.get("currentEventNames")).isEqualTo(List.of("고래 탐사 시즌"));
        assertThat(model.get("quickEventNames")).isEqualTo(List.of("고래 탐사 시즌", "빙설 시즌"));
    }

    @Test
    void versionTwoFormCanExplicitlyClearEitherSelection() {
        RedirectAttributesModelMap redirect = new RedirectAttributesModelMap();

        controller.save(List.of("고래 탐사 시즌"), null, null, 2, redirect);

        verify(service).replaceEventSettings(List.of("고래 탐사 시즌"), null);
        assertThat(redirect.getFlashAttributes()).containsKey("successMessage");
    }

    @Test
    void legacyCurrentOnlyFormPreservesQuickSelections() {
        when(service.getQuickEventNames()).thenReturn(List.of("데이브 더 다이버"));
        RedirectAttributesModelMap redirect = new RedirectAttributesModelMap();

        controller.save(null, null, List.of("고래 탐사 시즌"), null, redirect);

        verify(service).replaceEventSettings(
                List.of("고래 탐사 시즌"),
                List.of("데이브 더 다이버"));
    }

    @Test
    void unversionedEmptySubmissionDoesNotEraseSettings() {
        RedirectAttributesModelMap redirect = new RedirectAttributesModelMap();

        controller.save(null, null, null, null, redirect);

        verifyNoInteractions(service);
        assertThat(redirect.getFlashAttributes().get("errorMessage"))
                .isEqualTo("오래된 설정 화면입니다. 페이지를 새로고침한 뒤 다시 저장해 주세요.");
    }
}
