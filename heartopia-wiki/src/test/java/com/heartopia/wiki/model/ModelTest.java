package com.heartopia.wiki.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Model(DTO) 클래스들의 기본 getter/setter/equals 테스트
 */
class ModelTest {

    // ==================== MapPin ====================

    @Test
    @DisplayName("MapPin - 기본 생성 및 필드 설정")
    void mapPin_basicFields() {
        MapPin pin = new MapPin();
        pin.setId(1L);
        pin.setCategory("fish");
        pin.setName("민물배스");
        pin.setMapX(500);
        pin.setMapY(600);
        pin.setIconUrl("/images/fish.png");
        pin.setLinkUrl("/wiki/collections/fish/민물배스");
        pin.setDescription("강에서 잡을 수 있는 물고기");

        assertEquals(1L, pin.getId());
        assertEquals("fish", pin.getCategory());
        assertEquals("민물배스", pin.getName());
        assertEquals(500, pin.getMapX());
        assertEquals(600, pin.getMapY());
        assertEquals("/images/fish.png", pin.getIconUrl());
        assertNotNull(pin.toString());
    }

    @Test
    @DisplayName("MapPin - details Map 설정")
    void mapPin_details() {
        MapPin pin = new MapPin();
        Map<String, String> details = new HashMap<>();
        details.put("위치", "강 - 거목 강");
        details.put("날씨", "상시");
        details.put("가격(1성)", "75");
        pin.setDetails(details);

        assertEquals(3, pin.getDetails().size());
        assertEquals("강 - 거목 강", pin.getDetails().get("위치"));
    }

    // ==================== LocationZone ====================

    @Test
    @DisplayName("LocationZone - 기본 필드 및 부모-자식 관계")
    void locationZone_basicFields() {
        LocationZone parent = new LocationZone();
        parent.setId(1L);
        parent.setZoneKey("강");
        parent.setDisplayName("강 전체");
        parent.setColor("#4dabf7");
        parent.setParentZoneKey(null);

        LocationZone child = new LocationZone();
        child.setId(2L);
        child.setZoneKey("거목강");
        child.setDisplayName("거목 강");
        child.setMapX(800);
        child.setMapY(1200);
        child.setColor("#4dabf7");
        child.setParentZoneKey("강");

        assertNull(parent.getParentZoneKey());
        assertEquals("강", child.getParentZoneKey());
        assertEquals(800, child.getMapX());
        assertEquals(1200, child.getMapY());
    }

    @Test
    @DisplayName("LocationZone - 부모 zone은 좌표가 null일 수 있음")
    void locationZone_parentNoCoordinates() {
        LocationZone parent = new LocationZone();
        parent.setZoneKey("강");
        parent.setDisplayName("강 전체");

        assertNull(parent.getMapX());
        assertNull(parent.getMapY());
    }

    // ==================== FishCollection ====================

    @Test
    @DisplayName("FishCollection - 가격 리스트 반환")
    void fishCollection_prices() {
        FishCollection fish = new FishCollection();
        fish.setName("민물배스");
        fish.setLocation("강");
        fish.setSubLocation("강 전체");
        fish.setPrice1(75);
        fish.setPrice2(105);
        fish.setPrice3(150);
        fish.setPrice4(210);
        fish.setPrice5(300);

        assertEquals(5, fish.getPrices().size());
        assertEquals(75, fish.getPrices().get(0));
        assertEquals(300, fish.getPrices().get(4));
    }

    @Test
    @DisplayName("FishCollection - subLocation '전체' 패턴 검증")
    void fishCollection_wholeLocation() {
        FishCollection fish = new FishCollection();
        fish.setLocation("강");
        fish.setSubLocation("강 전체");

        // "전체"로 끝나는 subLocation은 전체 지역을 의미
        assertTrue(fish.getSubLocation().endsWith("전체"));
    }

    @Test
    @DisplayName("FishCollection - 일반 subLocation")
    void fishCollection_specificSubLocation() {
        FishCollection fish = new FishCollection();
        fish.setLocation("강");
        fish.setSubLocation("거목 강");

        assertFalse(fish.getSubLocation().endsWith("전체"));
    }

    // ==================== BirdCollection ====================

    @Test
    @DisplayName("BirdCollection - 기본 필드")
    void birdCollection_basicFields() {
        BirdCollection bird = new BirdCollection();
        bird.setName("참새");
        bird.setLocation("숲");
        bird.setSubLocation("영혼의 참나무 숲");
        bird.setWeather("상시");
        bird.setTime("상시");
        bird.setPrice1(100);

        assertEquals("참새", bird.getName());
        assertEquals("숲", bird.getLocation());
        assertFalse(bird.getSubLocation().endsWith("전체"));
    }

    // ==================== AnimalCollection ====================

    @Test
    @DisplayName("AnimalCollection - 기본 필드 (subLocation 없음)")
    void animalCollection_noSubLocation() {
        AnimalCollection animal = new AnimalCollection();
        animal.setName("양");
        animal.setLocation("초원");

        assertEquals("양", animal.getName());
        assertEquals("초원", animal.getLocation());
    }
}
