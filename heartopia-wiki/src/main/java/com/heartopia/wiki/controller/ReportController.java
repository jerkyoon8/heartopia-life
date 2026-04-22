package com.heartopia.wiki.controller;

import com.heartopia.wiki.dto.oauth2.CustomOAuth2User;
import com.heartopia.wiki.model.WikiReport;
import com.heartopia.wiki.service.WikiReportService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

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
    @GetMapping("/reports/write")
    public String showReportForm(@RequestParam(required = false) String itemName,
            @RequestParam(required = false) String sourceUrl,
            Model model,
            Authentication authentication) {
        log.debug("제보 양식 요청됨. 아이템: {}, URL: {}", itemName, sourceUrl);
        model.addAttribute("itemName", itemName);
        model.addAttribute("sourceUrl", sourceUrl);
        model.addAttribute("pageTitle", "정보 수정 제보");
        if (authentication != null && authentication.getPrincipal() instanceof CustomOAuth2User user) {
            model.addAttribute("currentNickname", user.getName());
        }
        return "wiki/report-form";
    }

    /**
     * 사용자가 제출한 제보를 처리합니다.
     * 
     * @param report 제보 데이터 객체
     * @return 처리 결과 메시지 (success/error)
     */
    @PostMapping("/reports/write")
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
            reportService.saveReport(report);
            return "success";
        } catch (Exception e) {
            log.error("제보 저장 중 예상치 못한 오류 발생", e);
            return "error: 서버 내부 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.";
        }
    }

    @GetMapping("/login")
    public String showLogin(Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            return "redirect:/wiki";
        }
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

    /**
     * 일반 사용자 페이지: 승인된 문의하기 공개 목록을 보여줍니다.
     */
    @GetMapping("/reports")
    public String viewPublicReports(Model model) {
        log.info("사용자 공개 문의 게시판 목록 조회 요청됨");
        List<WikiReport> publicReports = reportService.getPublicReports();
        model.addAttribute("reports", publicReports);
        model.addAttribute("pageTitle", "문의 게시판");
        return "wiki/reports";
    }

    /**
     * 관리자 전용: 제보 공개/비공개 상태 전환 API
     */
    @PostMapping("/admin/reports/{id}/public")
    public String togglePublicStatus(@PathVariable Integer id, @RequestParam boolean status) {
        try {
            reportService.togglePublicStatus(id, status);
        } catch (Exception e) {
            log.error("공개 상태 전환 중 통신 오류 발생", e);
        }
        return "redirect:/wiki/admin/reports";
    }

    /**
     * 관리자 전용: 제보 소프트 삭제 API
     */
    @PostMapping("/admin/reports/{id}/delete")
    public String deleteReport(@PathVariable Integer id) {
        try {
            reportService.softDeleteReport(id);
        } catch (Exception e) {
            log.error("제보 삭제 처리 중 통신 오류 발생", e);
        }
        return "redirect:/wiki/admin/reports";
    }

    /**
     * 관리자 전용: 문의 답변 저장 API
     */
    @PostMapping("/admin/reports/{id}/reply")
    public String submitAdminReply(@PathVariable Integer id,
                                   @RequestParam String adminReply) {
        try {
            reportService.updateAdminReply(id, adminReply);
        } catch (Exception e) {
            log.error("관리자 답변 저장 중 오류 발생", e);
        }
        return "redirect:/wiki/admin/reports";
    }
}
