package com.heartopia.wiki.controller;

import com.heartopia.wiki.service.CollectionService;
import com.heartopia.wiki.service.VillagerService;
import com.heartopia.wiki.model.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashMap;
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
                        String time, List<Integer> prices, String type) {
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

        // 검색 결과용 통합 record
        record SearchResult(String name, String category, String categoryLabel, String detailUrl, String subInfo) {
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

        // ======================== 목록 페이지 (기존) ========================

        @GetMapping("/collections/fish")
        public String fishList(Model model) {
                List<Fish> list = collectionService.getAllFish().stream()
                                .map(f -> new Fish(
                                                f.getName(),
                                                f.getImageUrl(),
                                                f.getLocation(),
                                                f.getSubLocation() != null ? f.getSubLocation() : "",
                                                String.valueOf(f.getLevel()),
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
                                                b.getImageUrl(),
                                                b.getLocation(),
                                                b.getSubLocation() != null && !b.getSubLocation().equals("-")
                                                                ? b.getSubLocation()
                                                                : "",
                                                String.valueOf(b.getLevel()),
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
                                                b.getImageUrl(),
                                                b.getLocation(),
                                                b.getSubLocation() != null ? b.getSubLocation() : "",
                                                String.valueOf(b.getLevel()),
                                                b.getWeather() != null && !b.getWeather().isEmpty() ? b.getWeather()
                                                                : "상시",
                                                b.getTime() != null && !b.getTime().isEmpty() ? b.getTime() : "상시",
                                                List.of(
                                                                b.getPrice1() != null ? b.getPrice1() : 0,
                                                                b.getPrice2() != null ? b.getPrice2() : 0,
                                                                b.getPrice3() != null ? b.getPrice3() : 0,
                                                                b.getPrice4() != null ? b.getPrice4() : 0,
                                                                b.getPrice5() != null ? b.getPrice5() : 0),
                                                b.getType()))
                                .toList();
                model.addAttribute("birdList", list);
                return "wiki/collections/bird";
        }

        @GetMapping("/collections/animal")
        public String animalList(Model model) {
                List<WildAnimal> list = collectionService.getAllAnimals().stream()
                                .map(a -> new WildAnimal(
                                                a.getName(),
                                                a.getImageUrl(),
                                                "",
                                                a.getLocation(),
                                                a.getFavoriteFood(),
                                                a.getFavoriteWeather() != null ? a.getFavoriteWeather() : ""))
                                .toList();
                model.addAttribute("animalList", list);
                return "wiki/collections/animal";
        }

        @GetMapping("/items/cooking")
        public String cookingList(Model model) {
                List<Cooking> list = collectionService.getAllCookings().stream()
                                .map(c -> new Cooking(
                                                c.getName(),
                                                c.getImageUrl(), // Image
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

        // ======================== 상세보기 페이지 (신규) ========================

        @GetMapping("/collections/fish/{name}")
        public String fishDetail(@PathVariable String name, Model model) {
                FishCollection item = collectionService.getFishByName(name);
                if (item == null)
                        return "redirect:/wiki/collections/fish";

                model.addAttribute("item", item);
                model.addAttribute("category", "fish");
                model.addAttribute("categoryLabel", "생선");
                model.addAttribute("categoryIcon", "fas fa-fish");
                model.addAttribute("listUrl", "/wiki/collections/fish");
                model.addAttribute("prices", item.getPrices());

                // 관련정보: 같은 장소의 다른 생선
                List<FishCollection> related = collectionService.getFishByLocation(item.getLocation(), name);
                model.addAttribute("relatedItems", related.stream()
                                .map(f -> new SearchResult(f.getName(), "fish", "생선",
                                                "/wiki/collections/fish/" + URLEncoder.encode(f.getName(),
                                                                StandardCharsets.UTF_8),
                                                f.getLocation() + " · " + f.getLevel() + " Lv"))
                                .toList());

                return "wiki/detail";
        }

        @GetMapping("/collections/bug/{name}")
        public String bugDetail(@PathVariable String name, Model model) {
                BugCollection item = collectionService.getBugByName(name);
                if (item == null)
                        return "redirect:/wiki/collections/bug";

                model.addAttribute("item", item);
                model.addAttribute("category", "bug");
                model.addAttribute("categoryLabel", "벌레");
                model.addAttribute("categoryIcon", "fas fa-bug");
                model.addAttribute("listUrl", "/wiki/collections/bug");
                model.addAttribute("prices", item.getPrices());

                List<BugCollection> related = collectionService.getBugsByLocation(item.getLocation(), name);
                model.addAttribute("relatedItems", related.stream()
                                .map(b -> new SearchResult(b.getName(), "bug", "벌레",
                                                "/wiki/collections/bug/" + URLEncoder.encode(b.getName(),
                                                                StandardCharsets.UTF_8),
                                                b.getLocation() + " · " + b.getLevel() + " Lv"))
                                .toList());

                return "wiki/detail";
        }

        @GetMapping("/collections/bird/{name}")
        public String birdDetail(@PathVariable String name, Model model) {
                BirdCollection item = collectionService.getBirdByName(name);
                if (item == null)
                        return "redirect:/wiki/collections/bird";

                model.addAttribute("item", item);
                model.addAttribute("category", "bird");
                model.addAttribute("categoryLabel", "새");
                model.addAttribute("categoryIcon", "fas fa-dove");
                model.addAttribute("listUrl", "/wiki/collections/bird");
                model.addAttribute("prices", item.getPrices());

                List<BirdCollection> related = collectionService.getBirdsByLocation(item.getLocation(), name);
                model.addAttribute("relatedItems", related.stream()
                                .map(b -> new SearchResult(b.getName(), "bird", "새",
                                                "/wiki/collections/bird/" + URLEncoder.encode(b.getName(),
                                                                StandardCharsets.UTF_8),
                                                b.getLocation() + " · " + b.getLevel() + " Lv"))
                                .toList());

                return "wiki/detail";
        }

        @GetMapping("/collections/animal/{name}")
        public String animalDetail(@PathVariable String name, Model model) {
                AnimalCollection item = collectionService.getAnimalByName(name);
                if (item == null)
                        return "redirect:/wiki/collections/animal";

                String imageUrl = item.getImageUrl();
                model.addAttribute("item", item);
                model.addAttribute("animalImageUrl", imageUrl);
                model.addAttribute("category", "animal");
                model.addAttribute("categoryLabel", "동물");
                model.addAttribute("categoryIcon", "fas fa-paw");
                model.addAttribute("listUrl", "/wiki/collections/animal");

                List<AnimalCollection> related = collectionService.getAnimalsByLocation(item.getLocation(), name);
                model.addAttribute("relatedItems", related.stream()
                                .map(a -> new SearchResult(a.getName(), "animal", "동물",
                                                "/wiki/collections/animal/" + URLEncoder.encode(a.getName(),
                                                                StandardCharsets.UTF_8),
                                                a.getLocation()))
                                .toList());

                return "wiki/detail";
        }

        @GetMapping("/collections/forageable/{name}")
        public String forageableDetail(@PathVariable String name, Model model) {
                ForageableCollection item = collectionService.getForageableByName(name);
                if (item == null)
                        return "redirect:/wiki/collections/forageable";

                model.addAttribute("item", item);
                model.addAttribute("category", "forageable");
                model.addAttribute("categoryLabel", "채집");
                model.addAttribute("categoryIcon", "fas fa-leaf");
                model.addAttribute("listUrl", "/wiki/collections/forageable");

                List<ForageableCollection> related = collectionService.getForageablesByLocation(item.getLocation(),
                                name);
                model.addAttribute("relatedItems", related.stream()
                                .map(f -> new SearchResult(f.getName(), "forageable", "채집",
                                                "/wiki/collections/forageable/" + URLEncoder.encode(f.getName(),
                                                                StandardCharsets.UTF_8),
                                                f.getLocation()))
                                .toList());

                return "wiki/detail";
        }

        @GetMapping("/items/cooking/{name}")
        public String cookingDetail(@PathVariable String name, Model model) {
                CookingCollection item = collectionService.getCookingByName(name);
                if (item == null)
                        return "redirect:/wiki/items/cooking";

                model.addAttribute("item", item);
                model.addAttribute("category", "cooking");
                model.addAttribute("categoryLabel", "요리");
                model.addAttribute("categoryIcon", "fas fa-utensils");
                model.addAttribute("listUrl", "/wiki/items/cooking");
                model.addAttribute("prices", item.getPrices());

                // 요리는 장소가 없으므로 같은 레벨의 다른 요리를 관련정보로 표시
                model.addAttribute("relatedItems", List.of());

                return "wiki/detail";
        }

        @GetMapping("/items/flowers/{name}")
        public String flowerDetail(@PathVariable String name, Model model) {
                FlowerCollection item = collectionService.getFlowerByName(name);
                if (item == null)
                        return "redirect:/wiki/items/flowers";

                model.addAttribute("item", item);
                model.addAttribute("category", "flower");
                model.addAttribute("categoryLabel", "꽃");
                model.addAttribute("categoryIcon", "fas fa-seedling");
                model.addAttribute("listUrl", "/wiki/items/flowers");
                model.addAttribute("prices", List.of(
                                item.getPrice1() != null ? item.getPrice1() : 0,
                                item.getPrice2() != null ? item.getPrice2() : 0,
                                item.getPrice3() != null ? item.getPrice3() : 0,
                                item.getPrice4() != null ? item.getPrice4() : 0,
                                item.getPrice5() != null ? item.getPrice5() : 0));

                model.addAttribute("relatedItems", List.of());
                return "wiki/detail";
        }

        @GetMapping("/items/crops/{name}")
        public String cropDetail(@PathVariable String name, Model model) {
                GardeningCollection item = collectionService.getCropByName(name);
                if (item == null)
                        return "redirect:/wiki/items/crops";

                model.addAttribute("item", item);
                model.addAttribute("category", "crop");
                model.addAttribute("categoryLabel", "작물");
                model.addAttribute("categoryIcon", "fas fa-carrot");
                model.addAttribute("listUrl", "/wiki/items/crops");
                model.addAttribute("prices", List.of(
                                item.getPrice1() != null ? item.getPrice1() : 0,
                                item.getPrice2() != null ? item.getPrice2() : 0,
                                item.getPrice3() != null ? item.getPrice3() : 0,
                                item.getPrice4() != null ? item.getPrice4() : 0,
                                item.getPrice5() != null ? item.getPrice5() : 0));

                model.addAttribute("relatedItems", List.of());
                return "wiki/detail";
        }

        // ======================== 검색 (신규) ========================

        @GetMapping("/search")
        public String search(@RequestParam(name = "q", required = false, defaultValue = "") String keyword,
                        Model model) {
                String q = keyword.trim();
                if (q.isEmpty()) {
                        return "redirect:/wiki";
                }
                final String searchKeyword = q;

                List<SearchResult> allResults = new ArrayList<>();

                // 8개 테이블 통합 검색
                collectionService.searchFish(searchKeyword)
                                .forEach(f -> allResults.add(new SearchResult(f.getName(), "fish", "생선",
                                                "/wiki/collections/fish/" + URLEncoder.encode(f.getName(),
                                                                StandardCharsets.UTF_8),
                                                f.getLocation() + " · " + f.getLevel() + " Lv")));

                collectionService.searchBugs(searchKeyword)
                                .forEach(b -> allResults.add(new SearchResult(b.getName(), "bug", "벌레",
                                                "/wiki/collections/bug/" + URLEncoder.encode(b.getName(),
                                                                StandardCharsets.UTF_8),
                                                b.getLocation() + " · " + b.getLevel() + " Lv")));

                collectionService.searchBirds(searchKeyword)
                                .forEach(b -> allResults.add(new SearchResult(b.getName(), "bird", "새",
                                                "/wiki/collections/bird/" + URLEncoder.encode(b.getName(),
                                                                StandardCharsets.UTF_8),
                                                b.getLocation() + " · " + b.getLevel() + " Lv")));

                collectionService.searchAnimals(searchKeyword)
                                .forEach(a -> allResults.add(new SearchResult(a.getName(), "animal", "동물",
                                                "/wiki/collections/animal/" + URLEncoder.encode(a.getName(),
                                                                StandardCharsets.UTF_8),
                                                a.getLocation())));

                collectionService.searchCookings(searchKeyword)
                                .forEach(c -> allResults.add(new SearchResult(c.getName(), "cooking", "요리",
                                                "/wiki/items/cooking/" + URLEncoder.encode(c.getName(),
                                                                StandardCharsets.UTF_8),
                                                c.getLevel() + " Lv")));

                collectionService.searchFlowers(searchKeyword)
                                .forEach(f -> allResults.add(new SearchResult(f.getName(), "flower", "꽃",
                                                "/wiki/items/flowers/" + URLEncoder.encode(f.getName(),
                                                                StandardCharsets.UTF_8),
                                                f.getLevel() + " Lv")));

                collectionService.searchCrops(searchKeyword)
                                .forEach(c -> allResults.add(new SearchResult(c.getName(), "crop", "작물",
                                                "/wiki/items/crops/" + URLEncoder.encode(c.getName(),
                                                                StandardCharsets.UTF_8),
                                                c.getLevel() + " Lv")));

                collectionService.searchForageables(searchKeyword)
                                .forEach(f -> allResults.add(new SearchResult(f.getName(), "forageable", "채집",
                                                "/wiki/collections/forageable/" + URLEncoder.encode(f.getName(),
                                                                StandardCharsets.UTF_8),
                                                f.getLocation())));

                // 주민 검색
                villagerService.getAllVillagers().stream()
                                .filter(v -> v.getName().contains(searchKeyword))
                                .forEach(v -> allResults.add(new SearchResult(v.getName(), "villager", "주민",
                                                "/wiki/others/villagers",
                                                v.getSubTitle() != null ? v.getSubTitle() : "")));

                // 결과가 1개면 바로 상세보기로 이동
                if (allResults.size() == 1) {
                        return "redirect:" + allResults.get(0).detailUrl();
                }

                // 카테고리별 그룹핑
                Map<String, List<SearchResult>> groupedResults = new LinkedHashMap<>();
                for (SearchResult result : allResults) {
                        groupedResults.computeIfAbsent(result.categoryLabel(), k -> new ArrayList<>()).add(result);
                }

                model.addAttribute("keyword", searchKeyword);
                model.addAttribute("totalCount", allResults.size());
                model.addAttribute("groupedResults", groupedResults);

                return "wiki/search-results";
        }

        // ======================== 검색 자동완성 API (신규) ========================

        @GetMapping("/search/suggest")
        @org.springframework.web.bind.annotation.ResponseBody
        public List<Map<String, String>> suggest(
                        @RequestParam(name = "q", required = false, defaultValue = "") String keyword) {
                String q = keyword.trim();
                if (q.isEmpty() || q.length() < 1) {
                        return List.of();
                }

                List<Map<String, String>> results = new ArrayList<>();

                collectionService.searchFish(q).forEach(f -> results.add(Map.of(
                                "name", f.getName(), "category", "fish", "label", "생선",
                                "url",
                                "/wiki/collections/fish/" + URLEncoder.encode(f.getName(), StandardCharsets.UTF_8),
                                "sub", f.getLocation() + " · " + f.getLevel() + " Lv", "icon", "🐟")));

                collectionService.searchBugs(q).forEach(b -> results.add(Map.of(
                                "name", b.getName(), "category", "bug", "label", "벌레",
                                "url",
                                "/wiki/collections/bug/" + URLEncoder.encode(b.getName(), StandardCharsets.UTF_8),
                                "sub", b.getLocation() + " · " + b.getLevel() + " Lv", "icon", "🦋")));

                collectionService.searchBirds(q).forEach(b -> results.add(Map.of(
                                "name", b.getName(), "category", "bird", "label", "새",
                                "url",
                                "/wiki/collections/bird/" + URLEncoder.encode(b.getName(), StandardCharsets.UTF_8),
                                "sub", b.getLocation() + " · " + b.getLevel() + " Lv", "icon", "🐦")));

                collectionService.searchAnimals(q).forEach(a -> results.add(Map.of(
                                "name", a.getName(), "category", "animal", "label", "동물",
                                "url",
                                "/wiki/collections/animal/" + URLEncoder.encode(a.getName(), StandardCharsets.UTF_8),
                                "sub", a.getLocation(), "icon", "🐾")));

                collectionService.searchCookings(q).forEach(c -> results.add(Map.of(
                                "name", c.getName(), "category", "cooking", "label", "요리",
                                "url", "/wiki/items/cooking/" + URLEncoder.encode(c.getName(), StandardCharsets.UTF_8),
                                "sub", c.getLevel() + " Lv", "icon", "🍳")));

                collectionService.searchFlowers(q).forEach(f -> results.add(Map.of(
                                "name", f.getName(), "category", "flower", "label", "꽃",
                                "url", "/wiki/items/flowers/" + URLEncoder.encode(f.getName(), StandardCharsets.UTF_8),
                                "sub", f.getLevel() + " Lv", "icon", "🌻")));

                collectionService.searchCrops(q).forEach(c -> results.add(Map.of(
                                "name", c.getName(), "category", "crop", "label", "작물",
                                "url", "/wiki/items/crops/" + URLEncoder.encode(c.getName(), StandardCharsets.UTF_8),
                                "sub", c.getLevel() + " Lv", "icon", "🌽")));

                collectionService.searchForageables(q).forEach(f -> results.add(Map.of(
                                "name", f.getName(), "category", "forageable", "label", "채집",
                                "url",
                                "/wiki/collections/forageable/"
                                                + URLEncoder.encode(f.getName(), StandardCharsets.UTF_8),
                                "sub", f.getLocation(), "icon", "🥐")));

                villagerService.getAllVillagers().stream()
                                .filter(v -> v.getName().contains(q))
                                .forEach(v -> results.add(Map.of(
                                                "name", v.getName(), "category", "villager", "label", "주민",
                                                "url", "/wiki/others/villagers",
                                                "sub", v.getSubTitle() != null ? v.getSubTitle() : "", "icon", "👤")));

                // 최대 10개만 반환
                return results.size() > 10 ? results.subList(0, 10) : results;
        }

}