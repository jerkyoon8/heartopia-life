package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.CollectionMapper;
import com.heartopia.wiki.model.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * CollectionService 단위 테스트 (Mockito 기반, DB 불필요)
 */
@ExtendWith(MockitoExtension.class)
class CollectionServiceTest {

    @Mock
    private CollectionMapper collectionMapper;

    @InjectMocks
    private CollectionService collectionService;

    // ==================== 전체 조회 ====================

    @Test
    @DisplayName("getAllFish - 물고기 전체 목록 반환")
    void getAllFish_returnsList() {
        FishCollection fish1 = new FishCollection();
        fish1.setName("민물배스");
        fish1.setLocation("강");

        FishCollection fish2 = new FishCollection();
        fish2.setName("꽃연어");
        fish2.setLocation("강");

        when(collectionMapper.findAllFish()).thenReturn(Arrays.asList(fish1, fish2));

        List<FishCollection> result = collectionService.getAllFish();
        assertEquals(2, result.size());
        verify(collectionMapper, times(1)).findAllFish();
    }

    @Test
    @DisplayName("getAllBirds - 새 전체 목록 반환")
    void getAllBirds_returnsList() {
        BirdCollection bird = new BirdCollection();
        bird.setName("참새");

        when(collectionMapper.findAllBirds()).thenReturn(List.of(bird));

        List<BirdCollection> result = collectionService.getAllBirds();
        assertEquals(1, result.size());
        assertEquals("참새", result.get(0).getName());
    }

    @Test
    @DisplayName("getAllBugs - 곤충 전체 목록 반환")
    void getAllBugs_returnsList() {
        BugCollection bug = new BugCollection();
        bug.setName("무당벌레");

        when(collectionMapper.findAllBugs()).thenReturn(List.of(bug));

        List<BugCollection> result = collectionService.getAllBugs();
        assertEquals(1, result.size());
    }

    @Test
    @DisplayName("getAllAnimals - 동물 전체 목록 반환")
    void getAllAnimals_returnsList() {
        when(collectionMapper.findAllAnimals()).thenReturn(List.of());
        List<AnimalCollection> result = collectionService.getAllAnimals();
        assertTrue(result.isEmpty());
    }

    // ==================== 개별 조회 ====================

    @Test
    @DisplayName("getFishByName - 이름으로 물고기 조회")
    void getFishByName_returnsItem() {
        FishCollection fish = new FishCollection();
        fish.setName("민물배스");
        fish.setLocation("강");
        fish.setSubLocation("강 전체");

        when(collectionMapper.findFishByName("민물배스")).thenReturn(fish);

        FishCollection result = collectionService.getFishByName("민물배스");
        assertNotNull(result);
        assertEquals("민물배스", result.getName());
        assertEquals("강 전체", result.getSubLocation());
    }

    @Test
    @DisplayName("getFishByName - 존재하지 않는 이름은 null 반환")
    void getFishByName_notFound() {
        when(collectionMapper.findFishByName("없는물고기")).thenReturn(null);

        FishCollection result = collectionService.getFishByName("없는물고기");
        assertNull(result);
    }

    // ==================== 검색 ====================

    @Test
    @DisplayName("searchFish - 키워드 검색")
    void searchFish_returnsMatches() {
        FishCollection fish = new FishCollection();
        fish.setName("민물배스");

        when(collectionMapper.searchFish("배스")).thenReturn(List.of(fish));

        List<FishCollection> result = collectionService.searchFish("배스");
        assertEquals(1, result.size());
        assertTrue(result.get(0).getName().contains("배스"));
    }

    // ==================== Count ====================

    @Test
    @DisplayName("getFishCount - 물고기 수 반환")
    void getFishCount_returnsCount() {
        when(collectionMapper.countAllFish()).thenReturn(42);
        assertEquals(42, collectionService.getFishCount());
    }

    @Test
    @DisplayName("getBirdCount - 새 수 반환")
    void getBirdCount_returnsCount() {
        when(collectionMapper.countAllBirds()).thenReturn(25);
        assertEquals(25, collectionService.getBirdCount());
    }

    // ==================== 추가/삭제 ====================

    @Test
    @DisplayName("addFish - 물고기 추가 시 mapper 호출")
    void addFish_callsMapper() {
        FishCollection fish = new FishCollection();
        fish.setName("새물고기");

        collectionService.addFish(fish);
        verify(collectionMapper, times(1)).insertFish(fish);
    }

    @Test
    @DisplayName("deleteFish - 삭제 시 mapper 호출")
    void deleteFish_callsMapper() {
        collectionService.deleteFish(10);
        verify(collectionMapper, times(1)).deleteFish(10);
    }
}
