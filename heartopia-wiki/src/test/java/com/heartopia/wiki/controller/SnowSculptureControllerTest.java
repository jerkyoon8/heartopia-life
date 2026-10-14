package com.heartopia.wiki.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.ui.ExtendedModelMap;
import java.util.List;
import java.util.Map;
import static org.junit.jupiter.api.Assertions.*;

class SnowSculptureControllerTest {
    @Test
    void loadsCompleteLocalCatalogWithQualifiedLevelsAndPricesWithoutDatabase() throws Exception {
        var controller = new SnowSculptureController(new ObjectMapper());
        var model = new ExtendedModelMap();
        assertEquals("wiki/others/snow", controller.snow(model));
        var items = (List<Map<String,Object>>)model.get("snowSculptures");
        assertEquals(15, items.size());
        assertTrue(items.stream().allMatch(i -> ((Number)i.get("sell_price_1star")).intValue() > 0));
        assertEquals(2, items.stream().filter(i -> "unverified".equals(i.get("filter_level"))).count());
        assertEquals("눈 조각 도감", model.get("pageTitle"));
    }
}
