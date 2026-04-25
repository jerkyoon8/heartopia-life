package com.heartopia.wiki.model;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {
    private Long id;
    private String provider;
    private String providerId;
    private String email;
    private String nickname;
    private String role;
    private LocalDateTime createdAt;
    private boolean checklistSyncEnabled;
}
