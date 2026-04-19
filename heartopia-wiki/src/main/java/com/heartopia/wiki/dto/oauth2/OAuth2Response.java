package com.heartopia.wiki.dto.oauth2;

public interface OAuth2Response {
    String getProvider(); // google, naver
    String getProviderId(); // provider specific unique account id
    String getEmail();
    String getName(); // nickname
}
