package com.heartopia.wiki.model;

import lombok.Data;
import java.util.Map;

@Data
public class MapPin {
    private Long id;
    private String category;
    private String name;
    private String iconUrl;
    private Integer mapX;
    private Integer mapY;
    private String linkUrl;
    private String description;
    private Map<String, String> details; // 추가 상세 정보 (날씨, 시간, 가격 등)
}
