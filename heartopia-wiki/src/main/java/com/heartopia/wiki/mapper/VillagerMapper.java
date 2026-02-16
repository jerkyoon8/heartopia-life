package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.Villager;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface VillagerMapper {
    List<Villager> findAllVillagers();
}
