package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.MapPin;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MapPinMapper {
    List<MapPin> findAllPins();

    List<MapPin> findPinsByCategory(@Param("category") String category);

    MapPin findPinByCategoryAndName(@Param("category") String category, @Param("name") String name);

    List<String> findAllCategories();

    void updatePinPosition(@Param("id") Long id, @Param("mapX") Integer mapX, @Param("mapY") Integer mapY);

    void insertPin(MapPin pin);

    void deletePin(Long id);
}
