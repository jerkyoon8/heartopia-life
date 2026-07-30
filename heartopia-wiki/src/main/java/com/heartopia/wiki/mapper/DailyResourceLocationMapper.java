package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.DailyResourceLocation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface DailyResourceLocationMapper {

    DailyResourceLocation findByGameDate(@Param("gameDate") LocalDate gameDate);

    List<DailyResourceLocation> findAll();

    void upsert(DailyResourceLocation location);

    void deleteById(@Param("id") Long id);
}
