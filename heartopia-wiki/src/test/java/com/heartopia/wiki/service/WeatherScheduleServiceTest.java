package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.WeatherScheduleMapper;
import com.heartopia.wiki.model.WeatherSchedule;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class WeatherScheduleServiceTest {
    @Mock
    private WeatherScheduleMapper mapper;

    @Test
    void normalizesAndSavesSupportedSchedule() {
        WeatherScheduleService service = new WeatherScheduleService(mapper);
        WeatherSchedule schedule = schedule(6, " rainbow ");
        service.save(schedule);

        ArgumentCaptor<WeatherSchedule> captor = ArgumentCaptor.forClass(WeatherSchedule.class);
        verify(mapper).upsert(captor.capture());
        assertEquals("RAINBOW", captor.getValue().getWeatherCode());
    }

    @Test
    void rejectsNonSixHourSlot() {
        WeatherScheduleService service = new WeatherScheduleService(mapper);
        assertThrows(IllegalArgumentException.class, () -> service.save(schedule(7, "SUNNY")));
    }

    @Test
    void rejectsUnsupportedWeather() {
        WeatherScheduleService service = new WeatherScheduleService(mapper);
        assertThrows(IllegalArgumentException.class, () -> service.save(schedule(12, "CLOUDY")));
    }

    private WeatherSchedule schedule(int hour, String code) {
        WeatherSchedule schedule = new WeatherSchedule();
        schedule.setForecastDate(LocalDate.of(2026, 9, 8));
        schedule.setSlotHour(hour);
        schedule.setWeatherCode(code);
        return schedule;
    }
}
