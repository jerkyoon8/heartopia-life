package com.heartopia.wiki.controller;

import com.heartopia.wiki.dto.DailyResourceLocationResponse;
import com.heartopia.wiki.model.DailyResourceLocation;
import com.heartopia.wiki.service.DailyResourceLocationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
public class DailyResourceLocationController {

    private static final String ADMIN_REDIRECT = "redirect:/wiki/admin/daily-resource-locations";

    private final DailyResourceLocationService service;

    @GetMapping("/api/daily-resource-locations/current")
    @ResponseBody
    public DailyResourceLocationResponse getCurrent() {
        return service.getCurrent();
    }

    @GetMapping("/wiki/admin/daily-resource-locations")
    public String adminPage(Model model) {
        model.addAttribute("dailyLocations", service.getAll());
        model.addAttribute("currentGameDate", service.currentGameDate());
        return "wiki/admin-daily-resource-locations";
    }

    @PostMapping("/wiki/admin/daily-resource-locations/save")
    public String save(
            @ModelAttribute DailyResourceLocation location,
            RedirectAttributes redirectAttributes) {
        try {
            service.save(location);
            redirectAttributes.addFlashAttribute("successMessage", "일일 위치를 저장했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }
        return ADMIN_REDIRECT;
    }

    @PostMapping("/wiki/admin/daily-resource-locations/delete")
    public String delete(
            @RequestParam Long id,
            RedirectAttributes redirectAttributes) {
        try {
            service.delete(id);
            redirectAttributes.addFlashAttribute("successMessage", "예약을 삭제했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }
        return ADMIN_REDIRECT;
    }
}
