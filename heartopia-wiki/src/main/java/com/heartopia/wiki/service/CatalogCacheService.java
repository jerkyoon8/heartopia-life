package com.heartopia.wiki.service;

import lombok.RequiredArgsConstructor;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.stereotype.Service;

import java.util.Set;

@Service
@RequiredArgsConstructor
public class CatalogCacheService {
    // 도감 전용 캐시만 지운다. 세션 및 다른 서비스 캐시는 대상에 포함하지 않는다.
    static final Set<String> CATALOG_CACHE_NAMES = Set.of(
            "allFish", "allBirds", "allBugs", "allAnimals", "allCookings", "allFlowers",
            "allCrops", "allForageables", "allSandboxes", "allSeaCleaningCollections", "allPuzzles",
            "fishDetail", "bugDetail", "birdDetail", "animalDetail", "cookingDetail", "flowerDetail",
            "cropDetail", "forageableDetail", "fishByLocation", "bugsByLocation", "birdsByLocation",
            "animalsByLocation", "forageablesByLocation", "searchFish", "searchBugs", "searchBirds",
            "searchAnimals", "searchCookings", "searchFlowers", "searchCrops", "searchForageables",
            "countFish", "countBirds", "countBugs", "countAnimals", "countCookings", "countFlowers",
            "countCrops", "countForageables", "countSandboxes", "countSeaCleaningCollections", "countPuzzles",
            "countFishMasteryData", "countBirdMasteryData", "countBugMasteryData", "countCookingMasteryData",
            "countFlowerMasteryData", "countCropMasteryData", "countSeaCleaningMasteryData",
            "allAchievements", "countAchievements", "searchAchievements", "achievementDetail",
            "allPets", "petsByType");

    private final CacheManager cacheManager;

    public void clearCatalogCaches() {
        for (String name : cacheManager.getCacheNames()) {
            if (CATALOG_CACHE_NAMES.contains(name)) {
                Cache cache = cacheManager.getCache(name);
                if (cache != null) {
                    cache.clear();
                }
            }
        }
    }
}
