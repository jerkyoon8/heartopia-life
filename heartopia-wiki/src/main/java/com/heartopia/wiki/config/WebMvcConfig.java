package com.heartopia.wiki.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 업로드된 이미지 파일을 정적 리소스로 서빙하기 위한 설정
 * /uploads/** URL 요청 시 서버의 업로드 디렉토리에서 파일을 찾아 서빙
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${app.upload.dir:./uploads}")
    private String uploadDir;

    @Override
    public void addResourceHandlers(@org.springframework.lang.NonNull ResourceHandlerRegistry registry) {
        // /uploads/** URL 패턴을 외부 업로드 디렉토리에 매핑
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadDir + "/")
                .setCachePeriod(3600);
    }
}
