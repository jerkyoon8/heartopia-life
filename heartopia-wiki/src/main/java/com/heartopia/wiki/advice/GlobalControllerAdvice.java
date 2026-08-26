package com.heartopia.wiki.advice;

import com.heartopia.wiki.dto.VisitorSummary;
import com.heartopia.wiki.service.VisitorService;
import lombok.RequiredArgsConstructor;

import org.springframework.core.annotation.AnnotatedElementUtils;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerMapping;

@ControllerAdvice
@RequiredArgsConstructor
public class GlobalControllerAdvice {

    private final VisitorService visitorService;

    @ModelAttribute
    public void addGlobalAttributes(org.springframework.ui.Model model,
            jakarta.servlet.http.HttpServletRequest request) {
        String uri = request.getRequestURI();
        if (isApiRequest(request, uri)) {
            return;
        }

        jakarta.servlet.http.HttpSession session = request.getSession();
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
        // 프로덕션 환경에서는 항상 https + 도메인 기준 URL 생성
        String baseUrl;
        if ("localhost".equals(serverName) || "127.0.0.1".equals(serverName)) {
            baseUrl = scheme + "://" + serverName + (port != 80 && port != 443 ? ":" + port : "");
        } else {
            baseUrl = "https://" + serverName;
        }
        model.addAttribute("canonicalUrl", baseUrl + uri);

        // Add both visitor counts with one aggregate query
        VisitorSummary visitorSummary = visitorService.getVisitorSummary();
        model.addAttribute("weeklyVisitors", visitorSummary.getWeeklyVisitors());
        model.addAttribute("todayVisitors", visitorSummary.getTodayVisitors());
    }

    private boolean isApiRequest(jakarta.servlet.http.HttpServletRequest request, String uri) {
        if (isPathOrChild(uri, "/api") || isPathOrChild(uri, "/wiki/map/api")) {
            return true;
        }

        Object handler = request.getAttribute(HandlerMapping.BEST_MATCHING_HANDLER_ATTRIBUTE);
        if (!(handler instanceof HandlerMethod handlerMethod)) {
            return false;
        }
        return AnnotatedElementUtils.hasAnnotation(handlerMethod.getBeanType(), RestController.class)
                || AnnotatedElementUtils.hasAnnotation(handlerMethod.getBeanType(), ResponseBody.class)
                || AnnotatedElementUtils.hasAnnotation(handlerMethod.getMethod(), ResponseBody.class);
    }

    private boolean isPathOrChild(String uri, String root) {
        return root.equals(uri) || uri.startsWith(root + "/");
    }
}
