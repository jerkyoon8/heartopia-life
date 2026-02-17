package com.heartopia.wiki.controller;

import com.heartopia.wiki.service.CollectionService;
import com.heartopia.wiki.service.VillagerService;
import com.heartopia.wiki.model.Villager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/wiki")
@RequiredArgsConstructor
public class WikiController {

        private final CollectionService collectionService;
        private final VillagerService villagerService;

        record CategoryItem(String name, String icon, String link, String imageUrl, int dataCount) {
                CategoryItem(String name, String icon, String link) {
                        this(name, icon, link, null, 0);
                }

                CategoryItem(String name, String icon, String link, String imageUrl) {
                        this(name, icon, link, imageUrl, 0);
                }
        }

        // 데이터 구조 정의
        record Fish(String name, String imageUrl, String location, String subLocation, String level, String weather,
                        String time, List<Integer> prices, String size) {
        }

        record Bug(String name, String imageUrl, String location, String subLocation, String level, String weather,
                        String time, List<Integer> prices) {
        }

        record Bird(String name, String imageUrl, String location, String subLocation, String level, String weather,
                        String time, List<Integer> prices) {
        }

        record WildAnimal(String name, String imageUrl, String description, String location, String favoriteFood,
                        String favoriteWeather) {
        }

        record Cooking(String name, String imageUrl, Integer level, String ingredients, Integer buyPrice,
                        List<Integer> prices) {
        }

        record Flower(String name, String imageUrl, Integer level, String growthTime, Integer seedBuyPrice,
                        Integer seedSellPrice, List<Integer> prices) {
        }

        record Crop(String name, String imageUrl, Integer level, String growthTime, Integer seedBuyPrice,
                        Integer seedSellPrice, List<Integer> prices) {
        }

        record Forageable(String name, String imageUrl, String location, Integer price, String energy) {
        }

        @GetMapping
        public String index(Model model) {
                // 1. 컬렉션 (Collections)
                List<CategoryItem> basics = new ArrayList<>();
                basics.add(new CategoryItem("생선", "🐟", "/wiki/collections/fish",
                                "/images/collections/fish_collection.png", collectionService.getFishCount()));
                basics.add(new CategoryItem("벌레", "🦋", "/wiki/collections/bug",
                                "/images/collections/insect_collection.png", collectionService.getBugCount()));
                basics.add(new CategoryItem("새", "🐦", "/wiki/collections/bird",
                                "/images/collections/bird_collection.png", collectionService.getBirdCount()));
                basics.add(new CategoryItem("동물", "🐾", "/wiki/collections/animal",
                                "/images/collections/animal_collection.png", collectionService.getAnimalCount()));

                // 2. 아이템들 (Items)
                List<CategoryItem> creative = new ArrayList<>();
                creative.add(new CategoryItem("요리", "🍳", "/wiki/items/cooking", "/images/activity/cooking.png",
                                collectionService.getCookingCount()));
                creative.add(new CategoryItem("작물", "🌽", "/wiki/items/crops", "/images/items/crops.png",
                                collectionService.getCropCount()));
                creative.add(new CategoryItem("꽃", "🌻", "/wiki/items/flowers", "/images/activity/gardning.png",
                                collectionService.getFlowerCount()));
                creative.add(new CategoryItem("채집", "🥐", "/wiki/collections/forageable", "/images/items/forage.png",
                                collectionService.getForageableCount()));

                // 3. 기타 (Others)
                List<CategoryItem> others = new ArrayList<>();
                others.add(new CategoryItem("주민", "👤", "/wiki/others/villagers", "/images/others/villagers.png", 21));
                others.add(new CategoryItem("업적", "🏆", "/wiki/others/achievements", "/images/others/achievements.png",
                                50));

                model.addAttribute("basics", basics);
                model.addAttribute("creative", creative);
                model.addAttribute("others", others);

                return "wiki/wiki";
        }

        @GetMapping("/collections/fish")
        public String fishList(Model model) {
                List<Fish> list = collectionService.getAllFish().stream()
                                .map(f -> new Fish(
                                                f.getName(),
                                                null,
                                                f.getLocation(),
                                                f.getSubLocation() != null ? f.getSubLocation() : "",
                                                "Lv." + f.getLevel(),
                                                f.getWeather() != null && !f.getWeather().isEmpty() ? f.getWeather()
                                                                : "상시",
                                                f.getTime() != null && !f.getTime().isEmpty() ? f.getTime() : "상시",
                                                List.of(
                                                                f.getPrice1() != null ? f.getPrice1() : 0,
                                                                f.getPrice2() != null ? f.getPrice2() : 0,
                                                                f.getPrice3() != null ? f.getPrice3() : 0,
                                                                f.getPrice4() != null ? f.getPrice4() : 0,
                                                                f.getPrice5() != null ? f.getPrice5() : 0),
                                                f.getSize() != null ? f.getSize() : "-"))
                                .toList();
                model.addAttribute("fishList", list);

                return "wiki/collections/fish";
        }

        @GetMapping("/collections/bug")
        public String bugList(Model model) {
                List<Bug> list = collectionService.getAllBugs().stream()
                                .map(b -> new Bug(
                                                b.getName(),
                                                null,
                                                b.getLocation(),
                                                b.getSubLocation() != null && !b.getSubLocation().equals("-")
                                                                ? b.getSubLocation()
                                                                : "",
                                                "Lv." + b.getLevel(),
                                                b.getWeather() != null && !b.getWeather().equals("-") ? b.getWeather()
                                                                : "상시",
                                                b.getTime() != null && !b.getTime().equals("-") ? b.getTime() : "상시",
                                                List.of(
                                                                b.getPrice1() != null ? b.getPrice1() : 0,
                                                                b.getPrice2() != null ? b.getPrice2() : 0,
                                                                b.getPrice3() != null ? b.getPrice3() : 0,
                                                                b.getPrice4() != null ? b.getPrice4() : 0,
                                                                b.getPrice5() != null ? b.getPrice5() : 0)))
                                .toList();
                model.addAttribute("bugList", list);
                return "wiki/collections/bug";
        }

        @GetMapping("/collections/bird")
        public String birdList(Model model) {
                List<Bird> list = collectionService.getAllBirds().stream()
                                .map(b -> new Bird(
                                                b.getName(),
                                                null,
                                                b.getLocation(),
                                                b.getSubLocation() != null ? b.getSubLocation() : "",
                                                "Lv." + b.getLevel(),
                                                b.getWeather() != null && !b.getWeather().isEmpty() ? b.getWeather()
                                                                : "상시",
                                                b.getTime() != null && !b.getTime().isEmpty() ? b.getTime() : "상시",
                                                List.of(
                                                                b.getPrice1() != null ? b.getPrice1() : 0,
                                                                b.getPrice2() != null ? b.getPrice2() : 0,
                                                                b.getPrice3() != null ? b.getPrice3() : 0,
                                                                b.getPrice4() != null ? b.getPrice4() : 0,
                                                                b.getPrice5() != null ? b.getPrice5() : 0)))
                                .toList();
                model.addAttribute("birdList", list);
                return "wiki/collections/bird";
        }

        // 동물 이름 -> 이미지 파일명 매핑
        private static final Map<String, String> ANIMAL_IMAGE_MAP = Map.of(
                        "판다", "wild_animal_판다.png",
                        "카피바라", "wild_animal_카피바라.png",
                        "토끼", "wild_animal_토끼.png",
                        "여우", "wild_animal_여우.png",
                        "해달", "wild_animal_해달.png",
                        "담비", "wild_animal_담비.png",
                        "꽃사슴", "wild_animal_꽃사슴.png",
                        "알파카", "wild_animal_알파카.png");

        @GetMapping("/collections/animal")
        public String animalList(Model model) {
                List<WildAnimal> list = collectionService.getAllAnimals().stream()
                                .map(a -> {
                                        String imageFileName = ANIMAL_IMAGE_MAP.getOrDefault(a.getName(), null);
                                        String imageUrl = imageFileName != null
                                                        ? "/images/collections/animals/" + imageFileName
                                                        : null;
                                        return new WildAnimal(
                                                        a.getName(),
                                                        imageUrl,
                                                        "",
                                                        a.getLocation(),
                                                        a.getFavoriteFood(),
                                                        a.getFavoriteWeather() != null ? a.getFavoriteWeather() : "");
                                })
                                .toList();
                model.addAttribute("animalList", list);
                return "wiki/collections/animal";
        }

        @GetMapping("/items/cooking")
        public String cookingList(Model model) {
                List<Cooking> list = collectionService.getAllCookings().stream()
                                .map(c -> new Cooking(
                                                c.getName(),
                                                null, // Image
                                                c.getLevel(),
                                                c.getIngredients(),
                                                c.getBuyPrice(),
                                                c.getPrices()))
                                .toList();
                model.addAttribute("cookingList", list);
                return "wiki/items/cooking";
        }

        @GetMapping("/items/flowers")
        public String flowerList(Model model) {
                List<Flower> list = collectionService.getAllFlowers().stream()
                                .map(f -> new Flower(
                                                f.getName(),
                                                null, // Image
                                                f.getLevel(),
                                                f.getGrowthTime(),
                                                f.getSeedBuyPrice(),
                                                f.getSeedSellPrice(),
                                                List.of(
                                                                f.getPrice1() != null ? f.getPrice1() : 0,
                                                                f.getPrice2() != null ? f.getPrice2() : 0,
                                                                f.getPrice3() != null ? f.getPrice3() : 0,
                                                                f.getPrice4() != null ? f.getPrice4() : 0,
                                                                f.getPrice5() != null ? f.getPrice5() : 0)))
                                .toList();
                model.addAttribute("flowerList", list);
                return "wiki/items/flowers";
        }

        @GetMapping("/items/crops")
        public String cropList(Model model) {
                List<Crop> list = collectionService.getAllCrops().stream()
                                .map(c -> new Crop(
                                                c.getName(),
                                                null, // Image
                                                c.getLevel(),
                                                c.getGrowthTime(),
                                                c.getSeedBuyPrice(),
                                                c.getSeedSellPrice(),
                                                List.of(
                                                                c.getPrice1() != null ? c.getPrice1() : 0,
                                                                c.getPrice2() != null ? c.getPrice2() : 0,
                                                                c.getPrice3() != null ? c.getPrice3() : 0,
                                                                c.getPrice4() != null ? c.getPrice4() : 0,
                                                                c.getPrice5() != null ? c.getPrice5() : 0)))
                                .toList();
                model.addAttribute("cropList", list);
                return "wiki/items/crops";
        }

        @GetMapping("/collections/forageable")
        public String forageableList(Model model) {
                List<Forageable> list = collectionService.getAllForageables().stream()
                                .map(f -> new Forageable(
                                                f.getName(),
                                                f.getImageUrl(),
                                                f.getLocation(),
                                                f.getPrice(),
                                                f.getEnergy() != null ? f.getEnergy() : "-"))
                                .toList();
                model.addAttribute("forageableList", list);
                return "wiki/collections/forageable";
        }

        @GetMapping("/others/villagers")
        public String villagers(Model model) {
                List<Villager> villagers = villagerService.getAllVillagers();
                model.addAttribute("villagers", villagers);
                return "wiki/others/villagers";
        }

}