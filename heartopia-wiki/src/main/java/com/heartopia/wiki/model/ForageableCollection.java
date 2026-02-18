package com.heartopia.wiki.model;

import lombok.Data;

@Data
public class ForageableCollection {
    private Integer id;
    private String name;
    private String location;
    private Integer price;
    private String energy;
    private String imageUrl;
}
