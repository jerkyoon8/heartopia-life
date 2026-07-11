package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.LocationZone;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LocationZoneMapper {
    List<LocationZone> findAll();
    List<LocationZone> findAllByMapKey(@Param("mapKey") String mapKey);
    LocationZone findByZoneKey(@Param("zoneKey") String zoneKey);
    LocationZone findByZoneKeyAndMapKey(@Param("zoneKey") String zoneKey, @Param("mapKey") String mapKey);
    List<LocationZone> findByZoneKeys(@Param("zoneKeys") List<String> zoneKeys);
    void updatePolygon(@Param("zoneKey") String zoneKey, @Param("mapKey") String mapKey, @Param("polygonPoints") String polygonPoints);
    void updateMapPosition(@Param("zoneKey") String zoneKey, @Param("mapKey") String mapKey, @Param("mapX") Integer mapX, @Param("mapY") Integer mapY);
}
