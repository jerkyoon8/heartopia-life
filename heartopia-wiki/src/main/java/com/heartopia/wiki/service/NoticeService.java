package com.heartopia.wiki.service;

import com.heartopia.wiki.mapper.NoticeMapper;
import com.heartopia.wiki.model.Notice;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NoticeService {
    private final NoticeMapper noticeMapper;

    public List<Notice> getAllNotices() {
        return noticeMapper.findAll();
    }

    public List<Notice> getActiveNotices() {
        return noticeMapper.findActiveNotices();
    }

    public Notice getNoticeById(Long id) {
        return noticeMapper.findById(id);
    }

    public void addNotice(Notice notice) {
        notice.setIsActive(notice.getIsActive() != null ? notice.getIsActive() : true);
        noticeMapper.insert(notice);
    }

    public void updateNotice(Notice notice) {
        noticeMapper.update(notice);
    }

    public void deleteNotice(Long id) {
        noticeMapper.delete(id);
    }
}
