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
    public void addGlobalAttributes(org.springframework.ui.Model model,
            jakarta.servlet.http.HttpSession session,
            jakarta.servlet.http.HttpServletRequest request) {
        // Track the visit only once per session
        if (session.getAttribute("visited") == null) {
            visitorService.trackVisitor();
            session.setAttribute("visited", true);
        }

        // Add current URI for report links, etc.
        model.addAttribute("currentUri", request.getRequestURI());

        // Add visitor counts to every page
        model.addAttribute("totalVisitors", visitorService.getTotalVisitorCount());
        model.addAttribute("recent48hVisitors", visitorService.getRecent48hVisitorCount());
    }
}
