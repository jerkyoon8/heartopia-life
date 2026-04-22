package com.heartopia.wiki.config;

import com.heartopia.wiki.dto.oauth2.CustomOAuth2User;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class UserAdvice {

    @ModelAttribute("currentUser")
    public CustomOAuth2User currentUser(Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof CustomOAuth2User user) {
            return user;
        }
        return null;
    }
}
