package com.heartopia.wiki.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WeatherVote {
    private Long id;
    private Long userId;
    private LocalDate forecastDate;
    private int slotHour;
    private String weatherCode;
    private int voteWeight;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
