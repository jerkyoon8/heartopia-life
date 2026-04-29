package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.CollectionMapper;
import com.heartopia.wiki.model.Achievement;
import com.heartopia.wiki.model.AnimalCollection;
import com.heartopia.wiki.model.BirdCollection;
import com.heartopia.wiki.model.BugCollection;
import com.heartopia.wiki.model.CookingCollection;
import com.heartopia.wiki.model.CookingIngredient;
import com.heartopia.wiki.model.FishCollection;
import com.heartopia.wiki.model.FlowerCollection;
import com.heartopia.wiki.model.FlowerImage;
import com.heartopia.wiki.model.GardeningCollection;
import com.heartopia.wiki.model.ForageableCollection;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CollectionService {

    private final CollectionMapper collectionMapper;

    // ===================================================================
    // 전체 조회 - @Cacheable 적용 (게임 데이터는 자주 변경되지 않으므로 캐싱에 적합)
    // 서버 재시작 시 캐시 자동 초기화됨
    // ===================================================================

    @Cacheable("allFish")
    public List<FishCollection> getAllFish() {
        return collectionMapper.findAllFish();
    }

    @Cacheable("allBirds")
    public List<BirdCollection> getAllBirds() {
        return collectionMapper.findAllBirds();
    }

    @Cacheable("allBugs")
    public List<BugCollection> getAllBugs() {
        return collectionMapper.findAllBugs();
    }

    @Cacheable("allAnimals")
    public List<AnimalCollection> getAllAnimals() {
        return collectionMapper.findAllAnimals();
    }

    @Cacheable("allCookings")
    public List<CookingCollection> getAllCookings() {
        return collectionMapper.findAllCookings();
    }

    @Cacheable("allFlowers")
    public List<FlowerCollection> getAllFlowers() {
        return collectionMapper.findAllFlowers();
    }

    @Cacheable("allCrops")
    public List<GardeningCollection> getAllCrops() {
        return collectionMapper.findAllGardening();
    }

    @Cacheable("allForageables")
    public List<ForageableCollection> getAllForageables() {
        return collectionMapper.findAllForageables();
    }

    // ===================================================================
    // 이름으로 개별 조회 (상세보기) - key에 name을 포함해 아이템별로 캐싱
    // ===================================================================

    @Cacheable(value = "fishDetail", key = "#name")
    public FishCollection getFishByName(String name) {
        return collectionMapper.findFishByName(name);
    }

    @Cacheable(value = "bugDetail", key = "#name")
    public BugCollection getBugByName(String name) {
        return collectionMapper.findBugByName(name);
    }

    @Cacheable(value = "birdDetail", key = "#name")
    public BirdCollection getBirdByName(String name) {
        return collectionMapper.findBirdByName(name);
    }

    @Cacheable(value = "animalDetail", key = "#name")
    public AnimalCollection getAnimalByName(String name) {
        return collectionMapper.findAnimalByName(name);
    }

    @Cacheable(value = "cookingDetail", key = "#name")
    public CookingCollection getCookingByName(String name) {
        return collectionMapper.findCookingByName(name);
    }

    @Cacheable(value = "cookingIngredients", key = "#cookingId")
    public List<CookingIngredient> getIngredientsByCookingId(Integer cookingId) {
        return collectionMapper.findIngredientsByCookingId(cookingId);
    }

    @Cacheable("allCookingIngredients")
    public Map<Integer, List<CookingIngredient>> getAllCookingIngredientMap() {
        return collectionMapper.findAllCookingIngredients().stream()
                .collect(Collectors.groupingBy(CookingIngredient::getCookingId));
    }

    @Cacheable(value = "flowerDetail", key = "#name")
    public FlowerCollection getFlowerByName(String name) {
        return collectionMapper.findFlowerByName(name);
    }

    @Cacheable(value = "cropDetail", key = "#name")
    public GardeningCollection getCropByName(String name) {
        return collectionMapper.findCropByName(name);
    }

    @Cacheable(value = "forageableDetail", key = "#name")
    public ForageableCollection getForageableByName(String name) {
        return collectionMapper.findForageableByName(name);
    }

    // ===================================================================
    // 같은 장소 관련 아이템 조회 (관련정보) - location + excludeName 조합으로 캐싱
    // ===================================================================

    @Cacheable(value = "fishByLocation", key = "#location + '-' + #excludeName")
    public List<FishCollection> getFishByLocation(String location, String excludeName) {
        return collectionMapper.findFishByLocation(location, excludeName);
    }

    @Cacheable(value = "bugsByLocation", key = "#location + '-' + #excludeName")
    public List<BugCollection> getBugsByLocation(String location, String excludeName) {
        return collectionMapper.findBugsByByLocation(location, excludeName);
    }

    @Cacheable(value = "birdsByLocation", key = "#location + '-' + #excludeName")
    public List<BirdCollection> getBirdsByLocation(String location, String excludeName) {
        return collectionMapper.findBirdsByLocation(location, excludeName);
    }

    @Cacheable(value = "animalsByLocation", key = "#location + '-' + #excludeName")
    public List<AnimalCollection> getAnimalsByLocation(String location, String excludeName) {
        return collectionMapper.findAnimalsByLocation(location, excludeName);
    }

    @Cacheable(value = "forageablesByLocation", key = "#location + '-' + #excludeName")
    public List<ForageableCollection> getForageablesByLocation(String location, String excludeName) {
        return collectionMapper.findForageablesByLocation(location, excludeName);
    }

    // ===================================================================
    // 키워드 검색 - keyword 기반 캐싱 (동일 키워드 반복 검색 시 효과)
    // ===================================================================

    @Cacheable(value = "searchFish", key = "#keyword")
    public List<FishCollection> searchFish(String keyword) {
        return collectionMapper.searchFish(keyword);
    }

    @Cacheable(value = "searchBugs", key = "#keyword")
    public List<BugCollection> searchBugs(String keyword) {
        return collectionMapper.searchBugs(keyword);
    }

    @Cacheable(value = "searchBirds", key = "#keyword")
    public List<BirdCollection> searchBirds(String keyword) {
        return collectionMapper.searchBirds(keyword);
    }

    @Cacheable(value = "searchAnimals", key = "#keyword")
    public List<AnimalCollection> searchAnimals(String keyword) {
        return collectionMapper.searchAnimals(keyword);
    }

    @Cacheable(value = "searchCookings", key = "#keyword")
    public List<CookingCollection> searchCookings(String keyword) {
        return collectionMapper.searchCookings(keyword);
    }

    @Cacheable(value = "searchFlowers", key = "#keyword")
    public List<FlowerCollection> searchFlowers(String keyword) {
        return collectionMapper.searchFlowers(keyword);
    }

    @Cacheable(value = "searchCrops", key = "#keyword")
    public List<GardeningCollection> searchCrops(String keyword) {
        return collectionMapper.searchCrops(keyword);
    }

    @Cacheable(value = "searchForageables", key = "#keyword")
    public List<ForageableCollection> searchForageables(String keyword) {
        return collectionMapper.searchForageables(keyword);
    }

    // ===================================================================
    // Count 조회 - @Cacheable 적용 (메인 페이지에서 매번 8번 조회하던 부분)
    // ===================================================================

    @Cacheable("countFish")
    public int getFishCount() {
        return collectionMapper.countAllFish();
    }

    @Cacheable("countBirds")
    public int getBirdCount() {
        return collectionMapper.countAllBirds();
    }

    @Cacheable("countBugs")
    public int getBugCount() {
        return collectionMapper.countAllBugs();
    }

    @Cacheable("countAnimals")
    public int getAnimalCount() {
        return collectionMapper.countAllAnimals();
    }

    @Cacheable("countCookings")
    public int getCookingCount() {
        return collectionMapper.countAllCookings();
    }

    @Cacheable("countFlowers")
    public int getFlowerCount() {
        return collectionMapper.countAllFlowers();
    }

    @Cacheable("countCrops")
    public int getCropCount() {
        return collectionMapper.countAllGardening();
    }

    @Cacheable("countForageables")
    public int getForageableCount() {
        return collectionMapper.countAllForageables();
    }

    // ===================================================================
    // INSERT (관리자 데이터 추가) - @CacheEvict로 관련 캐시 무효화
    // ===================================================================

    @org.springframework.cache.annotation.CacheEvict(value = {"allFish", "countFish", "searchFish"}, allEntries = true)
    public void addFish(FishCollection fish) {
        collectionMapper.insertFish(fish);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"allBugs", "countBugs", "searchBugs"}, allEntries = true)
    public void addBug(BugCollection bug) {
        collectionMapper.insertBug(bug);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"allBirds", "countBirds", "searchBirds"}, allEntries = true)
    public void addBird(BirdCollection bird) {
        collectionMapper.insertBird(bird);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"allAnimals", "countAnimals", "searchAnimals"}, allEntries = true)
    public void addAnimal(AnimalCollection animal) {
        collectionMapper.insertAnimal(animal);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"allCookings", "countCookings", "searchCookings"}, allEntries = true)
    public void addCooking(CookingCollection cooking) {
        collectionMapper.insertCooking(cooking);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"allFlowers", "countFlowers", "searchFlowers"}, allEntries = true)
    public void addFlower(FlowerCollection flower) {
        collectionMapper.insertFlower(flower);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"allCrops", "countCrops", "searchCrops"}, allEntries = true)
    public void addCrop(GardeningCollection crop) {
        collectionMapper.insertCrop(crop);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"allForageables", "countForageables", "searchForageables"}, allEntries = true)
    public void addForageable(ForageableCollection forageable) {
        collectionMapper.insertForageable(forageable);
    }

    // ===================================================================
    // UPDATE (관리자 데이터 수정) - @CacheEvict로 관련 캐시 무효화
    // ===================================================================
    @org.springframework.cache.annotation.CacheEvict(value = {"allFish", "countFish", "searchFish"}, allEntries = true)
    public void updateFish(FishCollection fish) { collectionMapper.updateFish(fish); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allBugs", "countBugs", "searchBugs"}, allEntries = true)
    public void updateBug(BugCollection bug) { collectionMapper.updateBug(bug); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allBirds", "countBirds", "searchBirds"}, allEntries = true)
    public void updateBird(BirdCollection bird) { collectionMapper.updateBird(bird); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allAnimals", "countAnimals", "searchAnimals"}, allEntries = true)
    public void updateAnimal(AnimalCollection animal) { collectionMapper.updateAnimal(animal); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allCookings", "countCookings", "searchCookings"}, allEntries = true)
    public void updateCooking(CookingCollection cooking) { collectionMapper.updateCooking(cooking); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allFlowers", "countFlowers", "searchFlowers"}, allEntries = true)
    public void updateFlower(FlowerCollection flower) { collectionMapper.updateFlower(flower); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allCrops", "countCrops", "searchCrops"}, allEntries = true)
    public void updateCrop(GardeningCollection crop) { collectionMapper.updateCrop(crop); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allForageables", "countForageables", "searchForageables"}, allEntries = true)
    public void updateForageable(ForageableCollection forageable) { collectionMapper.updateForageable(forageable); }

    // ===================================================================
    // DELETE (관리자 데이터 삭제) - @CacheEvict로 관련 캐시 무효화
    // ===================================================================
    @org.springframework.cache.annotation.CacheEvict(value = {"allFish", "countFish", "searchFish"}, allEntries = true)
    public void deleteFish(Integer id) { collectionMapper.deleteFish(id); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allBugs", "countBugs", "searchBugs"}, allEntries = true)
    public void deleteBug(Integer id) { collectionMapper.deleteBug(id); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allBirds", "countBirds", "searchBirds"}, allEntries = true)
    public void deleteBird(Integer id) { collectionMapper.deleteBird(id); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allAnimals", "countAnimals", "searchAnimals"}, allEntries = true)
    public void deleteAnimal(Integer id) { collectionMapper.deleteAnimal(id); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allCookings", "countCookings", "searchCookings"}, allEntries = true)
    public void deleteCooking(Integer id) { collectionMapper.deleteCooking(id); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allFlowers", "countFlowers", "searchFlowers"}, allEntries = true)
    public void deleteFlower(Long id) { collectionMapper.deleteFlower(id); }

    public List<FlowerImage> getFlowerImages(Long flowerId) {
        return collectionMapper.findFlowerImages(flowerId);
    }

    @org.springframework.transaction.annotation.Transactional
    public void saveFlowerImages(Long flowerId, List<String> imageUrls) {
        collectionMapper.deleteFlowerImagesByFlowerId(flowerId);
        for (int i = 0; i < imageUrls.size(); i++) {
            String url = imageUrls.get(i);
            if (url == null || url.isBlank()) continue;
            FlowerImage img = new FlowerImage();
            img.setFlowerId(flowerId);
            img.setImageUrl(url);
            img.setSortOrder(i);
            collectionMapper.insertFlowerImage(img);
        }
    }

    public void deleteFlowerImage(Long id) {
        collectionMapper.deleteFlowerImage(id);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"allCrops", "countCrops", "searchCrops"}, allEntries = true)
    public void deleteCrop(Long id) { collectionMapper.deleteCrop(id); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allForageables", "countForageables", "searchForageables"}, allEntries = true)
    public void deleteForageable(Integer id) { collectionMapper.deleteForageable(id); }

    // ===================================================================
    // 업적 (Achievement)
    // ===================================================================

    @Cacheable("allAchievements")
    public List<Achievement> getAllAchievements() {
        return collectionMapper.findAllAchievements();
    }

    @Cacheable("countAchievements")
    public int getAchievementCount() {
        return collectionMapper.countAllAchievements();
    }

    @Cacheable(value = "searchAchievements", key = "#keyword")
    public List<Achievement> searchAchievements(String keyword) {
        return collectionMapper.searchAchievements(keyword);
    }

    @Cacheable(value = "achievementDetail", key = "#name")
    public Achievement getAchievementByName(String name) {
        return collectionMapper.findAchievementByName(name);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"allAchievements", "countAchievements", "searchAchievements"}, allEntries = true)
    public void addAchievement(Achievement achievement) { collectionMapper.insertAchievement(achievement); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allAchievements", "countAchievements", "searchAchievements"}, allEntries = true)
    public void updateAchievement(Achievement achievement) { collectionMapper.updateAchievement(achievement); }

    @org.springframework.cache.annotation.CacheEvict(value = {"allAchievements", "countAchievements", "searchAchievements"}, allEntries = true)
    public void deleteAchievement(Integer id) { collectionMapper.deleteAchievement(id); }
}
