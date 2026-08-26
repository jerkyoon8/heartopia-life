package com.heartopia.wiki.advice;

import com.heartopia.wiki.dto.VisitorSummary;
import com.heartopia.wiki.service.VisitorService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerMapping;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

class GlobalControllerAdviceTest {

    private final VisitorService visitorService = mock(VisitorService.class);
    private final GlobalControllerAdvice advice = new GlobalControllerAdvice(visitorService);

    @ParameterizedTest
    @ValueSource(strings = {"/api", "/api/weather/forecast", "/wiki/map/api", "/wiki/map/api/fish"})
    void apiRequestsDoNotCreateSessionOrQueryVisitorStats(String uri) {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", uri);

        advice.addGlobalAttributes(new ExtendedModelMap(), request);

        assertThat(request.getSession(false)).isNull();
        verifyNoInteractions(visitorService);
    }

    @Test
    void firstHtmlRequestTracksOnceAndLoadsSummaryOnce() {
        when(visitorService.getVisitorSummary()).thenReturn(new VisitorSummary(12, 70));
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/wiki");
        ExtendedModelMap model = new ExtendedModelMap();

        advice.addGlobalAttributes(model, request);

        verify(visitorService).trackVisitor();
        verify(visitorService).getVisitorSummary();
        assertThat(model.get("todayVisitors")).isEqualTo(12);
        assertThat(model.get("weeklyVisitors")).isEqualTo(70);
        assertThat(request.getSession(false).getAttribute("visited")).isEqualTo(true);
    }

    @Test
    void responseBodyHandlerOutsideApiPathsAlsoSkipsVisitorWork() throws NoSuchMethodException {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/wiki/search/suggest");
        HandlerMethod handler = new HandlerMethod(
                new ResponseController(),
                ResponseController.class.getDeclaredMethod("suggest"));
        request.setAttribute(HandlerMapping.BEST_MATCHING_HANDLER_ATTRIBUTE, handler);

        advice.addGlobalAttributes(new ExtendedModelMap(), request);

        assertThat(request.getSession(false)).isNull();
        verifyNoInteractions(visitorService);
    }

    @Test
    void realMvcDispatchExposesResponseBodyHandlerBeforeAdviceRuns() throws Exception {
        MockMvc mockMvc = MockMvcBuilders
                .standaloneSetup(new ResponseController())
                .setControllerAdvice(advice)
                .build();

        MvcResult result = mockMvc.perform(get("/custom-json"))
                .andExpect(status().isOk())
                .andReturn();

        assertThat(result.getRequest().getSession(false)).isNull();
        verifyNoInteractions(visitorService);
    }

    @Test
    void existingHtmlSessionDoesNotIncrementAgainButRefreshesSummary() {
        when(visitorService.getVisitorSummary()).thenReturn(new VisitorSummary(12, 70));
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("visited", true);
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/wiki/collections/fish");
        request.setSession(session);

        advice.addGlobalAttributes(new ExtendedModelMap(), request);

        verify(visitorService, never()).trackVisitor();
        verify(visitorService, times(1)).getVisitorSummary();
    }

    @Controller
    static final class ResponseController {
        @GetMapping("/custom-json")
        @ResponseBody
        public String suggest() {
            return "[]";
        }
    }
}
