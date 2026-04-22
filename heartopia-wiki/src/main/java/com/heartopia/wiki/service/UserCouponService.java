package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.UserCouponMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserCouponService {

    private final UserCouponMapper userCouponMapper;

    public List<String> getCoupons(Long userId) {
        return userCouponMapper.findCouponNamesByUserId(userId);
    }

    @Transactional
    public void saveCoupon(Long userId, String couponName) {
        userCouponMapper.insertCoupon(userId, couponName);
    }

    @Transactional
    public List<String> mergeCoupons(Long userId, List<String> localCoupons) {
        if (localCoupons != null && !localCoupons.isEmpty()) {
            userCouponMapper.insertCoupons(userId, localCoupons);
        }
        return userCouponMapper.findCouponNamesByUserId(userId);
    }
}
