package com.heartopia.wiki.model;

import lombok.Data;

@Data
public class GardeningCollection {
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

    public java.util.List<Integer> getPrices() {
        return java.util.Arrays.asList(price1, price2, price3, price4, price5);
    }

    public boolean hasMasteryData() {
        return masteryBeginnerMax != null
                && masteryIntroMin != null
                && masteryExpertMin != null
                && masteryMasterMin != null;
    }

    public java.util.List<Integer> getMasteryThresholds() {
        return java.util.Arrays.asList(masteryBeginnerMax, masteryIntroMin, masteryExpertMin, masteryMasterMin);
    }
}
