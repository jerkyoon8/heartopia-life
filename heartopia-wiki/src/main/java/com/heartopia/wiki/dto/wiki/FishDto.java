package com.heartopia.wiki.dto.wiki;

import com.heartopia.wiki.model.FishCollection;
import java.util.List;

public record FishDto(
    String name,
    String imageUrl,
    String location,
    String subLocation,
    String level,
    String weather,
    String time,
    List<Integer> prices,
    String size,
    String eventName
) {
    public static FishDto from(FishCollection f) {
        return new FishDto(
            f.getName(),
            f.getImageUrl(),
            f.getLocation(),
            f.getSubLocation() != null ? f.getSubLocation() : "",
            String.valueOf(f.getLevel()),
            f.getWeather() != null && !f.getWeather().isEmpty() ? f.getWeather() : "상시",
            f.getTime() != null && !f.getTime().isEmpty() ? f.getTime() : "상시",
            List.of(
                f.getPrice1() != null ? f.getPrice1() : 0,
                f.getPrice2() != null ? f.getPrice2() : 0,
                f.getPrice3() != null ? f.getPrice3() : 0,
                f.getPrice4() != null ? f.getPrice4() : 0,
                f.getPrice5() != null ? f.getPrice5() : 0
            ),
            f.getSize() != null ? f.getSize() : "-",
            f.getEventName()
        );
    }
}
