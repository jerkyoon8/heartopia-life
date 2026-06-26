package com.heartopia.wiki.controller;

import com.heartopia.wiki.dto.oauth2.CustomOAuth2User;
import com.heartopia.wiki.service.UserPetFoodService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserPetFoodController {

    private final UserPetFoodService petFoodService;

    @GetMapping("/pet-food")
    public List<Map<String, Object>> getPetFoodProfiles(@AuthenticationPrincipal CustomOAuth2User user) {
        return petFoodService.getPetFoodProfiles(user.getUserId());
    }

    @PutMapping("/pet-food")
    public List<Map<String, Object>> savePetFoodProfiles(@AuthenticationPrincipal CustomOAuth2User user,
                                                         @RequestBody List<Map<String, Object>> profiles) {
        return petFoodService.savePetFoodProfiles(user.getUserId(), profiles);
    }

    @PostMapping("/pet-food/migrate")
    public List<Map<String, Object>> migrate(@AuthenticationPrincipal CustomOAuth2User user,
                                             @RequestBody List<Map<String, Object>> localData) {
        return petFoodService.migrate(user.getUserId(), localData);
    }

    @DeleteMapping("/pet-food")
    public void deleteAll(@AuthenticationPrincipal CustomOAuth2User user) {
        petFoodService.deleteAll(user.getUserId());
    }

    @PutMapping("/pet-food/sync")
    public List<Map<String, Object>> toggleSync(@AuthenticationPrincipal CustomOAuth2User user,
                                                @RequestBody Map<String, Object> body) {
        boolean enabled = Boolean.TRUE.equals(body.get("enabled"));
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> localData = (List<Map<String, Object>>) body.get("localData");
        List<Map<String, Object>> result = petFoodService.toggleSync(user.getUserId(), enabled, localData);
        user.updatePetFoodSyncEnabled(enabled);
        return result;
    }
}
