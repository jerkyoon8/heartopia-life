package com.heartopia.wiki.controller;

import com.heartopia.wiki.service.EventSettingsService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class EventSettingsController {

    private static final String ADMIN_REDIRECT = "redirect:/wiki/admin/event-settings";

    private final EventSettingsService eventSettingsService;

    @GetMapping("/wiki/admin/event-settings")
    public String adminPage(Model model) {
        model.addAttribute("availableEventNames", eventSettingsService.getAvailableEventNames());
        model.addAttribute("currentEventNames", eventSettingsService.getCurrentEventNames());
        return "wiki/admin-event-settings";
    }

    @PostMapping("/wiki/admin/event-settings")
    public String save(
            @RequestParam(name = "eventNames", required = false) List<String> eventNames,
            RedirectAttributes redirectAttributes) {
        try {
            eventSettingsService.replaceCurrentEvents(eventNames);
            redirectAttributes.addFlashAttribute("successMessage", "현재 이벤트 설정을 저장했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }
        return ADMIN_REDIRECT;
    }
}
