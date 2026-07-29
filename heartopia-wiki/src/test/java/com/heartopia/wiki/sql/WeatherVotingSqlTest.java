package com.heartopia.wiki.sql;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertTrue;

class WeatherVotingSqlTest {

    private static final Path SQL_ROOT = Path.of("src", "main", "resources", "sql");

    @Test
    @DisplayName("로컬 날씨 테이블 권한 SQL은 조회, 입력, 수정, 삭제 권한을 모두 부여한다")
    void grantsAllPermissionsRequiredByWeatherVoting() throws IOException {
        String sql = Files.readString(
                SQL_ROOT.resolve("weather-voting-permissions-local.sql"),
                StandardCharsets.UTF_8);

        assertTrue(sql.contains("GRANT SELECT, INSERT, UPDATE, DELETE"));
        assertTrue(sql.contains("ON heartopia_db.weather_votes"));
        assertTrue(sql.contains("ON heartopia_db.weather_vote_history"));
        assertTrue(sql.contains("TO 'wiki_user'@'%'"));
        assertTrue(sql.contains("SHOW GRANTS FOR 'wiki_user'@'%'"));
    }
}
