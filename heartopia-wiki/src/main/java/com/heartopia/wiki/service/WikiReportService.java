package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.WikiReportMapper;
import com.heartopia.wiki.model.WikiReport;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/**
 * 위키 제보 관련 비즈니스 로직을 처리하는 서비스 클래스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WikiReportService {
    private final WikiReportMapper reportMapper;

    /**
     * 새로운 제보를 데이터베이스에 저장합니다.
     * 
     * @param report 저장할 제보 정보
     */
    @Transactional
    public void saveReport(WikiReport report) {
        // 기본 유효성 검사 (서버측 보안 강화)
        if (report.getReporterName() == null || report.getReporterName().trim().isEmpty()) {
            throw new IllegalArgumentException("제보자 이름은 필수입니다.");
        }
        if (report.getMessage() == null || report.getMessage().trim().isEmpty()) {
            throw new IllegalArgumentException("제보 내용은 필수입니다.");
        }

        try {
            reportMapper.insertReport(report);
            log.info("새로운 위키 제보가 접수되었습니다. 아이템: {}, 제보자: {}", report.getItemName(), report.getReporterName());
        } catch (Exception e) {
            log.error("제보 저장 중 오류 발생: {}", e.getMessage(), e);
            throw new RuntimeException("제보를 저장하는 도중 서버 오류가 발생했습니다.");
        }
    }

    /**
     * 모든 제보 내역을 관리자용으로 조회합니다.
     * 
     * @return 제보 목록 (최신순)
     */
    @Transactional(readOnly = true)
    public List<WikiReport> getAllReports() {
        return reportMapper.findAllReports();
    }
}
