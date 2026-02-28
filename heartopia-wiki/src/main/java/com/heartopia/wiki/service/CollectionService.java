package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.CollectionMapper;
import com.heartopia.wiki.model.AnimalCollection;
import com.heartopia.wiki.model.BirdCollection;
import com.heartopia.wiki.model.BugCollection;
import com.heartopia.wiki.model.CookingCollection;
import com.heartopia.wiki.model.FishCollection;
import com.heartopia.wiki.model.FlowerCollection;
import com.heartopia.wiki.model.GardeningCollection;
import com.heartopia.wiki.model.ForageableCollection;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CollectionService {

    private final CollectionMapper collectionMapper;

    // === 전체 조회 (기존) ===
    public List<FishCollection> getAllFish() {
        return collectionMapper.findAllFish();
    }

    public List<BirdCollection> getAllBirds() {
        return collectionMapper.findAllBirds();
    }

    public List<BugCollection> getAllBugs() {
        return collectionMapper.findAllBugs();
    }

    public List<AnimalCollection> getAllAnimals() {
        return collectionMapper.findAllAnimals();
    }

    public List<CookingCollection> getAllCookings() {
        return collectionMapper.findAllCookings();
    }

    public List<FlowerCollection> getAllFlowers() {
        return collectionMapper.findAllFlowers();
    }

    public List<GardeningCollection> getAllCrops() {
        return collectionMapper.findAllGardening();
    }

    public List<ForageableCollection> getAllForageables() {
        return collectionMapper.findAllForageables();
    }

    // === 이름으로 개별 조회 (상세보기) ===
    public FishCollection getFishByName(String name) {
        return collectionMapper.findFishByName(name);
    }

    public BugCollection getBugByName(String name) {
        return collectionMapper.findBugByName(name);
    }

    public BirdCollection getBirdByName(String name) {
        return collectionMapper.findBirdByName(name);
    }

    public AnimalCollection getAnimalByName(String name) {
        return collectionMapper.findAnimalByName(name);
    }

    public CookingCollection getCookingByName(String name) {
        return collectionMapper.findCookingByName(name);
    }

    public FlowerCollection getFlowerByName(String name) {
        return collectionMapper.findFlowerByName(name);
    }

    public GardeningCollection getCropByName(String name) {
        return collectionMapper.findCropByName(name);
    }

    public ForageableCollection getForageableByName(String name) {
        return collectionMapper.findForageableByName(name);
    }

    // === 같은 장소 관련 아이템 조회 (관련정보) ===
    public List<FishCollection> getFishByLocation(String location, String excludeName) {
        return collectionMapper.findFishByLocation(location, excludeName);
    }

    public List<BugCollection> getBugsByLocation(String location, String excludeName) {
        return collectionMapper.findBugsByByLocation(location, excludeName);
    }

    public List<BirdCollection> getBirdsByLocation(String location, String excludeName) {
        return collectionMapper.findBirdsByLocation(location, excludeName);
    }

    public List<AnimalCollection> getAnimalsByLocation(String location, String excludeName) {
        return collectionMapper.findAnimalsByLocation(location, excludeName);
    }

    public List<ForageableCollection> getForageablesByLocation(String location, String excludeName) {
        return collectionMapper.findForageablesByLocation(location, excludeName);
    }

    // === 키워드 검색 ===
    public List<FishCollection> searchFish(String keyword) {
        return collectionMapper.searchFish(keyword);
    }

    public List<BugCollection> searchBugs(String keyword) {
        return collectionMapper.searchBugs(keyword);
    }

    public List<BirdCollection> searchBirds(String keyword) {
        return collectionMapper.searchBirds(keyword);
    }

    public List<AnimalCollection> searchAnimals(String keyword) {
        return collectionMapper.searchAnimals(keyword);
    }

    public List<CookingCollection> searchCookings(String keyword) {
        return collectionMapper.searchCookings(keyword);
    }

    public List<FlowerCollection> searchFlowers(String keyword) {
        return collectionMapper.searchFlowers(keyword);
    }

    public List<GardeningCollection> searchCrops(String keyword) {
        return collectionMapper.searchCrops(keyword);
    }

    public List<ForageableCollection> searchForageables(String keyword) {
        return collectionMapper.searchForageables(keyword);
    }

    // === Count (기존) ===
    public int getFishCount() {
        return collectionMapper.countAllFish();
    }

    public int getBirdCount() {
        return collectionMapper.countAllBirds();
    }

    public int getBugCount() {
        return collectionMapper.countAllBugs();
    }

    public int getAnimalCount() {
        return collectionMapper.countAllAnimals();
    }

    public int getCookingCount() {
        return collectionMapper.countAllCookings();
    }

    public int getFlowerCount() {
        return collectionMapper.countAllFlowers();
    }

    public int getCropCount() {
        return collectionMapper.countAllGardening();
    }

    public int getForageableCount() {
        return collectionMapper.countAllForageables();
    }
}
