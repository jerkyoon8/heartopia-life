package com.heartopia.wiki.dto;

public record DailyResourceLocationResponse(
        String serverTime,
        String fluoriteLocation,
        String oakLocation,
        boolean available) {
}
