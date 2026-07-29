package com.heartopia.wiki.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WeatherVoteTally {
    private LocalDate forecastDate;
    private int slotHour;
    private String weatherCode;
    private int score;
    private int voterCount;
}
