package com.heartopia.wiki.service;

import com.heartopia.wiki.dto.weather.WeatherForecastResponse;
import com.heartopia.wiki.mapper.WeatherScheduleMapper;
import com.heartopia.wiki.model.WeatherSchedule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class WeatherForecastService {

    private static final ZoneId ASIA_SERVER_ZONE = ZoneId.of("Asia/Seoul");
    private static final DateTimeFormatter SERVER_TIME_FORMAT = DateTimeFormatter.ISO_OFFSET_DATE_TIME;

    private static final Map<String, Integer> DAILY_PRIORITY = Map.of(
            "RAINBOW", 70,
            "METEOR_SHOWER", 60,
            "RAIN", 50,
            "SNOW", 40,
            "AURORA", 30,
            "HEATWAVE", 20,
            "SUNNY", 10);

    private final WeatherScheduleMapper mapper;
    private final Clock clock;

    @Autowired
    public WeatherForecastService(WeatherScheduleMapper mapper) {
        this(mapper, Clock.system(ASIA_SERVER_ZONE));
    }

    WeatherForecastService(WeatherScheduleMapper mapper, Clock clock) {
        this.mapper = mapper;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public WeatherForecastResponse getForecast() {
        ZonedDateTime now = ZonedDateTime.now(clock).withZoneSameInstant(ASIA_SERVER_ZONE);
        LocalDate today = now.toLocalDate();
        LocalDate lastDate = today.plusDays(7);
        Map<SlotKey, String> weatherBySlot = scheduledWeather(today, lastDate);

        List<WeatherForecastResponse.DetailSlot> detailSlots = new ArrayList<>(5);
        for (ZonedDateTime slot : detailSlotStarts(now)) {
            detailSlots.add(new WeatherForecastResponse.DetailSlot(
                    slot.toLocalDate(),
                    slot.getHour(),
                    result(weatherBySlot.get(new SlotKey(slot.toLocalDate(), slot.getHour()))),
                    null));
        }

        List<WeatherForecastResponse.DailyForecast> dailyForecasts = new ArrayList<>(7);
        for (int dayOffset = 1; dayOffset <= 7; dayOffset++) {
            LocalDate forecastDate = today.plusDays(dayOffset);
            dailyForecasts.add(new WeatherForecastResponse.DailyForecast(
                    forecastDate,
                    result(dailyWeather(weatherBySlot, forecastDate)),
                    null));
        }

        return new WeatherForecastResponse(
                SERVER_TIME_FORMAT.format(now),
                false,
                List.copyOf(detailSlots),
                List.copyOf(dailyForecasts));
    }

    private Map<SlotKey, String> scheduledWeather(LocalDate fromDate, LocalDate toDate) {
        Map<SlotKey, String> result = new HashMap<>();
        List<WeatherSchedule> rows = mapper.findActiveBetween(fromDate, toDate);
        if (rows == null) {
            return result;
        }
        for (WeatherSchedule row : rows) {
            if (row != null && row.getForecastDate() != null && row.getSlotHour() != null) {
                result.put(new SlotKey(row.getForecastDate(), row.getSlotHour()), row.getWeatherCode());
            }
        }
        return result;
    }

    private List<ZonedDateTime> detailSlotStarts(ZonedDateTime now) {
        int currentSlotHour = (now.getHour() / 6) * 6;
        ZonedDateTime slotStart = now.withHour(currentSlotHour).withMinute(0).withSecond(0).withNano(0);
        List<ZonedDateTime> slots = new ArrayList<>(5);
        for (int i = 0; i < 5; i++) {
            slots.add(slotStart.plusHours((long) i * 6));
        }
        return slots;
    }

    private String dailyWeather(Map<SlotKey, String> weatherBySlot, LocalDate date) {
        String selected = null;
        int selectedPriority = Integer.MIN_VALUE;
        for (int slotHour : List.of(0, 6, 12, 18)) {
            String candidate = weatherBySlot.get(new SlotKey(date, slotHour));
            if (candidate == null) {
                continue;
            }
            int priority = DAILY_PRIORITY.getOrDefault(candidate, Integer.MIN_VALUE);
            if (priority > selectedPriority) {
                selected = candidate;
                selectedPriority = priority;
            }
        }
        return selected;
    }

    private WeatherForecastResponse.ForecastResult result(String weatherCode) {
        if (weatherCode == null || weatherCode.isBlank()) {
            return new WeatherForecastResponse.ForecastResult("EMPTY", null, 0, 0, false);
        }
        return new WeatherForecastResponse.ForecastResult("CONFIRMED", weatherCode, 0, 0, false);
    }

    private record SlotKey(LocalDate date, int hour) {
    }
}
