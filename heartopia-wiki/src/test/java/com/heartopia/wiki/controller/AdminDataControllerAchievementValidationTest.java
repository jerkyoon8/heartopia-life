package com.heartopia.wiki.controller;

import com.heartopia.wiki.model.Achievement;
import com.heartopia.wiki.service.CollectionService;
import com.heartopia.wiki.service.FileUploadService;
import com.heartopia.wiki.service.GiftCodeService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

class AdminDataControllerAchievementValidationTest {

    private final CollectionService collectionService = mock(CollectionService.class);
    private final AdminDataController controller = new AdminDataController(
            collectionService,
            mock(GiftCodeService.class),
            mock(FileUploadService.class));

    @AfterEach
    void clearRequestContext() {
        RequestContextHolder.resetRequestAttributes();
    }

    @Test
    void normalizesWhitespaceAndDuplicateCategories() {
        Achievement achievement = new Achievement();
        achievement.setCategories(" 바다 청소,숨겨진,바다 청소 ");

        controller.validateAchievement(achievement);

        assertThat(achievement.getCategories()).isEqualTo("바다 청소,숨겨진");
        assertThat(achievement.getSortOrder()).isZero();
    }

    @Test
    void rejectsMissingOrUnknownCategories() {
        Achievement missing = new Achievement();
        missing.setCategories(" ");
        Achievement unknown = new Achievement();
        unknown.setCategories("없는 분류");

        assertThatThrownBy(() -> controller.validateAchievement(missing))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("카테고리");
        assertThatThrownBy(() -> controller.validateAchievement(unknown))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("없는 분류");
    }

    @Test
    void rejectsNegativeSortOrder() {
        Achievement achievement = new Achievement();
        achievement.setCategories("바다 청소");
        achievement.setSortOrder(-1);

        assertThatThrownBy(() -> controller.validateAchievement(achievement))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("정렬 순서");
    }

    @Test
    void rejectsNullAchievementAndPreservesExplicitSortOrder() {
        assertThatThrownBy(() -> controller.validateAchievement(null))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("카테고리");

        Achievement achievement = new Achievement();
        achievement.setCategories("숨바꼭질 파티");
        achievement.setSortOrder(62);

        controller.validateAchievement(achievement);

        assertThat(achievement.getSortOrder()).isEqualTo(62);
    }

    @Test
    void addNormalizesAndPersistsAchievement() throws Exception {
        bindDefaultImageRequest();
        Achievement achievement = achievement(" 바다 청소,바다 청소 ", 59);

        String view = controller.addAchievement(achievement, new MockMultipartFile("imageFile", new byte[0]));

        assertThat(view).isEqualTo("redirect:/wiki/others/achievements");
        assertThat(achievement.getCategories()).isEqualTo("바다 청소");
        assertThat(achievement.getImageUrl()).isEqualTo("/images/achievements/테스트 업적.webp");
        verify(collectionService).addAchievement(achievement);
    }

    @Test
    void updateNormalizesAndPersistsAchievement() throws Exception {
        bindDefaultImageRequest();
        Achievement achievement = achievement("바다 청소,숨겨진", 60);
        achievement.setId(99);

        String view = controller.updateAchievement(achievement, null, "/uploads/old.webp");

        assertThat(view).isEqualTo("redirect:/wiki/others/achievements");
        verify(collectionService).updateAchievement(achievement);
    }

    @Test
    void invalidAddDoesNotWrite() {
        Achievement achievement = achievement("없는 분류", 1);

        assertThatThrownBy(() -> controller.addAchievement(achievement, null))
                .isInstanceOf(IllegalArgumentException.class);
        verify(collectionService, never()).addAchievement(achievement);
    }

    @Test
    void invalidInputHandlerReturnsBadRequestMessage() {
        var response = controller.handleInvalidAdminInput(new IllegalArgumentException("잘못된 업적"));

        assertThat(response.getStatusCode().value()).isEqualTo(400);
        assertThat(response.getBody()).containsEntry("message", "잘못된 업적");
    }

    private Achievement achievement(String categories, int sortOrder) {
        Achievement achievement = new Achievement();
        achievement.setName("테스트 업적");
        achievement.setCategories(categories);
        achievement.setSortOrder(sortOrder);
        return achievement;
    }

    private void bindDefaultImageRequest() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setParameter("imageMode", "DEFAULT");
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
    }
}
