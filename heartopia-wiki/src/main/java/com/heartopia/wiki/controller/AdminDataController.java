package com.heartopia.wiki.controller;

import com.heartopia.wiki.model.*;
import com.heartopia.wiki.service.CollectionService;
import com.heartopia.wiki.service.GiftCodeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 관리자 전용 데이터 CRUD 컨트롤러
 * - 모든 엔드포인트는 /wiki/admin/data/** 하위에 배치
 * - SecurityConfig에서 /wiki/admin/** 패턴으로 ROLE_ADMIN 보호됨
 */
@Slf4j
@Controller
@RequestMapping("/wiki/admin/data")
@RequiredArgsConstructor
public class AdminDataController {

    private final CollectionService collectionService;
    private final GiftCodeService giftCodeService;

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
    public String addFish(FishCollection fish) {
        log.info("관리자 데이터 추가: 물고기 '{}'", fish.getName());
        collectionService.addFish(fish);
        return "redirect:/wiki/collections/fish";
    }

    @PostMapping("/fish/update")
    public String updateFish(FishCollection fish) {
        log.info("관리자 데이터 수정: 물고기 id={}", fish.getId());
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
    public String addBug(BugCollection bug) {
        log.info("관리자 데이터 추가: 벌레 '{}'", bug.getName());
        collectionService.addBug(bug);
        return "redirect:/wiki/collections/bug";
    }

    @PostMapping("/bug/update")
    public String updateBug(BugCollection bug) {
        log.info("관리자 데이터 수정: 벌레 id={}", bug.getId());
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
    public String addBird(BirdCollection bird) {
        log.info("관리자 데이터 추가: 새 '{}'", bird.getName());
        collectionService.addBird(bird);
        return "redirect:/wiki/collections/bird";
    }

    @PostMapping("/bird/update")
    public String updateBird(BirdCollection bird) {
        log.info("관리자 데이터 수정: 새 id={}", bird.getId());
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
    public String addAnimal(AnimalCollection animal) {
        log.info("관리자 데이터 추가: 동물 '{}'", animal.getName());
        collectionService.addAnimal(animal);
        return "redirect:/wiki/collections/animal";
    }

    @PostMapping("/animal/update")
    public String updateAnimal(AnimalCollection animal) {
        log.info("관리자 데이터 수정: 동물 id={}", animal.getId());
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
    public String addForageable(ForageableCollection forageable) {
        log.info("관리자 데이터 추가: 채집물 '{}'", forageable.getName());
        collectionService.addForageable(forageable);
        return "redirect:/wiki/collections/forageable";
    }

    @PostMapping("/forageable/update")
    public String updateForageable(ForageableCollection forageable) {
        log.info("관리자 데이터 수정: 채집물 id={}", forageable.getId());
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
    public String addCooking(CookingCollection cooking) {
        log.info("관리자 데이터 추가: 요리 '{}'", cooking.getName());
        collectionService.addCooking(cooking);
        return "redirect:/wiki/items/cooking";
    }

    @PostMapping("/cooking/update")
    public String updateCooking(CookingCollection cooking) {
        log.info("관리자 데이터 수정: 요리 id={}", cooking.getId());
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
    public String addFlower(FlowerCollection flower) {
        log.info("관리자 데이터 추가: 꽃 '{}'", flower.getName());
        collectionService.addFlower(flower);
        return "redirect:/wiki/items/flowers";
    }

    @PostMapping("/flower/update")
    public String updateFlower(FlowerCollection flower) {
        log.info("관리자 데이터 수정: 꽃 id={}", flower.getId());
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
    public String addCrop(GardeningCollection crop) {
        log.info("관리자 데이터 추가: 작물 '{}'", crop.getName());
        collectionService.addCrop(crop);
        return "redirect:/wiki/items/crops";
    }

    @PostMapping("/crop/update")
    public String updateCrop(GardeningCollection crop) {
        log.info("관리자 데이터 수정: 작물 id={}", crop.getId());
        collectionService.updateCrop(crop);
        return "redirect:/wiki/items/crops";
    }

    @PostMapping("/crop/delete/{id}")
    public String deleteCrop(@PathVariable Long id) {
        log.info("관리자 데이터 삭제: 작물 id={}", id);
        collectionService.deleteCrop(id);
        return "redirect:/wiki/items/crops";
    }
}
