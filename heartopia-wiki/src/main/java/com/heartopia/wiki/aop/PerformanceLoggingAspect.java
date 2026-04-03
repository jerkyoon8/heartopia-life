package com.heartopia.wiki.aop;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.util.StopWatch;

/**
 * [성능 모니터링 AOP]
 * 컨트롤러 및 서비스 메서드의 실행 시간을 자동 측정합니다.
 * 1초(1000ms)를 초과하는 슬로우 로직이 감지되면 WARN 레벨로 로그를 남깁니다.
 */
@Aspect
@Component
@Slf4j
public class PerformanceLoggingAspect {

    private static final long SLOW_THRESHOLD_MS = 1000;

    @Around("execution(* com.heartopia.wiki.controller..*(..)) || execution(* com.heartopia.wiki.service..*(..))")
    public Object measureExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        StopWatch stopWatch = new StopWatch();
        stopWatch.start();

        Object result = joinPoint.proceed();

        stopWatch.stop();
        long executionTimeMs = stopWatch.getTotalTimeMillis();

        if (executionTimeMs > SLOW_THRESHOLD_MS) {
            log.warn("[SLOW] {}.{} 실행 시간: {}ms (임계값 {}ms 초과!)",
                    joinPoint.getTarget().getClass().getSimpleName(),
                    joinPoint.getSignature().getName(),
                    executionTimeMs,
                    SLOW_THRESHOLD_MS);
        } else {
            log.debug("[PERF] {}.{} 실행 시간: {}ms",
                    joinPoint.getTarget().getClass().getSimpleName(),
                    joinPoint.getSignature().getName(),
                    executionTimeMs);
        }

        return result;
    }
}
