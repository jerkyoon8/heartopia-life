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
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZoneOffset;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.never;
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
    @DisplayName("같은 게임 날짜의 위치와 빈 결과는 각각 한 번만 조회한다")
    void cachesLocationAndEmptyResultForSameGameDate() {
        DailyResourceLocationService service = serviceAt("2026-07-30T22:00:00Z");
        LocalDate gameDate = LocalDate.of(2026, 7, 31);
        when(mapper.findByGameDate(gameDate)).thenReturn(null);

        service.getCurrent();
        service.getCurrent();

        verify(mapper, times(1)).findByGameDate(gameDate);
    }

    @Test
    @DisplayName("응답 서버 시각은 위치 캐시와 분리되어 매 호출 시 갱신된다")
    void refreshesServerTimeWhenLocationIsCached() {
        MutableClock clock = new MutableClock("2026-07-30T22:00:00Z");
        DailyResourceLocationService service = new DailyResourceLocationService(mapper, clock);
        LocalDate gameDate = LocalDate.of(2026, 7, 31);
        when(mapper.findByGameDate(gameDate)).thenReturn(null);

        DailyResourceLocationResponse first = service.getCurrent();
        clock.setInstant("2026-07-30T23:00:00Z");
        DailyResourceLocationResponse second = service.getCurrent();

        assertEquals("2026-07-31T07:00:00+09:00", first.serverTime());
        assertEquals("2026-07-31T08:00:00+09:00", second.serverTime());
        verify(mapper, times(1)).findByGameDate(gameDate);
    }

    @Test
    @DisplayName("오전 6시 경계를 지나면 전날 캐시를 사용하지 않는다")
    void doesNotReusePreviousDateCacheAfterSixAm() {
        MutableClock clock = new MutableClock("2026-07-30T20:59:59Z");
        DailyResourceLocationService service = new DailyResourceLocationService(mapper, clock);
        LocalDate previousDate = LocalDate.of(2026, 7, 30);
        LocalDate currentDate = LocalDate.of(2026, 7, 31);
        when(mapper.findByGameDate(previousDate)).thenReturn(null);
        when(mapper.findByGameDate(currentDate)).thenReturn(location(
                currentDate, "RUINS", null, "OAK_FOREST", null));

        service.getCurrent();
        clock.setInstant("2026-07-30T21:00:00Z");
        DailyResourceLocationResponse response = service.getCurrent();

        verify(mapper).findByGameDate(previousDate);
        verify(mapper).findByGameDate(currentDate);
        assertEquals("유적", response.fluoriteLocation());
        assertEquals("참나무숲", response.oakLocation());
    }

    @Test
    @DisplayName("저장과 삭제가 성공하면 현재 위치 캐시를 무효화한다")
    void invalidatesCacheAfterSaveAndDelete() {
        DailyResourceLocationService service = serviceAt("2026-07-30T22:00:00Z");
        LocalDate gameDate = LocalDate.of(2026, 7, 31);
        DailyResourceLocation first = location(gameDate, "RUINS", null, "RUINS", null);
        DailyResourceLocation second = location(gameDate, "OAK_FOREST", null, "OAK_FOREST", null);
        when(mapper.findByGameDate(gameDate)).thenReturn(first, second, null);

        service.getCurrent();
        service.save(location(LocalDate.of(2026, 8, 1), "RUINS", null, "RUINS", null));
        assertEquals("참나무숲", service.getCurrent().fluoriteLocation());
        service.delete(99L);
        assertEquals("위치 정보 없음", service.getCurrent().fluoriteLocation());

        verify(mapper, times(3)).findByGameDate(gameDate);
        verify(mapper).deleteById(99L);
    }

    @Test
    @DisplayName("트랜잭션 저장은 커밋 이후에 캐시를 무효화한다")
    void invalidatesCacheOnlyAfterTransactionCommit() {
        DailyResourceLocationService service = serviceAt("2026-07-30T22:00:00Z");
        LocalDate gameDate = LocalDate.of(2026, 7, 31);
        DailyResourceLocation first = location(gameDate, "RUINS", null, "RUINS", null);
        DailyResourceLocation second = location(gameDate, "OAK_FOREST", null, "OAK_FOREST", null);
        when(mapper.findByGameDate(gameDate)).thenReturn(first, second);
        service.getCurrent();

        TransactionSynchronizationManager.initSynchronization();
        try {
            service.save(location(LocalDate.of(2026, 8, 1), "RUINS", null, "RUINS", null));
            assertEquals("유적", service.getCurrent().fluoriteLocation());

            for (TransactionSynchronization synchronization
                    : TransactionSynchronizationManager.getSynchronizations()) {
                synchronization.afterCommit();
            }

            assertEquals("참나무숲", service.getCurrent().fluoriteLocation());
            verify(mapper, times(2)).findByGameDate(gameDate);
        } finally {
            TransactionSynchronizationManager.clearSynchronization();
        }
    }

    @Test
    @DisplayName("시작 및 오전 6시 정리는 과거만 삭제하고 캐시를 비운다")
    void deletesOnlyPastLocationsAndInvalidatesCache() {
        DailyResourceLocationService service = serviceAt("2026-07-30T22:00:00Z");
        LocalDate gameDate = LocalDate.of(2026, 7, 31);
        when(mapper.findByGameDate(gameDate)).thenReturn(null);

        service.getCurrent();
        service.cleanupPastLocations();
        service.getCurrent();

        verify(mapper).deleteBeforeGameDate(gameDate);
        verify(mapper, times(2)).findByGameDate(gameDate);
    }

    @Test
    @DisplayName("정리 실패 시 완료로 기록하지 않고 다음 요청에서 재시도한다")
    void retriesCleanupAfterFailure() {
        DailyResourceLocationCleanupService cleanupService = org.mockito.Mockito.mock(
                DailyResourceLocationCleanupService.class);
        LocalDate gameDate = LocalDate.of(2026, 7, 31);
        when(cleanupService.deleteBefore(gameDate))
                .thenThrow(new IllegalStateException("temporary failure"))
                .thenReturn(1);
        DailyResourceLocationService service = new DailyResourceLocationService(
                mapper,
                cleanupService,
                Clock.fixed(Instant.parse("2026-07-30T22:00:00Z"), ASIA_SERVER_ZONE));
        when(mapper.findByGameDate(gameDate)).thenReturn(null);

        assertThrows(IllegalStateException.class, service::getCurrent);
        verify(mapper, never()).findByGameDate(gameDate);

        service.getCurrent();
        verify(cleanupService, times(2)).deleteBefore(gameDate);
        verify(mapper).findByGameDate(gameDate);
    }

    @Test
    @DisplayName("과거 정리는 서울 시간 매일 오전 6시에 실행되도록 선언된다")
    void cleanupScheduleUsesSeoulSixAmBoundary() throws NoSuchMethodException {
        Scheduled scheduled = DailyResourceLocationService.class
                .getDeclaredMethod("cleanupPastLocations")
                .getAnnotation(Scheduled.class);

        assertEquals("0 0 6 * * *", scheduled.cron());
        assertEquals("Asia/Seoul", scheduled.zone());
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

    private static final class MutableClock extends Clock {
        private Instant instant;

        private MutableClock(String instant) {
            this.instant = Instant.parse(instant);
        }

        private void setInstant(String instant) {
            this.instant = Instant.parse(instant);
        }

        @Override
        public ZoneId getZone() {
            return ZoneOffset.UTC;
        }

        @Override
        public Clock withZone(ZoneId zone) {
            return this;
        }

        @Override
        public Instant instant() {
            return instant;
        }
    }
}
