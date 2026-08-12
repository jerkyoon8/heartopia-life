package com.heartopia.wiki.template;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;

class QaDarkModeAndEventFilterRegressionTest {

    // Regression: ISSUE-001, ISSUE-002, ISSUE-003 — 모바일 헤더 겹침과 2열 카드 넘침
    // Found by /qa on 2026-08-12
    // Report: .gstack/qa-reports/qa-report-localhost-2026-08-12.md
    @Test
    void mobileCatalogUsesActualHeaderHeightAndSingleColumnCards() throws IOException {
        String css = read("static/css/common.css");
        String header = read("templates/fragments/header.html");

        assertThat(css)
                .containsPattern("(?s)@media \\(max-width: 991px\\).*?--header-height:\\s*105px;")
                .containsPattern("(?s)@media \\(max-width: 480px\\).*?\\.wiki-grid-layout\\s*\\{.*?grid-template-columns:\\s*minmax\\(0, 1fr\\);");
        assertThat(header)
                .containsPattern("(?s)@media \\(max-width: 991px\\).*?\\.nav-bar\\s*\\{.*?overflow-x:\\s*auto;")
                .containsPattern("(?s)@media \\(max-width: 991px\\).*?\\.header-weather\\s*\\{.*?position:\\s*static;");
    }

    // Regression: ISSUE-004 — 채집물 장소 선택창의 다크모드 글자 대비 부족
    // Found by /qa on 2026-08-12
    // Report: .gstack/qa-reports/qa-report-localhost-2026-08-12.md
    @Test
    void standaloneFilterSelectUsesThemeColors() throws IOException {
        String css = read("static/css/common.css");
        String forageable = read("templates/wiki/collections/forageable.html");

        assertThat(forageable).contains("class=\"filter-standalone-select\"");
        assertThat(css)
                .contains(".filter-standalone-select")
                .contains("color: var(--text-color)")
                .contains("background-color: var(--card-bg)");
    }

    // Regression: ISSUE-005, ISSUE-006 — 관리자 현재 이벤트가 페이지 후보에서 사라짐
    // Found by /qa on 2026-08-12
    // Report: .gstack/qa-reports/qa-report-localhost-2026-08-12.md
    @Test
    void eventFilterExplainsCurrentEventsMissingFromThePage() throws IOException {
        String script = read("static/js/wiki-filter.js");

        assertThat(script)
                .contains("missingCurrentValues")
                .contains("이 도감에 항목 없음")
                .contains("checkbox.disabled = unavailable")
                .contains("element.classList.toggle('event-filter-unavailable'");
    }

    @Test
    void mobileAdminKeepsEventSettingsAccessibleWithoutOverflowingTheTopBar() throws IOException {
        String header = read("templates/fragments/header.html");
        String adminPage = read("templates/wiki/admin-event-settings.html");

        assertThat(header)
                .contains("class=\"btn btn-warning btn-sm admin-event-shortcut\"")
                .containsPattern("(?s)@media \\(max-width: 480px\\).*?\\.admin-event-shortcut\\s*\\{.*?display:\\s*none;")
                .contains("현재 이벤트 관리");
        assertThat(adminPage)
                .contains("margin: 16px auto 56px;")
                .contains("margin-top: 16px;");
    }

    private String read(String resourcePath) throws IOException {
        return new ClassPathResource(resourcePath).getContentAsString(StandardCharsets.UTF_8);
    }
}
