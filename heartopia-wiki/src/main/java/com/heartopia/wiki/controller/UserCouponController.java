package com.heartopia.wiki.controller;

import com.heartopia.wiki.dto.oauth2.CustomOAuth2User;
import com.heartopia.wiki.service.UserCouponService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserCouponController {

    private final UserCouponService userCouponService;

    @GetMapping("/coupons")
    public List<String> getCoupons(@AuthenticationPrincipal CustomOAuth2User user) {
        return userCouponService.getCoupons(user.getUserId());
    }

    @PostMapping("/coupons")
    public void saveCoupon(@AuthenticationPrincipal CustomOAuth2User user,
                           @RequestBody String couponName) {
        userCouponService.saveCoupon(user.getUserId(), couponName);
    }

    @PostMapping("/coupons/migrate")
    public List<String> migrateCoupons(@AuthenticationPrincipal CustomOAuth2User user,
                                       @RequestBody List<String> localCoupons) {
        return userCouponService.mergeCoupons(user.getUserId(), localCoupons);
    }
}
