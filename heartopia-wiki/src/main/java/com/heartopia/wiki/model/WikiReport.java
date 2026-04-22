package com.heartopia.wiki.model;

import lombok.Data;
import jakarta.validation.constraints.*;
import java.time.LocalDateTime;

/**
 * 위키 정보 수정 제보를 위한 도메인 모델 클래스
 * 사용자가 상세 페이지에서 제보한 내용을 담습니다.
 */
@Data
public class WikiReport {
    private Integer id; // 고유 번호 (PK)
    
    @NotBlank(message = "카테고리는 필수 선택 사항입니다.")
    private String category; // 제보 분류 (BUG, CONTRIBUTION, HELP, BUSINESS, GENERAL)
    
    @NotBlank(message = "이름을 입력해주세요.")
    @Size(max = 100, message = "이름은 100자 이내로 입력해주세요.")
    private String reporterName; // 제보자 성함
    
    private boolean isPublic; // 공개 여부
    private boolean isDeleted; // 삭제(숨김) 여부
    
    @NotBlank(message = "내용을 입력해주세요.")
    @Size(max = 2000, message = "내용은 2000자 이내로 입력해주세요.")
    private String message; // 제보 내용
    
    private String sourceUrl; // 제보가 발생한 원본 페이지 URL
    private String itemName; // 대상 아이템 이름
    private LocalDateTime createdAt; // 제보 일시
    private String adminReply; // 관리자 답변
    private LocalDateTime repliedAt; // 답변 일시
}
