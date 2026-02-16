package com.heartopia.wiki.model;

import lombok.Data;

@Data
public class VillagerGift {
    private Long id;
    private Long villagerId;
    private String itemName;
    private Boolean isLoved;
}
