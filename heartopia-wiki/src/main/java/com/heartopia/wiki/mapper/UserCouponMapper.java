package com.heartopia.wiki.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface UserCouponMapper {
    List<String> findCouponNamesByUserId(@Param("userId") Long userId);
    void insertCoupon(@Param("userId") Long userId, @Param("couponName") String couponName);
    void insertCoupons(@Param("userId") Long userId, @Param("couponNames") List<String> couponNames);
}
