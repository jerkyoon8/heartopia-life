package com.heartopia.wiki.model;

import lombok.Data;

@Data
public class LocationZone {
    private Long id;
    private String zoneKey;         // 고유 키 (예: "거목강", "온천산")
    private String displayName;     // 표시 이름 (예: "거목 강", "온천산 전체")
    private String polygonPoints;   // JSON 문자열 [[x1,y1],[x2,y2],...] (레거시, 선택)
    private Integer mapX;           // 위치 x좌표 (픽셀)
    private Integer mapY;           // 위치 y좌표 (픽셀)
    private String color;           // 색상 (예: "#4dabf7")
    private String parentZoneKey;   // 상위 zone 키 (예: "거목강" → 상위: "강")
}
