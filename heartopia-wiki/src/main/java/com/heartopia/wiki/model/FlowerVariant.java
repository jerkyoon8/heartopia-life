package com.heartopia.wiki.model;

import lombok.Data;

@Data
public class FlowerVariant {
    private Long id;
    private Long flowerId;
    private Integer stars;
    private String colorName;
    private String imageUrl;
    private Integer sortOrder;
}
