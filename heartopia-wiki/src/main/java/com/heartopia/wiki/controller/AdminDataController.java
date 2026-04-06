package com.heartopia.wiki.controller;

import com.heartopia.wiki.model.*;
import com.heartopia.wiki.service.CollectionService;
import com.heartopia.wiki.service.FileUploadService;
import com.heartopia.wiki.service.GiftCodeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

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
                            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) throws IOException {
        log.info("관리자 데이터 추가: 꽃 '{}'", flower.getName());
        handleImageUpload(flower, imageFile, "flower", null);
        collectionService.addFlower(flower);
        return "redirect:/wiki/items/flowers";
    }

    @PostMapping("/flower/update")
    public String updateFlower(FlowerCollection flower,
                               @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                               @RequestParam(value = "existingImageUrl", required = false) String existingImageUrl) throws IOException {
        log.info("관리자 데이터 수정: 꽃 id={}", flower.getId());
        handleImageUpload(flower, imageFile, "flower", existingImageUrl);
        collectionService.updateFlower(flower);
        return "redirect:/wiki/items/flowers";
    }

    @PostMapping("/flower/delete/{id}")
    public String deleteFlower(@PathVariable Long id) {
        log.info("관리자 데이터 삭제: 꽃 id={}", id);
        collectionService.deleteFlower(id);
        return "redirect:/wiki/items/flowers";
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
     * - 새 파일이 올라오면: 업로드 → imageUrl 세팅, 기존 파일 삭제
     * - 새 파일이 없으면: 기존 imageUrl 유지
     */
    private void handleImageUpload(Object entity, MultipartFile imageFile, String category, String existingImageUrl) throws IOException {
        if (imageFile != null && !imageFile.isEmpty()) {
            // 기존 이미지 삭제 (업로드된 것만)
            if (existingImageUrl != null && !existingImageUrl.isBlank()) {
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
