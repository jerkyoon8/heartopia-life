package com.heartopia.wiki.dto.wiki;

public record CategoryItemDto(
    String name, 
    String icon, 
    String link, 
    String imageUrl, 
    int dataCount
) {
    public CategoryItemDto(String name, String icon, String link) {
        this(name, icon, link, null, 0);
    }

    public CategoryItemDto(String name, String icon, String link, String imageUrl) {
        this(name, icon, link, imageUrl, 0);
    }
}
