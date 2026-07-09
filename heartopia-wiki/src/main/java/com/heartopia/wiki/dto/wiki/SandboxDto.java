package com.heartopia.wiki.dto.wiki;

import com.heartopia.wiki.model.SandboxCollection;

public record SandboxDto(
    Integer id,
    String name,
    Integer level,
    String time,
    String weather,
    String shape,
    String shapeImageUrl,
    String dialogueOption,
    Integer price,
    String imageUrl,
    Integer sortOrder,
    String eventName
) {
    public static SandboxDto from(SandboxCollection item) {
        return new SandboxDto(
            item.getId(),
            item.getName(),
            item.getLevel(),
            item.getTime(),
            item.getWeather(),
            item.getShape(),
            item.getShapeImageUrl(),
            item.getDialogueOption(),
            item.getPrice(),
            item.getImageUrl(),
            item.getSortOrder(),
            item.getEventName()
        );
    }
}
