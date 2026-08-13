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

    @Test
    void providesQuickEventTableAndPermissionScripts() throws IOException {
        String create = read("sql/20260813_create_wiki_quick_events.sql");
        String local = read("sql/20260813_grant_wiki_quick_events_local.sql");
        String production = read("sql/20260813_grant_wiki_quick_events_production.sql");

        assertThat(create)
                .contains("CREATE TABLE IF NOT EXISTS wiki_quick_events")
                .contains("event_name VARCHAR(100) NOT NULL PRIMARY KEY");
        assertThat(local)
                .contains("GRANT SELECT, INSERT, UPDATE, DELETE")
                .contains("ON heartopia_db.wiki_quick_events")
                .contains("TO 'wiki_user'@'%'")
                .contains("SHOW GRANTS FOR 'wiki_user'@'%'");
        assertThat(production)
                .contains("GRANT SELECT, INSERT, UPDATE, DELETE")
                .contains("ON heartopia_db.wiki_quick_events")
                .contains("TO 'wiki_usedasr'@'%'");
    }

    private String read(String resourcePath) throws IOException {
        return new ClassPathResource(resourcePath).getContentAsString(StandardCharsets.UTF_8);
    }
}
