package com.heartopia.wiki.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.ui.ExtendedModelMap;
import static org.junit.jupiter.api.Assertions.*;
import java.util.List;

class PumpkinSculptureControllerTest {
    @Test
    void providesAllSculpturesAndResourcesWithoutDatabase() throws Exception {
        var controller = new PumpkinSculptureController(new ObjectMapper());
        var model = new ExtendedModelMap();
        assertEquals("wiki/others/pumpkin", controller.pumpkin(model));
        assertEquals(21, ((List<?>)model.get("pumpkinItems")).size());
        assertEquals(12, ((List<?>)model.get("pumpkinResources")).size());
        assertEquals("호박 조각 도감", model.get("pageTitle"));
    }
}
