package com.heartopia.wiki.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserPetFoodMapper {
    String findPetsJsonByUserId(@Param("userId") Long userId);

    void upsertPetsJson(@Param("userId") Long userId, @Param("petsJson") String petsJson);

    void deleteByUserId(@Param("userId") Long userId);
}
