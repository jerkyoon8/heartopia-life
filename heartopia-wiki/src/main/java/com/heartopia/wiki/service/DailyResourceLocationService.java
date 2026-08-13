package com.heartopia.wiki.service;

import com.heartopia.wiki.dto.DailyResourceLocationResponse;
import com.heartopia.wiki.mapper.DailyResourceLocationMapper;
import com.heartopia.wiki.model.DailyResourceLocation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Set;

@Service
public class DailyResourceLocationService {

    private static final ZoneId ASIA_SERVER_ZONE = ZoneId.of("Asia/Seoul");
    private static final DateTimeFormatter SERVER_TIME_FORMAT = DateTimeFormatter.ISO_OFFSET_DATE_TIME;
    private static final Set<String> LOCATION_TYPES = Set.of("HOUSE_FRONT", "RUINS", "OAK_FOREST");
    private static final String EMPTY_LOCATION = "위치 정보 없음";

    private final DailyResourceLocationMapper mapper;
    private final Clock clock;

    @Autowired
    public DailyResourceLocationService(DailyResourceLocationMapper mapper) {
        this(mapper, Clock.system(ASIA_SERVER_ZONE));
    }

    DailyResourceLocationService(DailyResourceLocationMapper mapper, Clock clock) {
        this.mapper = mapper;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public DailyResourceLocationResponse getCurrent() {
        ZonedDateTime now = ZonedDateTime.now(clock).withZoneSameInstant(ASIA_SERVER_ZONE);
        DailyResourceLocation location = mapper.findByGameDate(gameDate(now));
        if (location == null) {
            return new DailyResourceLocationResponse(
                    SERVER_TIME_FORMAT.format(now),
                    EMPTY_LOCATION,
                    EMPTY_LOCATION,
                    false);
        }
        return new DailyResourceLocationResponse(
                SERVER_TIME_FORMAT.format(now),
                location.getFluoriteLocationLabel(),
                location.getOakLocationLabel(),
                true);
    }

    @Transactional(readOnly = true)
    public List<DailyResourceLocation> getAll() {
        return mapper.findAll();
    }

    @Transactional
    public void save(DailyResourceLocation location) {
        if (location == null || location.getGameDate() == null) {
            throw new IllegalArgumentException("적용 날짜를 선택해 주세요.");
        }
        location.setFluoriteLocationType(normalizeType(location.getFluoriteLocationType(), "형광석"));
        location.setFluoriteHouseNumber(normalizeHouseNumber(
                location.getFluoriteLocationType(),
                location.getFluoriteHouseNumber(),
                "형광석"));
        location.setOakLocationType(normalizeType(location.getOakLocationType(), "그자리 참나무"));
        location.setOakHouseNumber(normalizeHouseNumber(
                location.getOakLocationType(),
                location.getOakHouseNumber(),
                "그자리 참나무"));
        mapper.upsert(location);
    }

    @Transactional
    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("삭제할 예약을 찾을 수 없습니다.");
        }
        mapper.deleteById(id);
    }

    public LocalDate currentGameDate() {
        return gameDate(ZonedDateTime.now(clock).withZoneSameInstant(ASIA_SERVER_ZONE));
    }

    private LocalDate gameDate(ZonedDateTime now) {
        return now.minusHours(6).toLocalDate();
    }

    private String normalizeType(String type, String resourceName) {
        String normalized = type == null ? "" : type.trim().toUpperCase(Locale.ROOT);
        if (!LOCATION_TYPES.contains(normalized)) {
            throw new IllegalArgumentException(resourceName + " 위치는 집 앞, 유적 또는 참나무숲만 선택할 수 있습니다.");
        }
        return normalized;
    }

    private Integer normalizeHouseNumber(String type, Integer houseNumber, String resourceName) {
        if (!"HOUSE_FRONT".equals(type)) {
            return null;
        }
        if (houseNumber == null || houseNumber < 1) {
            throw new IllegalArgumentException(resourceName + "의 집 번호를 1 이상으로 입력해 주세요.");
        }
        return houseNumber;
    }
}
