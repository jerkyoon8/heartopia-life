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
    private String imageUrl;
    private String eventName;

    // 신규: 관계형 재료 목록 (cooking_ingredients 테이블)
    private List<CookingIngredient> ingredientList;

    public List<Integer> getPrices() {
        return Arrays.asList(price1, price2, price3, price4, price5);
    }
}
