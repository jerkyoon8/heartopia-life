package com.heartopia.wiki.controller;

import com.heartopia.wiki.model.*;
import com.heartopia.wiki.service.CollectionService;
import com.heartopia.wiki.service.MapPinService;
import com.heartopia.wiki.service.VillagerService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/wiki/map")
@RequiredArgsConstructor
public class MapController {

    private final MapPinService mapPinService;
    private final CollectionService collectionService;
    private final VillagerService villagerService;

    // 채집물.txt 기반 허용된 16개 항목 목록
    private static final List<String> ALLOWED_FORAGEABLES = Arrays.asList(
            "검은 트러플", "광석", "그물버섯", "느타리버섯",
            "대나무", "돌", "라즈베리", "블루베리", "사과",
            "양송이버섯", "귤 (오렌지)", "표고버섯", "희귀 목재");

    @GetMapping
    public String mapPage(Model model) {
        List<String> categories = mapPinService.getAllCategories();
        // 채집물 명단도 함께 전달하여 사이드바에서 핀이 없어도 보이게 함
        model.addAttribute("categories", categories);
        return "wiki/map";
    }

    @GetMapping("/api/forageables")
    @ResponseBody
    public List<ForageableCollection> getForageableMasterList() {
        List<ForageableCollection> all = collectionService.getAllForageables();
        return all.stream()
                .filter(f -> ALLOWED_FORAGEABLES.contains(f.getName()))
                .collect(Collectors.toList());
    }

    @GetMapping("/api/fish")
    @ResponseBody
    public List<FishCollection> getFishMasterList() {
        return collectionService.getAllFish();
    }

    @GetMapping("/api/birds")
    @ResponseBody
    public List<BirdCollection> getBirdMasterList() {
        return collectionService.getAllBirds();
    }

    @GetMapping("/api/insects")
    @ResponseBody
    public List<BugCollection> getInsectMasterList() {
        return collectionService.getAllBugs();
    }

    @GetMapping("/api/animals")
    @ResponseBody
    public List<AnimalCollection> getAnimalMasterList() {
        return collectionService.getAllAnimals();
    }

    @GetMapping("/api/pins")
    @ResponseBody
    public List<MapPin> getPins(@RequestParam(required = false) String category) {
        List<MapPin> pins;
        if (category != null && !category.isEmpty()) {
            pins = mapPinService.getPinsByCategory(category);
        } else {
            pins = mapPinService.getAllPins();
        }

        // 카테고리별 상세 정보 채우기
        pins.forEach(this::enrichPinDetails);

        // 채집물 카테고리의 경우 허용된 16종만 필터링하여 반환
        return pins.stream()
                .filter(pin -> !"forageable".equals(pin.getCategory()) || ALLOWED_FORAGEABLES.contains(pin.getName()))
                .collect(Collectors.toList());
    }

    private void enrichPinDetails(MapPin pin) {
        Map<String, String> details = new HashMap<>();
        String name = pin.getName();

        switch (pin.getCategory()) {
            case "villager":
                villagerService.getAllVillagers().stream()
                        .filter(v -> v.getName().contains(name))
                        .findFirst().ifPresent(v -> {
                            if (v.getSubTitle() != null)
                                details.put("역할", v.getSubTitle());
                            if (v.getLocation() != null)
                                details.put("위치", v.getLocation());
                            if (v.getUnlockCondition() != null)
                                details.put("해금", v.getUnlockCondition());
                        });
                break;
            case "fish":
                collectionService.getAllFish().stream()
                        .filter(f -> f.getName().equals(name))
                        .findFirst().ifPresent(f -> {
                            details.put("위치", f.getLocation());
                            details.put("날씨", f.getWeather());
                            details.put("시간", f.getTime());
                            details.put("가격(1성)", String.valueOf(f.getPrice1()));
                        });
                break;
            case "insect":
                collectionService.getAllBugs().stream()
                        .filter(b -> b.getName().equals(name))
                        .findFirst().ifPresent(b -> {
                            details.put("위치", b.getLocation());
                            details.put("날씨", b.getWeather());
                            details.put("시간", b.getTime());
                            details.put("가격(1성)", String.valueOf(b.getPrice1()));
                        });
                break;
            case "bird":
                collectionService.getAllBirds().stream()
                        .filter(b -> b.getName().equals(name))
                        .findFirst().ifPresent(b -> {
                            details.put("위치", b.getLocation());
                            details.put("날씨", b.getWeather());
                            details.put("시간", b.getTime());
                            details.put("가격(1성)", String.valueOf(b.getPrice1()));
                        });
                break;
            case "animal":
                collectionService.getAllAnimals().stream()
                        .filter(a -> a.getName().equals(name))
                        .findFirst().ifPresent(a -> {
                            details.put("위치", a.getLocation());
                            details.put("선호 날씨", a.getFavoriteWeather());
                            details.put("선호 음식", a.getFavoriteFood());
                        });
                break;
            case "forageable":
                collectionService.getAllForageables().stream()
                        .filter(f -> f.getName().equals(name))
                        .findFirst().ifPresent(f -> {
                            details.put("위치", f.getLocation());
                            details.put("가격", String.valueOf(f.getPrice()));
                            if (f.getEnergy() != null)
                                details.put("에너지", f.getEnergy());
                        });
                break;
        }
        pin.setDetails(details);
    }

    @GetMapping("/api/categories")
    @ResponseBody
    public List<String> getCategories() {
        return mapPinService.getAllCategories();
    }

    @PutMapping("/api/pins/{id}/position")
    @ResponseBody
    public Map<String, Object> updatePinPosition(
            @PathVariable Long id,
            @RequestBody Map<String, Integer> body) {
        Integer mapX = body.get("mapX");
        Integer mapY = body.get("mapY");
        mapPinService.updatePinPosition(id, mapX, mapY);
        return Map.of("success", true, "id", id, "mapX", mapX, "mapY", mapY);
    }

    @PostMapping("/api/pins")
    @ResponseBody
    public MapPin addPin(@RequestBody MapPin pin) {
        MapPin saved = mapPinService.addPin(pin);
        enrichPinDetails(saved); // 새 핀에도 도감 상세 정보 즉시 연동
        return saved;
    }

    @DeleteMapping("/api/pins/{id}")
    @ResponseBody
    public Map<String, Object> deletePin(@PathVariable Long id) {
        mapPinService.deletePin(id);
        return Map.of("success", true, "id", id);
    }
}
