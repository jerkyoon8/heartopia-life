package com.heartopia.wiki.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class IndexController {

    @GetMapping("/")
    public String index() {
        // localhost:8080 접속 시 /wiki로 자동 리다이렉트
        return "redirect:/wiki";
    }
}
