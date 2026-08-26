package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.DailyResourceLocationMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

@Service
@RequiredArgsConstructor
public class DailyResourceLocationCleanupService {

    private final DailyResourceLocationMapper mapper;

    @Transactional
    public int deleteBefore(LocalDate gameDate) {
        return mapper.deleteBeforeGameDate(gameDate);
    }
}
