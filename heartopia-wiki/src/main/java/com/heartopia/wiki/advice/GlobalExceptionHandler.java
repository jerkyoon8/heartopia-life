package com.heartopia.wiki.advice;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ui.Model;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(org.springframework.web.servlet.resource.NoResourceFoundException.class)
    public void handleNoResourceFoundException(org.springframework.web.servlet.resource.NoResourceFoundException e) {
        // 이미지가 없어서 발생하는 404 에러는 프론트엔드의 onerror 로직이 
        // 대체 아이콘으로 알아서 덮어씌워주므로, 굳이 백엔드 단에서 시끄럽게 에러 로그(WARN)를 남길 필요가 없습니다.
        // log.warn("Resource not found: {}", e.getResourcePath());
    }

    // API JSON 파라미터 검증 실패 처리 (@Valid 실패 로직)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, Object> errorResponse = new HashMap<>();
        String errorMsg = ex.getBindingResult().getAllErrors().get(0).getDefaultMessage();
        
        errorResponse.put("success", false);
        errorResponse.put("message", "데이터 검증 실패: " + errorMsg);
        
        log.warn("API 데이터 검증 에러 차단됨: {}", errorMsg);
        return ResponseEntity.badRequest().body(errorResponse);
    }

    @ExceptionHandler(Exception.class)
    public Object handleException(Exception e, Model model, org.springframework.web.context.request.WebRequest request) {
        // 에러 역추적을 위한 클라이언트 정보 수집
        String clientInfo = request.getDescription(false);
        String userAgent = request.getHeader("User-Agent");
        log.error("[ERROR] URL: {} | User-Agent: {} | 에러: {}", clientInfo, userAgent, e.getMessage(), e);
        
        String acceptHeader = request.getHeader("Accept");
        if (acceptHeader != null && acceptHeader.contains("application/json")) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "일시적인 서버 오류가 발생했습니다. 관리자에게 문의하세요.");
            return ResponseEntity.internalServerError().body(errorResponse);
        } else {
            model.addAttribute("errorTitle", "시스템 오류가 발생했습니다.");
            model.addAttribute("errorMessage", "잠시 후 다시 시도해 주세요. 문제가 지속되면 관리자에게 문의 바랍니다.");
            return new org.springframework.web.servlet.ModelAndView("error/default-error", model.asMap());
        }
    }
}
