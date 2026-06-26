package com.heartopia.wiki.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.heartopia.wiki.mapper.UserMapper;
import com.heartopia.wiki.mapper.UserPetFoodMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class UserPetFoodService {

    private final UserPetFoodMapper mapper;
    private final UserMapper userMapper;
    private final ObjectMapper objectMapper;

    public List<Map<String, Object>> getPetFoodProfiles(Long userId) {
        String petsJson = mapper.findPetsJsonByUserId(userId);
        if (petsJson == null || petsJson.isBlank()) {
            return new ArrayList<>();
        }
        try {
            return objectMapper.readValue(petsJson, new TypeReference<List<Map<String, Object>>>() {});
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    @Transactional
    public List<Map<String, Object>> savePetFoodProfiles(Long userId, List<Map<String, Object>> profiles) {
        List<Map<String, Object>> safeProfiles = profiles != null ? profiles : new ArrayList<>();
        mapper.upsertPetsJson(userId, writeJson(safeProfiles));
        return getPetFoodProfiles(userId);
    }

    @Transactional
    public List<Map<String, Object>> migrate(Long userId, List<Map<String, Object>> localData) {
        if (localData != null && !localData.isEmpty()) {
            mapper.upsertPetsJson(userId, writeJson(mergeProfiles(getPetFoodProfiles(userId), localData)));
        }
        return getPetFoodProfiles(userId);
    }

    @Transactional
    public List<Map<String, Object>> toggleSync(Long userId, boolean enabled, List<Map<String, Object>> localData) {
        if (enabled && localData != null && !localData.isEmpty()) {
            mapper.upsertPetsJson(userId, writeJson(mergeProfiles(getPetFoodProfiles(userId), localData)));
        }
        userMapper.updatePetFoodSyncEnabled(userId, enabled);
        return getPetFoodProfiles(userId);
    }

    @Transactional
    public void deleteAll(Long userId) {
        mapper.deleteByUserId(userId);
    }

    private String writeJson(List<Map<String, Object>> profiles) {
        try {
            return objectMapper.writeValueAsString(profiles);
        } catch (Exception e) {
            throw new IllegalArgumentException("펫 먹이 기록을 저장할 수 없습니다.", e);
        }
    }

    private List<Map<String, Object>> mergeProfiles(List<Map<String, Object>> dbProfiles,
                                                    List<Map<String, Object>> localProfiles) {
        Map<String, Map<String, Object>> merged = new LinkedHashMap<>();
        addProfiles(merged, dbProfiles);
        addProfiles(merged, localProfiles);
        return new ArrayList<>(merged.values());
    }

    private void addProfiles(Map<String, Map<String, Object>> target, List<Map<String, Object>> profiles) {
        if (profiles == null) return;

        for (Map<String, Object> profile : profiles) {
            if (profile == null) continue;
            Object idValue = profile.get("id");
            String id = idValue != null ? idValue.toString() : "";
            if (id.isBlank()) continue;
            target.put(id, profile);
        }
    }
}
