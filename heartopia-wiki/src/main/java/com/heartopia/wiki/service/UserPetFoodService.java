package com.heartopia.wiki.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.heartopia.wiki.exception.PetFoodValidationException;
import com.heartopia.wiki.mapper.UserMapper;
import com.heartopia.wiki.mapper.UserPetFoodMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class UserPetFoodService {

    private static final int MAX_PROFILES = 20;
    private static final int MAX_NAME_LENGTH = 80;
    private static final int MAX_ID_LENGTH = 120;
    private static final int MAX_CUSTOM_FOODS = 100;
    private static final int MAX_HIDDEN_FOODS = 200;
    private static final int MAX_FOOD_STATES = 300;
    private static final Set<String> PROFILE_FIELDS = Set.of(
            "id", "name", "type", "preferences", "tried", "customFoods", "hiddenFoodIds"
    );
    private static final Set<String> CUSTOM_FOOD_FIELDS = Set.of("id", "name");
    private static final Set<String> PET_TYPES = Set.of("dog", "cat");
    private static final Set<String> PREFERENCES = Set.of("neutral", "like", "dislike");

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
        validateProfiles(safeProfiles);
        mapper.upsertPetsJson(userId, writeJson(safeProfiles));
        return getPetFoodProfiles(userId);
    }

    @Transactional
    public List<Map<String, Object>> migrate(Long userId, List<Map<String, Object>> localData) {
        if (localData != null && !localData.isEmpty()) {
            List<Map<String, Object>> mergedProfiles = mergeProfiles(getPetFoodProfiles(userId), localData);
            validateProfiles(mergedProfiles);
            mapper.upsertPetsJson(userId, writeJson(mergedProfiles));
        }
        return getPetFoodProfiles(userId);
    }

    @Transactional
    public List<Map<String, Object>> toggleSync(Long userId, boolean enabled, List<Map<String, Object>> localData) {
        if (enabled && localData != null && !localData.isEmpty()) {
            List<Map<String, Object>> mergedProfiles = mergeProfiles(getPetFoodProfiles(userId), localData);
            validateProfiles(mergedProfiles);
            mapper.upsertPetsJson(userId, writeJson(mergedProfiles));
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

    private void validateProfiles(List<Map<String, Object>> profiles) {
        if (profiles.size() > MAX_PROFILES) {
            throw validationError("반려동물은 최대 " + MAX_PROFILES + "마리까지 저장할 수 있습니다.");
        }

        Set<String> petIds = new HashSet<>();
        for (int index = 0; index < profiles.size(); index++) {
            Map<String, Object> profile = profiles.get(index);
            if (profile == null) {
                throw validationError("반려동물 프로필 " + (index + 1) + "번의 구조가 올바르지 않습니다.");
            }
            validateAllowedFields(profile, PROFILE_FIELDS, "반려동물 프로필");

            String petId = requireText(profile.get("id"), "반려동물 ID", MAX_ID_LENGTH);
            requireText(profile.get("name"), "반려동물 이름", MAX_NAME_LENGTH);
            String type = requireText(profile.get("type"), "반려동물 종류", 10);
            if (!PET_TYPES.contains(type)) {
                throw validationError("반려동물 종류는 dog 또는 cat이어야 합니다.");
            }
            if (!petIds.add(petId)) {
                throw validationError("중복된 반려동물 ID가 있습니다.");
            }

            validatePreferences(profile.get("preferences"));
            validateTried(profile.get("tried"));
            validateCustomFoods(profile.get("customFoods"));
            validateHiddenFoodIds(profile.get("hiddenFoodIds"));
        }
    }

    private void validatePreferences(Object value) {
        if (value == null) return;
        Map<?, ?> preferences = requireMap(value, "먹이 선호도");
        if (preferences.size() > MAX_FOOD_STATES) {
            throw validationError("먹이 선호도는 반려동물당 최대 " + MAX_FOOD_STATES + "개까지 저장할 수 있습니다.");
        }
        for (Map.Entry<?, ?> entry : preferences.entrySet()) {
            requireText(entry.getKey(), "먹이 선호도 ID", MAX_ID_LENGTH);
            if (!(entry.getValue() instanceof String preference) || !PREFERENCES.contains(preference)) {
                throw validationError("먹이 선호도 값은 neutral, like, dislike 중 하나여야 합니다.");
            }
        }
    }

    private void validateTried(Object value) {
        if (value == null) return;
        Map<?, ?> tried = requireMap(value, "먹여봄 기록");
        if (tried.size() > MAX_FOOD_STATES) {
            throw validationError("먹여봄 기록은 반려동물당 최대 " + MAX_FOOD_STATES + "개까지 저장할 수 있습니다.");
        }
        for (Map.Entry<?, ?> entry : tried.entrySet()) {
            requireText(entry.getKey(), "먹여봄 기록 ID", MAX_ID_LENGTH);
            if (!(entry.getValue() instanceof Boolean)) {
                throw validationError("먹여봄 기록 값은 true 또는 false여야 합니다.");
            }
        }
    }

    private void validateCustomFoods(Object value) {
        if (value == null) return;
        List<?> customFoods = requireList(value, "사용자 정의 먹이");
        if (customFoods.size() > MAX_CUSTOM_FOODS) {
            throw validationError("사용자 정의 먹이는 반려동물당 최대 " + MAX_CUSTOM_FOODS + "개까지 저장할 수 있습니다.");
        }

        Set<String> ids = new HashSet<>();
        Set<String> names = new HashSet<>();
        for (Object item : customFoods) {
            Map<?, ?> food = requireMap(item, "사용자 정의 먹이");
            validateAllowedFields(food, CUSTOM_FOOD_FIELDS, "사용자 정의 먹이");
            String id = requireText(food.get("id"), "사용자 정의 먹이 ID", MAX_ID_LENGTH);
            String name = requireText(food.get("name"), "사용자 정의 먹이 이름", MAX_NAME_LENGTH);
            if (!ids.add(id)) {
                throw validationError("중복된 사용자 정의 먹이 ID가 있습니다.");
            }
            if (!names.add(normalizeName(name))) {
                throw validationError("중복된 사용자 정의 먹이 이름이 있습니다.");
            }
        }
    }

    private void validateHiddenFoodIds(Object value) {
        if (value == null) return;
        List<?> hiddenFoodIds = requireList(value, "숨김 먹이");
        if (hiddenFoodIds.size() > MAX_HIDDEN_FOODS) {
            throw validationError("숨김 먹이는 반려동물당 최대 " + MAX_HIDDEN_FOODS + "개까지 저장할 수 있습니다.");
        }

        Set<String> ids = new HashSet<>();
        for (Object idValue : hiddenFoodIds) {
            String id = requireText(idValue, "숨김 먹이 ID", MAX_ID_LENGTH);
            if (!ids.add(id)) {
                throw validationError("중복된 숨김 먹이 ID가 있습니다.");
            }
        }
    }

    private Map<?, ?> requireMap(Object value, String fieldName) {
        if (!(value instanceof Map<?, ?> map)) {
            throw validationError(fieldName + " 구조가 올바르지 않습니다.");
        }
        return map;
    }

    private List<?> requireList(Object value, String fieldName) {
        if (!(value instanceof List<?> list)) {
            throw validationError(fieldName + " 구조가 올바르지 않습니다.");
        }
        return list;
    }

    private String requireText(Object value, String fieldName, int maxLength) {
        if (!(value instanceof String text)) {
            throw validationError(fieldName + "은 문자열이어야 합니다.");
        }
        String trimmed = text.trim();
        if (trimmed.isEmpty()) {
            throw validationError(fieldName + "은 비어 있을 수 없습니다.");
        }
        if (trimmed.codePointCount(0, trimmed.length()) > maxLength) {
            throw validationError(fieldName + "은 " + maxLength + "자 이하여야 합니다.");
        }
        return trimmed;
    }

    private void validateAllowedFields(Map<?, ?> value, Set<String> allowedFields, String fieldName) {
        for (Object key : value.keySet()) {
            if (!(key instanceof String textKey) || !allowedFields.contains(textKey)) {
                throw validationError(fieldName + "에 허용되지 않은 필드가 있습니다.");
            }
        }
    }

    private String normalizeName(String value) {
        return value.replaceAll("\\s+", "").toLowerCase(Locale.ROOT);
    }

    private PetFoodValidationException validationError(String message) {
        return new PetFoodValidationException(message);
    }
}
