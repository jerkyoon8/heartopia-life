package com.heartopia.wiki.model;

import lombok.Data;

@Data
public class AnimalCollection {
    private Integer id;
    private String name;
    private String location;
    private String description;
    private String favoriteFood;
    private String favoriteWeather;
    private String imageUrl;
    private String eventName;
}
