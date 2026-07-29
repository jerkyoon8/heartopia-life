package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.WeatherVote;
import com.heartopia.wiki.model.WeatherVoteTally;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface WeatherVoteMapper {

    List<WeatherVoteTally> findTallies(
            @Param("fromDate") LocalDate fromDate,
            @Param("toDate") LocalDate toDate);

    List<WeatherVote> findUserVotes(
            @Param("userId") Long userId,
            @Param("fromDate") LocalDate fromDate,
            @Param("toDate") LocalDate toDate);

    WeatherVote findUserVote(
            @Param("userId") Long userId,
            @Param("forecastDate") LocalDate forecastDate,
            @Param("slotHour") int slotHour);

    void upsertVote(WeatherVote vote);

    void insertHistory(
            @Param("userId") Long userId,
            @Param("forecastDate") LocalDate forecastDate,
            @Param("slotHour") int slotHour,
            @Param("previousWeatherCode") String previousWeatherCode,
            @Param("newWeatherCode") String newWeatherCode);

    void deleteVotesBefore(@Param("cutoffDate") LocalDate cutoffDate);

    void deleteHistoryBefore(@Param("cutoffDateTime") LocalDateTime cutoffDateTime);
}
