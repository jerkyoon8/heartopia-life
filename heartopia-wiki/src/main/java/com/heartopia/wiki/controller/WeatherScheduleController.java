package com.heartopia.wiki.controller;

import com.heartopia.wiki.model.WeatherSchedule;
import com.heartopia.wiki.service.WeatherScheduleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
public class WeatherScheduleController {

    private static final String ADMIN_REDIRECT = "redirect:/wiki/admin/weather-schedules";
    private final WeatherScheduleService service;

    @GetMapping("/wiki/admin/weather-schedules")
    public String adminPage(Model model) {
        model.addAttribute("weatherSchedules", service.getAll());
        model.addAttribute("today", service.today());
        return "wiki/admin-weather-schedules";
    }

    @PostMapping("/wiki/admin/weather-schedules/save")
    public String save(@ModelAttribute WeatherSchedule schedule, RedirectAttributes redirectAttributes) {
        try {
            service.save(schedule);
            redirectAttributes.addFlashAttribute("successMessage", "날씨 예약을 저장했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }
        return ADMIN_REDIRECT;
    }

    @PostMapping("/wiki/admin/weather-schedules/delete")
    public String delete(@RequestParam Long id, RedirectAttributes redirectAttributes) {
        try {
            service.delete(id);
            redirectAttributes.addFlashAttribute("successMessage", "날씨 예약을 삭제했습니다.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }
        return ADMIN_REDIRECT;
    }
}
