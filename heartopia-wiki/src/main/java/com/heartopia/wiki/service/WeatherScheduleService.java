package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.WeatherScheduleMapper;
import com.heartopia.wiki.model.WeatherSchedule;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.Locale;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class WeatherScheduleService {

    private static final Set<Integer> SLOT_HOURS = Set.of(0, 6, 12, 18);
    private static final Set<String> WEATHER_CODES = Set.of(
            "SUNNY", "RAIN", "RAINBOW", "METEOR_SHOWER", "HEATWAVE", "SNOW", "AURORA");
    private static final ZoneId ASIA_SERVER_ZONE = ZoneId.of("Asia/Seoul");

    private final WeatherScheduleMapper mapper;

    @Transactional(readOnly = true)
    public List<WeatherSchedule> getAll() {
        return mapper.findAllActive();
    }

    public LocalDate today() {
        return LocalDate.now(ASIA_SERVER_ZONE);
    }

    @Transactional
    public void save(WeatherSchedule schedule) {
        if (schedule == null || schedule.getForecastDate() == null) {
            throw new IllegalArgumentException("적용 날짜를 선택해 주세요.");
        }
        if (schedule.getSlotHour() == null || !SLOT_HOURS.contains(schedule.getSlotHour())) {
            throw new IllegalArgumentException("시간은 0시, 6시, 12시, 18시 중에서 선택해 주세요.");
        }
        String code = schedule.getWeatherCode() == null
                ? ""
                : schedule.getWeatherCode().trim().toUpperCase(Locale.ROOT);
        if (!WEATHER_CODES.contains(code)) {
            throw new IllegalArgumentException("지원하지 않는 날씨입니다.");
        }
        schedule.setWeatherCode(code);
        schedule.setSourceWeatherIds(normalizeSourceIds(schedule.getSourceWeatherIds()));
        mapper.upsert(schedule);
    }

    @Transactional
    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("삭제할 날씨 예약을 찾을 수 없습니다.");
        }
        mapper.deleteById(id);
    }

    private String normalizeSourceIds(String sourceWeatherIds) {
        if (sourceWeatherIds == null || sourceWeatherIds.isBlank()) {
            return null;
        }
        String normalized = sourceWeatherIds.trim();
        if (normalized.length() > 64) {
            throw new IllegalArgumentException("원본 날씨 ID는 64자 이하여야 합니다.");
        }
        return normalized;
    }
}
