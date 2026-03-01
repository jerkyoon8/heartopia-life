package com.heartopia.wiki.mapper;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface VisitorMapper {
    void incrementTodayCount();

    int getWeeklyTotal();
}
