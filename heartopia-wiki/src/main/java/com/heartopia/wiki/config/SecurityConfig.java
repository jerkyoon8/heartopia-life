package com.heartopia.wiki.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import com.heartopia.wiki.service.CustomOAuth2UserService;
import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final CustomOAuth2UserService customOAuth2UserService;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        // 지도 데이터 조회(GET) 및 일반 페이지는 모두 허용
                        .requestMatchers(AntPathRequestMatcher.antMatcher(org.springframework.http.HttpMethod.GET,
                                "/wiki/map/api/**"))
                        .permitAll()

                        // 지도 데이터 변경(POST, PUT, DELETE)은 ADMIN만 가능
                        .requestMatchers(AntPathRequestMatcher
                                .antMatcher(org.springframework.http.HttpMethod.POST, "/wiki/map/api/**"))
                        .hasRole("ADMIN")
                        .requestMatchers(AntPathRequestMatcher
                                .antMatcher(org.springframework.http.HttpMethod.PUT, "/wiki/map/api/**"))
                        .hasRole("ADMIN")
                        .requestMatchers(AntPathRequestMatcher.antMatcher(org.springframework.http.HttpMethod.DELETE,
                                "/wiki/map/api/**"))
                        .hasRole("ADMIN")

                        // 관리자 페이지는 ADMIN만 가능
                        .requestMatchers("/wiki/admin/**").hasRole("ADMIN")

                        // 개인정보처리방침/OAuth2는 비로그인 포함 모두 허용
                        .requestMatchers("/wiki/privacy", "/oauth2/**", "/login/oauth2/**").permitAll()

                        // 나머지는 모두 허용 (정적 리소스 포함)
                        .anyRequest().permitAll())
                .formLogin(form -> form
                        .loginPage("/wiki/admin/login")
                        .loginProcessingUrl("/wiki/admin/login")
                        .defaultSuccessUrl("/wiki", true)
                        .permitAll())
                .oauth2Login(oauth2 -> oauth2
                        .loginPage("/wiki/login")
                        .defaultSuccessUrl("/wiki", true)
                        .userInfoEndpoint(userInfo -> userInfo
                                .userService(customOAuth2UserService))
                )
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/wiki/admin/logout"))
                        .logoutSuccessUrl("/wiki")
                        .deleteCookies("JSESSIONID")
                        .invalidateHttpSession(true)
                        .permitAll());

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @org.springframework.beans.factory.annotation.Value("${wiki.admin.username}")
    private String adminUsername;

    @org.springframework.beans.factory.annotation.Value("${wiki.admin.password}")
    private String adminPassword;

    @Bean
    public UserDetailsService userDetailsService(PasswordEncoder passwordEncoder) {
        UserDetails admin = User.builder()
                .username(adminUsername)
                .password(passwordEncoder.encode(adminPassword))
                .roles("ADMIN")
                .build();

        return new InMemoryUserDetailsManager(admin);
    }
}
