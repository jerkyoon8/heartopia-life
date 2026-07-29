package com.heartopia.wiki.dto.weather;

import java.util.List;

public record WeatherVoteBatchRequest(List<WeatherVoteRequest> votes) {
}
