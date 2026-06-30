package com.heartopia.wiki.model;

import lombok.Data;
import java.util.List;

@Data
public class FlowerBreedingRule {
    private Long id;
    private Long flowerId;
    private Long resultVariantId;
    private FlowerVariant resultVariant;
    private String note;
    private Integer sortOrder;
    private List<FlowerBreedingOption> leftOptions;
    private List<FlowerBreedingOption> rightOptions;
}
