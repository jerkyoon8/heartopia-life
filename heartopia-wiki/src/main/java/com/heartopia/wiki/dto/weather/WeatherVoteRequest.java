package com.heartopia.wiki.dto.weather;

import java.time.LocalDate;

public record WeatherVoteRequest(
        LocalDate forecastDate,
        int slotHour,
        String weatherCode
) {
}
