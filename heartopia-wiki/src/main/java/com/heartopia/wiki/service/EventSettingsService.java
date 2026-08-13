package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.EventSettingsMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class EventSettingsService {

    private final EventSettingsMapper mapper;

    @Transactional(readOnly = true)
    public List<String> getAvailableEventNames() {
        return normalize(mapper.findAvailableEventNames()).stream().toList();
    }

    @Transactional(readOnly = true)
    public List<String> getCurrentEventNames() {
        return normalize(mapper.findCurrentEventNames()).stream().toList();
    }

    @Transactional(readOnly = true)
    public List<String> getQuickEventNames() {
        return normalize(mapper.findQuickEventNames()).stream().toList();
    }

    @Transactional
    public void replaceEventSettings(
            List<String> submittedCurrentEventNames,
            List<String> submittedQuickEventNames) {
        Set<String> available = normalize(mapper.findAvailableEventNames());
        Set<String> current = normalize(submittedCurrentEventNames);
        Set<String> quick = normalize(submittedQuickEventNames);
        Set<String> unknown = new LinkedHashSet<>(current);
        unknown.addAll(quick);
        unknown.removeAll(available);
        if (!unknown.isEmpty()) {
            throw new IllegalArgumentException("도감 데이터에 존재하지 않는 이벤트입니다: " + String.join(", ", unknown));
        }

        mapper.deleteAllCurrentEvents();
        if (!current.isEmpty()) {
            mapper.insertCurrentEvents(current.stream().toList());
        }
        mapper.deleteAllQuickEvents();
        if (!quick.isEmpty()) {
            mapper.insertQuickEvents(quick.stream().toList());
        }
    }

    private LinkedHashSet<String> normalize(Collection<String> eventNames) {
        LinkedHashSet<String> normalized = new LinkedHashSet<>();
        if (eventNames == null) {
            return normalized;
        }
        for (String eventName : eventNames) {
            if (eventName == null) {
                continue;
            }
            String trimmed = eventName.trim();
            if (!trimmed.isEmpty()) {
                normalized.add(trimmed);
            }
        }
        return normalized;
    }
}
