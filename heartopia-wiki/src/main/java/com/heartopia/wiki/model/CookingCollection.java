package com.heartopia.wiki.model;

import lombok.Data;
import java.util.Arrays;
import java.util.List;

@Data
public class CookingCollection {
    private Integer id;
    private String name;
    private Integer level;
    private String ingredients;       // 기존 텍스트 (하위 호환 유지)
    private Integer buyPrice;
    private Integer price1;
    private Integer price2;
    private Integer price3;
    private Integer price4;
    private Integer price5;
    private Integer recovery1;
    private Integer recovery2;
    private Integer recovery3;
    private Integer recovery4;
    private Integer recovery5;
    private String imageUrl;
    private String eventName;
    private Integer masteryBeginnerMax;
    private Integer masteryIntroMin;
    private Integer masteryExpertMin;
    private Integer masteryMasterMin;
    private Boolean masteryFieldsPresent;

    public List<Integer> getPrices() {
        return Arrays.asList(price1, price2, price3, price4, price5);
    }

    public List<Integer> getRecoveries() {
        return Arrays.asList(recovery1, recovery2, recovery3, recovery4, recovery5);
    }

    public boolean hasRecoveryData() {
        return getRecoveries().stream().anyMatch(value -> value != null);
    }

    public boolean hasMasteryData() {
        return masteryBeginnerMax != null
                && masteryIntroMin != null
                && masteryExpertMin != null
                && masteryMasterMin != null;
    }

    public List<Integer> getMasteryThresholds() {
        return Arrays.asList(masteryBeginnerMax, masteryIntroMin, masteryExpertMin, masteryMasterMin);
    }
}
