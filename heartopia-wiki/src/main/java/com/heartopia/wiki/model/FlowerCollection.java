package com.heartopia.wiki.model;

import lombok.Data;
import java.util.List;

@Data
public class FlowerCollection {
    private Long id;
    private String name;
    private Integer price1;
    private Integer price2;
    private Integer price3;
    private Integer price4;
    private Integer price5;
    private Integer level;
    private String growthTime;
    private Integer seedBuyPrice;
    private Integer seedSellPrice;
    private String imageUrl;
    private String eventName;
    private Integer masteryBeginnerMax;
    private Integer masteryIntroMin;
    private Integer masteryExpertMin;
    private Integer masteryMasterMin;
    private Boolean masteryFieldsPresent;
    private List<FlowerImage> images;
    private List<FlowerVariant> variants;
    private List<FlowerBreedingRule> breedingRules;

    public boolean hasMasteryData() {
        return masteryBeginnerMax != null
                && masteryIntroMin != null
                && masteryExpertMin != null
                && masteryMasterMin != null;
    }

    public List<Integer> getMasteryThresholds() {
        return java.util.Arrays.asList(masteryBeginnerMax, masteryIntroMin, masteryExpertMin, masteryMasterMin);
    }
}
