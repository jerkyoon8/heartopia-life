package com.heartopia.wiki.model;

import lombok.Data;

/**
 * 요리 재료 중간 테이블 모델
 * - itemType / itemId 가 null → 연결 안 된 재료 (이름만 표시, 클릭 불가)
 * - itemType / itemId 가 존재 → 연결된 재료 (아이콘 + 클릭 이동 가능)
 */
@Data
public class CookingIngredient {
    private Integer id;
    private Integer cookingId;
    private String  ingredientName;
    private Integer quantity;
    private String  itemType;    // 'crop', 'forageable', 'fish', 'bug', 'bird', 'flower' or null
    private Integer itemId;
    private String  imageUrl;    // JOIN으로 각 테이블에서 가져오는 이미지 URL
}
