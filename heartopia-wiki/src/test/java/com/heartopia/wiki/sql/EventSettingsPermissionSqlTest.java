package com.heartopia.wiki.sql;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;

class EventSettingsPermissionSqlTest {

    @Test
    void providesPermissionScriptsForLocalAndProductionDatabaseAccounts() throws IOException {
        String local = read("sql/20260812_grant_wiki_current_events_local.sql");
        String production = read("sql/20260812_grant_wiki_current_events_production.sql");

        assertThat(local)
                .contains("GRANT SELECT, INSERT, UPDATE, DELETE")
                .contains("ON heartopia_db.wiki_current_events")
                .contains("TO 'wiki_user'@'localhost'")
                .contains("SHOW GRANTS FOR 'wiki_user'@'localhost'");
        assertThat(production)
                .contains("GRANT SELECT, INSERT, UPDATE, DELETE")
                .contains("ON heartopia_db.wiki_current_events")
                .contains("TO 'wiki_usedasr'@'%'")
                .contains("SHOW GRANTS FOR 'wiki_usedasr'@'%'");
    }

    private String read(String resourcePath) throws IOException {
        return new ClassPathResource(resourcePath).getContentAsString(StandardCharsets.UTF_8);
    }
}
