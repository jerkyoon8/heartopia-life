package com.heartopia.wiki.controller;

import com.heartopia.wiki.model.*;
import com.heartopia.wiki.service.CollectionService;
import com.heartopia.wiki.service.FileUploadService;
import com.heartopia.wiki.service.GiftCodeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * 관리자 전용 데이터 CRUD 컨트롤러
 * - 모든 엔드포인트는 /wiki/admin/data/** 하위에 배치
 * - SecurityConfig에서 /wiki/admin/** 패턴으로 ROLE_ADMIN 보호됨
 * - 이미지 파일 업로드 지원 (MultipartFile)
 */
@Slf4j
@Controller
@RequestMapping("/wiki/admin/data")
@RequiredArgsConstructor
public class AdminDataController {

    private final CollectionService collectionService;
    private final GiftCodeService giftCodeService;
    private final FileUploadService fileUploadService;

    // ======================== 쿠폰 (Gift Code) ========================
    @PostMapping("/giftcode/add")
    public String addGiftCode(GiftCode giftCode) {
        log.info("관리자 데이터 추가: 기프트코드 '{}'", giftCode.getCodeName());
        giftCodeService.addGiftCode(giftCode);
        return "redirect:/wiki/codes";
    }

    @PostMapping("/giftcode/update")
    public String updateGiftCode(GiftCode giftCode) {
        log.info("관리자 데이터 수정: 기프트코드 id={}", giftCode.getId());
        giftCodeService.updateGiftCode(giftCode);
        return "redirect:/wiki/codes";
    }

    @PostMapping("/giftcode/delete/{id}")
    public String deleteGiftCode(@PathVariable Long id) {
        log.info("관리자 데이터 삭제: 기프트코드 id={}", id);
        giftCodeService.deleteGiftCode(id);
        return "redirect:/wiki/codes";
    }

    // ======================== 물고기 ========================
    @PostMapping("/fish/add")
    public String addFish(FishCollection fish,
                          @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) throws IOException {
        log.info("관리자 데이터 추가: 물고기 '{}'", fish.getName());
        handleImageUpload(fish, imageFile, "fish", null);
        collectionService.addFish(fish);
        return "redirect:/wiki/collections/fish";
    }

    @PostMapping("/fish/update")
    public String updateFish(FishCollection fish,
                             @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                             @RequestParam(value = "existingImageUrl", required = false) String existingImageUrl) throws IOException {
        log.info("관리자 데이터 수정: 물고기 id={}", fish.getId());
        handleImageUpload(fish, imageFile, "fish", existingImageUrl);
        collectionService.updateFish(fish);
        return "redirect:/wiki/collections/fish";
    }

    @PostMapping("/fish/delete/{id}")
    public String deleteFish(@PathVariable Integer id) {
        log.info("관리자 데이터 삭제: 물고기 id={}", id);
        collectionService.deleteFish(id);
        return "redirect:/wiki/collections/fish";
    }

    // ======================== 벌레 ========================
    @PostMapping("/bug/add")
    public String addBug(BugCollection bug,
                         @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) throws IOException {
        log.info("관리자 데이터 추가: 벌레 '{}'", bug.getName());
        handleImageUpload(bug, imageFile, "bug", null);
        collectionService.addBug(bug);
        return "redirect:/wiki/collections/bug";
    }

    @PostMapping("/bug/update")
    public String updateBug(BugCollection bug,
                            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                            @RequestParam(value = "existingImageUrl", required = false) String existingImageUrl) throws IOException {
        log.info("관리자 데이터 수정: 벌레 id={}", bug.getId());
        handleImageUpload(bug, imageFile, "bug", existingImageUrl);
        collectionService.updateBug(bug);
        return "redirect:/wiki/collections/bug";
    }

    @PostMapping("/bug/delete/{id}")
    public String deleteBug(@PathVariable Integer id) {
        log.info("관리자 데이터 삭제: 벌레 id={}", id);
        collectionService.deleteBug(id);
        return "redirect:/wiki/collections/bug";
    }

    // ======================== 새 ========================
    @PostMapping("/bird/add")
    public String addBird(BirdCollection bird,
                          @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) throws IOException {
        log.info("관리자 데이터 추가: 새 '{}'", bird.getName());
        handleImageUpload(bird, imageFile, "bird", null);
        collectionService.addBird(bird);
        return "redirect:/wiki/collections/bird";
    }

    @PostMapping("/bird/update")
    public String updateBird(BirdCollection bird,
                             @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                             @RequestParam(value = "existingImageUrl", required = false) String existingImageUrl) throws IOException {
        log.info("관리자 데이터 수정: 새 id={}", bird.getId());
        handleImageUpload(bird, imageFile, "bird", existingImageUrl);
        collectionService.updateBird(bird);
        return "redirect:/wiki/collections/bird";
    }

    @PostMapping("/bird/delete/{id}")
    public String deleteBird(@PathVariable Integer id) {
        log.info("관리자 데이터 삭제: 새 id={}", id);
        collectionService.deleteBird(id);
        return "redirect:/wiki/collections/bird";
    }

    // ======================== 동물 ========================
    @PostMapping("/animal/add")
    public String addAnimal(AnimalCollection animal,
                            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) throws IOException {
        log.info("관리자 데이터 추가: 동물 '{}'", animal.getName());
        handleImageUpload(animal, imageFile, "animal", null);
        collectionService.addAnimal(animal);
        return "redirect:/wiki/collections/animal";
    }

    @PostMapping("/animal/update")
    public String updateAnimal(AnimalCollection animal,
                               @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                               @RequestParam(value = "existingImageUrl", required = false) String existingImageUrl) throws IOException {
        log.info("관리자 데이터 수정: 동물 id={}", animal.getId());
        handleImageUpload(animal, imageFile, "animal", existingImageUrl);
        collectionService.updateAnimal(animal);
        return "redirect:/wiki/collections/animal";
    }

    @PostMapping("/animal/delete/{id}")
    public String deleteAnimal(@PathVariable Integer id) {
        log.info("관리자 데이터 삭제: 동물 id={}", id);
        collectionService.deleteAnimal(id);
        return "redirect:/wiki/collections/animal";
    }

    // ======================== 채집물 ========================
    @PostMapping("/forageable/add")
    public String addForageable(ForageableCollection forageable,
                                @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) throws IOException {
        log.info("관리자 데이터 추가: 채집물 '{}'", forageable.getName());
        handleImageUpload(forageable, imageFile, "forageable", null);
        collectionService.addForageable(forageable);
        return "redirect:/wiki/collections/forageable";
    }

    @PostMapping("/forageable/update")
    public String updateForageable(ForageableCollection forageable,
                                   @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                   @RequestParam(value = "existingImageUrl", required = false) String existingImageUrl) throws IOException {
        log.info("관리자 데이터 수정: 채집물 id={}", forageable.getId());
        handleImageUpload(forageable, imageFile, "forageable", existingImageUrl);
        collectionService.updateForageable(forageable);
        return "redirect:/wiki/collections/forageable";
    }

    @PostMapping("/forageable/delete/{id}")
    public String deleteForageable(@PathVariable Integer id) {
        log.info("관리자 데이터 삭제: 채집물 id={}", id);
        collectionService.deleteForageable(id);
        return "redirect:/wiki/collections/forageable";
    }

    // ======================== 요리 ========================
    @PostMapping("/cooking/add")
    public String addCooking(CookingCollection cooking,
                             @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) throws IOException {
        log.info("관리자 데이터 추가: 요리 '{}'", cooking.getName());
        handleImageUpload(cooking, imageFile, "cook", null);
        collectionService.addCooking(cooking);
        return "redirect:/wiki/items/cooking";
    }

    @PostMapping("/cooking/update")
    public String updateCooking(CookingCollection cooking,
                                @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                @RequestParam(value = "existingImageUrl", required = false) String existingImageUrl) throws IOException {
        log.info("관리자 데이터 수정: 요리 id={}", cooking.getId());
        handleImageUpload(cooking, imageFile, "cook", existingImageUrl);
        collectionService.updateCooking(cooking);
        return "redirect:/wiki/items/cooking";
    }

    @PostMapping("/cooking/delete/{id}")
    public String deleteCooking(@PathVariable Integer id) {
        log.info("관리자 데이터 삭제: 요리 id={}", id);
        collectionService.deleteCooking(id);
        return "redirect:/wiki/items/cooking";
    }

    // ======================== 꽃 ========================
    @PostMapping("/flower/add")
    public String addFlower(FlowerCollection flower,
                            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                            @RequestParam(value = "variantImageFiles", required = false) List<MultipartFile> variantImageFiles,
                            @RequestParam(value = "existingVariantUrls", required = false) List<String> existingVariantUrls) throws IOException {
        log.info("관리자 데이터 추가: 꽃 '{}'", flower.getName());
        handleImageUpload(flower, imageFile, "flower", null);
        collectionService.addFlower(flower);
        saveVariantImages(flower.getId(), variantImageFiles, existingVariantUrls);
        return "redirect:/wiki/items/flowers";
    }

    @PostMapping("/flower/update")
    public String updateFlower(FlowerCollection flower,
                               @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                               @RequestParam(value = "existingImageUrl", required = false) String existingImageUrl,
                               @RequestParam(value = "variantImageFiles", required = false) List<MultipartFile> variantImageFiles,
                               @RequestParam(value = "existingVariantUrls", required = false) List<String> existingVariantUrls) throws IOException {
        log.info("관리자 데이터 수정: 꽃 id={}", flower.getId());
        handleImageUpload(flower, imageFile, "flower", existingImageUrl);
        collectionService.updateFlower(flower);
        saveVariantImages(flower.getId(), variantImageFiles, existingVariantUrls);
        return "redirect:/wiki/items/flowers";
    }

    @PostMapping("/flower/delete/{id}")
    public String deleteFlower(@PathVariable Long id) {
        log.info("관리자 데이터 삭제: 꽃 id={}", id);
        collectionService.deleteFlower(id);
        return "redirect:/wiki/items/flowers";
    }

    @GetMapping("/flower/{id}/images")
    @ResponseBody
    public ResponseEntity<List<FlowerImage>> getFlowerImages(@PathVariable Long id) {
        return ResponseEntity.ok(collectionService.getFlowerImages(id));
    }

    @PostMapping("/flower/image/delete/{id}")
    public String deleteFlowerImage(@PathVariable Long id) {
        log.info("꽃 이미지 삭제: id={}", id);
        collectionService.deleteFlowerImage(id);
        return "redirect:/wiki/items/flowers";
    }

    private void saveVariantImages(Long flowerId, List<MultipartFile> files, List<String> existingUrls) throws IOException {
        List<String> urls = new ArrayList<>();
        int fileIdx = 0;
        int existingIdx = 0;
        // existingUrls: 유지할 기존 URL (빈 문자열이면 새 파일로 대체)
        int total = Math.max(
            files != null ? files.size() : 0,
            existingUrls != null ? existingUrls.size() : 0
        );
        for (int i = 0; i < total; i++) {
            String existing = (existingUrls != null && i < existingUrls.size()) ? existingUrls.get(i) : "";
            MultipartFile file = (files != null && i < files.size()) ? files.get(i) : null;
            if (file != null && !file.isEmpty()) {
                if (existing != null && existing.startsWith("/uploads/")) {
                    fileUploadService.delete(existing);
                }
                urls.add(fileUploadService.upload(file, "flower"));
            } else if (existing != null && !existing.isBlank()) {
                urls.add(existing);
            }
        }
        collectionService.saveFlowerImages(flowerId, urls);
    }

    // ======================== 작물 ========================
    @PostMapping("/crop/add")
    public String addCrop(GardeningCollection crop,
                          @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) throws IOException {
        log.info("관리자 데이터 추가: 작물 '{}'", crop.getName());
        handleImageUpload(crop, imageFile, "crop", null);
        collectionService.addCrop(crop);
        return "redirect:/wiki/items/crops";
    }

    @PostMapping("/crop/update")
    public String updateCrop(GardeningCollection crop,
                             @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                             @RequestParam(value = "existingImageUrl", required = false) String existingImageUrl) throws IOException {
        log.info("관리자 데이터 수정: 작물 id={}", crop.getId());
        handleImageUpload(crop, imageFile, "crop", existingImageUrl);
        collectionService.updateCrop(crop);
        return "redirect:/wiki/items/crops";
    }

    @PostMapping("/crop/delete/{id}")
    public String deleteCrop(@PathVariable Long id) {
        log.info("관리자 데이터 삭제: 작물 id={}", id);
        collectionService.deleteCrop(id);
        return "redirect:/wiki/items/crops";
    }

    // ======================== 이미지 처리 공통 메서드 ========================

    /**
     * 이미지 업로드 공통 처리
     * - imageMode 파라미터를 읽어 'DEFAULT'이면 기본 URL 생성 및 기존 파일 정리
     * - 'UPLOAD'이면 새 파일 업로드 처리
     */
    private void handleImageUpload(Object entity, MultipartFile imageFile, String category, String existingImageUrl) throws IOException {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        String imageMode = request.getParameter("imageMode");
        
        // Multipart 요청에서 파라미터가 누락된 경우 직접 Part를 읽어 수동으로 파라미터 추출
        if (imageMode == null) {
            try {
                if (request.getContentType() != null && request.getContentType().startsWith("multipart/form-data")) {
                    for (jakarta.servlet.http.Part part : request.getParts()) {
                        if ("imageMode".equals(part.getName())) {
                            imageMode = new String(part.getInputStream().readAllBytes(), java.nio.charset.StandardCharsets.UTF_8);
                            break;
                        }
                    }
                }
            } catch (Exception e) {
                log.warn("Multipart imageMode 파라미터 추출 실패", e);
            }
        }
        
        if (imageMode == null) imageMode = "DEFAULT";

        if ("DEFAULT".equals(imageMode)) {
            // 기존에 직접 업로드된 파일이 있었다면 서버 공간 확보를 위해 삭제
            if (existingImageUrl != null && existingImageUrl.startsWith("/uploads/")) {
                fileUploadService.delete(existingImageUrl);
            }
            // 이름 기반 기본 URL 생성
            String itemName = getEntityName(entity);
            String defaultUrl = generateDefaultImageUrl(category, itemName);
            setImageUrl(entity, defaultUrl);
        } else {
            // UPLOAD 모드
            if (imageFile != null && !imageFile.isEmpty()) {
                // 기존 이미지 삭제 (업로드된 것만)
                if (existingImageUrl != null && existingImageUrl.startsWith("/uploads/")) {
                    fileUploadService.delete(existingImageUrl);
                }
                // 새 파일 업로드
                String newImageUrl = fileUploadService.upload(imageFile, category);
                setImageUrl(entity, newImageUrl);
            } else if (existingImageUrl != null && !existingImageUrl.isBlank()) {
                // 파일 업로드 안 했으면 기존 이미지 URL 유지
                setImageUrl(entity, existingImageUrl);
            }
        }
    }

    private String getEntityName(Object entity) {
        if (entity instanceof FishCollection e) return e.getName();
        else if (entity instanceof BugCollection e) return e.getName();
        else if (entity instanceof BirdCollection e) return e.getName();
        else if (entity instanceof AnimalCollection e) return e.getName();
        else if (entity instanceof ForageableCollection e) return e.getName();
        else if (entity instanceof CookingCollection e) return e.getName();
        else if (entity instanceof FlowerCollection e) return e.getName();
        else if (entity instanceof GardeningCollection e) return e.getName();
        return "unknown";
    }

    private String generateDefaultImageUrl(String category, String itemName) {
        if ("cook".equals(category) || "flower".equals(category) || "crop".equals(category)) {
            return "/images/items/" + category + "/" + category + "_" + itemName + ".webp";
        }
        if ("forageable".equals(category) || "forage".equals(category)) {
             return "/images/collections/forage/forage_" + itemName + ".webp";
        }
        return "/images/collections/" + category + "/" + category + "_" + itemName + ".webp";
    }

    /**
     * 리플렉션 없이 모델별 imageUrl 세팅
     */
    private void setImageUrl(Object entity, String imageUrl) {
        if (entity instanceof FishCollection e) e.setImageUrl(imageUrl);
        else if (entity instanceof BugCollection e) e.setImageUrl(imageUrl);
        else if (entity instanceof BirdCollection e) e.setImageUrl(imageUrl);
        else if (entity instanceof AnimalCollection e) e.setImageUrl(imageUrl);
        else if (entity instanceof ForageableCollection e) e.setImageUrl(imageUrl);
        else if (entity instanceof CookingCollection e) e.setImageUrl(imageUrl);
        else if (entity instanceof FlowerCollection e) e.setImageUrl(imageUrl);
        else if (entity instanceof GardeningCollection e) e.setImageUrl(imageUrl);
    }
}
