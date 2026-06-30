package com.heartopia.wiki.model;

import lombok.Data;

@Data
public class FlowerBreedingOption {
    private Long id;
    private Long ruleId;
    private String side;
    private Long variantId;
    private FlowerVariant variant;
}
