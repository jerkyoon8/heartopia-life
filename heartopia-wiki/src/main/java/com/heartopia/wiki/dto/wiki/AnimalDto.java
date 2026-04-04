package com.heartopia.wiki.dto.wiki;

import com.heartopia.wiki.model.AnimalCollection;

public record AnimalDto(
    Integer id,
    String name,
    String imageUrl,
    String description,
    String location,
    String favoriteFood,
    String favoriteWeather,
    String eventName
) {
    public static AnimalDto from(AnimalCollection a) {
        return new AnimalDto(
            a.getId(),
            a.getName(),
            a.getImageUrl(),
            "", // description
            a.getLocation(),
            a.getFavoriteFood(),
            a.getFavoriteWeather() != null ? a.getFavoriteWeather() : "",
            a.getEventName()
        );
    }
}
