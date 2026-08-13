package com.heartopia.wiki.service;

import com.heartopia.wiki.dto.DailyResourceLocationResponse;
import com.heartopia.wiki.mapper.DailyResourceLocationMapper;
import com.heartopia.wiki.model.DailyResourceLocation;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class DailyResourceLocationServiceTest {

    private static final ZoneId ASIA_SERVER_ZONE = ZoneId.of("Asia/Seoul");

    @Mock
    private DailyResourceLocationMapper mapper;

    @Test
    @DisplayName("아시아 서버 오전 5시 59분은 전날 게임 날짜를 조회한다")
    void usesPreviousGameDateBeforeSixAm() {
        DailyResourceLocationService service = serviceAt("2026-07-30T20:59:00Z"); // 07/31 05:59
        when(mapper.findByGameDate(LocalDate.of(2026, 7, 30))).thenReturn(null);

        DailyResourceLocationResponse response = service.getCurrent();

        verify(mapper).findByGameDate(LocalDate.of(2026, 7, 30));
        assertEquals("위치 정보 없음", response.fluoriteLocation());
        assertEquals("위치 정보 없음", response.oakLocation());
    }

    @Test
    @DisplayName("아시아 서버 오전 6시 정각부터 당일 게임 날짜를 조회한다")
    void switchesGameDateAtSixAm() {
        DailyResourceLocationService service = serviceAt("2026-07-30T21:00:00Z"); // 07/31 06:00
        DailyResourceLocation row = location(
                LocalDate.of(2026, 7, 31),
                "HOUSE_FRONT", 8,
                "RUINS", null);
        when(mapper.findByGameDate(LocalDate.of(2026, 7, 31))).thenReturn(row);

        DailyResourceLocationResponse response = service.getCurrent();

        verify(mapper).findByGameDate(LocalDate.of(2026, 7, 31));
        assertEquals("8번 집 앞", response.fluoriteLocation());
        assertEquals("유적", response.oakLocation());
    }

    @Test
    @DisplayName("집 앞은 양의 집 번호를 요구하고 유적과 참나무숲의 집 번호는 제거한다")
    void validatesAndNormalizesLocationTypes() {
        DailyResourceLocationService service = serviceAt("2026-07-30T21:00:00Z");
        DailyResourceLocation valid = location(
                LocalDate.of(2026, 8, 1),
                "HOUSE_FRONT", 8,
                "RUINS", 99);

        service.save(valid);

        ArgumentCaptor<DailyResourceLocation> captor = ArgumentCaptor.forClass(DailyResourceLocation.class);
        verify(mapper).upsert(captor.capture());
        assertEquals(8, captor.getValue().getFluoriteHouseNumber());
        assertNull(captor.getValue().getOakHouseNumber());

        DailyResourceLocation oakForest = location(
                LocalDate.of(2026, 8, 2),
                "OAK_FOREST", 77,
                "OAK_FOREST", 88);
        service.save(oakForest);
        assertEquals("참나무숲", oakForest.getFluoriteLocationLabel());
        assertEquals("참나무숲", oakForest.getOakLocationLabel());
        assertNull(oakForest.getFluoriteHouseNumber());
        assertNull(oakForest.getOakHouseNumber());

        assertThrows(IllegalArgumentException.class, () -> service.save(location(
                LocalDate.of(2026, 8, 3),
                "HOUSE_FRONT", 0,
                "RUINS", null)));
        assertThrows(IllegalArgumentException.class, () -> service.save(location(
                LocalDate.of(2026, 8, 3),
                "FREE_TEXT", null,
                "RUINS", null)));
    }

    private DailyResourceLocationService serviceAt(String instant) {
        return new DailyResourceLocationService(
                mapper,
                Clock.fixed(Instant.parse(instant), ASIA_SERVER_ZONE));
    }

    private DailyResourceLocation location(
            LocalDate gameDate,
            String fluoriteType,
            Integer fluoriteHouseNumber,
            String oakType,
            Integer oakHouseNumber) {
        DailyResourceLocation location = new DailyResourceLocation();
        location.setGameDate(gameDate);
        location.setFluoriteLocationType(fluoriteType);
        location.setFluoriteHouseNumber(fluoriteHouseNumber);
        location.setOakLocationType(oakType);
        location.setOakHouseNumber(oakHouseNumber);
        return location;
    }
}
