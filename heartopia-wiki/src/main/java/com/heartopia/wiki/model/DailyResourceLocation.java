package com.heartopia.wiki.model;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class DailyResourceLocation {
    private Long id;
    private LocalDate gameDate;
    private String fluoriteLocationType;
    private Integer fluoriteHouseNumber;
    private String oakLocationType;
    private Integer oakHouseNumber;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public String getFluoriteLocationLabel() {
        return locationLabel(fluoriteLocationType, fluoriteHouseNumber);
    }

    public String getOakLocationLabel() {
        return locationLabel(oakLocationType, oakHouseNumber);
    }

    private String locationLabel(String type, Integer houseNumber) {
        if ("RUINS".equals(type)) {
            return "유적";
        }
        if ("OAK_FOREST".equals(type)) {
            return "참나무숲";
        }
        if ("HOUSE_FRONT".equals(type) && houseNumber != null) {
            return houseNumber + "번 집 앞";
        }
        return "위치 정보 없음";
    }
}
