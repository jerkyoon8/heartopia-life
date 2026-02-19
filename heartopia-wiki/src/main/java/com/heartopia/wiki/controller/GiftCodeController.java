package com.heartopia.wiki.controller;

import com.heartopia.wiki.model.GiftCode;
import com.heartopia.wiki.service.GiftCodeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/wiki/codes")
public class GiftCodeController {

    private final GiftCodeService giftCodeService;

    public GiftCodeController(GiftCodeService giftCodeService) {
        this.giftCodeService = giftCodeService;
    }

    @GetMapping
    public String getGiftCodes(Model model) {
        Map<String, List<GiftCode>> codes = giftCodeService.getCodesGroupedByStatus();
        
        model.addAttribute("activeCodes", codes.get("active"));
        model.addAttribute("expiredCodes", codes.get("expired"));
        
        return "wiki/codes"; // HTML 파일 경로
    }
}
