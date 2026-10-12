package com.heartopia.wiki.model;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class DynamicMapResource {
    private Long id;
    private String mapKey;

    @NotBlank(message = "변동 자원 이름을 입력해 주세요.")
    @Size(max = 100, message = "변동 자원 이름은 100자 이하여야 합니다.")
    private String name;

    @Size(max = 500, message = "아이콘 URL은 500자 이하여야 합니다.")
    private String iconUrl;

    private String description;
    private String eventName;
    private Integer forageableId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
