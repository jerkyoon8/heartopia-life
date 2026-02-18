package com.heartopia.wiki.model;

import lombok.Data;
import java.util.Arrays;
import java.util.List;

@Data
public class GourmetCollection {
    private Integer id;
    private String name;
    private Integer level;
    private String ingredients;
    private String price1; // Changed to String to handle "280 / 140coin"
    private String price2;
    private String price3;
    private String price4;
    private String price5;

    public List<String> getPrices() {
        return Arrays.asList(price1, price2, price3, price4, price5);
    }
}
