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

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf
                .ignoringRequestMatchers("/wiki/map/api/**") // API는 CSRF 일단 제외 (필요시 토큰 연동)
            )
            .authorizeHttpRequests(auth -> auth
                // 지도 데이터 조회(GET) 및 일반 페이지는 모두 허용
                .requestMatchers(AntPathRequestMatcher.antMatcher(org.springframework.http.HttpMethod.GET, "/wiki/map/api/**")).permitAll()
                
                // 지도 데이터 변경(POST, PUT, DELETE)은 ADMIN만 가능
                .requestMatchers(AntPathRequestMatcher.antMatcher(org.springframework.http.HttpMethod.POST, "/wiki/map/api/**")).hasRole("ADMIN")
                .requestMatchers(AntPathRequestMatcher.antMatcher(org.springframework.http.HttpMethod.PUT, "/wiki/map/api/**")).hasRole("ADMIN")
                .requestMatchers(AntPathRequestMatcher.antMatcher(org.springframework.http.HttpMethod.DELETE, "/wiki/map/api/**")).hasRole("ADMIN")

                // 관리자 페이지는 ADMIN만 가능
                .requestMatchers("/wiki/admin/**").hasRole("ADMIN")
                
                // 나머지는 모두 허용 (정적 리소스 포함)
                .anyRequest().permitAll()
            )
            .formLogin(form -> form
                .loginPage("/wiki/admin/login")
                .loginProcessingUrl("/wiki/admin/login")
                .defaultSuccessUrl("/wiki/admin/reports", true)
                .permitAll()
            )
            .logout(logout -> logout
                .logoutRequestMatcher(new AntPathRequestMatcher("/wiki/admin/logout"))
                .logoutSuccessUrl("/wiki")
                .deleteCookies("JSESSIONID")
                .invalidateHttpSession(true)
                .permitAll()
            );

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public UserDetailsService userDetailsService(PasswordEncoder passwordEncoder) {
        // 아이디: jerkyoon8, 비밀번호: !Dx11src02
        // 실제 운영시는 application-secret.properties에서 값을 가져오도록 개선 가능
        UserDetails admin = User.builder()
                .username("jerkyoon8")
                .password(passwordEncoder.encode("!Dx11src02")) // 비밀번호는 해시(BCrypt)로 인코딩되어 안전하게 저장됩니다.
                .roles("ADMIN")
                .build();

        return new InMemoryUserDetailsManager(admin);
    }
}
