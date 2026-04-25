package com.heartopia.wiki.controller;

import com.heartopia.wiki.dto.oauth2.CustomOAuth2User;
import com.heartopia.wiki.service.UserChecklistService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserChecklistController {

    private final UserChecklistService checklistService;

    @GetMapping("/checklist")
    public Map<String, Integer> getChecklist(@AuthenticationPrincipal CustomOAuth2User user) {
        return checklistService.getChecklist(user.getUserId());
    }

    @PostMapping("/checklist/item")
    public void upsertItem(@AuthenticationPrincipal CustomOAuth2User user,
                           @RequestBody Map<String, Object> body) {
        String key = (String) body.get("key");
        int val = ((Number) body.get("val")).intValue();
        checklistService.upsertItem(user.getUserId(), key, val);
    }

    @DeleteMapping("/checklist/item")
    public void deleteItem(@AuthenticationPrincipal CustomOAuth2User user,
                           @RequestBody Map<String, String> body) {
        checklistService.deleteItem(user.getUserId(), body.get("key"));
    }

    @PostMapping("/checklist/migrate")
    public Map<String, Integer> migrate(@AuthenticationPrincipal CustomOAuth2User user,
                                        @RequestBody Map<String, Integer> localData) {
        return checklistService.migrate(user.getUserId(), localData);
    }

    @PostMapping("/checklist/batch")
    public void batchSync(@AuthenticationPrincipal CustomOAuth2User user,
                          @RequestBody Map<String, Object> body) {
        @SuppressWarnings("unchecked")
        Map<String, Integer> upserts = (Map<String, Integer>) body.get("upserts");
        @SuppressWarnings("unchecked")
        List<String> deletes = (List<String>) body.get("deletes");
        checklistService.batchSync(user.getUserId(), upserts, deletes);
    }

    @DeleteMapping("/checklist")
    public void deleteAll(@AuthenticationPrincipal CustomOAuth2User user) {
        checklistService.deleteAll(user.getUserId());
    }

    /**
     * 기기 간 동기화 opt-in 토글.
     * Body: { enabled: boolean, localData?: { key: starRating } }
     * - enabled=true + localData 있으면 1회 업로드 후 플래그 ON
     * - enabled=false면 플래그만 OFF (DB 데이터는 유지)
     * Response: 토글 후 DB 전체 상태
     */
    @PutMapping("/checklist/sync")
    public Map<String, Integer> toggleSync(@AuthenticationPrincipal CustomOAuth2User user,
                                           @RequestBody Map<String, Object> body) {
        boolean enabled = Boolean.TRUE.equals(body.get("enabled"));
        @SuppressWarnings("unchecked")
        Map<String, Integer> localData = (Map<String, Integer>) body.get("localData");
        Map<String, Integer> result = checklistService.toggleSync(user.getUserId(), enabled, localData);
        // 세션 캐시 갱신 — 다음 요청부터 Thymeleaf가 새 값을 읽게 함
        user.updateChecklistSyncEnabled(enabled);
        return result;
    }
}
