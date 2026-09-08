package com.heartopia.wiki.service;

import com.heartopia.wiki.dto.weather.WeatherForecastResponse;
import com.heartopia.wiki.mapper.WeatherScheduleMapper;
import com.heartopia.wiki.model.WeatherSchedule;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class WeatherForecastServiceTest {
    private static final ZoneId ASIA_SERVER_ZONE = ZoneId.of("Asia/Seoul");

    @Mock
    private WeatherScheduleMapper mapper;

    @Test
    @DisplayName("현재 달력 날짜의 6시간 구간부터 다섯 구간을 순서대로 반환한다")
    void returnsFiveCalendarSlotsAcrossMidnight() {
        LocalDate today = LocalDate.of(2026, 9, 8);
        WeatherForecastService service = serviceAt("2026-09-08T11:30:00Z");
        when(mapper.findActiveBetween(today, today.plusDays(7))).thenReturn(List.of(
                schedule(today, 18, "RAIN"),
                schedule(today.plusDays(1), 0, "SUNNY"),
                schedule(today.plusDays(1), 6, "SNOW"),
                schedule(today.plusDays(1), 12, "AURORA"),
                schedule(today.plusDays(1), 18, "RAINBOW")));

        WeatherForecastResponse response = service.getForecast();

        assertEquals(List.of(18, 0, 6, 12, 18),
                response.detailSlots().stream().map(WeatherForecastResponse.DetailSlot::slotHour).toList());
        assertEquals(List.of(today, today.plusDays(1), today.plusDays(1), today.plusDays(1), today.plusDays(1)),
                response.detailSlots().stream().map(WeatherForecastResponse.DetailSlot::forecastDate).toList());
        assertEquals(List.of("RAIN", "SUNNY", "SNOW", "AURORA", "RAINBOW"),
                response.detailSlots().stream().map(slot -> slot.result().weatherCode()).toList());
        assertFalse(response.authenticated());
        assertNull(response.detailSlots().get(0).myVote());
        verify(mapper).findActiveBetween(today, today.plusDays(7));
    }

    @Test
    @DisplayName("일간 예보는 무지개, 유성우, 비, 맑음 우선순위로 대표 날씨를 고른다")
    void selectsDailyWeatherByPriority() {
        LocalDate today = LocalDate.of(2026, 12, 30);
        WeatherForecastService service = serviceAt("2026-12-30T03:00:00Z");
        List<WeatherSchedule> rows = new ArrayList<>();
        rows.add(schedule(today.plusDays(1), 0, "SUNNY"));
        rows.add(schedule(today.plusDays(1), 6, "RAIN"));
        rows.add(schedule(today.plusDays(1), 12, "METEOR_SHOWER"));
        rows.add(schedule(today.plusDays(1), 18, "RAIN"));
        rows.add(schedule(today.plusDays(2), 0, "METEOR_SHOWER"));
        rows.add(schedule(today.plusDays(2), 6, "SNOW"));
        rows.add(schedule(today.plusDays(2), 12, "RAINBOW"));
        rows.add(schedule(today.plusDays(2), 18, "SUNNY"));
        when(mapper.findActiveBetween(today, today.plusDays(7))).thenReturn(rows);

        WeatherForecastResponse response = service.getForecast();

        assertEquals(today.plusDays(1), response.dailyForecasts().get(0).forecastDate());
        assertEquals("METEOR_SHOWER", response.dailyForecasts().get(0).result().weatherCode());
        assertEquals("RAINBOW", response.dailyForecasts().get(1).result().weatherCode());
    }

    @Test
    @DisplayName("예약이 없는 구간과 날짜는 정보 없음 상태다")
    void returnsEmptyForMissingSchedule() {
        LocalDate today = LocalDate.of(2026, 9, 8);
        WeatherForecastService service = serviceAt("2026-09-08T00:00:00Z");
        when(mapper.findActiveBetween(today, today.plusDays(7))).thenReturn(List.of());

        WeatherForecastResponse response = service.getForecast();

        assertEquals("EMPTY", response.detailSlots().get(0).result().status());
        assertNull(response.detailSlots().get(0).result().weatherCode());
        assertEquals("EMPTY", response.dailyForecasts().get(0).result().status());
    }

    private WeatherForecastService serviceAt(String instant) {
        return new WeatherForecastService(mapper, Clock.fixed(Instant.parse(instant), ASIA_SERVER_ZONE));
    }

    private WeatherSchedule schedule(LocalDate date, int hour, String code) {
        WeatherSchedule schedule = new WeatherSchedule();
        schedule.setForecastDate(date);
        schedule.setSlotHour(hour);
        schedule.setWeatherCode(code);
        return schedule;
    }
}
