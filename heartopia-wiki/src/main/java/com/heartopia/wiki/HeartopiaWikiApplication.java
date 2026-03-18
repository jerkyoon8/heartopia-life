package com.heartopia.wiki;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@MapperScan("com.heartopia.wiki.mapper")
@EnableCaching  // Spring Cache 활성화 (기본: JVM 인메모리 캐시)
public class HeartopiaWikiApplication {

	public static void main(String[] args) {
		SpringApplication.run(HeartopiaWikiApplication.class, args);
	}

}
