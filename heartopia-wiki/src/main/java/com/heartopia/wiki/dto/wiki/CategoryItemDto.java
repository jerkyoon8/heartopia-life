package com.heartopia.wiki.dto.wiki;

public record CategoryItemDto(
    String name, 
    String icon, 
    String link, 
    String imageUrl, 
    int dataCount,
    String checklistPrefix
) {
    public CategoryItemDto(String name, String icon, String link, String imageUrl, int dataCount) {
        this(name, icon, link, imageUrl, dataCount, null);
    }

    public CategoryItemDto(String name, String icon, String link) {
        this(name, icon, link, null, 0, null);
    }

    public CategoryItemDto(String name, String icon, String link, String imageUrl) {
        this(name, icon, link, imageUrl, 0, null);
    }
}
