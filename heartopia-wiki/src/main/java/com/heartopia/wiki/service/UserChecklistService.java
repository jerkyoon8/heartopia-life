package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.UserChecklistMapper;
import com.heartopia.wiki.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserChecklistService {

    private final UserChecklistMapper mapper;
    private final UserMapper userMapper;
    private final CollectionService collectionService;

    public Map<String, Integer> getChecklist(Long userId) {
        Map<String, Integer> checklist = new LinkedHashMap<>();
        mapper.findByUserId(userId).forEach(row -> checklist.put(
                (String) row.get("itemKey"),
                ((Number) row.get("starRating")).intValue()));
        return normalizeChecklistData(checklist, aliasesFor(checklist.keySet()));
    }

    @Transactional
    public void upsertItem(Long userId, String itemKey, int starRating) {
        mapper.upsertItem(userId, normalizeChecklistKey(itemKey, aliasesFor(List.of(itemKey))), starRating);
    }

    @Transactional
    public void deleteItem(Long userId, String itemKey) {
        mapper.deleteItem(userId, normalizeChecklistKey(itemKey, aliasesFor(List.of(itemKey))));
    }

    @Transactional
    public Map<String, Integer> migrate(Long userId, Map<String, Integer> localData) {
        if (localData != null && !localData.isEmpty()) {
            Map<String, Integer> normalized = normalizeChecklistData(localData, aliasesFor(localData.keySet()));
            List<Map<String, Object>> items = normalized.entrySet().stream()
                    .map(e -> {
                        Map<String, Object> m = new HashMap<>();
                        m.put("itemKey", e.getKey());
                        m.put("starRating", e.getValue());
                        return m;
                    })
                    .collect(Collectors.toList());
            mapper.bulkUpsert(userId, items);
        }
        return getChecklist(userId);
    }

    @Transactional
    public void batchSync(Long userId, Map<String, Integer> upserts, List<String> deletes) {
        List<String> candidateKeys = new ArrayList<>();
        if (upserts != null) candidateKeys.addAll(upserts.keySet());
        if (deletes != null) candidateKeys.addAll(deletes);
        Map<String, String> aliases = aliasesFor(candidateKeys);

        if (upserts != null && !upserts.isEmpty()) {
            Map<String, Integer> normalized = normalizeChecklistData(upserts, aliases);
            List<Map<String, Object>> items = normalized.entrySet().stream()
                    .map(e -> {
                        Map<String, Object> m = new HashMap<>();
                        m.put("itemKey", e.getKey());
                        m.put("starRating", e.getValue());
                        return m;
                    })
                    .collect(Collectors.toList());
            mapper.bulkUpsert(userId, items);
        }
        if (deletes != null && !deletes.isEmpty()) {
            List<String> normalizedDeletes = deletes.stream()
                    .map(key -> normalizeChecklistKey(key, aliases))
                    .distinct()
                    .toList();
            mapper.batchDelete(userId, normalizedDeletes);
        }
    }

    @Transactional
    public void deleteAll(Long userId) {
        mapper.deleteAll(userId);
    }

    /**
     * 체크리스트 DB 동기화 토글.
     * - enabled=true + localData 있으면 localData를 DB로 업로드(1회 마이그레이션)
     * - enabled=false면 플래그만 끔(DB 데이터는 유지되어 다시 켜면 복구 가능)
     * 응답: 토글 후 DB 상태(프론트가 메모리/localStorage 갱신용으로 사용)
     */
    @Transactional
    public Map<String, Integer> toggleSync(Long userId, boolean enabled, Map<String, Integer> localData) {
        if (enabled && localData != null && !localData.isEmpty()) {
            Map<String, Integer> normalized = normalizeChecklistData(localData, aliasesFor(localData.keySet()));
            List<Map<String, Object>> items = normalized.entrySet().stream()
                    .map(e -> {
                        Map<String, Object> m = new HashMap<>();
                        m.put("itemKey", e.getKey());
                        m.put("starRating", e.getValue());
                        return m;
                    })
                    .collect(Collectors.toList());
            mapper.bulkUpsert(userId, items);
        }
        userMapper.updateChecklistSyncEnabled(userId, enabled);
        return getChecklist(userId);
    }

    private Map<String, Integer> normalizeChecklistData(Map<String, Integer> source,
                                                         Map<String, String> aliases) {
        Map<String, Integer> normalized = new LinkedHashMap<>();
        source.forEach((key, value) -> {
            if (key == null || value == null) return;
            String normalizedKey = normalizeChecklistKey(key, aliases);
            normalized.merge(normalizedKey, value, Math::max);
        });
        return normalized;
    }

    private String normalizeChecklistKey(String key, Map<String, String> aliases) {
        if (key == null) return null;
        if (key.startsWith("mastery_sea_cleaning_")
                && !key.startsWith("mastery_sea_cleaning_id_")) {
            String baseKey = key.substring("mastery_".length());
            String normalizedBase = aliases.get(baseKey);
            return normalizedBase == null ? key : "mastery_" + normalizedBase;
        }
        return aliases.getOrDefault(key, key);
    }

    private Map<String, String> aliasesFor(Collection<String> keys) {
        if (keys == null || keys.stream().noneMatch(this::isLegacySeaCleaningKey)) {
            return Map.of();
        }

        Map<String, String> aliases = new HashMap<>();
        for (var item : collectionService.getAllSeaCleaningCollections()) {
            if (item.getId() == null || item.getLegacyChecklistName() == null
                    || item.getLegacyChecklistName().isBlank()) {
                continue;
            }
            aliases.put(
                    "sea_cleaning_" + item.getLegacyChecklistName(),
                    "sea_cleaning_id_" + item.getId());
        }
        return aliases;
    }

    private boolean isLegacySeaCleaningKey(String key) {
        if (key == null) return false;
        return (key.startsWith("sea_cleaning_") && !key.startsWith("sea_cleaning_id_"))
                || (key.startsWith("mastery_sea_cleaning_")
                    && !key.startsWith("mastery_sea_cleaning_id_"));
    }
}
