package com.heartopia.wiki.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@Controller
public class SnowSculptureController {
    private final List<Map<String, Object>> sculptures;

    public SnowSculptureController(ObjectMapper objectMapper) throws IOException {
        try (var input = new ClassPathResource("static/snow/catalog/snow-sculptures.json").getInputStream()) {
            sculptures = objectMapper.convertValue(objectMapper.readTree(input).path("items"),
                    new TypeReference<List<Map<String, Object>>>() {});
        }
    }

    @GetMapping({"/wiki/others/snow", "/snow/index.html"})
    public String snow(Model model) {
        model.addAttribute("snowSculptures", sculptures);
        model.addAttribute("pageTitle", "눈 조각 도감");
        model.addAttribute("pageDescription", "눈 조각 15종의 제작 방법, 취미 레벨, 날씨, 1성 판매가와 성급별 실제 외형을 확인하세요.");
        model.addAttribute("canonicalUrl", "https://heartopia-life.me/wiki/others/snow");
        return "wiki/others/snow";
    }
}
