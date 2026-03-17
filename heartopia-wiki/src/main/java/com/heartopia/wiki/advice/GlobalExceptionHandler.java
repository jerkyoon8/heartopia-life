package com.heartopia.wiki.advice;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(org.springframework.web.servlet.resource.NoResourceFoundException.class)
    public void handleNoResourceFoundException(org.springframework.web.servlet.resource.NoResourceFoundException e) {
        // 정적 리소스(아이콘 등)가 없는 경우 에러 로그를 남기지 않고 조용히 넘아감
        // 브라우저에서는 404가 발생하며, 프론트엔드의 onerror 로직이 처리함
        log.warn("Resource not found: {}", e.getResourcePath());
    }

    @ExceptionHandler(Exception.class)
    public String handleException(Exception e, Model model) {
        log.error("Unhandled exception occurred: ", e);
        
        // 브라우저에는 최소한의 정보만 노출
        model.addAttribute("errorTitle", "시스템 오류가 발생했습니다.");
        model.addAttribute("errorMessage", "잠시 후 다시 시도해 주세요. 문제가 지속되면 관리자에게 문의 바랍니다.");
        
        return "error/default-error";
    }
}
