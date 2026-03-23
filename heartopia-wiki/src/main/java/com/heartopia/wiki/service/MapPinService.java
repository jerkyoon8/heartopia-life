package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.MapPinMapper;
import com.heartopia.wiki.model.MapPin;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MapPinService {

    private final MapPinMapper mapPinMapper;

    public List<MapPin> getAllPins() {
        return mapPinMapper.findAllPins();
    }

    public List<MapPin> getPinsByCategory(String category) {
        return mapPinMapper.findPinsByCategory(category);
    }

    public MapPin getPinByCategoryAndName(String category, String name) {
        return mapPinMapper.findPinByCategoryAndName(category, name);
    }

    public List<String> getAllCategories() {
        return mapPinMapper.findAllCategories();
    }

    @Transactional
    public void updatePinPosition(Long id, Integer mapX, Integer mapY) {
        log.info("맵 핀 위치 수정됨 - ID: {}, 새로운 좌표: ({}, {})", id, mapX, mapY);
        mapPinMapper.updatePinPosition(id, mapX, mapY);
    }

    @Transactional
    public MapPin addPin(MapPin pin) {
        mapPinMapper.insertPin(pin);
        log.info("새로운 맵 핀 다수/단일 추가됨 - 카테고리: {}, 이름: {}, 좌표: ({}, {})", pin.getCategory(), pin.getName(), pin.getMapX(), pin.getMapY());
        return pin;
    }

    @Transactional
    public void deletePin(Long id) {
        log.warn("맵 핀 삭제됨 - ID: {}", id);
        mapPinMapper.deletePin(id);
    }
}
