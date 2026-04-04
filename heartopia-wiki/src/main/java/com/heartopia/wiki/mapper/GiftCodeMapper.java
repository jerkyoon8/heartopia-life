package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.GiftCode;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface GiftCodeMapper {
    // 모든 코드 조회
    List<GiftCode> findAll();
    
    // 상태별 코드 조회 (ACTIVE, EXPIRED 등)
    List<GiftCode> findByStatus(String status);

    // 새 기프트코드 추가
    void insertGiftCode(GiftCode giftCode);
    void updateGiftCode(GiftCode giftCode);
    void deleteGiftCode(Long id);
}
