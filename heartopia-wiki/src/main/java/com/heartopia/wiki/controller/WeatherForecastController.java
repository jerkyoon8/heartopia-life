package com.heartopia.wiki.controller;

import com.heartopia.wiki.dto.weather.WeatherForecastResponse;
import com.heartopia.wiki.service.WeatherForecastService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/weather")
public class WeatherForecastController {

    private final WeatherForecastService weatherForecastService;

    @GetMapping("/forecast")
    public WeatherForecastResponse getForecast() {
        return weatherForecastService.getForecast();
    }
}
