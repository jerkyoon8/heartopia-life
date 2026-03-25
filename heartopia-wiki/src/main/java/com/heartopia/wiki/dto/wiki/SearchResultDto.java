package com.heartopia.wiki.dto.wiki;

public record SearchResultDto(
    String name, 
    String category, 
    String categoryLabel, 
    String detailUrl, 
    String subInfo
) {
}
