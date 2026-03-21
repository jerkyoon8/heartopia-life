package com.heartopia.wiki.model;

import lombok.Data;

@Data
public class FishCollection {
    private Integer id;
    private String location;
    private String subLocation;
    private String name;
    private Integer level;
    private String weather;
    private String time;
    private Integer price1;
    private Integer price2;
    private Integer price3;
    private Integer price4;
    private Integer price5;
    private String size;
    private String imageUrl;
    private String eventName;

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public java.util.List<Integer> getPrices() {
        return java.util.Arrays.asList(price1, price2, price3, price4, price5);
    }
}
