package com.heartopia.wiki.dto.wiki;

import com.heartopia.wiki.model.FlowerCollection;
import java.util.List;

public record FlowerDto(
    String name,
    String imageUrl,
    Integer level,
    String growthTime,
    Integer seedBuyPrice,
    Integer seedSellPrice,
    List<Integer> prices,
    String eventName
) {
    public static FlowerDto from(FlowerCollection f) {
        return new FlowerDto(
            f.getName(),
            f.getImageUrl(),
            f.getLevel(),
            f.getGrowthTime(),
            f.getSeedBuyPrice(),
            f.getSeedSellPrice(),
            List.of(
                f.getPrice1() != null ? f.getPrice1() : 0,
                f.getPrice2() != null ? f.getPrice2() : 0,
                f.getPrice3() != null ? f.getPrice3() : 0,
                f.getPrice4() != null ? f.getPrice4() : 0,
                f.getPrice5() != null ? f.getPrice5() : 0
            ),
            f.getEventName()
        );
    }
}
