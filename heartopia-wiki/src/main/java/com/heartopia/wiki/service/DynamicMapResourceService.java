package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.DynamicMapResourceMapper;
import com.heartopia.wiki.model.DynamicMapResource;
import com.heartopia.wiki.mapper.CollectionMapper;
import com.heartopia.wiki.model.ForageableCollection;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DynamicMapResourceService {

    private static final Set<String> SUPPORTED_MAP_KEYS = Set.of("town", "second");
    private final DynamicMapResourceMapper dynamicMapResourceMapper;
    private final CollectionMapper collectionMapper;

    public List<DynamicMapResource> getAllByMapKey(String mapKey) {
        List<DynamicMapResource> resources = dynamicMapResourceMapper.findAllByMapKey(normalizeMapKey(mapKey));
        return resources.stream().filter(resource -> {
            try { resolveForageable(resource); return true; }
            catch (IllegalArgumentException exception) {
                // Hidden/deleted catalog links must not break the entire public map response.
                return false;
            }
        }).toList();
    }

    public DynamicMapResource getByMapKeyAndName(String mapKey, String name) {
        String normalizedName = normalizeRequiredName(name);
        DynamicMapResource resource = dynamicMapResourceMapper.findByMapKeyAndName(
                normalizeMapKey(mapKey), normalizedName
        );
        if (resource == null) {
            throw new IllegalArgumentException("등록되지 않은 변동 자원입니다.");
        }
        return resource;
    }

    public DynamicMapResource getById(Long id) {
        DynamicMapResource resource = dynamicMapResourceMapper.findById(id);
        if (resource == null) throw new IllegalArgumentException("등록되지 않은 지도 항목입니다.");
        resolveForageable(resource);
        return resource;
    }

    private void resolveForageable(DynamicMapResource resource) {
        if (resource.getForageableId() == null) return;
        ForageableCollection linked = collectionMapper.findAllForageables().stream()
                .filter(f -> resource.getForageableId().equals(f.getId()) && Boolean.TRUE.equals(f.getShowOnMap()))
                .findFirst().orElseThrow(() -> new IllegalArgumentException("지도에 표시되는 채집물을 선택해 주세요."));
        if (!"town".equals(resource.getMapKey())) throw new IllegalArgumentException("채집물 연결은 고래섬 지도에서 사용할 수 있습니다.");
        resource.setName(linked.getName());
        resource.setIconUrl(linked.getImageUrl());
    }

    private void normalizeEvent(DynamicMapResource resource) {
        resource.setEventName(normalizeOptional(resource.getEventName()));
        if (resource.getEventName() != null && resource.getEventName().length() > 100)
            throw new IllegalArgumentException("시즌명은 100자 이하여야 합니다.");
        if (resource.getForageableId() != null && resource.getEventName() == null)
            throw new IllegalArgumentException("채집물을 연결할 시즌명을 입력해 주세요.");
    }

    @Transactional
    public DynamicMapResource update(Long id, String name, String eventName, String description) {
        return update(id, name, eventName, description, null);
    }

    @Transactional
    public DynamicMapResource update(Long id, String name, String eventName, String description, String iconUrl) {
        DynamicMapResource before = getById(id);
        DynamicMapResource after = new DynamicMapResource();
        after.setId(id);
        after.setMapKey(before.getMapKey());
        after.setForageableId(before.getForageableId());
        after.setIconUrl(before.getIconUrl());
        if (iconUrl != null && before.getForageableId() == null) {
            if (iconUrl.length() > 500 || !isSafeIconUrl(iconUrl)) throw new IllegalArgumentException("올바른 아이콘 경로를 선택해 주세요.");
            after.setIconUrl(iconUrl);
        }
        after.setName(before.getForageableId() == null ? normalizeRequiredName(name) : before.getName());
        after.setEventName(eventName);
        after.setDescription(normalizeOptional(description));
        normalizeEvent(after);
        DynamicMapResource conflict = dynamicMapResourceMapper.findByMapKeyAndName(after.getMapKey(), after.getName());
        if (conflict != null && !id.equals(conflict.getId())) throw duplicateResourceException();
        try {
            dynamicMapResourceMapper.update(after);
            if (after.getForageableId() == null) dynamicMapResourceMapper.updatePins(before, after);
        } catch (DuplicateKeyException exception) { throw duplicateResourceException(); }
        return after;
    }

    @Transactional
    public void renameEvent(String mapKey, String oldName, String newName) {
        String oldEvent = normalizeRequiredName(oldName);
        String newEvent = normalizeRequiredName(newName);
        dynamicMapResourceMapper.renameEvent(normalizeMapKey(mapKey), oldEvent, newEvent);
    }

    @Transactional
    public DynamicMapResource create(DynamicMapResource resource) {
        String mapKey = normalizeMapKey(resource.getMapKey());
        String name = normalizeRequiredName(resource.getName());
        resource.setMapKey(mapKey);
        resource.setName(name);
        resource.setIconUrl(normalizeOptional(resource.getIconUrl()));
        resource.setDescription(normalizeOptional(resource.getDescription()));
        normalizeEvent(resource);
        resolveForageable(resource);
        name = resource.getName();

        if (resource.getIconUrl() != null && resource.getIconUrl().length() > 500) {
            throw new IllegalArgumentException("아이콘 URL은 500자 이하여야 합니다.");
        }
        if (resource.getIconUrl() != null && !isSafeIconUrl(resource.getIconUrl())) {
            throw new IllegalArgumentException("아이콘 URL은 /로 시작하는 경로 또는 http(s) 주소만 사용할 수 있습니다.");
        }
        if (dynamicMapResourceMapper.findByMapKeyAndName(mapKey, name) != null) {
            throw duplicateResourceException();
        }

        try {
            dynamicMapResourceMapper.insert(resource);
        } catch (DuplicateKeyException exception) {
            throw duplicateResourceException();
        }
        return resource;
    }

    private String normalizeMapKey(String mapKey) {
        String normalized = normalizeOptional(mapKey);
        if (normalized == null) {
            normalized = "town";
        }
        if (!SUPPORTED_MAP_KEYS.contains(normalized)) {
            throw new IllegalArgumentException("지원하지 않는 지도입니다.");
        }
        return normalized;
    }

    private String normalizeRequiredName(String name) {
        String normalized = normalizeOptional(name);
        if (normalized == null) {
            throw new IllegalArgumentException("변동 자원 이름을 입력해 주세요.");
        }
        if (normalized.length() > 100) {
            throw new IllegalArgumentException("변동 자원 이름은 100자 이하여야 합니다.");
        }
        return normalized;
    }

    private String normalizeOptional(String value) {
        if (value == null) {
            return null;
        }
        String normalized = value.trim();
        return normalized.isEmpty() ? null : normalized;
    }

    private IllegalArgumentException duplicateResourceException() {
        return new IllegalArgumentException("현재 지도에 같은 이름의 변동 자원이 이미 있습니다.");
    }

    private boolean isSafeIconUrl(String iconUrl) {
        if (iconUrl.startsWith("/") && !iconUrl.startsWith("//")) {
            return true;
        }
        try {
            URI uri = new URI(iconUrl);
            return ("http".equalsIgnoreCase(uri.getScheme()) || "https".equalsIgnoreCase(uri.getScheme()))
                    && uri.getHost() != null;
        } catch (URISyntaxException exception) {
            return false;
        }
    }
}
