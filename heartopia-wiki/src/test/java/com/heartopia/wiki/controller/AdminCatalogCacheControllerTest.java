package com.heartopia.wiki.controller;

import com.heartopia.wiki.config.SecurityConfig;
import com.heartopia.wiki.service.CatalogCacheService;
import com.heartopia.wiki.service.CustomOAuth2UserService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.mock.web.MockServletContext;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextImpl;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.web.FilterChainProxy;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

class AdminCatalogCacheControllerTest {
    private AnnotationConfigWebApplicationContext context;
    private MockMvc mvc;
    private CatalogCacheService service;

    @BeforeEach
    void setUp() {
        context = new AnnotationConfigWebApplicationContext();
        context.setServletContext(new MockServletContext());
        context.register(TestConfig.class);
        context.refresh();
        service = context.getBean(CatalogCacheService.class);
        mvc = MockMvcBuilders.webAppContextSetup(context)
                .addFilters(context.getBean(FilterChainProxy.class)).build();
    }

    @AfterEach
    void tearDown() {
        context.close();
    }

    @Test
    void adminCanClearWithCsrfWithoutLosingSession() throws Exception {
        MockHttpSession session = session("ADMIN");
        session.setAttribute("collectionProgress", "saved");
        String originalId = session.getId();
        MvcResult page = mvc.perform(get("/wiki/admin/catalog-cache").session(session))
                .andExpect(status().isOk()).andExpect(view().name("wiki/admin-catalog-cache")).andReturn();
        verifyNoInteractions(service);
        CsrfToken token = (CsrfToken) page.getRequest().getAttribute(CsrfToken.class.getName());
        mvc.perform(post("/wiki/admin/catalog-cache/clear").session(session)
                        .param(token.getParameterName(), token.getToken()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/wiki/admin/catalog-cache"))
                .andExpect(flash().attributeExists("successMessage"));
        verify(service).clearCatalogCaches();
        assertThat(session.isInvalid()).isFalse();
        assertThat(session.getId()).isEqualTo(originalId);
        assertThat(session.getAttribute("collectionProgress")).isEqualTo("saved");
        SecurityContextImpl security = (SecurityContextImpl) session.getAttribute(
                HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY);
        assertThat(security.getAuthentication().isAuthenticated()).isTrue();
        mvc.perform(get("/wiki/admin/catalog-cache").session(session)).andExpect(status().isOk());
    }

    @Test
    void missingCsrfDoesNotClearCaches() throws Exception {
        mvc.perform(post("/wiki/admin/catalog-cache/clear").session(session("ADMIN")))
                .andExpect(status().isForbidden());
        verifyNoInteractions(service);
    }

    @Test
    void ordinaryUserCannotViewOrClearEvenWithValidCsrf() throws Exception {
        MockHttpSession session = session("USER");
        MvcResult page = mvc.perform(get("/wiki/admin/catalog-cache").session(session))
                .andExpect(status().isForbidden()).andReturn();
        CsrfToken token = (CsrfToken) page.getRequest().getAttribute(CsrfToken.class.getName());
        mvc.perform(post("/wiki/admin/catalog-cache/clear").session(session)
                        .param(token.getParameterName(), token.getToken()))
                .andExpect(status().isForbidden());
        verifyNoInteractions(service);
    }

    @Test
    void anonymousUserIsSentToLoginAndGetCannotClear() throws Exception {
        mvc.perform(get("/wiki/admin/catalog-cache"))
                .andExpect(status().is3xxRedirection()).andExpect(redirectedUrl("http://localhost/wiki/login"));
        mvc.perform(get("/wiki/admin/catalog-cache/clear").session(session("ADMIN")))
                .andExpect(status().isMethodNotAllowed());
        verifyNoInteractions(service);
    }

    private MockHttpSession session(String role) {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY,
                new SecurityContextImpl(new UsernamePasswordAuthenticationToken(
                        "test-admin", "unused", List.of(new SimpleGrantedAuthority("ROLE_" + role)))));
        return session;
    }

    @Configuration
    @EnableWebMvc
    @Import({SecurityConfig.class, AdminCatalogCacheController.class})
    static class TestConfig {
        @Bean CatalogCacheService catalogCacheService() { return mock(CatalogCacheService.class); }
        @Bean CustomOAuth2UserService oauth2UserService() { return mock(CustomOAuth2UserService.class); }
        @Bean InternalResourceViewResolver viewResolver() {
            return new InternalResourceViewResolver("/templates/", ".html");
        }
        @Bean ClientRegistrationRepository clientRegistrationRepository() {
            return new InMemoryClientRegistrationRepository(ClientRegistration.withRegistrationId("test")
                    .clientId("test").clientSecret("test")
                    .authorizationGrantType(AuthorizationGrantType.AUTHORIZATION_CODE)
                    .redirectUri("{baseUrl}/login/oauth2/code/{registrationId}")
                    .authorizationUri("https://example.invalid/authorize")
                    .tokenUri("https://example.invalid/token")
                    .userInfoUri("https://example.invalid/userinfo")
                    .userNameAttributeName("id").clientName("test").build());
        }
    }
}
