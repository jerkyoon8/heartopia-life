package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.WeatherSchedule;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface WeatherScheduleMapper {
    List<WeatherSchedule> findActiveBetween(
            @Param("fromDate") LocalDate fromDate,
            @Param("toDate") LocalDate toDate);

    List<WeatherSchedule> findAllActive();

    void upsert(WeatherSchedule schedule);

    void deleteById(@Param("id") Long id);
}
