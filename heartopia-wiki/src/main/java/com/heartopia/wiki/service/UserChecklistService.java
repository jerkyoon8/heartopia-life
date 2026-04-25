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

    public Map<String, Integer> getChecklist(Long userId) {
        return mapper.findByUserId(userId).stream().collect(
                Collectors.toMap(
                        r -> (String) r.get("itemKey"),
                        r -> ((Number) r.get("starRating")).intValue()
                )
        );
    }

    @Transactional
    public void upsertItem(Long userId, String itemKey, int starRating) {
        mapper.upsertItem(userId, itemKey, starRating);
    }

    @Transactional
    public void deleteItem(Long userId, String itemKey) {
        mapper.deleteItem(userId, itemKey);
    }

    @Transactional
    public Map<String, Integer> migrate(Long userId, Map<String, Integer> localData) {
        if (localData != null && !localData.isEmpty()) {
            List<Map<String, Object>> items = localData.entrySet().stream()
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
        if (upserts != null && !upserts.isEmpty()) {
            List<Map<String, Object>> items = upserts.entrySet().stream()
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
            mapper.batchDelete(userId, deletes);
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
            List<Map<String, Object>> items = localData.entrySet().stream()
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
}
