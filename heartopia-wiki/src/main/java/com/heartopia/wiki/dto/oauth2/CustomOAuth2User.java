package com.heartopia.wiki.dto.oauth2;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;
import com.heartopia.wiki.model.User;

import java.util.Collection;
import java.util.Collections;
import java.util.Map;

@RequiredArgsConstructor
public class CustomOAuth2User implements OAuth2User {
    private final User user;
    private final Map<String, Object> attributes;

    @Override
    public Map<String, Object> getAttributes() { 
        return attributes; 
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singleton(() -> user.getRole());
    }

    @Override
    public String getName() {
        return user.getNickname();
    }

    public String getEmail() {
        return user.getEmail();
    }
    
    public String getProviderId() {
        return user.getProviderId();
    }
}
