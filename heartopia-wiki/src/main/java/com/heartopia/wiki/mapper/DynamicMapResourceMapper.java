package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.DynamicMapResource;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DynamicMapResourceMapper {
    List<DynamicMapResource> findAllByMapKey(@Param("mapKey") String mapKey);

    DynamicMapResource findByMapKeyAndName(
            @Param("mapKey") String mapKey,
            @Param("name") String name
    );

    void insert(DynamicMapResource resource);
    DynamicMapResource findById(@Param("id") Long id);
    void update(DynamicMapResource resource);
    void updatePins(@Param("before") DynamicMapResource before, @Param("after") DynamicMapResource after);
    void renameEvent(@Param("mapKey") String mapKey, @Param("oldName") String oldName, @Param("newName") String newName);
}
