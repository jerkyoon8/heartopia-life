package com.heartopia.wiki.model;

import lombok.Data;

@Data
public class FlowerImage {
    private Long id;
    private Long flowerId;
    private String imageUrl;
    private int sortOrder;
}
