package com.heartopia.wiki.service;

import com.heartopia.wiki.dto.weather.WeatherForecastResponse;
import com.heartopia.wiki.dto.weather.WeatherVoteBatchRequest;
import com.heartopia.wiki.dto.weather.WeatherVoteRequest;
import com.heartopia.wiki.mapper.WeatherVoteMapper;
import com.heartopia.wiki.model.WeatherVote;
import com.heartopia.wiki.model.WeatherVoteTally;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class WeatherForecastService {

    private static final java.time.ZoneId ASIA_SERVER_ZONE = java.time.ZoneId.of("Asia/Seoul");
    private static final DateTimeFormatter SERVER_TIME_FORMAT = DateTimeFormatter.ISO_OFFSET_DATE_TIME;
    private static final Set<String> WEATHER_CODES = Set.of(
            "SUNNY", "RAIN", "RAINBOW", "METEOR_SHOWER", "HEATWAVE");
    private static final int DAILY_SLOT = -1;
    private static final int MAX_BATCH_SIZE = 12;

    private final WeatherVoteMapper mapper;
    private final Clock clock;

    @Autowired
    public WeatherForecastService(WeatherVoteMapper mapper) {
        this(mapper, Clock.system(ASIA_SERVER_ZONE));
    }

    WeatherForecastService(WeatherVoteMapper mapper, Clock clock) {
        this.mapper = mapper;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public WeatherForecastResponse getForecast(Long userId) {
        ZonedDateTime now = ZonedDateTime.now(clock).withZoneSameInstant(ASIA_SERVER_ZONE);
        LocalDate today = now.toLocalDate();
        LocalDate lastDate = today.plusDays(6);

        List<WeatherVoteTally> tallies = mapper.findTallies(today, lastDate);
        Map<ForecastKey, List<WeatherVoteTally>> talliesByKey = safeList(tallies).stream()
                .collect(Collectors.groupingBy(t -> new ForecastKey(t.getForecastDate(), t.getSlotHour())));

        Map<ForecastKey, String> myVotes = new HashMap<>();
        if (userId != null) {
            for (WeatherVote vote : safeList(mapper.findUserVotes(userId, today, lastDate))) {
                myVotes.put(new ForecastKey(vote.getForecastDate(), vote.getSlotHour()), vote.getWeatherCode());
            }
        }

        Map<LocalDate, WeatherForecastResponse.ForecastResult> dailyResults = new HashMap<>();
        List<WeatherForecastResponse.DailyForecast> dailyForecasts = new ArrayList<>(7);
        for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
            LocalDate date = today.plusDays(dayOffset);
            ForecastKey key = new ForecastKey(date, DAILY_SLOT);
            WeatherForecastResponse.ForecastResult result = resolve(talliesByKey.get(key), false);
            dailyResults.put(date, result);
            dailyForecasts.add(new WeatherForecastResponse.DailyForecast(date, result, myVotes.get(key)));
        }

        List<WeatherForecastResponse.DetailSlot> detailSlots = new ArrayList<>(5);
        for (ForecastKey key : detailKeys(now)) {
            WeatherForecastResponse.ForecastResult detail = resolve(talliesByKey.get(key), false);
            if ("EMPTY".equals(detail.status())) {
                WeatherForecastResponse.ForecastResult daily = dailyResults.get(key.forecastDate());
                if (daily != null && !"EMPTY".equals(daily.status())) {
                    detail = new WeatherForecastResponse.ForecastResult(
                            daily.status(),
                            daily.weatherCode(),
                            daily.score(),
                            daily.voterCount(),
                            true);
                }
            }
            detailSlots.add(new WeatherForecastResponse.DetailSlot(
                    key.forecastDate(),
                    key.slotHour(),
                    detail,
                    myVotes.get(key)));
        }

        return new WeatherForecastResponse(
                SERVER_TIME_FORMAT.format(now),
                userId != null,
                List.copyOf(detailSlots),
                List.copyOf(dailyForecasts));
    }

    @Transactional
    public WeatherForecastResponse submitVotes(Long userId, boolean admin, WeatherVoteBatchRequest request) {
        if (userId == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }

        ZonedDateTime now = ZonedDateTime.now(clock).withZoneSameInstant(ASIA_SERVER_ZONE);
        List<WeatherVoteRequest> votes = request == null ? null : request.votes();
        validateBatch(votes, now);

        int weight = admin ? 5 : 1;
        for (WeatherVoteRequest item : votes) {
            WeatherVote existing = mapper.findUserVote(userId, item.forecastDate(), item.slotHour());
            if (existing != null && !existing.getWeatherCode().equals(item.weatherCode())) {
                mapper.insertHistory(
                        userId,
                        item.forecastDate(),
                        item.slotHour(),
                        existing.getWeatherCode(),
                        item.weatherCode());
            }

            mapper.upsertVote(WeatherVote.builder()
                    .userId(userId)
                    .forecastDate(item.forecastDate())
                    .slotHour(item.slotHour())
                    .weatherCode(item.weatherCode())
                    .voteWeight(weight)
                    .build());
        }

        mapper.deleteVotesBefore(now.toLocalDate());
        mapper.deleteHistoryBefore(LocalDateTime.ofInstant(clock.instant(), ZoneOffset.UTC).minusDays(7));
        return getForecast(userId);
    }

    private void validateBatch(List<WeatherVoteRequest> votes, ZonedDateTime now) {
        if (votes == null || votes.isEmpty()) {
            throw new IllegalArgumentException("제보할 날씨를 하나 이상 선택해 주세요.");
        }
        if (votes.size() > MAX_BATCH_SIZE) {
            throw new IllegalArgumentException("한 번에 제출할 수 있는 예보는 최대 12개입니다.");
        }

        Set<ForecastKey> allowedDetailKeys = new HashSet<>(detailKeys(now));
        Set<LocalDate> allowedDailyDates = new HashSet<>();
        for (int i = 0; i < 7; i++) {
            allowedDailyDates.add(now.toLocalDate().plusDays(i));
        }

        Set<ForecastKey> seen = new HashSet<>();
        for (WeatherVoteRequest item : votes) {
            if (item == null || item.forecastDate() == null || !WEATHER_CODES.contains(item.weatherCode())) {
                throw new IllegalArgumentException("지원하지 않는 날씨 제보입니다.");
            }

            ForecastKey key = new ForecastKey(item.forecastDate(), item.slotHour());
            boolean validDaily = item.slotHour() == DAILY_SLOT && allowedDailyDates.contains(item.forecastDate());
            boolean validDetail = item.slotHour() != DAILY_SLOT && allowedDetailKeys.contains(key);
            if (!validDaily && !validDetail) {
                throw new IllegalArgumentException("현재 제공되는 예보 범위 밖의 제보입니다.");
            }
            if (!seen.add(key)) {
                throw new IllegalArgumentException("같은 예보 칸이 중복되었습니다.");
            }
        }
    }

    private List<ForecastKey> detailKeys(ZonedDateTime now) {
        int currentSlotHour = (now.getHour() / 6) * 6;
        ZonedDateTime slotStart = now.withHour(currentSlotHour).withMinute(0).withSecond(0).withNano(0);
        List<ForecastKey> keys = new ArrayList<>(5);
        for (int i = 0; i < 5; i++) {
            ZonedDateTime slot = slotStart.plusHours((long) i * 6);
            keys.add(new ForecastKey(slot.toLocalDate(), slot.getHour()));
        }
        return keys;
    }

    private WeatherForecastResponse.ForecastResult resolve(List<WeatherVoteTally> rows, boolean fallback) {
        List<WeatherVoteTally> safeRows = safeList(rows);
        if (safeRows.isEmpty()) {
            return new WeatherForecastResponse.ForecastResult("EMPTY", null, 0, 0, fallback);
        }

        int maxScore = safeRows.stream().mapToInt(WeatherVoteTally::getScore).max().orElse(0);
        int totalVoters = safeRows.stream().mapToInt(WeatherVoteTally::getVoterCount).sum();
        List<WeatherVoteTally> leaders = safeRows.stream()
                .filter(row -> row.getScore() == maxScore)
                .toList();

        if (leaders.size() != 1) {
            return new WeatherForecastResponse.ForecastResult("TIED", null, maxScore, totalVoters, fallback);
        }
        return new WeatherForecastResponse.ForecastResult(
                "CONFIRMED",
                leaders.get(0).getWeatherCode(),
                maxScore,
                totalVoters,
                fallback);
    }

    private <T> List<T> safeList(List<T> value) {
        return value == null ? List.of() : value;
    }

    private record ForecastKey(LocalDate forecastDate, int slotHour) {
    }
}
