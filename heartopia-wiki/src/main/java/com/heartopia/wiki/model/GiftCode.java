package com.heartopia.wiki.model;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class GiftCode {
    private Long id;
    private String codeName;
    private String rewards;
    private String status;      // ACTIVE, EXPIRED, SOON
    private LocalDate expirationDate;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
