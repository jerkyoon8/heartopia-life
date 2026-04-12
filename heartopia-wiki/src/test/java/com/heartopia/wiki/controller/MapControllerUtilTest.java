package com.heartopia.wiki.controller;

import com.heartopia.wiki.mapper.LocationZoneMapper;
import com.heartopia.wiki.model.LocationZone;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * MapController의 유틸리티 메서드 및 Location 관련 로직 테스트
 */
class MapControllerUtilTest {

    @Test
    @DisplayName("formatLocation - location만 있을 때")
    void formatLocation_locationOnly() {
        assertEquals("강", formatLocation("강", null));
        assertEquals("강", formatLocation("강", ""));
        assertEquals("강", formatLocation("강", "-"));
    }

    @Test
    @DisplayName("formatLocation - location + subLocation")
    void formatLocation_withSubLocation() {
        assertEquals("강 - 거목 강", formatLocation("강", "거목 강"));
        assertEquals("바다 - 잔잔한 바다", formatLocation("바다", "잔잔한 바다"));
    }

    @Test
    @DisplayName("formatLocation - location이 null이면 '-' 반환")
    void formatLocation_nullLocation() {
        assertEquals("-", formatLocation(null, null));
        assertEquals("-", formatLocation(null, "거목 강"));
    }

    @Test
    @DisplayName("formatLocation - '전체' subLocation")
    void formatLocation_wholeSubLocation() {
        // "강 전체"는 유효한 subLocation으로 포맷됨 (표시 목적)
        assertEquals("강 - 강 전체", formatLocation("강", "강 전체"));
        assertEquals("바다 - 바다 전체", formatLocation("바다", "바다 전체"));
    }

    // ==================== isWhole 판별 로직 ====================

    @Test
    @DisplayName("isWhole - '전체'로 끝나는 subLocation 감지")
    void isWhole_detection() {
        assertTrue(isWholeLocation("강 전체"));
        assertTrue(isWholeLocation("바다 전체"));
        assertTrue(isWholeLocation("호수 전체"));
        assertTrue(isWholeLocation("전체"));
        assertTrue(isWholeLocation(null));
        assertTrue(isWholeLocation(""));
        assertTrue(isWholeLocation("-"));
    }

    @Test
    @DisplayName("isWhole - 구체적 subLocation은 false")
    void isWhole_specificLocation() {
        assertFalse(isWholeLocation("거목 강"));
        assertFalse(isWholeLocation("잔잔한 바다"));
        assertFalse(isWholeLocation("영혼의 참나무 숲"));
        assertFalse(isWholeLocation("근교 호수"));
    }

    // ==================== LocationZone 부모-자식 관계 ====================

    @Test
    @DisplayName("LocationZone - 부모 zone 하위 자식 필터링")
    void locationZone_childFiltering() {
        LocationZone parent = createZone("강", "강 전체", null, null, null);
        LocationZone child1 = createZone("거목강", "거목 강", "강", 800, 1200);
        LocationZone child2 = createZone("고요한강", "고요한 강", "강", 900, 1100);
        LocationZone child3 = createZone("노을강", "노을 강", "강", 700, 1300);
        LocationZone otherChild = createZone("잔잔한바다", "잔잔한 바다", "바다", 500, 500);

        List<LocationZone> allZones = Arrays.asList(parent, child1, child2, child3, otherChild);

        // "강" 부모의 자식만 필터링
        List<LocationZone> riverChildren = allZones.stream()
                .filter(z -> "강".equals(z.getParentZoneKey()))
                .toList();

        assertEquals(3, riverChildren.size());
        assertTrue(riverChildren.stream().allMatch(z -> z.getMapX() != null));
    }

    @Test
    @DisplayName("LocationZone - 부모 zone은 좌표가 없어도 됨")
    void locationZone_parentHasNoCoords() {
        LocationZone parent = createZone("강", "강 전체", null, null, null);
        assertNull(parent.getMapX());
        assertNull(parent.getMapY());
        assertNull(parent.getParentZoneKey());
    }

    // ==================== 헬퍼 메서드 (MapController의 private 메서드 재현) ====================

    private String formatLocation(String location, String subLocation) {
        if (location == null) return "-";
        if (subLocation == null || subLocation.isEmpty() || subLocation.equals("-")) {
            return location;
        }
        return location + " - " + subLocation;
    }

    private boolean isWholeLocation(String subLocation) {
        return subLocation == null || subLocation.isEmpty()
                || subLocation.equals("-") || subLocation.endsWith("전체");
    }

    private LocationZone createZone(String key, String displayName, String parentKey, Integer x, Integer y) {
        LocationZone zone = new LocationZone();
        zone.setZoneKey(key);
        zone.setDisplayName(displayName);
        zone.setParentZoneKey(parentKey);
        zone.setMapX(x);
        zone.setMapY(y);
        return zone;
    }
}
