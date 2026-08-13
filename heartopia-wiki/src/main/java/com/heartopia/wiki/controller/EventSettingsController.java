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
    private static final int EVENT_SETTINGS_FORM_VERSION = 2;

    private final EventSettingsService eventSettingsService;

    @GetMapping("/wiki/admin/event-settings")
    public String adminPage(Model model) {
        model.addAttribute("availableEventNames", eventSettingsService.getAvailableEventNames());
        model.addAttribute("currentEventNames", eventSettingsService.getCurrentEventNames());
        model.addAttribute("quickEventNames", eventSettingsService.getQuickEventNames());
        return "wiki/admin-event-settings";
    }

    @PostMapping("/wiki/admin/event-settings")
    public String save(
            @RequestParam(name = "currentEventNames", required = false) List<String> currentEventNames,
            @RequestParam(name = "quickEventNames", required = false) List<String> quickEventNames,
            @RequestParam(name = "eventNames", required = false) List<String> legacyEventNames,
            @RequestParam(name = "eventSettingsVersion", required = false) Integer formVersion,
            RedirectAttributes redirectAttributes) {
        try {
            if (Integer.valueOf(EVENT_SETTINGS_FORM_VERSION).equals(formVersion)) {
                eventSettingsService.replaceEventSettings(currentEventNames, quickEventNames);
            } else if (legacyEventNames != null) {
                eventSettingsService.replaceEventSettings(
                        legacyEventNames,
                        eventSettingsService.getQuickEventNames());
            } else {
                redirectAttributes.addFlashAttribute(
                        "errorMessage",
                        "오래된 설정 화면입니다. 페이지를 새로고침한 뒤 다시 저장해 주세요.");
                return ADMIN_REDIRECT;
            }
            redirectAttributes.addFlashAttribute("successMessage", "현재 이벤트와 빠른 선택 설정을 저장했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }
        return ADMIN_REDIRECT;
    }
}
