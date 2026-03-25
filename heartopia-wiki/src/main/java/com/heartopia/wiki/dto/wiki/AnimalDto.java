package com.heartopia.wiki.dto.wiki;

import com.heartopia.wiki.model.AnimalCollection;

public record AnimalDto(
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
            a.getName(),
            a.getImageUrl(),
            "", // previously description was passed as empty string in controller
            a.getLocation(),
            a.getFavoriteFood(),
            a.getFavoriteWeather() != null ? a.getFavoriteWeather() : "",
            a.getEventName()
        );
    }
}
