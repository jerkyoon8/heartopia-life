package com.heartopia.wiki.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 * 이미지 파일 업로드/삭제 서비스
 * - 카테고리별 하위 디렉토리에 파일 저장
 * - 파일명 중복 방지 (타임스탬프 접두어)
 * - 수정 시 기존 파일 삭제
 */
@Slf4j
@Service
public class FileUploadService {

    @Value("${app.upload.dir:./uploads}")
    private String uploadDir;

    /**
     * 파일 업로드
     * @param file 업로드할 파일
     * @param category 카테고리 (fish, bird, bug, animal, forageable, cook, crop, flower)
     * @return 접근 가능한 URL 경로 (예: /uploads/images/fish/1712345678_참돔.png)
     */
    public String upload(MultipartFile file, String category) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }

        // 카테고리별 디렉토리 생성
        Path categoryDir = Paths.get(uploadDir, "images", category);
        Files.createDirectories(categoryDir);

        // 파일명 중복 방지: 타임스탬프_원본파일명
        String originalFilename = file.getOriginalFilename();
        String safeFilename = System.currentTimeMillis() + "_" + originalFilename;
        Path targetPath = categoryDir.resolve(safeFilename);

        // 파일 저장
        Files.copy(file.getInputStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);
        log.info("이미지 업로드 완료: {}", targetPath);

        // URL 경로 반환
        return "/uploads/images/" + category + "/" + safeFilename;
    }

    /**
     * 기존 이미지 파일 삭제
     * @param imageUrl DB에 저장된 이미지 URL (예: /uploads/images/fish/1712345678_참돔.png)
     */
    public void delete(String imageUrl) {
        if (imageUrl == null || imageUrl.isBlank()) {
            return;
        }

        // /uploads/ 로 시작하는 업로드 파일만 삭제 (기존 static 이미지는 건드리지 않음)
        if (!imageUrl.startsWith("/uploads/")) {
            log.debug("기존 static 이미지는 삭제하지 않음: {}", imageUrl);
            return;
        }

        try {
            // URL에서 실제 파일 경로 계산: /uploads/images/fish/xxx.png → ./uploads/images/fish/xxx.png
            String relativePath = imageUrl.substring("/uploads/".length());
            Path filePath = Paths.get(uploadDir, relativePath);

            if (Files.exists(filePath)) {
                Files.delete(filePath);
                log.info("이미지 삭제 완료: {}", filePath);
            }
        } catch (IOException e) {
            log.error("이미지 삭제 실패: {}", imageUrl, e);
        }
    }
}
