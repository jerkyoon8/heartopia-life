package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.UserChecklistMapper;
import com.heartopia.wiki.mapper.UserMapper;
import com.heartopia.wiki.model.SeaCleaningCollection;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserChecklistServiceTest {

    @Mock
    private UserChecklistMapper mapper;

    @Mock
    private UserMapper userMapper;

    @Mock
    private CollectionService collectionService;

    private UserChecklistService service;

    @BeforeEach
    void setUp() {
        service = new UserChecklistService(mapper, userMapper, collectionService);
    }

    @Test
    void migrateNormalizesLegacySeaCleaningKeysAndKeepsHighestRating() {
        when(collectionService.getAllSeaCleaningCollections()).thenReturn(List.of(seaCleaning(17, "오래된 조개")));
        when(mapper.findByUserId(1L)).thenReturn(List.of());
        Map<String, Integer> localData = new LinkedHashMap<>();
        localData.put("sea_cleaning_오래된 조개", 5);
        localData.put("sea_cleaning_id_17", 2);
        localData.put("mastery_sea_cleaning_오래된 조개", 1);
        localData.put("fish_배스", 3);

        service.migrate(1L, localData);

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<Map<String, Object>>> items = ArgumentCaptor.forClass(List.class);
        verify(mapper).bulkUpsert(eq(1L), items.capture());
        assertThat(items.getValue()).containsExactlyInAnyOrder(
                item("sea_cleaning_id_17", 5),
                item("mastery_sea_cleaning_id_17", 1),
                item("fish_배스", 3));
    }

    @Test
    void getChecklistNormalizesLegacyRowsReturnedFromDatabase() {
        when(collectionService.getAllSeaCleaningCollections()).thenReturn(List.of(seaCleaning(17, "오래된 조개")));
        when(mapper.findByUserId(1L)).thenReturn(List.of(
                row("sea_cleaning_오래된 조개", 4),
                row("sea_cleaning_id_17", 2),
                row("bug_나비", 1)));

        assertThat(service.getChecklist(1L)).containsExactlyInAnyOrderEntriesOf(Map.of(
                "sea_cleaning_id_17", 4,
                "bug_나비", 1));
    }

    @Test
    void singleWritesAndDeletesNormalizeOnlyLegacySeaCleaningKeys() {
        when(collectionService.getAllSeaCleaningCollections()).thenReturn(List.of(seaCleaning(17, "오래된 조개")));

        service.upsertItem(1L, "sea_cleaning_오래된 조개", 3);
        service.deleteItem(1L, "mastery_sea_cleaning_오래된 조개");

        verify(mapper).upsertItem(1L, "sea_cleaning_id_17", 3);
        verify(mapper).deleteItem(1L, "mastery_sea_cleaning_id_17");
    }

    @Test
    void currentAndOtherCollectionKeysDoNotLoadLegacyMappings() {
        service.upsertItem(1L, "sea_cleaning_id_17", 3);
        service.deleteItem(1L, "fish_배스");

        verify(mapper).upsertItem(1L, "sea_cleaning_id_17", 3);
        verify(mapper).deleteItem(1L, "fish_배스");
        verify(collectionService, never()).getAllSeaCleaningCollections();
    }

    @Test
    void batchSyncNormalizesLegacyUpsertsAndDeletesWithOneMapping() {
        when(collectionService.getAllSeaCleaningCollections()).thenReturn(List.of(seaCleaning(17, "오래된 조개")));
        Map<String, Integer> upserts = new LinkedHashMap<>();
        upserts.put("sea_cleaning_오래된 조개", 5);
        upserts.put("sea_cleaning_id_17", 2);

        service.batchSync(1L, upserts, List.of("mastery_sea_cleaning_오래된 조개"));

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<Map<String, Object>>> items = ArgumentCaptor.forClass(List.class);
        verify(mapper).bulkUpsert(eq(1L), items.capture());
        assertThat(items.getValue()).containsExactly(item("sea_cleaning_id_17", 5));
        verify(mapper).batchDelete(1L, List.of("mastery_sea_cleaning_id_17"));
    }

    @Test
    void toggleSyncNormalizesLegacyLocalDataBeforeUpload() {
        when(collectionService.getAllSeaCleaningCollections()).thenReturn(List.of(seaCleaning(17, "오래된 조개")));
        when(mapper.findByUserId(1L)).thenReturn(List.of());

        service.toggleSync(1L, true, Map.of("sea_cleaning_오래된 조개", 4));

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<Map<String, Object>>> items = ArgumentCaptor.forClass(List.class);
        verify(mapper).bulkUpsert(eq(1L), items.capture());
        assertThat(items.getValue()).containsExactly(item("sea_cleaning_id_17", 4));
        verify(userMapper).updateChecklistSyncEnabled(1L, true);
    }

    private SeaCleaningCollection seaCleaning(int id, String legacyName) {
        SeaCleaningCollection item = new SeaCleaningCollection();
        item.setId(id);
        item.setLegacyChecklistName(legacyName);
        return item;
    }

    private Map<String, Object> row(String key, int rating) {
        return Map.of("itemKey", key, "starRating", rating);
    }

    private Map<String, Object> item(String key, int rating) {
        Map<String, Object> item = new LinkedHashMap<>();
        item.put("itemKey", key);
        item.put("starRating", rating);
        return item;
    }
}
