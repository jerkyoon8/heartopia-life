package com.heartopia.wiki.service;

import com.heartopia.wiki.dto.oauth2.CustomOAuth2User;
import com.heartopia.wiki.dto.oauth2.GoogleResponse;
import com.heartopia.wiki.dto.oauth2.OAuth2Response;
import com.heartopia.wiki.mapper.UserMapper;
import com.heartopia.wiki.model.User;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserMapper userMapper;

    @Value("${wiki.admin.email}")
    private String adminEmailsRaw;

    private Set<String> adminEmails;

    @PostConstruct
    private void initAdminEmails() {
        adminEmails = Arrays.stream(adminEmailsRaw.split(","))
                .map(String::trim)
                .map(String::toLowerCase)
                .collect(Collectors.toSet());
    }

    @Override
    @Transactional
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);
        String registrationId = userRequest.getClientRegistration().getRegistrationId();

        OAuth2Response oAuth2Response;
        if ("google".equals(registrationId)) {
            oAuth2Response = new GoogleResponse(oAuth2User.getAttributes());
        } else {
            throw new OAuth2AuthenticationException("Unsupported provider: " + registrationId);
        }

        String provider = oAuth2Response.getProvider();
        String providerId = oAuth2Response.getProviderId();
        String email = oAuth2Response.getEmail();
        String role = adminEmails.contains(email.toLowerCase()) ? "ROLE_ADMIN" : "ROLE_USER";

        Optional<User> existingUser = userMapper.findByProviderAndProviderId(provider, providerId);
        User user;

        if (existingUser.isEmpty()) {
            user = User.builder()
                    .provider(provider)
                    .providerId(providerId)
                    .email(email)
                    .nickname(oAuth2Response.getName())
                    .role(role)
                    .build();
            userMapper.insertUser(user);
        } else {
            user = existingUser.get();
            user.setEmail(email);
            user.setNickname(oAuth2Response.getName());
            user.setRole(role);
            userMapper.updateUser(user);
        }

        return new CustomOAuth2User(user, oAuth2User.getAttributes());
    }
}
