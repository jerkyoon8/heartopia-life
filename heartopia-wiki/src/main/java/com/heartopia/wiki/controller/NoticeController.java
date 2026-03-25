package com.heartopia.wiki.controller;

import com.heartopia.wiki.model.Notice;
import com.heartopia.wiki.service.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
public class NoticeController {
    
    private final NoticeService noticeService;

    // Public 소식 목록 페이지
    @GetMapping("/wiki/notices")
    public String getPublicNotices(Model model) {
        model.addAttribute("notices", noticeService.getAllNotices());
        return "wiki/notices";
    }

    // 관리자: 목록 조회
    @GetMapping("/wiki/admin/notices")
    public String adminNotices(Model model) {
        model.addAttribute("notices", noticeService.getAllNotices());
        return "wiki/admin-notices";
    }

    // 관리자: 새 소식 추가
    @PostMapping("/wiki/admin/notices/add")
    public String addNotice(Notice notice) {
        noticeService.addNotice(notice);
        return "redirect:/wiki/admin/notices";
    }

    // 관리자: 토글 및 수정 (간단한 처리용)
    @PostMapping("/wiki/admin/notices/toggle")
    public String toggleNotice(@RequestParam Long id, @RequestParam Boolean isActive) {
        Notice notice = noticeService.getNoticeById(id);
        if(notice != null) {
            notice.setIsActive(isActive);
            noticeService.updateNotice(notice);
        }
        return "redirect:/wiki/admin/notices";
    }

    // 관리자: 공지 삭제
    @PostMapping("/wiki/admin/notices/delete")
    public String deleteNotice(@RequestParam Long id) {
        noticeService.deleteNotice(id);
        return "redirect:/wiki/admin/notices";
    }
}
