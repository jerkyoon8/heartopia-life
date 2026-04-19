package com.heartopia.wiki.controller;

import com.heartopia.wiki.model.WikiReport;
import com.heartopia.wiki.service.WikiReportService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.HtmlUtils;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 위키 정보 수정 제보 관련 요청을 처리하는 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/wiki")
public class ReportController {

    private final WikiReportService reportService;

    /**
     * 제보 양식 페이지를 보여줍니다.
     * 
     * @param itemName  제보 대상 아이템 명 (선택)
     * @param sourceUrl 제보가 발생한 페이지 URL (선택)
     * @param model     뷰에 전달할 데이터
     * @return 제보 양식 템플릿 경로
     */
    @GetMapping("/report")
    public String showReportForm(@RequestParam(required = false) String itemName,
            @RequestParam(required = false) String sourceUrl,
            Model model) {
        log.debug("제보 양식 요청됨. 아이템: {}, URL: {}", itemName, sourceUrl);
        model.addAttribute("itemName", itemName);
        model.addAttribute("sourceUrl", sourceUrl);
        model.addAttribute("pageTitle", "정보 수정 제보");
        return "wiki/report-form";
    }

    /**
     * 사용자가 제출한 제보를 처리합니다.
     * 
     * @param report 제보 데이터 객체
     * @return 처리 결과 메시지 (success/error)
     */
    @PostMapping("/report")
    @ResponseBody   
    public String submitReport(@Valid @RequestBody WikiReport report, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            String errorMessage = bindingResult.getAllErrors().stream()
                    .map(error -> error.getDefaultMessage())
                    .collect(Collectors.joining(", "));
            log.warn("제보 제출 유효성 검사 실패: {}", errorMessage);
            return "error: " + errorMessage;
        }

        try {
            // XSS 방지를 위한 HTML 이스케이프 처리
            if (report.getMessage() != null) {
                report.setMessage(HtmlUtils.htmlEscape(report.getMessage()));
            }
            if (report.getReporterName() != null) {
                report.setReporterName(HtmlUtils.htmlEscape(report.getReporterName()));
            }

            reportService.saveReport(report);
            return "success";
        } catch (Exception e) {
            log.error("제보 저장 중 예상치 못한 오류 발생", e);
            return "error: 서버 내부 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.";
        }
    }

    /**
     * 관리자 로그인 페이지를 보여줍니다.
     */
    @GetMapping("/admin/login")
    public String showAdminLogin() {
        return "wiki/admin-login";
    }

    /**
     * 일반 사용자 소셜 로그인 페이지를 보여줍니다.
     */
    @GetMapping("/login")
    public String showLogin() {
        return "wiki/login";
    }

    /**
     * 개인정보 처리방침 페이지를 보여줍니다.
     */
    @GetMapping("/privacy")
    public String showPrivacy() {
        return "wiki/privacy";
    }

    /**
     * 관리자 전용 제보 내역 조회 페이지를 보여줍니다.
     * 
     * @param model   뷰에 전달할 데이터
     * @return 관리자 제보 목록 템플릿 경로
     */
    @GetMapping("/admin/reports")
    public String viewReports(Model model) {
        log.info("관리자 권한으로 제보 목록 조회 요청됨");
        List<WikiReport> reports = reportService.getAllReports();
        model.addAttribute("reports", reports);
        return "wiki/admin-reports";
    }
}
