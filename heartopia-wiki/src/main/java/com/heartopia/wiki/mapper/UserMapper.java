package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.Optional;

@Mapper
public interface UserMapper {
    /**
     * 공급자(google 등)와 해당 플랫폼의 고유 ID로 유저 검색
     */
    Optional<User> findByProviderAndProviderId(@Param("provider") String provider, @Param("providerId") String providerId);
    
    /**
     * 신규 소셜 로그인 유저 생성
     */
    void insertUser(User user);
    
    /**
     * 유저 정보(이메일, 닉네임) 갱신
     */
    void updateUser(User user);

    /**
     * 체크리스트 DB 동기화 opt-in 토글
     */
    void updateChecklistSyncEnabled(@Param("userId") Long userId, @Param("enabled") boolean enabled);
}
