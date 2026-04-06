package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.LocationZone;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LocationZoneMapper {
    List<LocationZone> findAll();
    LocationZone findByZoneKey(@Param("zoneKey") String zoneKey);
    List<LocationZone> findByZoneKeys(@Param("zoneKeys") List<String> zoneKeys);
    void updatePolygon(@Param("zoneKey") String zoneKey, @Param("polygonPoints") String polygonPoints);
    void updateMapPosition(@Param("zoneKey") String zoneKey, @Param("mapX") Integer mapX, @Param("mapY") Integer mapY);
}
