package com.heartopia.wiki.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

@Slf4j
@Component
public class RateLimitInterceptor implements HandlerInterceptor {

    private static final int MAX_ENTRIES = 1000;
    private static final int MAX_REQUESTS_PER_HOUR = 5;
    private static final long ONE_HOUR_MS = 60 * 60 * 1000L;

    // LRU Cache: 메모리 누수 방지를 위해 가장 오래된 접속 IP 자동 삭제 + 스레드 세이프
    private final Map<String, Queue<Long>> requestCounts = Collections.synchronizedMap(
            new LinkedHashMap<String, Queue<Long>>(MAX_ENTRIES + 1, .75F, true) {
                @Override
                protected boolean removeEldestEntry(Map.Entry<String, Queue<Long>> eldest) {
                    return size() > MAX_ENTRIES;
                }
            });

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // POST 요청 (글 작성 시도)만 검사하여 통신 차단
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String clientIp = getClientIp(request);
        long currentTime = System.currentTimeMillis();

        requestCounts.putIfAbsent(clientIp, new ConcurrentLinkedQueue<>());
        Queue<Long> requests = requestCounts.get(clientIp);

        // 1시간이 지난 과거 요청 기록 정리
        while (!requests.isEmpty() && currentTime - requests.peek() > ONE_HOUR_MS) {
            requests.poll();
        }

        if (requests.size() >= MAX_REQUESTS_PER_HOUR) {
            log.warn("Rate limit 도배 차단 동작 (IP: {})", clientIp);
            response.setStatus(429); // HTTP 429 Too Many Requests
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("error: 도배 방지를 위해 1시간에 5번까지만 제보가 가능합니다.");
            return false;
        }

        requests.offer(currentTime);
        return true;
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // X-Forwarded-For는 프록시를 여러 개 타면 다수의 IP가 오므로 첫 번째(실 사용자기기) IP 추출
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
}
