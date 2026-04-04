package com.heartopia.wiki.dto.wiki;

import com.heartopia.wiki.model.ForageableCollection;

public record ForageableDto(
    Integer id,
    String name,
    String imageUrl,
    String location,
    Integer price,
    String energy,
    String eventName
) {
    public static ForageableDto from(ForageableCollection f) {
        return new ForageableDto(
            f.getId(),
            f.getName(),
            f.getImageUrl(),
            f.getLocation(),
            f.getPrice(),
            f.getEnergy() != null ? f.getEnergy() : "-",
            f.getEventName()
        );
    }
}
