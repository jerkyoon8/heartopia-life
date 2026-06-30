package com.heartopia.wiki.dto.wiki;

import com.heartopia.wiki.model.FlowerCollection;
import com.heartopia.wiki.model.FlowerBreedingOption;
import com.heartopia.wiki.model.FlowerBreedingRule;
import com.heartopia.wiki.model.FlowerImage;
import com.heartopia.wiki.model.FlowerVariant;
import java.util.Collections;
import java.util.List;

public record FlowerDto(
    Long id,
    String name,
    String imageUrl,
    Integer level,
    String growthTime,
    Integer seedBuyPrice,
    Integer seedSellPrice,
    List<Integer> prices,
    Integer price1, Integer price2, Integer price3, Integer price4, Integer price5,
    String eventName,
    List<String> imageUrls,
    List<VariantDto> variants,
    List<BreedingRuleDto> breedingRules
) {
    public record VariantDto(
        Long id,
        Integer stars,
        String colorName,
        String imageUrl,
        Integer sortOrder
    ) {
        public static VariantDto from(FlowerVariant v) {
            return new VariantDto(
                v.getId(),
                v.getStars(),
                v.getColorName(),
                v.getImageUrl(),
                v.getSortOrder()
            );
        }
    }

    public record BreedingRuleDto(
        Long id,
        VariantDto result,
        List<VariantDto> leftOptions,
        List<VariantDto> rightOptions,
        String note,
        Integer sortOrder
    ) {
        public static BreedingRuleDto from(FlowerBreedingRule rule) {
            return new BreedingRuleDto(
                rule.getId(),
                rule.getResultVariant() != null ? VariantDto.from(rule.getResultVariant()) : null,
                toVariantDtos(rule.getLeftOptions()),
                toVariantDtos(rule.getRightOptions()),
                rule.getNote(),
                rule.getSortOrder()
            );
        }

        private static List<VariantDto> toVariantDtos(List<FlowerBreedingOption> options) {
            return options != null
                ? options.stream()
                    .map(FlowerBreedingOption::getVariant)
                    .filter(v -> v != null)
                    .map(VariantDto::from)
                    .toList()
                : Collections.emptyList();
        }
    }

    public static FlowerDto from(FlowerCollection f) {
        List<String> imageUrls = f.getImages() != null
            ? f.getImages().stream().map(FlowerImage::getImageUrl).toList()
            : Collections.emptyList();
        List<VariantDto> variants = f.getVariants() != null
            ? f.getVariants().stream().map(VariantDto::from).toList()
            : Collections.emptyList();
        List<BreedingRuleDto> breedingRules = f.getBreedingRules() != null
            ? f.getBreedingRules().stream().map(BreedingRuleDto::from).toList()
            : Collections.emptyList();

        return new FlowerDto(
            f.getId(),
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
            f.getPrice1(), f.getPrice2(), f.getPrice3(), f.getPrice4(), f.getPrice5(),
            f.getEventName(),
            imageUrls,
            variants,
            breedingRules
        );
    }
}
