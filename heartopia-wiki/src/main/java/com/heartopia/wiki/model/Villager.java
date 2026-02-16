package com.heartopia.wiki.model;

import lombok.Data;
import java.util.List;
import java.util.ArrayList;

@Data
public class Villager {
    private Long id;
    private String name;
    private String subTitle;
    private String imageUrl;
    private String location;
    private String unlockCondition;

    private List<VillagerRole> roles;
    private List<VillagerGift> gifts;

    public List<String> getLovedGifts() {
        if (gifts == null)
            return new ArrayList<>();
        return gifts.stream()
                .filter(g -> Boolean.TRUE.equals(g.getIsLoved()))
                .map(VillagerGift::getItemName)
                .toList();
    }

    public List<String> getDislikedGifts() {
        if (gifts == null)
            return new ArrayList<>();
        return gifts.stream()
                .filter(g -> Boolean.FALSE.equals(g.getIsLoved()))
                .map(VillagerGift::getItemName)
                .toList();
    }
}
