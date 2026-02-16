package com.heartopia.wiki.model;

import lombok.Data;
import java.util.List;

@Data
public class VillagerRole {
    private Long id;
    private Long villagerId;
    private String roleType;
    private String title;
    private String description;

    private List<RoleItem> items;

    // For compatibility with Thymeleaf switch
    public String getType() {
        return roleType;
    }
}
