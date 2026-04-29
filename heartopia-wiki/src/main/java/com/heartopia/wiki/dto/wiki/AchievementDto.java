package com.heartopia.wiki.dto.wiki;

import com.heartopia.wiki.model.Achievement;
import java.util.Arrays;
import java.util.List;

public record AchievementDto(
    Integer id,
    String categories,
    String name,
    String cond,
    String title,
    String tip,
    String imageUrl,
    Integer sortOrder
) {
    public static AchievementDto from(Achievement a) {
        return new AchievementDto(
            a.getId(),
            a.getCategories(),
            a.getName(),
            a.getCond(),
            a.getTitle(),
            a.getTip(),
            a.getImageUrl(),
            a.getSortOrder()
        );
    }

    /**
     * 카테고리 문자열을 리스트로 반환 (Thymeleaf에서 사용)
     * 예: "숨겨진,낚시" -> ["숨겨진", "낚시"]
     */
    public List<String> categoryList() {
        if (categories == null || categories.isEmpty()) return List.of();
        return Arrays.asList(categories.split(","));
    }
}
