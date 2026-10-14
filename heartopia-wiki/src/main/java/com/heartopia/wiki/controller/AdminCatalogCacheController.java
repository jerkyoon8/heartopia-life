package com.heartopia.wiki.controller;

import com.heartopia.wiki.service.CatalogCacheService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/wiki/admin/catalog-cache")
@RequiredArgsConstructor
public class AdminCatalogCacheController {
    private final CatalogCacheService catalogCacheService;

    @GetMapping
    public String page() {
        return "wiki/admin-catalog-cache";
    }

    @PostMapping("/clear")
    public String clear(RedirectAttributes redirectAttributes) {
        catalogCacheService.clearCatalogCaches();
        redirectAttributes.addFlashAttribute("successMessage", "도감 캐시를 비웠습니다. 도감을 다시 조회해 주세요.");
        return "redirect:/wiki/admin/catalog-cache";
    }
}
