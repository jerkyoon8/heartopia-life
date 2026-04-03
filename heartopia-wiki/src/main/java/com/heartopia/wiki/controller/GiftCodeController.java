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
        model.addAttribute("pageTitle", "기프트코드");
        model.addAttribute("pageDescription", "두근두근라이프 최신 기프트코드(쿠폰) 목록 - 사용 가능한 코드와 만료된 코드를 확인하세요.");
        
        return "wiki/codes"; // HTML 파일 경로
    }
}
