package com.heartopia.wiki.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface UserChecklistMapper {
    List<Map<String, Object>> findByUserId(@Param("userId") Long userId);
    void upsertItem(@Param("userId") Long userId, @Param("itemKey") String itemKey, @Param("starRating") int starRating);
    void deleteItem(@Param("userId") Long userId, @Param("itemKey") String itemKey);
    void bulkUpsert(@Param("userId") Long userId, @Param("items") List<Map<String, Object>> items);
    void batchDelete(@Param("userId") Long userId, @Param("keys") List<String> keys);
    void deleteAll(@Param("userId") Long userId);
}
