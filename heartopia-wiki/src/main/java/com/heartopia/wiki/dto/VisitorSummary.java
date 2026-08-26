package com.heartopia.wiki.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VisitorSummary {
    private int todayVisitors;
    private int weeklyVisitors;
}
