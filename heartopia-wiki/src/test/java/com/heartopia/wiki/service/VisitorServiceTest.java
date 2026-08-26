package com.heartopia.wiki.service;

import com.heartopia.wiki.dto.VisitorSummary;
import com.heartopia.wiki.mapper.VisitorMapper;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class VisitorServiceTest {

    private final VisitorMapper mapper = mock(VisitorMapper.class);
    private final VisitorService service = new VisitorService(mapper);

    @Test
    void returnsTodayAndWeeklyCountsFromOneMapperSummary() {
        VisitorSummary summary = new VisitorSummary(8, 41);
        when(mapper.getVisitorSummary()).thenReturn(summary);

        assertThat(service.getVisitorSummary()).isSameAs(summary);

        verify(mapper).getVisitorSummary();
    }
}
