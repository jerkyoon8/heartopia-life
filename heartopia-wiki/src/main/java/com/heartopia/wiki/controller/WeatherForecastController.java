package com.heartopia.wiki.controller;

import com.heartopia.wiki.dto.oauth2.CustomOAuth2User;
import com.heartopia.wiki.dto.weather.WeatherForecastResponse;
import com.heartopia.wiki.dto.weather.WeatherVoteBatchRequest;
import com.heartopia.wiki.service.WeatherForecastService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/weather")
public class WeatherForecastController {

    private final WeatherForecastService weatherForecastService;

    @GetMapping("/forecast")
    public WeatherForecastResponse getForecast(@AuthenticationPrincipal CustomOAuth2User user) {
        return weatherForecastService.getForecast(user == null ? null : user.getUserId());
    }

    @PostMapping("/votes")
    public WeatherForecastResponse submitVotes(
            @AuthenticationPrincipal CustomOAuth2User user,
            @RequestBody WeatherVoteBatchRequest request) {
        boolean admin = user.getAuthorities().stream()
                .anyMatch(authority -> "ROLE_ADMIN".equals(authority.getAuthority()));
        return weatherForecastService.submitVotes(user.getUserId(), admin, request);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Map<String, String> handleInvalidVote(IllegalArgumentException exception) {
        return Map.of("message", exception.getMessage());
    }
}
