package com.heartopia.wiki.model;

import lombok.Data;
import java.time.LocalDate;

@Data
public class VisitorStats {
    private LocalDate visitDate;
    private int visitCount;
}
