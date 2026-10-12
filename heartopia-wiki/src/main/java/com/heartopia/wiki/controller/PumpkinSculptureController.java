package com.heartopia.wiki.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.io.IOException;

@Controller
public class PumpkinSculptureController {
    private final java.util.List<?> items;
    private final java.util.List<?> resources;

    public PumpkinSculptureController(ObjectMapper mapper) throws IOException {
        try (var input = new ClassPathResource("static/pumpkin/catalog.json").getInputStream()) {
            JsonNode catalog = mapper.readTree(input);
            items = mapper.convertValue(catalog.path("items"), java.util.List.class);
            resources = mapper.convertValue(catalog.path("resources"), java.util.List.class);
        }
    }

    @GetMapping("/wiki/others/pumpkin")
    public String pumpkin(Model model) {
        model.addAttribute("pumpkinItems", items);
        model.addAttribute("pumpkinResources", resources);
        model.addAttribute("pageTitle", "호박 조각 도감");
        model.addAttribute("pageDescription", "호박 조각 21종의 한국어 이름, 제작 재료, 취미 레벨과 실제 외형을 확인하세요.");
        model.addAttribute("canonicalUrl", "https://heartopia-life.me/wiki/others/pumpkin");
        return "wiki/others/pumpkin";
    }
}
