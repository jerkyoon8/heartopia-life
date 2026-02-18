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

    // Connect to Mapper Count methods
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
