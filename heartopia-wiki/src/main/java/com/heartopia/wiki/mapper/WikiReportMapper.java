package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.WikiReport;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
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

    /**
     * 공개 승인된 제보 내역만 목록용으로 조회합니다.
     */
    List<WikiReport> findPublicReports();

    /**
     * 공개 승인된 제보 내역을 페이지네이션하여 조회합니다.
     *
     * @param offset 조회 시작 위치 (0-based)
     * @param size   한 페이지당 표시할 건수
     */
    List<WikiReport> findPublicReportsPaged(@Param("offset") int offset, @Param("size") int size);

    /**
     * 공개 승인된 제보의 전체 건수를 조회합니다.
     */
    int countPublicReports();

    /**
     * 제보의 공개 상태를 변경합니다.
     */
    void updatePublicStatus(@Param("id") Integer id, @Param("isPublic") boolean isPublic);

    /**
     * 제보를 소프트 삭제(숨김) 처리합니다.
     */
    void updateDeleteStatus(@Param("id") Integer id);

    /**
     * 관리자 답변을 저장합니다.
     */
    void updateAdminReply(@Param("id") Integer id, @Param("adminReply") String adminReply);
}
