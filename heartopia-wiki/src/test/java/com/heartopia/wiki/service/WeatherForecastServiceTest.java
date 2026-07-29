package com.heartopia.wiki.service;

import com.heartopia.wiki.dto.weather.WeatherForecastResponse;
import com.heartopia.wiki.dto.weather.WeatherVoteBatchRequest;
import com.heartopia.wiki.dto.weather.WeatherVoteRequest;
import com.heartopia.wiki.mapper.WeatherVoteMapper;
import com.heartopia.wiki.model.WeatherVote;
import com.heartopia.wiki.model.WeatherVoteTally;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class WeatherForecastServiceTest {

    private static final ZoneId ASIA_SERVER_ZONE = ZoneId.of("Asia/Seoul");
    private static final LocalDate TODAY = LocalDate.of(2026, 7, 29);

    @Mock
    private WeatherVoteMapper mapper;

    private WeatherForecastService service;

    @BeforeEach
    void setUp() {
        Clock clock = Clock.fixed(Instant.parse("2026-07-28T23:00:00Z"), ASIA_SERVER_ZONE); // 07/29 08:00
        service = new WeatherForecastService(mapper, clock);
        lenient().when(mapper.findTallies(any(), any())).thenReturn(List.of());
    }

    @Test
    @DisplayName("08시는 현재 06시 슬롯부터 다음 날 06시 슬롯까지 다섯 칸을 만든다")
    void buildsFiveRollingSixHourSlots() {
        WeatherForecastResponse response = service.getForecast(null);

        assertEquals(5, response.detailSlots().size());
        assertEquals(List.of(6, 12, 18, 0, 6),
                response.detailSlots().stream().map(WeatherForecastResponse.DetailSlot::slotHour).toList());
        assertEquals(List.of(TODAY, TODAY, TODAY, TODAY.plusDays(1), TODAY.plusDays(1)),
                response.detailSlots().stream().map(WeatherForecastResponse.DetailSlot::forecastDate).toList());
        assertEquals(7, response.dailyForecasts().size());
    }

    @Test
    @DisplayName("상세 제보가 비어 있으면 같은 날짜의 기본 날씨를 사용한다")
    void fallsBackToDailyWeatherOnlyWhenDetailIsEmpty() {
        when(mapper.findTallies(any(), any())).thenReturn(List.of(
                tally(TODAY, -1, "SUNNY", 3, 3)
        ));

        WeatherForecastResponse response = service.getForecast(null);
        WeatherForecastResponse.ForecastResult first = response.detailSlots().get(0).result();

        assertEquals("CONFIRMED", first.status());
        assertEquals("SUNNY", first.weatherCode());
        assertTrue(first.fallback());
    }

    @Test
    @DisplayName("상세 제보가 동점이면 기본 날씨로 덮어쓰지 않는다")
    void doesNotFallbackWhenDetailIsTied() {
        when(mapper.findTallies(any(), any())).thenReturn(List.of(
                tally(TODAY, 6, "SUNNY", 2, 2),
                tally(TODAY, 6, "RAIN", 2, 2),
                tally(TODAY, -1, "SUNNY", 4, 4)
        ));

        WeatherForecastResponse response = service.getForecast(null);
        WeatherForecastResponse.ForecastResult first = response.detailSlots().get(0).result();

        assertEquals("TIED", first.status());
        assertNull(first.weatherCode());
        assertFalse(first.fallback());
    }

    @Test
    @DisplayName("관리자 5점은 일반 4점을 이기지만 일반 6점에는 뒤집힌다")
    void resolvesWeightedConsensusWithoutAdminLock() {
        when(mapper.findTallies(any(), any())).thenReturn(List.of(
                tally(TODAY, 6, "SUNNY", 4, 4),
                tally(TODAY, 6, "RAIN", 5, 1)
        ));

        WeatherForecastResponse adminLead = service.getForecast(null);
        assertEquals("RAIN", adminLead.detailSlots().get(0).result().weatherCode());

        when(mapper.findTallies(any(), any())).thenReturn(List.of(
                tally(TODAY, 6, "SUNNY", 6, 6),
                tally(TODAY, 6, "RAIN", 5, 1)
        ));

        WeatherForecastResponse usersLead = service.getForecast(null);
        assertEquals("SUNNY", usersLead.detailSlots().get(0).result().weatherCode());
    }

    @Test
    @DisplayName("관리자 제출은 서버에서 가중치 5로 저장한다")
    void appliesAdminWeightOnServer() {
        when(mapper.findUserVote(anyLong(), any(), any(Integer.class))).thenReturn(null);

        service.submitVotes(7L, true, new WeatherVoteBatchRequest(List.of(
                new WeatherVoteRequest(TODAY, 6, "HEATWAVE")
        )));

        ArgumentCaptor<WeatherVote> captor = ArgumentCaptor.forClass(WeatherVote.class);
        verify(mapper).upsertVote(captor.capture());
        assertEquals(5, captor.getValue().getVoteWeight());
        assertEquals("HEATWAVE", captor.getValue().getWeatherCode());
        verify(mapper, never()).insertHistory(anyLong(), any(), any(Integer.class), any(), any());
    }

    @Test
    @DisplayName("일반 사용자 제출은 가중치 1이며 실제 변경만 이력에 남긴다")
    void recordsHistoryOnlyWhenWeatherActuallyChanges() {
        WeatherVote existing = WeatherVote.builder()
                .userId(9L)
                .forecastDate(TODAY)
                .slotHour(6)
                .weatherCode("SUNNY")
                .voteWeight(1)
                .build();
        when(mapper.findUserVote(9L, TODAY, 6)).thenReturn(existing);

        service.submitVotes(9L, false, new WeatherVoteBatchRequest(List.of(
                new WeatherVoteRequest(TODAY, 6, "RAIN")
        )));

        verify(mapper).insertHistory(9L, TODAY, 6, "SUNNY", "RAIN");
        ArgumentCaptor<WeatherVote> captor = ArgumentCaptor.forClass(WeatherVote.class);
        verify(mapper).upsertVote(captor.capture());
        assertEquals(1, captor.getValue().getVoteWeight());
    }

    @Test
    @DisplayName("7일 이력 정리 기준은 UTC 연결 시간대에 맞춰 전달한다")
    void cleansHistoryUsingUtcCutoff() {
        when(mapper.findUserVote(anyLong(), any(), any(Integer.class))).thenReturn(null);

        service.submitVotes(11L, false, new WeatherVoteBatchRequest(List.of(
                new WeatherVoteRequest(TODAY, 6, "SUNNY")
        )));

        verify(mapper).deleteHistoryBefore(LocalDateTime.of(2026, 7, 21, 23, 0));
    }

    @Test
    @DisplayName("허용되지 않은 날씨와 중복 예보 키는 거부한다")
    void rejectsInvalidWeatherAndDuplicateKeys() {
        assertThrows(IllegalArgumentException.class, () ->
                service.submitVotes(1L, false, new WeatherVoteBatchRequest(List.of(
                        new WeatherVoteRequest(TODAY, 6, "SNOW")
                ))));

        assertThrows(IllegalArgumentException.class, () ->
                service.submitVotes(1L, false, new WeatherVoteBatchRequest(List.of(
                        new WeatherVoteRequest(TODAY, 6, "SUNNY"),
                        new WeatherVoteRequest(TODAY, 6, "RAIN")
                ))));
    }

    @Test
    @DisplayName("현재 상세 다섯 칸과 7일 기본 범위 밖의 제보는 거부한다")
    void rejectsVotesOutsideVisibleForecastKeys() {
        assertThrows(IllegalArgumentException.class, () ->
                service.submitVotes(1L, false, new WeatherVoteBatchRequest(List.of(
                        new WeatherVoteRequest(TODAY.plusDays(2), 6, "SUNNY")
                ))));

        assertThrows(IllegalArgumentException.class, () ->
                service.submitVotes(1L, false, new WeatherVoteBatchRequest(List.of(
                        new WeatherVoteRequest(TODAY.plusDays(7), -1, "SUNNY")
                ))));
    }

    private WeatherVoteTally tally(LocalDate date, int slotHour, String weatherCode, int score, int voters) {
        return WeatherVoteTally.builder()
                .forecastDate(date)
                .slotHour(slotHour)
                .weatherCode(weatherCode)
                .score(score)
                .voterCount(voters)
                .build();
    }
}
