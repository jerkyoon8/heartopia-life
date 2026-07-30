package com.heartopia.wiki.model;

import lombok.Data;

@Data
public class PuzzleCollection {
    private Integer id;
    private Integer imageId;
    private Integer catalogOrder;
    private String category;
    private String name;
    private String englishName;
    private String size;
    private String acquisitionMethod;
    private String purchasePrice;
    private String imageUrl;
    private Integer sortOrder;
}
