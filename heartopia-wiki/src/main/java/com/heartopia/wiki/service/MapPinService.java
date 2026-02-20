package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.MapPinMapper;
import com.heartopia.wiki.model.MapPin;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
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

    public void updatePinPosition(Long id, Integer mapX, Integer mapY) {
        mapPinMapper.updatePinPosition(id, mapX, mapY);
    }

    public MapPin addPin(MapPin pin) {
        mapPinMapper.insertPin(pin);
        return pin;
    }

    public void deletePin(Long id) {
        mapPinMapper.deletePin(id);
    }
}
