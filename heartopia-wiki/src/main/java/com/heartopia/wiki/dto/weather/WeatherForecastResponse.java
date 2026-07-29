package com.heartopia.wiki.dto.weather;

import java.time.LocalDate;
import java.util.List;

public record WeatherForecastResponse(
        String serverNow,
        boolean authenticated,
        List<DetailSlot> detailSlots,
        List<DailyForecast> dailyForecasts
) {
    public record DetailSlot(
            LocalDate forecastDate,
            int slotHour,
            ForecastResult result,
            String myVote
    ) {
    }

    public record DailyForecast(
            LocalDate forecastDate,
            ForecastResult result,
            String myVote
    ) {
    }

    public record ForecastResult(
            String status,
            String weatherCode,
            int score,
            int voterCount,
            boolean fallback
    ) {
    }
}
