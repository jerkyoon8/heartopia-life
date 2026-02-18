package com.heartopia.wiki.model;

import lombok.Data;
import java.util.Arrays;
import java.util.List;

@Data
public class CookingCollection {
    private Integer id;
    private String name;
    private Integer level;
    private String ingredients;
    private Integer buyPrice; // Added buyPrice
    private Integer price1;
    private Integer price2;
    private Integer price3;
    private Integer price4;
    private Integer price5;

    public List<Integer> getPrices() {
        return Arrays.asList(price1, price2, price3, price4, price5);
    }
}
