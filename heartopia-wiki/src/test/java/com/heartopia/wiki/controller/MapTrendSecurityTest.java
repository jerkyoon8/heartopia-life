package com.heartopia.wiki.controller;

import com.heartopia.wiki.config.SecurityConfig;
import com.heartopia.wiki.mapper.LocationZoneMapper;
import com.heartopia.wiki.service.*;
import org.junit.jupiter.api.*;
import org.springframework.context.annotation.*;
import org.springframework.mock.web.*;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextImpl;
import org.springframework.security.oauth2.client.registration.*;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.web.FilterChainProxy;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.test.web.servlet.*;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import java.util.List;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

class MapTrendSecurityTest {
    AnnotationConfigWebApplicationContext context;
    MockMvc mvc;
    DynamicMapResourceService service;
    @BeforeEach void setup() {
        context=new AnnotationConfigWebApplicationContext(); context.setServletContext(new MockServletContext());
        context.register(Config.class); context.refresh();
        service=context.getBean(DynamicMapResourceService.class);
        mvc=MockMvcBuilders.webAppContextSetup(context).addFilters(context.getBean(FilterChainProxy.class)).build();
    }
    @AfterEach void close(){context.close();}
    MockHttpSession session(String role){
        MockHttpSession s=new MockHttpSession();
        s.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY,
            new SecurityContextImpl(new UsernamePasswordAuthenticationToken("test","",List.of(new SimpleGrantedAuthority("ROLE_"+role)))));
        return s;
    }
    CsrfToken token(MockHttpSession s) throws Exception {
        return (CsrfToken)mvc.perform(get("/wiki/map/api/dynamic-resources").session(s)).andReturn().getRequest().getAttribute(CsrfToken.class.getName());
    }
    @Test void ordinaryUserCannotCreateEditOrRenameSeason() throws Exception {
        MockHttpSession s=session("USER"); CsrfToken t=token(s); clearInvocations(service);
        mvc.perform(post("/wiki/map/api/dynamic-resources").session(s).param(t.getParameterName(),t.getToken()).param("name","나무")).andExpect(status().isForbidden());
        mvc.perform(put("/wiki/map/api/dynamic-resources/1").session(s).param(t.getParameterName(),t.getToken()).param("name","나무")).andExpect(status().isForbidden());
        mvc.perform(post("/wiki/map/api/dynamic-resources/rename-event").session(s).param(t.getParameterName(),t.getToken()).param("mapKey","town").param("oldName","전").param("newName","후")).andExpect(status().isForbidden());
        verifyNoInteractions(service);
    }
    @Test void adminCanEditAndRenameWithCsrf() throws Exception {
        MockHttpSession s=session("ADMIN"); CsrfToken t=token(s);
        mvc.perform(put("/wiki/map/api/dynamic-resources/1").session(s).param(t.getParameterName(),t.getToken()).param("name","속이 빈 나무").param("eventName","다음 시즌").param("description","숲속 섬")).andExpect(status().isOk());
        verify(service).update(1L,"속이 빈 나무","다음 시즌","숲속 섬");
        mvc.perform(post("/wiki/map/api/dynamic-resources/rename-event").session(s).param(t.getParameterName(),t.getToken()).param("mapKey","town").param("oldName","다음 시즌").param("newName","새 시즌")).andExpect(status().isOk());
        verify(service).renameEvent("town","다음 시즌","새 시즌");
    }
    @Test void adminMutationWithoutCsrfIsForbidden() throws Exception {
        mvc.perform(put("/wiki/map/api/dynamic-resources/1").session(session("ADMIN")).param("name","나무")).andExpect(status().isForbidden());
        verifyNoInteractions(service);
    }
    @Configuration @EnableWebMvc @Import({SecurityConfig.class,MapController.class})
    static class Config {
        @Bean DynamicMapResourceService resourceService(){return mock(DynamicMapResourceService.class);}
        @Bean CustomOAuth2UserService oauth(){return mock(CustomOAuth2UserService.class);}
        @Bean CollectionService collections(){return mock(CollectionService.class);}
        @Bean MapPinService pins(){return mock(MapPinService.class);}
        @Bean VillagerService villagers(){return mock(VillagerService.class);}
        @Bean LocationZoneMapper zones(){return mock(LocationZoneMapper.class);}
        @Bean FileUploadService uploads(){return mock(FileUploadService.class);}
        @Bean ClientRegistrationRepository registrations(){return new InMemoryClientRegistrationRepository(ClientRegistration.withRegistrationId("test")
            .clientId("test").clientSecret("test").authorizationGrantType(AuthorizationGrantType.AUTHORIZATION_CODE)
            .redirectUri("{baseUrl}/login/oauth2/code/{registrationId}").authorizationUri("https://example.invalid/auth")
            .tokenUri("https://example.invalid/token").userInfoUri("https://example.invalid/user")
            .userNameAttributeName("id").clientName("test").build());}
    }
}
