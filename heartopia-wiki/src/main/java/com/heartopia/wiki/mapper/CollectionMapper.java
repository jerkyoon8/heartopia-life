package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.AnimalCollection;
import com.heartopia.wiki.model.CookingCollection;
import com.heartopia.wiki.model.FishCollection;
import com.heartopia.wiki.model.FlowerCollection;
import com.heartopia.wiki.model.GardeningCollection;
import com.heartopia.wiki.model.ForageableCollection;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface CollectionMapper {
    List<FishCollection> findAllFish();

    // Using BirdCollection and BugCollection
    List<com.heartopia.wiki.model.BirdCollection> findAllBirds();

    List<com.heartopia.wiki.model.BugCollection> findAllBugs();

    List<AnimalCollection> findAllAnimals();

    List<CookingCollection> findAllCookings();

    List<FlowerCollection> findAllFlowers();

    List<GardeningCollection> findAllGardening();

    List<ForageableCollection> findAllForageables();

    // Count methods
    int countAllFish();

    int countAllBirds();

    int countAllBugs();

    int countAllAnimals();

    int countAllCookings();

    int countAllFlowers();

    int countAllGardening();

    int countAllForageables();
}
