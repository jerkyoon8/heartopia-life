package com.heartopia.wiki.model;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class WeatherSchedule {
    private Long id;
    private LocalDate forecastDate;
    private Integer slotHour;
    private String weatherCode;
    private String sourceWeatherIds;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public String getWeatherLabel() {
        return switch (weatherCode == null ? "" : weatherCode) {
            case "SUNNY" -> "맑음";
            case "RAIN" -> "비";
            case "RAINBOW" -> "무지개";
            case "METEOR_SHOWER" -> "유성우";
            case "HEATWAVE" -> "폭염";
            case "SNOW" -> "눈";
            case "AURORA" -> "오로라";
            default -> "미정";
        };
    }
}
