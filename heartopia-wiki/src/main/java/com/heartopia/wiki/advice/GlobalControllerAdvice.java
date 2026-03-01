package com.heartopia.wiki.advice;

import com.heartopia.wiki.service.VisitorService;
import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
@RequiredArgsConstructor
public class GlobalControllerAdvice {

    private final VisitorService visitorService;

    @ModelAttribute
    public void addWeeklyVisitorsToModel(org.springframework.ui.Model model, jakarta.servlet.http.HttpSession session) {
        // Track the visit only once per session
        if (session.getAttribute("visited") == null) {
            visitorService.trackVisitor();
            session.setAttribute("visited", true);
        }

        // Add the weekly count to every page
        int count = visitorService.getWeeklyVisitorCount();
        model.addAttribute("weeklyVisitors", count);
    }
}
