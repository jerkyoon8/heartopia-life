package com.heartopia.wiki.model;

import lombok.Data;

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
}
