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

        // Canonical URL: 중복 페이지 방지 및 Google SEO 사이트명 인식용
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int port = request.getServerPort();
        String uri = request.getRequestURI();
        // 프로덕션 환경에서는 항상 https + 도메인 기준 URL 생성
        String baseUrl;
        if ("localhost".equals(serverName) || "127.0.0.1".equals(serverName)) {
            baseUrl = scheme + "://" + serverName + (port != 80 && port != 443 ? ":" + port : "");
        } else {
            baseUrl = "https://" + serverName;
        }
        model.addAttribute("canonicalUrl", baseUrl + uri);

        // Add visitor counts to every page
        model.addAttribute("totalVisitors", visitorService.getTotalVisitorCount());
        model.addAttribute("recent48hVisitors", visitorService.getRecent48hVisitorCount());
    }
}
