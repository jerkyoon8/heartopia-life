package com.heartopia.wiki.dto.wiki;

import com.heartopia.wiki.model.GardeningCollection;
import java.util.List;

public record CropDto(
    Long id,
    String name,
    String imageUrl,
    Integer level,
    String growthTime,
    Integer seedBuyPrice,
    Integer seedSellPrice,
    List<Integer> prices,
    Integer price1, Integer price2, Integer price3, Integer price4, Integer price5,
    String eventName
) {
    public static CropDto from(GardeningCollection c) {
        return new CropDto(
            c.getId(),
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
            c.getPrice1(), c.getPrice2(), c.getPrice3(), c.getPrice4(), c.getPrice5(),
            c.getEventName()
        );
    }
}
