package com.heartopia.wiki.dto.wiki;

import com.heartopia.wiki.model.GardeningCollection;
import java.util.List;

public record CropDto(
    String name,
    String imageUrl,
    Integer level,
    String growthTime,
    Integer seedBuyPrice,
    Integer seedSellPrice,
    List<Integer> prices,
    String eventName
) {
    public static CropDto from(GardeningCollection c) {
        return new CropDto(
            c.getName(),
            c.getImageUrl(),
            c.getLevel(),
            c.getGrowthTime(),
            c.getSeedBuyPrice(),
            c.getSeedSellPrice(),
            List.of(
                c.getPrice1() != null ? c.getPrice1() : 0,
                c.getPrice2() != null ? c.getPrice2() : 0,
                c.getPrice3() != null ? c.getPrice3() : 0,
                c.getPrice4() != null ? c.getPrice4() : 0,
                c.getPrice5() != null ? c.getPrice5() : 0
            ),
            c.getEventName()
        );
    }
}
