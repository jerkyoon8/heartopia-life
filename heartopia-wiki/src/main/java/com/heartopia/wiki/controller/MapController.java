package com.heartopia.wiki.controller;

import com.heartopia.wiki.mapper.LocationZoneMapper;
import com.heartopia.wiki.model.*;
import com.heartopia.wiki.service.CollectionService;
import com.heartopia.wiki.service.MapPinService;
import com.heartopia.wiki.service.VillagerService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import jakarta.validation.Valid;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.stream.Collectors;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/wiki/map")
@RequiredArgsConstructor
public class MapController {

    private final MapPinService mapPinService;
    private final CollectionService collectionService;
    private final VillagerService villagerService;
    private final LocationZoneMapper locationZoneMapper;

    // 채집물 필터는 더 이상 하드코딩 배열을 쓰지 않고 DB 필드 f.getShowOnMap()에 의존합니다.

    @GetMapping
    public String mapPage(Model model) {
        List<String> categories = mapPinService.getAllCategories();
        // 채집물 명단도 함께 전달하여 사이드바에서 핀이 없어도 보이게 함
        model.addAttribute("categories", categories);
        model.addAttribute("pageTitle", "인터랙티브 지도");
        model.addAttribute("pageDescription", "두근두근라이프 인터랙티브 맵 - 물고기, 벌레, 동물 등 자원 위치를 지도에서 확인하세요.");
        return "wiki/map";
    }

    @GetMapping("/api/forageables")
    @ResponseBody
    public List<ForageableCollection> getForageableMasterList() {
        List<ForageableCollection> all = collectionService.getAllForageables();
        return all.stream()
                .filter(f -> Boolean.TRUE.equals(f.getShowOnMap()))
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

    @GetMapping("/api/villagers")
    @ResponseBody
    public List<Villager> getVillagerMasterList() {
        return villagerService.getAllVillagers();
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

        // --- 성능 최적화: 사전 메모리 매핑 (O(n) 사전 변환) ---
        List<Villager> allVillagers = villagerService.getAllVillagers();
        Map<String, FishCollection> fishMap = collectionService.getAllFish().stream()
                .collect(Collectors.toMap(FishCollection::getName, f -> f, (e, r) -> e));
        Map<String, BugCollection> bugMap = collectionService.getAllBugs().stream()
                .collect(Collectors.toMap(BugCollection::getName, b -> b, (e, r) -> e));
        Map<String, BirdCollection> birdMap = collectionService.getAllBirds().stream()
                .collect(Collectors.toMap(BirdCollection::getName, b -> b, (e, r) -> e));
        Map<String, AnimalCollection> animalMap = collectionService.getAllAnimals().stream()
                .collect(Collectors.toMap(AnimalCollection::getName, a -> a, (e, r) -> e));
        Map<String, ForageableCollection> forageableMap = collectionService.getAllForageables().stream()
                .collect(Collectors.toMap(ForageableCollection::getName, f -> f, (e, r) -> e));

        // 카테고리별 상세 정보 채우기 (O(1) 해시 룩업 활용 방식)
        pins.forEach(pin -> {
            if ("villager".equals(pin.getCategory())) {
                allVillagers.stream()
                        .filter(v -> v.getName().contains(pin.getName()))
                        .findFirst().ifPresent(v -> {
                            Map<String, String> details = new HashMap<>();
                            if (v.getSubTitle() != null) details.put("역할", v.getSubTitle());
                            if (v.getLocation() != null) details.put("위치", v.getLocation());
                            if (v.getUnlockCondition() != null) details.put("해금", v.getUnlockCondition());
                            pin.setDetails(details);
                        });
            } else if ("fish".equals(pin.getCategory()) && fishMap.containsKey(pin.getName())) {
                FishCollection f = fishMap.get(pin.getName());
                Map<String, String> details = new HashMap<>();
                details.put("위치", formatLocation(f.getLocation(), f.getSubLocation()));
                details.put("날씨", f.getWeather());
                details.put("시간", f.getTime());
                details.put("가격(1성)", String.valueOf(f.getPrice1()));
                pin.setDetails(details);
            } else if ("insect".equals(pin.getCategory()) && bugMap.containsKey(pin.getName())) {
                BugCollection b = bugMap.get(pin.getName());
                Map<String, String> details = new HashMap<>();
                details.put("위치", formatLocation(b.getLocation(), b.getSubLocation()));
                details.put("날씨", b.getWeather());
                details.put("시간", b.getTime());
                details.put("가격(1성)", String.valueOf(b.getPrice1()));
                pin.setDetails(details);
            } else if ("bird".equals(pin.getCategory()) && birdMap.containsKey(pin.getName())) {
                BirdCollection b = birdMap.get(pin.getName());
                Map<String, String> details = new HashMap<>();
                details.put("위치", formatLocation(b.getLocation(), b.getSubLocation()));
                details.put("날씨", b.getWeather());
                details.put("시간", b.getTime());
                details.put("가격(1성)", String.valueOf(b.getPrice1()));
                pin.setDetails(details);
            } else if ("animal".equals(pin.getCategory()) && animalMap.containsKey(pin.getName())) {
                AnimalCollection a = animalMap.get(pin.getName());
                Map<String, String> details = new HashMap<>();
                details.put("위치", a.getLocation());
                details.put("선호 날씨", a.getFavoriteWeather());
                details.put("선호 음식", a.getFavoriteFood());
                pin.setDetails(details);
            } else if ("forageable".equals(pin.getCategory()) && forageableMap.containsKey(pin.getName())) {
                ForageableCollection f = forageableMap.get(pin.getName());
                Map<String, String> details = new HashMap<>();
                details.put("위치", f.getLocation());
                details.put("가격", String.valueOf(f.getPrice()));
                if (f.getEnergy() != null) details.put("에너지", f.getEnergy());
                pin.setDetails(details);
            }
        });

        // 채집물 카테고리의 경우 DB 설정(showOnMap)이 켜진 종만 필터링하여 반환
        List<String> validForageables = forageableMap.values().stream()
                .filter(f -> Boolean.TRUE.equals(f.getShowOnMap()))
                .map(ForageableCollection::getName)
                .collect(Collectors.toList());

        return pins.stream()
                .filter(pin -> !"forageable".equals(pin.getCategory()) || validForageables.contains(pin.getName()))
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
                            details.put("위치", formatLocation(f.getLocation(), f.getSubLocation()));
                            details.put("날씨", f.getWeather());
                            details.put("시간", f.getTime());
                            details.put("가격(1성)", String.valueOf(f.getPrice1()));
                        });
                break;
            case "insect":
                collectionService.getAllBugs().stream()
                        .filter(b -> b.getName().equals(name))
                        .findFirst().ifPresent(b -> {
                            details.put("위치", formatLocation(b.getLocation(), b.getSubLocation()));
                            details.put("날씨", b.getWeather());
                            details.put("시간", b.getTime());
                            details.put("가격(1성)", String.valueOf(b.getPrice1()));
                        });
                break;
            case "bird":
                collectionService.getAllBirds().stream()
                        .filter(b -> b.getName().equals(name))
                        .findFirst().ifPresent(b -> {
                            details.put("위치", formatLocation(b.getLocation(), b.getSubLocation()));
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

    private String formatLocation(String location, String subLocation) {
        if (location == null)
            return "-";
        if (subLocation == null || subLocation.isEmpty() || subLocation.equals("-")) {
            return location;
        }
        return location + " - " + subLocation;
    }

    @GetMapping("/api/categories")
    @ResponseBody
    public List<String> getCategories() {
        return mapPinService.getAllCategories();
    }

    // ===== Location Zone API =====

    @GetMapping("/api/zones")
    @ResponseBody
    public List<LocationZone> getAllZones() {
        return locationZoneMapper.findAll();
    }

    @GetMapping("/api/zones/{zoneKey}")
    @ResponseBody
    public LocationZone getZoneByKey(@PathVariable String zoneKey) {
        return locationZoneMapper.findByZoneKey(zoneKey);
    }

    @PutMapping("/api/zones/{zoneKey}/polygon")
    @ResponseBody
    public Map<String, Object> updateZonePolygon(
            @PathVariable String zoneKey,
            @RequestBody Map<String, String> body) {
        String polygonPoints = body.get("polygonPoints");
        locationZoneMapper.updatePolygon(zoneKey, polygonPoints);
        return Map.of("success", true, "zoneKey", zoneKey);
    }

    @PutMapping("/api/zones/{zoneKey}/position")
    @ResponseBody
    public Map<String, Object> updateZonePosition(
            @PathVariable String zoneKey,
            @RequestBody Map<String, Integer> body) {
        Integer mapX = body.get("mapX");
        Integer mapY = body.get("mapY");
        locationZoneMapper.updateMapPosition(zoneKey, mapX, mapY);
        return Map.of("success", true, "zoneKey", zoneKey, "mapX", mapX, "mapY", mapY);
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
    public MapPin addPin(@Valid @RequestBody MapPin pin) {
        log.info("새로운 핀 추가 API 호출됨: {}", pin.getName());
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
