package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.DynamicMapResourceMapper;
import com.heartopia.wiki.model.DynamicMapResource;
import com.heartopia.wiki.model.ForageableCollection;
import com.heartopia.wiki.mapper.CollectionMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class DynamicMapResourceServiceTest {

    @Mock
    private DynamicMapResourceMapper dynamicMapResourceMapper;
    @Mock private CollectionMapper collectionMapper;

    @InjectMocks
    private DynamicMapResourceService dynamicMapResourceService;

    @Test
    @DisplayName("변동 자원 생성 시 입력값을 정리하고 저장한다")
    void createNormalizesAndStoresResource() {
        DynamicMapResource resource = new DynamicMapResource();
        resource.setMapKey(" town ");
        resource.setName("  유성 조각  ");
        resource.setIconUrl("  ");
        resource.setDescription("  밤에 나타나는 자원  ");

        when(dynamicMapResourceMapper.findByMapKeyAndName("town", "유성 조각")).thenReturn(null);

        DynamicMapResource saved = dynamicMapResourceService.create(resource);

        assertEquals("town", saved.getMapKey());
        assertEquals("유성 조각", saved.getName());
        assertNull(saved.getIconUrl());
        assertEquals("밤에 나타나는 자원", saved.getDescription());
        verify(dynamicMapResourceMapper).insert(resource);
    }

    @Test
    @DisplayName("같은 지도에 같은 이름의 변동 자원을 중복 생성할 수 없다")
    void createRejectsDuplicateNameInSameMap() {
        DynamicMapResource resource = resource("town", "유성 조각");
        when(dynamicMapResourceMapper.findByMapKeyAndName("town", "유성 조각"))
                .thenReturn(resource("town", "유성 조각"));

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> dynamicMapResourceService.create(resource)
        );

        assertEquals("현재 지도에 같은 이름의 변동 자원이 이미 있습니다.", exception.getMessage());
        verify(dynamicMapResourceMapper, never()).insert(resource);
    }

    @Test
    @DisplayName("지원하지 않는 지도에는 변동 자원을 생성할 수 없다")
    void createRejectsUnknownMap() {
        DynamicMapResource resource = resource("unknown", "유성 조각");

        assertThrows(IllegalArgumentException.class, () -> dynamicMapResourceService.create(resource));
        verify(dynamicMapResourceMapper, never()).insert(resource);
    }

    @Test
    @DisplayName("실행 가능한 스킴의 아이콘 URL은 저장하지 않는다")
    void createRejectsUnsafeIconUrl() {
        DynamicMapResource resource = resource("town", "유성 조각");
        resource.setIconUrl("javascript:alert(1)");

        assertThrows(IllegalArgumentException.class, () -> dynamicMapResourceService.create(resource));
        verify(dynamicMapResourceMapper, never()).insert(resource);
    }

    @Test
    @DisplayName("지도별 변동 자원 목록을 반환한다")
    void getAllByMapKeyReturnsResourcesForNormalizedMap() {
        when(dynamicMapResourceMapper.findAllByMapKey("second"))
                .thenReturn(List.of(resource("second", "협곡 수정")));

        List<DynamicMapResource> result = dynamicMapResourceService.getAllByMapKey(" second ");

        assertEquals(1, result.size());
        assertEquals("협곡 수정", result.get(0).getName());
    }

    @Test
    void linkedMushroomUsesCatalogIdentityWithoutCopyingPins() {
        ForageableCollection mushroom = new ForageableCollection();
        mushroom.setId(44); mushroom.setName("뽕나무버섯"); mushroom.setShowOnMap(true);
        mushroom.setImageUrl("/uploads/mushroom.webp");
        when(collectionMapper.findAllForageables()).thenReturn(List.of(mushroom));
        DynamicMapResource entry = resource("town", "임의 이름");
        entry.setForageableId(44); entry.setEventName(" 밤의 점술회 ");
        DynamicMapResource saved = dynamicMapResourceService.create(entry);
        assertEquals("뽕나무버섯", saved.getName());
        assertEquals("밤의 점술회", saved.getEventName());
        assertEquals("/uploads/mushroom.webp", saved.getIconUrl());
        verify(dynamicMapResourceMapper).insert(saved);
        verify(dynamicMapResourceMapper, never()).updatePins(org.mockito.ArgumentMatchers.any(), org.mockito.ArgumentMatchers.any());
    }

    @Test
    void invalidLinkedForageableIsRejected() {
        when(collectionMapper.findAllForageables()).thenReturn(List.of());
        DynamicMapResource entry = resource("town", "없음");
        entry.setForageableId(999); entry.setEventName("다음 시즌");
        assertThrows(IllegalArgumentException.class, () -> dynamicMapResourceService.create(entry));
        verify(dynamicMapResourceMapper, never()).insert(entry);
    }

    @Test
    void hiddenCatalogLinkDoesNotBreakOtherMapResources() {
        DynamicMapResource hidden = resource("town", "숨겨진 채집물"); hidden.setForageableId(99);
        DynamicMapResource tree = resource("town", "속이 빈 나무");
        when(dynamicMapResourceMapper.findAllByMapKey("town")).thenReturn(List.of(hidden,tree));
        when(collectionMapper.findAllForageables()).thenReturn(List.of());
        assertEquals(List.of(tree),dynamicMapResourceService.getAllByMapKey("town"));
    }

    @Test
    void editingTreeUpdatesItsPinsWithoutChangingCoordinates() {
        DynamicMapResource before = resource("town", "속이 빈 나무"); before.setId(1L);
        when(dynamicMapResourceMapper.findById(1L)).thenReturn(before);
        DynamicMapResource after = dynamicMapResourceService.update(1L,"수정된 나무","다음 시즌","수정 설명");
        assertEquals("다음 시즌", after.getEventName());
        assertEquals("수정된 나무", after.getName());
        verify(dynamicMapResourceMapper).update(after);
        verify(dynamicMapResourceMapper).updatePins(before,after);
    }

    @Test
    void renameSeasonUpdatesAllMatchingItemsInSelectedMap() {
        dynamicMapResourceService.renameEvent(" town ","밤의 점술회","다음 시즌");
        verify(dynamicMapResourceMapper).renameEvent("town","밤의 점술회","다음 시즌");
        assertThrows(IllegalArgumentException.class, () -> dynamicMapResourceService.renameEvent("town","밤의 점술회"," "));
    }

    @Test
    void editingLinkedEntryCannotRenameCatalogOrModifySharedPins() {
        ForageableCollection mushroom = new ForageableCollection();
        mushroom.setId(44); mushroom.setName("뽕나무버섯"); mushroom.setShowOnMap(true);
        when(collectionMapper.findAllForageables()).thenReturn(List.of(mushroom));
        DynamicMapResource before = resource("town","뽕나무버섯"); before.setId(2L); before.setForageableId(44);
        when(dynamicMapResourceMapper.findById(2L)).thenReturn(before);
        DynamicMapResource after = dynamicMapResourceService.update(2L,"임의 이름","다음 시즌","설명");
        assertEquals("뽕나무버섯",after.getName());
        verify(dynamicMapResourceMapper, never()).updatePins(org.mockito.ArgumentMatchers.any(),org.mockito.ArgumentMatchers.any());
    }

    private DynamicMapResource resource(String mapKey, String name) {
        DynamicMapResource resource = new DynamicMapResource();
        resource.setMapKey(mapKey);
        resource.setName(name);
        return resource;
    }
}
