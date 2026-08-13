package com.heartopia.wiki.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface EventSettingsMapper {

    List<String> findAvailableEventNames();

    List<String> findCurrentEventNames();

    List<String> findQuickEventNames();

    void deleteAllCurrentEvents();

    void insertCurrentEvents(@Param("eventNames") List<String> eventNames);

    void deleteAllQuickEvents();

    void insertQuickEvents(@Param("eventNames") List<String> eventNames);
}
