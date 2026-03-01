package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.VisitorMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class VisitorService {
    private final VisitorMapper visitorMapper;

    @Transactional
    public void trackVisitor() {
        visitorMapper.incrementTodayCount();
    }

    public int getWeeklyVisitorCount() {
        return visitorMapper.getWeeklyTotal();
    }
}
