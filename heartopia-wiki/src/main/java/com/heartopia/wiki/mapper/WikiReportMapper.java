package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.WikiReport;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

/**
 * 위키 제보 데이터베이스 처리를 위한 MyBatis 매퍼 인터페이스
 */
@Mapper
public interface WikiReportMapper {
    /**
     * 새로운 제보 데이터를 테이블에 삽입합니다.
     */
    void insertReport(WikiReport report);

    /**
     * 모든 제보 내역을 생성일 역순으로 조회합니다.
     */
    List<WikiReport> findAllReports();
}
