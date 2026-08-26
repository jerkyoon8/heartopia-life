package com.heartopia.wiki.mapper;

import com.heartopia.wiki.dto.VisitorSummary;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface VisitorMapper {
    void incrementTodayCount();

    VisitorSummary getVisitorSummary();

    int getTotalTotal();

    int getRecent48hTotal();

}
