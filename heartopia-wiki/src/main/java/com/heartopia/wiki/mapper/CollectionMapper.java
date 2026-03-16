package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.AnimalCollection;
import com.heartopia.wiki.model.BirdCollection;
import com.heartopia.wiki.model.BugCollection;
import com.heartopia.wiki.model.CookingCollection;
import com.heartopia.wiki.model.CookingIngredient;
import com.heartopia.wiki.model.FishCollection;
import com.heartopia.wiki.model.FlowerCollection;
import com.heartopia.wiki.model.GardeningCollection;
import com.heartopia.wiki.model.ForageableCollection;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface CollectionMapper {
    // === 전체 조회 ===
    List<FishCollection> findAllFish();

    List<BirdCollection> findAllBirds();

    List<BugCollection> findAllBugs();

    List<AnimalCollection> findAllAnimals();

    List<CookingCollection> findAllCookings();

    List<FlowerCollection> findAllFlowers();

    List<GardeningCollection> findAllGardening();

    List<ForageableCollection> findAllForageables();

    // === 이름으로 개별 조회 (상세보기) ===
    FishCollection findFishByName(@Param("name") String name);

    BugCollection findBugByName(@Param("name") String name);

    BirdCollection findBirdByName(@Param("name") String name);

    AnimalCollection findAnimalByName(@Param("name") String name);

    CookingCollection findCookingByName(@Param("name") String name);

    // === 요리 재료 목록 조회 ===
    List<CookingIngredient> findIngredientsByCookingId(@Param("cookingId") Integer cookingId);

    List<CookingIngredient> findAllCookingIngredients();

    FlowerCollection findFlowerByName(@Param("name") String name);

    GardeningCollection findCropByName(@Param("name") String name);

    ForageableCollection findForageableByName(@Param("name") String name);

    // === 같은 장소 관련 아이템 조회 (관련정보) ===
    List<FishCollection> findFishByLocation(@Param("location") String location,
            @Param("excludeName") String excludeName);

    List<BugCollection> findBugsByByLocation(@Param("location") String location,
            @Param("excludeName") String excludeName);

    List<BirdCollection> findBirdsByLocation(@Param("location") String location,
            @Param("excludeName") String excludeName);

    List<AnimalCollection> findAnimalsByLocation(@Param("location") String location,
            @Param("excludeName") String excludeName);

    List<ForageableCollection> findForageablesByLocation(@Param("location") String location,
            @Param("excludeName") String excludeName);

    // === 키워드 검색 ===
    List<FishCollection> searchFish(@Param("keyword") String keyword);

    List<BugCollection> searchBugs(@Param("keyword") String keyword);

    List<BirdCollection> searchBirds(@Param("keyword") String keyword);

    List<AnimalCollection> searchAnimals(@Param("keyword") String keyword);

    List<CookingCollection> searchCookings(@Param("keyword") String keyword);

    List<FlowerCollection> searchFlowers(@Param("keyword") String keyword);

    List<GardeningCollection> searchCrops(@Param("keyword") String keyword);

    List<ForageableCollection> searchForageables(@Param("keyword") String keyword);

    // === Count ===
    int countAllFish();

    int countAllBirds();

    int countAllBugs();

    int countAllAnimals();

    int countAllCookings();

    int countAllFlowers();

    int countAllGardening();

    int countAllForageables();
}
