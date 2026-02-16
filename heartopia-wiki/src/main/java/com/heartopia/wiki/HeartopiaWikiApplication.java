package com.heartopia.wiki;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.heartopia.wiki.mapper")
public class HeartopiaWikiApplication {

	public static void main(String[] args) {
		SpringApplication.run(HeartopiaWikiApplication.class, args);
	}

}
