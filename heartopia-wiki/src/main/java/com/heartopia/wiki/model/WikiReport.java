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
    
    @Email(message = "올바른 이메일 형식이 아닙니다.")
    @Size(max = 200, message = "이메일은 200자 이내로 입력해주세요.")
    private String reporterEmail; // 제보자 연락처 (이메일, 선택 사항)
    
    @NotBlank(message = "내용을 입력해주세요.")
    @Size(max = 2000, message = "내용은 2000자 이내로 입력해주세요.")
    private String message; // 제보 내용
    
    private String sourceUrl; // 제보가 발생한 원본 페이지 URL
    private String itemName; // 대상 아이템 이름
    private LocalDateTime createdAt; // 제보 일시
}
