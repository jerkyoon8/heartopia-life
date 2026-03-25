package com.heartopia.wiki.dto.wiki;

import com.heartopia.wiki.model.BugCollection;
import java.util.List;

public record BugDto(
    String name,
    String imageUrl,
    String location,
    String subLocation,
    String level,
    String weather,
    String time,
    List<Integer> prices,
    String eventName
) {
    public static BugDto from(BugCollection b) {
        return new BugDto(
            b.getName(),
            b.getImageUrl(),
            b.getLocation(),
            b.getSubLocation() != null && !b.getSubLocation().equals("-") ? b.getSubLocation() : "",
            String.valueOf(b.getLevel()),
            b.getWeather() != null && !b.getWeather().equals("-") ? b.getWeather() : "상시",
            b.getTime() != null && !b.getTime().equals("-") ? b.getTime() : "상시",
            List.of(
                b.getPrice1() != null ? b.getPrice1() : 0,
                b.getPrice2() != null ? b.getPrice2() : 0,
                b.getPrice3() != null ? b.getPrice3() : 0,
                b.getPrice4() != null ? b.getPrice4() : 0,
                b.getPrice5() != null ? b.getPrice5() : 0
            ),
            b.getEventName()
        );
    }
}
