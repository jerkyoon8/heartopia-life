package com.heartopia.wiki.controller;

import com.fasterxml.jackson.databind.*;
import com.heartopia.wiki.mapper.DynamicMapResourceMapper;
import com.heartopia.wiki.model.DynamicMapResource;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfEnvironmentVariable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextImpl;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.test.web.servlet.*;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.UUID;
import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

// Opt-in local database verification; all test writes roll back. Never connect to production.
@SpringBootTest(properties="spring.datasource.url=jdbc:mysql://127.0.0.1:3306/heartopia_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true")
@AutoConfigureMockMvc @Transactional
@EnabledIfEnvironmentVariable(named="HEARTOPIA_LOCAL_DB_TESTS",matches="true")
class MapTrendLocalIntegrationTest {
    @Autowired MockMvc mvc;
    @Autowired ObjectMapper json;
    @Autowired DynamicMapResourceMapper resources;
    MockHttpSession admin(){
        MockHttpSession s=new MockHttpSession();
        s.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY,
            new SecurityContextImpl(new UsernamePasswordAuthenticationToken("local-test","",List.of(new SimpleGrantedAuthority("ROLE_ADMIN")))));
        return s;
    }
    @Test void newSeasonTreeCanBeRegisteredEditedRenamedAndItsPinMovedDeleted() throws Exception {
        MockHttpSession s=admin();
        CsrfToken t=(CsrfToken)mvc.perform(get("/wiki/map/api/dynamic-resources").session(s)).andReturn().getRequest().getAttribute(CsrfToken.class.getName());
        String name="검증나무_"+UUID.randomUUID();
        String created=mvc.perform(post("/wiki/map/api/dynamic-resources").session(s).param(t.getParameterName(),t.getToken())
            .param("mapKey","town").param("name",name).param("eventName","검증 다음 시즌")
            .param("imageMode","PRESET").param("iconUrl","/images/map/dynamic-resources/oak.webp"))
            .andExpect(status().isOk()).andReturn().getResponse().getContentAsString();
        long id=json.readTree(created).get("id").asLong();
        String pin=mvc.perform(post("/wiki/map/api/pins").session(s).header(t.getHeaderName(),t.getToken()).contentType("application/json")
            .content(json.writeValueAsString(java.util.Map.of("mapKey","town","category","dynamic_resource","name",name,"mapX",100,"mapY",200))))
            .andExpect(status().isOk()).andReturn().getResponse().getContentAsString();
        long pinId=json.readTree(pin).get("id").asLong();
        mvc.perform(put("/wiki/map/api/dynamic-resources/"+id).session(s).param(t.getParameterName(),t.getToken())
            .param("name",name+"수정").param("eventName","검증 다음 시즌").param("description","수정 설명")
            .param("imageMode","PRESET").param("iconUrl","/images/map/dynamic-resources/fluorite.webp")).andExpect(status().isOk());
        JsonNode pins=json.readTree(mvc.perform(get("/wiki/map/api/pins?mapKey=town")).andReturn().getResponse().getContentAsString());
        JsonNode updated=null;for(JsonNode p:pins)if(p.path("id").asLong()==pinId)updated=p;
        assertThat(updated).isNotNull(); assertThat(updated.get("name").asText()).isEqualTo(name+"수정");
        assertThat(updated.get("mapX").asInt()).isEqualTo(100);
        assertThat(updated.get("iconUrl").asText()).isEqualTo("/images/map/dynamic-resources/fluorite.webp");
        mvc.perform(post("/wiki/map/api/dynamic-resources/rename-event").session(s).param(t.getParameterName(),t.getToken())
            .param("mapKey","town").param("oldName","검증 다음 시즌").param("newName","검증 시즌 수정")).andExpect(status().isOk());
        assertThat(resources.findById(id).getEventName()).isEqualTo("검증 시즌 수정");
        mvc.perform(put("/wiki/map/api/pins/"+pinId+"/position").session(s).header(t.getHeaderName(),t.getToken()).contentType("application/json")
            .content("{\"mapX\":300,\"mapY\":400}")).andExpect(status().isOk());
        mvc.perform(delete("/wiki/map/api/pins/"+pinId).session(s).header(t.getHeaderName(),t.getToken())).andExpect(status().isOk());
        assertThat(s.isInvalid()).isFalse();
    }
    @Test void linkedMushroomUsesForageablePinAndRejectsDuplicateDynamicPin() throws Exception {
        MockHttpSession s=admin();
        CsrfToken t=(CsrfToken)mvc.perform(get("/wiki/map/api/dynamic-resources").session(s)).andReturn().getRequest().getAttribute(CsrfToken.class.getName());
        DynamicMapResource entry=resources.findByMapKeyAndName("town","뽕나무버섯");
        assertThat(entry).isNotNull(); assertThat(entry.getForageableId()).isNotNull();
        mvc.perform(post("/wiki/map/api/pins").session(s).header(t.getHeaderName(),t.getToken()).contentType("application/json")
            .content("{\"mapKey\":\"town\",\"category\":\"dynamic_resource\",\"name\":\"뽕나무버섯\",\"mapX\":100,\"mapY\":200}"))
            .andExpect(status().isBadRequest());
        mvc.perform(post("/wiki/map/api/pins").session(s).header(t.getHeaderName(),t.getToken()).contentType("application/json")
            .content("{\"mapKey\":\"town\",\"category\":\"forageable\",\"name\":\"뽕나무버섯\",\"mapX\":100,\"mapY\":200}"))
            .andExpect(status().isOk());
        JsonNode pins=json.readTree(mvc.perform(get("/wiki/map/api/pins?mapKey=town")).andReturn().getResponse().getContentAsString());
        int count=0;for(JsonNode p:pins)if(p.path("name").asText().equals("뽕나무버섯")){count++;assertThat(p.path("category").asText()).isEqualTo("forageable");}
        assertThat(count).isEqualTo(1);
    }
}
