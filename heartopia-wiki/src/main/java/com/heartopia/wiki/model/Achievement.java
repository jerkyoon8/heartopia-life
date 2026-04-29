package com.heartopia.wiki.model;

import lombok.Data;
import java.util.Arrays;
import java.util.List;

@Data
public class Achievement {
    private Integer id;
    private String categories;   // 쉼표 구분 (예: "숨겨진,낚시")
    private String name;
    private String cond;         // DB 컬럼명: cond (condition은 MySQL 예약어)
    private String title;
    private String tip;          // nullable, detail 페이지 전용
    private String imageUrl;
    private Integer sortOrder;

    /**
     * 카테고리 문자열을 리스트로 반환
     * 예: "숨겨진,낚시" -> ["숨겨진", "낚시"]
     */
    public List<String> getCategoryList() {
        if (categories == null || categories.isEmpty()) return List.of();
        return Arrays.asList(categories.split(","));
    }
}
