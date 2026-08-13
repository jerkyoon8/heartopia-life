package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.EventSettingsMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InOrder;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class EventSettingsServiceTest {

    @Mock
    private EventSettingsMapper mapper;

    @Test
    @DisplayName("현재 이벤트는 공백과 중복을 정리한 뒤 전체 교체한다")
    void replacesCurrentEventsWithNormalizedSelection() {
        when(mapper.findAvailableEventNames()).thenReturn(List.of(
                "고래 탐사 시즌",
                "데이브 더 다이버",
                "겨울 축제"));
        EventSettingsService service = new EventSettingsService(mapper);

        service.replaceEventSettings(List.of(
                " 고래 탐사 시즌 ",
                "데이브 더 다이버",
                "고래 탐사 시즌",
                " "), List.of(" 데이브 더 다이버 ", "데이브 더 다이버"));

        InOrder inOrder = inOrder(mapper);
        inOrder.verify(mapper).deleteAllCurrentEvents();
        inOrder.verify(mapper).insertCurrentEvents(List.of("고래 탐사 시즌", "데이브 더 다이버"));
        inOrder.verify(mapper).deleteAllQuickEvents();
        inOrder.verify(mapper).insertQuickEvents(List.of("데이브 더 다이버"));
    }

    @Test
    @DisplayName("아무 이벤트도 선택하지 않으면 현재 이벤트를 모두 해제한다")
    void clearsAllCurrentEventsWhenSelectionIsEmpty() {
        when(mapper.findAvailableEventNames()).thenReturn(List.of("고래 탐사 시즌"));
        EventSettingsService service = new EventSettingsService(mapper);

        service.replaceEventSettings(null, null);

        verify(mapper).deleteAllCurrentEvents();
        verify(mapper, never()).insertCurrentEvents(org.mockito.ArgumentMatchers.anyList());
        verify(mapper).deleteAllQuickEvents();
        verify(mapper, never()).insertQuickEvents(org.mockito.ArgumentMatchers.anyList());
    }

    @Test
    @DisplayName("도감 데이터에 없는 이벤트명은 저장하지 않는다")
    void rejectsUnknownEventNames() {
        when(mapper.findAvailableEventNames()).thenReturn(List.of("고래 탐사 시즌"));
        EventSettingsService service = new EventSettingsService(mapper);

        assertThatThrownBy(() -> service.replaceEventSettings(List.of("고래 탐사 시즌"), List.of("임의 이벤트")))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("존재하지 않는 이벤트");

        verify(mapper, never()).deleteAllCurrentEvents();
        verify(mapper, never()).insertCurrentEvents(org.mockito.ArgumentMatchers.anyList());
        verify(mapper, never()).deleteAllQuickEvents();
        verify(mapper, never()).insertQuickEvents(org.mockito.ArgumentMatchers.anyList());
    }

    @Test
    @DisplayName("빠른 선택 이벤트 목록을 정규화해 조회한다")
    void returnsNormalizedQuickEvents() {
        when(mapper.findQuickEventNames()).thenReturn(List.of(" 고래 탐사 시즌 ", "", "고래 탐사 시즌"));
        EventSettingsService service = new EventSettingsService(mapper);

        org.assertj.core.api.Assertions.assertThat(service.getQuickEventNames())
                .containsExactly("고래 탐사 시즌");
    }
}
