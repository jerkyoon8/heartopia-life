package com.heartopia.wiki.dto.wiki;

import com.heartopia.wiki.model.BirdCollection;
import java.util.List;

public record BirdDto(
    Integer id,
    String name,
    String imageUrl,
    String location,
    String subLocation,
    String level,
    String weather,
    String time,
    List<Integer> prices,
    Integer price1, Integer price2, Integer price3, Integer price4, Integer price5,
    String type,
    String eventName
) {
    public static BirdDto from(BirdCollection b) {
        return new BirdDto(
            b.getId(),
            b.getName(),
            b.getImageUrl(),
            b.getLocation(),
            b.getSubLocation() != null ? b.getSubLocation() : "",
            String.valueOf(b.getLevel()),
            b.getWeather() != null && !b.getWeather().isEmpty() ? b.getWeather() : "상시",
            b.getTime() != null && !b.getTime().isEmpty() ? b.getTime() : "상시",
            List.of(
                b.getPrice1() != null ? b.getPrice1() : 0,
                b.getPrice2() != null ? b.getPrice2() : 0,
                b.getPrice3() != null ? b.getPrice3() : 0,
                b.getPrice4() != null ? b.getPrice4() : 0,
                b.getPrice5() != null ? b.getPrice5() : 0
            ),
            b.getPrice1(), b.getPrice2(), b.getPrice3(), b.getPrice4(), b.getPrice5(),
            b.getType(),
            b.getEventName()
        );
    }
}
