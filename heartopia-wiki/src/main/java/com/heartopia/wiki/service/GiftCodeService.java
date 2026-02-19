package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.GiftCodeMapper;
import com.heartopia.wiki.model.GiftCode;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class GiftCodeService {

    private final GiftCodeMapper giftCodeMapper;

    public GiftCodeService(GiftCodeMapper giftCodeMapper) {
        this.giftCodeMapper = giftCodeMapper;
    }

    public List<GiftCode> getAllCodes() {
        return giftCodeMapper.findAll();
    }

    // 화면에 보여줄 때 활성/만료 코드를 구분해서 맵으로 리턴
    public Map<String, List<GiftCode>> getCodesGroupedByStatus() {
        List<GiftCode> allCodes = giftCodeMapper.findAll();
        
        Map<String, List<GiftCode>> groupedCodes = new HashMap<>();
        
        LocalDate today = LocalDate.now();

        // 1. 만료된 코드 (expirationDate가 있고, 오늘 날짜보다 이전인 경우)
        List<GiftCode> expiredCodes = allCodes.stream()
                .filter(code -> {
                    // DB status가 EXPIRED이거나, 날짜가 지난 경우
                    if ("EXPIRED".equals(code.getStatus())) return true;
                    return code.getExpirationDate() != null && code.getExpirationDate().isBefore(today);
                })
                .collect(Collectors.toList());

        // 2. 활성 코드 (만료되지 않은 코드)
        List<GiftCode> activeCodes = allCodes.stream()
                .filter(code -> {
                    // 이미 만료 리스트에 들어간 건 제외
                    if ("EXPIRED".equals(code.getStatus())) return false;
                    return code.getExpirationDate() == null || !code.getExpirationDate().isBefore(today);
                })
                .peek(code -> {
                    // 날짜 계산해서 상태 업데이트 (메모리상에서만)
                    if (code.getExpirationDate() != null) {
                        long daysLeft = java.time.temporal.ChronoUnit.DAYS.between(today, code.getExpirationDate());
                        if (daysLeft <= 3) {
                            code.setStatus("SOON");
                        } else {
                            code.setStatus("ACTIVE");
                        }
                    } else {
                        // 날짜 없으면 무조건 ACTIVE
                        code.setStatus("ACTIVE");
                    }
                })
                .collect(Collectors.toList());

        groupedCodes.put("active", activeCodes);
        groupedCodes.put("expired", expiredCodes);
        
        return groupedCodes;
    }
}
