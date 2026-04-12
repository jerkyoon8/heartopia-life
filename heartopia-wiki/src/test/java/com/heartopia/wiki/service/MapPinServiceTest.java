package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.MapPinMapper;
import com.heartopia.wiki.model.MapPin;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * MapPinService 단위 테스트 (Mockito 기반, DB 불필요)
 */
@ExtendWith(MockitoExtension.class)
class MapPinServiceTest {

    @Mock
    private MapPinMapper mapPinMapper;

    @InjectMocks
    private MapPinService mapPinService;

    @Test
    @DisplayName("getAllPins - 전체 핀 리스트 반환")
    void getAllPins_returnsList() {
        MapPin pin1 = new MapPin();
        pin1.setId(1L);
        pin1.setCategory("villager");
        pin1.setName("루나");

        MapPin pin2 = new MapPin();
        pin2.setId(2L);
        pin2.setCategory("fish");
        pin2.setName("민물배스");

        when(mapPinMapper.findAllPins()).thenReturn(Arrays.asList(pin1, pin2));

        List<MapPin> result = mapPinService.getAllPins();
        assertEquals(2, result.size());
        assertEquals("루나", result.get(0).getName());
        verify(mapPinMapper, times(1)).findAllPins();
    }

    @Test
    @DisplayName("getPinsByCategory - 카테고리 필터링")
    void getPinsByCategory_filtersCorrectly() {
        MapPin fishPin = new MapPin();
        fishPin.setCategory("fish");
        fishPin.setName("은어");

        when(mapPinMapper.findPinsByCategory("fish")).thenReturn(List.of(fishPin));

        List<MapPin> result = mapPinService.getPinsByCategory("fish");
        assertEquals(1, result.size());
        assertEquals("fish", result.get(0).getCategory());
    }

    @Test
    @DisplayName("getAllCategories - 카테고리 목록 반환")
    void getAllCategories_returnsList() {
        when(mapPinMapper.findAllCategories())
                .thenReturn(Arrays.asList("villager", "fish", "insect", "bird", "animal", "bus"));

        List<String> categories = mapPinService.getAllCategories();
        assertTrue(categories.contains("villager"));
        assertTrue(categories.contains("fish"));
        assertEquals(6, categories.size());
    }

    @Test
    @DisplayName("addPin - 핀 추가 시 mapper 호출")
    void addPin_callsMapper() {
        MapPin pin = new MapPin();
        pin.setCategory("forageable");
        pin.setName("도토리");
        pin.setMapX(100);
        pin.setMapY(200);

        MapPin result = mapPinService.addPin(pin);
        verify(mapPinMapper, times(1)).insertPin(pin);
        assertEquals("도토리", result.getName());
    }

    @Test
    @DisplayName("deletePin - 삭제 시 mapper 호출")
    void deletePin_callsMapper() {
        mapPinService.deletePin(99L);
        verify(mapPinMapper, times(1)).deletePin(99L);
    }

    @Test
    @DisplayName("updatePinPosition - 좌표 업데이트")
    void updatePinPosition_callsMapper() {
        mapPinService.updatePinPosition(5L, 300, 400);
        verify(mapPinMapper, times(1)).updatePinPosition(5L, 300, 400);
    }
}
