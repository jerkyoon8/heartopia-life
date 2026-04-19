package com.heartopia.wiki.service;

import com.heartopia.wiki.dto.oauth2.CustomOAuth2User;
import com.heartopia.wiki.dto.oauth2.GoogleResponse;
import com.heartopia.wiki.dto.oauth2.OAuth2Response;
import com.heartopia.wiki.mapper.UserMapper;
import com.heartopia.wiki.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserMapper userMapper;

    @Override
    @Transactional
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);
        String registrationId = userRequest.getClientRegistration().getRegistrationId();

        OAuth2Response oAuth2Response = null;
        if ("google".equals(registrationId)) {
            oAuth2Response = new GoogleResponse(oAuth2User.getAttributes());
        } else {
            return null; // unsupported provider
        }

        String provider = oAuth2Response.getProvider();
        String providerId = oAuth2Response.getProviderId();
        
        Optional<User> existingUser = userMapper.findByProviderAndProviderId(provider, providerId);
        User user;

        if (existingUser.isEmpty()) {
            user = User.builder()
                    .provider(provider)
                    .providerId(providerId)
                    .email(oAuth2Response.getEmail())
                    .nickname(oAuth2Response.getName())
                    .role("ROLE_USER")
                    .build();
            userMapper.insertUser(user);
        } else {
            user = existingUser.get();
            user.setEmail(oAuth2Response.getEmail());
            user.setNickname(oAuth2Response.getName());
            userMapper.updateUser(user);
        }

        return new CustomOAuth2User(user, oAuth2User.getAttributes());
    }
}
