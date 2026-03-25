package com.heartopia.wiki.mapper;

import com.heartopia.wiki.model.Notice;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface NoticeMapper {
    List<Notice> findAll();
    List<Notice> findActiveNotices();
    Notice findById(Long id);
    void insert(Notice notice);
    void update(Notice notice);
    void delete(Long id);
    int countActiveNotices();
}
