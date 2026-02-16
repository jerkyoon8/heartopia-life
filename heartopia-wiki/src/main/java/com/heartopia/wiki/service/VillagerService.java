package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.VillagerMapper;
import com.heartopia.wiki.model.Villager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class VillagerService {
    private final VillagerMapper villagerMapper;

    public List<Villager> getAllVillagers() {
        return villagerMapper.findAllVillagers();
    }
}
