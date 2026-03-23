package com.heartopia.wiki.model;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.util.Map;

@Data
public class MapPin {
    private Long id;

    @NotBlank(message = "카테고리는 필수 입력값입니다.")
    private String category;

    @NotBlank(message = "아이템 이름은 필수 입력값입니다.")
    private String name;
    
    private String iconUrl;

    @NotNull(message = "지도 X 좌표가 누락되었습니다.")
    private Integer mapX;

    @NotNull(message = "지도 Y 좌표가 누락되었습니다.")
    private Integer mapY;

    private String linkUrl;
    private String description;
    private Map<String, String> details;
}
