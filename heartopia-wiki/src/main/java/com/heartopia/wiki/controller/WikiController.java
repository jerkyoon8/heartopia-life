package com.heartopia.wiki.controller;

import com.heartopia.wiki.service.CollectionService;
import com.heartopia.wiki.service.VillagerService;
import com.heartopia.wiki.service.NoticeService;
import com.heartopia.wiki.model.*;
import com.heartopia.wiki.dto.wiki.*;
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
        private final NoticeService noticeService;

        @GetMapping
        public String index(Model model) {
                // 1. 공지사항 (Notices)
                List<Notice> notices = noticeService.getActiveNotices();
                model.addAttribute("notices", notices);

                // 2. 컬렉션 (Collections)
                List<CategoryItemDto> basics = new ArrayList<>();
                basics.add(new CategoryItemDto("물고기", "🐟", "/wiki/collections/fish",
                                "/images/collections/fish_collection.png", collectionService.getFishCount()));
                basics.add(new CategoryItemDto("벌레", "🦋", "/wiki/collections/bug",
                                "/images/collections/insect_collection.png", collectionService.getBugCount()));
                basics.add(new CategoryItemDto("새", "🐦", "/wiki/collections/bird",
                                "/images/collections/bird_collection.png", collectionService.getBirdCount()));
                basics.add(new CategoryItemDto("동물", "🐾", "/wiki/collections/animal",
                                "/images/collections/animal_collection.png", collectionService.getAnimalCount()));

                // 2. 아이템들 (Items)
                List<CategoryItemDto> creative = new ArrayList<>();
                creative.add(new CategoryItemDto("요리", "🍳", "/wiki/items/cooking", "/images/activity/cooking.png",
                                collectionService.getCookingCount()));
                creative.add(new CategoryItemDto("작물", "🌽", "/wiki/items/crops", "/images/items/crops.png",
                                collectionService.getCropCount()));
                creative.add(new CategoryItemDto("꽃", "🌻", "/wiki/items/flowers", "/images/activity/gardning.png",
                                collectionService.getFlowerCount()));
                creative.add(new CategoryItemDto("채집", "🥐", "/wiki/collections/forageable", "/images/items/forage.png",
                                collectionService.getForageableCount()));

                // 3. 기타 (Others)
                List<CategoryItemDto> others = new ArrayList<>();
                others.add(new CategoryItemDto("주민", "👤", "/wiki/others/villagers", "/images/others/villages_icon.png", 21));

                model.addAttribute("basics", basics);
                model.addAttribute("creative", creative);
                model.addAttribute("others", others);

                // SEO: /wiki는 heartopia-life.me/의 redirect 대상이므로
                // canonical을 루트(/)로 지정해 Google 중복 페이지 문제 방지
                model.addAttribute("canonicalUrl", "https://heartopia-life.me/");

                return "wiki/wiki";
        }

        // ======================== 목록 페이지 ========================

        @GetMapping("/collections/fish")
        public String fishList(Model model) {
                List<FishDto> list = collectionService.getAllFish().stream()
                                .map(FishDto::from)
                                .toList();
                model.addAttribute("fishList", list);
                model.addAttribute("pageTitle", "물고기 도감");
                model.addAttribute("pageDescription", "두근두근라이프 물고기 전체 목록 - 서식지, 등급별 가격, 시간대 정보를 확인하세요.");
                return "wiki/collections/fish";
        }

        @GetMapping("/collections/bug")
        public String bugList(Model model) {
                List<BugDto> list = collectionService.getAllBugs().stream()
                                .map(BugDto::from)
                                .toList();
                model.addAttribute("bugList", list);
                model.addAttribute("pageTitle", "벌레 도감");
                model.addAttribute("pageDescription", "두근두근라이프 벌레 전체 목록 - 서식지, 등급별 가격, 시간대 정보를 확인하세요.");
                return "wiki/collections/bug";
        }

        @GetMapping("/collections/bird")
        public String birdList(Model model) {
                List<BirdDto> list = collectionService.getAllBirds().stream()
                                .map(BirdDto::from)
                                .toList();
                model.addAttribute("birdList", list);
                model.addAttribute("pageTitle", "새 도감");
                model.addAttribute("pageDescription", "두근두근라이프 새 전체 목록 - 서식지, 등급별 가격, 시간대 정보를 확인하세요.");
                return "wiki/collections/bird";
        }

        @GetMapping("/collections/animal")
        public String animalList(Model model) {
                List<AnimalDto> list = collectionService.getAllAnimals().stream()
                                .map(AnimalDto::from)
                                .toList();
                model.addAttribute("animalList", list);
                model.addAttribute("pageTitle", "동물 도감");
                model.addAttribute("pageDescription", "두근두근라이프 동물 전체 목록 - 서식지, 좋아하는 음식, 날씨 정보를 확인하세요.");
                return "wiki/collections/animal";
        }

        @GetMapping("/items/cooking")
        public String cookingList(Model model) {
                List<CookingCollection> list = collectionService.getAllCookings();

                java.util.Map<Integer, List<com.heartopia.wiki.model.CookingIngredient>> ingredientMap =
                        collectionService.getAllCookingIngredientMap();
                list.forEach(c -> c.setIngredientList(
                        ingredientMap.getOrDefault(c.getId(), List.of())
                ));

                model.addAttribute("cookingList", list);
                model.addAttribute("pageTitle", "요리 레시피");
                model.addAttribute("pageDescription", "두근두근라이프 요리 전체 목록 - 필요 재료, 레벨, 판매 가격 정보를 확인하세요.");
                return "wiki/items/cooking";
        }

        @GetMapping("/items/flowers")
        public String flowerList(Model model) {
                List<FlowerDto> list = collectionService.getAllFlowers().stream()
                                .map(FlowerDto::from)
                                .toList();
                model.addAttribute("flowerList", list);
                model.addAttribute("pageTitle", "꽃 도감");
                model.addAttribute("pageDescription", "두근두근라이프 꽃 전체 목록 - 성장 시간, 씨앗 가격, 등급별 판매가 정보를 확인하세요.");
                return "wiki/items/flowers";
        }

        @GetMapping("/items/crops")
        public String cropList(Model model) {
                List<CropDto> list = collectionService.getAllCrops().stream()
                                .map(CropDto::from)
                                .toList();
                model.addAttribute("cropList", list);
                model.addAttribute("pageTitle", "작물 도감");
                model.addAttribute("pageDescription", "두근두근라이프 작물 전체 목록 - 성장 시간, 씨앗 가격, 등급별 판매가 정보를 확인하세요.");
                return "wiki/items/crops";
        }

        @GetMapping("/collections/forageable")
        public String forageableList(Model model) {
                List<ForageableDto> list = collectionService.getAllForageables().stream()
                                .map(ForageableDto::from)
                                .toList();
                model.addAttribute("forageableList", list);
                model.addAttribute("pageTitle", "채집물 도감");
                model.addAttribute("pageDescription", "두근두근라이프 채집물 전체 목록 - 채집 장소, 판매가, 에너지 정보를 확인하세요.");
                return "wiki/collections/forageable";
        }

        @GetMapping("/others/villagers")
        public String villagers(Model model) {
                List<Villager> villagers = villagerService.getAllVillagers();
                model.addAttribute("villagers", villagers);
                model.addAttribute("pageTitle", "주민 정보");
                model.addAttribute("pageDescription", "두근두근라이프 전체 주민 목록 - 이름, 역할, 선물 취향 정보를 확인하세요.");
                return "wiki/others/villagers";
        }

        // ======================== 상세보기 페이지 ========================

        @GetMapping("/collections/fish/{name}")
        public String fishDetail(@PathVariable String name, Model model) {
                FishCollection item = collectionService.getFishByName(name);
                if (item == null) return "redirect:/wiki/collections/fish";

                model.addAttribute("item", item);
                model.addAttribute("category", "fish");
                model.addAttribute("categoryLabel", "물고기");
                model.addAttribute("categoryIcon", "fas fa-fish");
                model.addAttribute("listUrl", "/wiki/collections/fish");
                model.addAttribute("prices", item.getPrices());
                model.addAttribute("pageTitle", item.getName());
                model.addAttribute("pageDescription", "두근두근라이프 " + item.getName() + " - 서식지, 시간, 날씨, 등급별 가격 공략 정보");

                List<FishCollection> related = collectionService.getFishByLocation(item.getLocation(), name);
                model.addAttribute("relatedItems", related.stream()
                                .map(f -> new SearchResultDto(f.getName(), "fish", "물고기",
                                                "/wiki/collections/fish/" + URLEncoder.encode(f.getName(), StandardCharsets.UTF_8),
                                                f.getLocation() + " · " + f.getLevel() + " Lv"))
                                .toList());

                return "wiki/detail";
        }

        @GetMapping("/collections/bug/{name}")
        public String bugDetail(@PathVariable String name, Model model) {
                BugCollection item = collectionService.getBugByName(name);
                if (item == null) return "redirect:/wiki/collections/bug";

                model.addAttribute("item", item);
                model.addAttribute("category", "bug");
                model.addAttribute("categoryLabel", "벌레");
                model.addAttribute("categoryIcon", "fas fa-bug");
                model.addAttribute("listUrl", "/wiki/collections/bug");
                model.addAttribute("prices", item.getPrices());
                model.addAttribute("pageTitle", item.getName());
                model.addAttribute("pageDescription", "두근두근라이프 " + item.getName() + " - 서식지, 시간, 날씨, 등급별 가격 공략 정보");

                List<BugCollection> related = collectionService.getBugsByLocation(item.getLocation(), name);
                model.addAttribute("relatedItems", related.stream()
                                .map(b -> new SearchResultDto(b.getName(), "bug", "벌레",
                                                "/wiki/collections/bug/" + URLEncoder.encode(b.getName(), StandardCharsets.UTF_8),
                                                b.getLocation() + " · " + b.getLevel() + " Lv"))
                                .toList());

                return "wiki/detail";
        }

        @GetMapping("/collections/bird/{name}")
        public String birdDetail(@PathVariable String name, Model model) {
                BirdCollection item = collectionService.getBirdByName(name);
                if (item == null) return "redirect:/wiki/collections/bird";

                model.addAttribute("item", item);
                model.addAttribute("category", "bird");
                model.addAttribute("categoryLabel", "새");
                model.addAttribute("categoryIcon", "fas fa-dove");
                model.addAttribute("listUrl", "/wiki/collections/bird");
                model.addAttribute("prices", item.getPrices());
                model.addAttribute("pageTitle", item.getName());
                model.addAttribute("pageDescription", "두근두근라이프 " + item.getName() + " - 서식지, 시간, 날씨, 등급별 가격 공략 정보");

                List<BirdCollection> related = collectionService.getBirdsByLocation(item.getLocation(), name);
                model.addAttribute("relatedItems", related.stream()
                                .map(b -> new SearchResultDto(b.getName(), "bird", "새",
                                                "/wiki/collections/bird/" + URLEncoder.encode(b.getName(), StandardCharsets.UTF_8),
                                                b.getLocation() + " · " + b.getLevel() + " Lv"))
                                .toList());

                return "wiki/detail";
        }

        @GetMapping("/collections/animal/{name}")
        public String animalDetail(@PathVariable String name, Model model) {
                AnimalCollection item = collectionService.getAnimalByName(name);
                if (item == null) return "redirect:/wiki/collections/animal";

                String imageUrl = item.getImageUrl();
                model.addAttribute("item", item);
                model.addAttribute("animalImageUrl", imageUrl);
                model.addAttribute("category", "animal");
                model.addAttribute("categoryLabel", "동물");
                model.addAttribute("categoryIcon", "fas fa-paw");
                model.addAttribute("listUrl", "/wiki/collections/animal");
                model.addAttribute("pageTitle", item.getName());
                model.addAttribute("pageDescription", "두근두근라이프 " + item.getName() + " - 서식지, 좋아하는 음식, 날씨 공략 정보");

                List<AnimalCollection> related = collectionService.getAnimalsByLocation(item.getLocation(), name);
                model.addAttribute("relatedItems", related.stream()
                                .map(a -> new SearchResultDto(a.getName(), "animal", "동물",
                                                "/wiki/collections/animal/" + URLEncoder.encode(a.getName(), StandardCharsets.UTF_8),
                                                a.getLocation()))
                                .toList());

                return "wiki/detail";
        }

        @GetMapping("/collections/forageable/{name}")
        public String forageableDetail(@PathVariable String name, Model model) {
                ForageableCollection item = collectionService.getForageableByName(name);
                if (item == null) return "redirect:/wiki/collections/forageable";

                model.addAttribute("item", item);
                model.addAttribute("category", "forageable");
                model.addAttribute("categoryLabel", "채집");
                model.addAttribute("categoryIcon", "fas fa-leaf");
                model.addAttribute("listUrl", "/wiki/collections/forageable");
                model.addAttribute("pageTitle", item.getName());
                model.addAttribute("pageDescription", "두근두근라이프 " + item.getName() + " - 채집 장소, 판매가, 에너지 공략 정보");

                List<ForageableCollection> related = collectionService.getForageablesByLocation(item.getLocation(), name);
                model.addAttribute("relatedItems", related.stream()
                                .map(f -> new SearchResultDto(f.getName(), "forageable", "채집",
                                                "/wiki/collections/forageable/" + URLEncoder.encode(f.getName(), StandardCharsets.UTF_8),
                                                f.getLocation()))
                                .toList());

                return "wiki/detail";
        }

        @GetMapping("/items/cooking/{name}")
        public String cookingDetail(@PathVariable String name, Model model) {
                CookingCollection item = collectionService.getCookingByName(name);
                if (item == null) return "redirect:/wiki/items/cooking";

                List<com.heartopia.wiki.model.CookingIngredient> ingredientList =
                        collectionService.getIngredientsByCookingId(item.getId());
                item.setIngredientList(ingredientList);

                model.addAttribute("item", item);
                model.addAttribute("category", "cooking");
                model.addAttribute("categoryLabel", "요리");
                model.addAttribute("categoryIcon", "fas fa-utensils");
                model.addAttribute("listUrl", "/wiki/items/cooking");
                model.addAttribute("prices", item.getPrices());
                model.addAttribute("pageTitle", item.getName());
                model.addAttribute("pageDescription", "두근두근라이프 " + item.getName() + " - 필요 재료, 레벨, 등급별 가격 공략 정보");

                model.addAttribute("relatedItems", List.of());

                return "wiki/detail";
        }

        @GetMapping("/items/flowers/{name}")
        public String flowerDetail(@PathVariable String name, Model model) {
                FlowerCollection item = collectionService.getFlowerByName(name);
                if (item == null) return "redirect:/wiki/items/flowers";

                model.addAttribute("item", item);
                model.addAttribute("category", "flower");
                model.addAttribute("categoryLabel", "꽃");
                model.addAttribute("categoryIcon", "fas fa-seedling");
                model.addAttribute("listUrl", "/wiki/items/flowers");
                model.addAttribute("pageTitle", item.getName());
                model.addAttribute("pageDescription", "두근두근라이프 " + item.getName() + " - 성장 시간, 씨앗 가격, 등급별 판매가 공략 정보");
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
                if (item == null) return "redirect:/wiki/items/crops";

                model.addAttribute("item", item);
                model.addAttribute("category", "crop");
                model.addAttribute("categoryLabel", "작물");
                model.addAttribute("categoryIcon", "fas fa-carrot");
                model.addAttribute("listUrl", "/wiki/items/crops");
                model.addAttribute("pageTitle", item.getName());
                model.addAttribute("pageDescription", "두근두근라이프 " + item.getName() + " - 성장 시간, 씨앗 가격, 등급별 판매가 공략 정보");
                model.addAttribute("prices", List.of(
                                item.getPrice1() != null ? item.getPrice1() : 0,
                                item.getPrice2() != null ? item.getPrice2() : 0,
                                item.getPrice3() != null ? item.getPrice3() : 0,
                                item.getPrice4() != null ? item.getPrice4() : 0,
                                item.getPrice5() != null ? item.getPrice5() : 0));

                model.addAttribute("relatedItems", List.of());
                return "wiki/detail";
        }

        // ======================== 검색 ========================

        @GetMapping("/search")
        public String search(@RequestParam(name = "q", required = false, defaultValue = "") String keyword,
                        Model model) {
                String q = keyword.trim();
                if (q.isEmpty()) return "redirect:/wiki";
                
                final String searchKeyword = q;
                List<SearchResultDto> allResults = new ArrayList<>();

                collectionService.searchFish(searchKeyword)
                                .forEach(f -> allResults.add(new SearchResultDto(f.getName(), "fish", "물고기",
                                                "/wiki/collections/fish/" + URLEncoder.encode(f.getName(), StandardCharsets.UTF_8),
                                                f.getLocation() + " · " + f.getLevel() + " Lv")));

                collectionService.searchBugs(searchKeyword)
                                .forEach(b -> allResults.add(new SearchResultDto(b.getName(), "bug", "벌레",
                                                "/wiki/collections/bug/" + URLEncoder.encode(b.getName(), StandardCharsets.UTF_8),
                                                b.getLocation() + " · " + b.getLevel() + " Lv")));

                collectionService.searchBirds(searchKeyword)
                                .forEach(b -> allResults.add(new SearchResultDto(b.getName(), "bird", "새",
                                                "/wiki/collections/bird/" + URLEncoder.encode(b.getName(), StandardCharsets.UTF_8),
                                                b.getLocation() + " · " + b.getLevel() + " Lv")));

                collectionService.searchAnimals(searchKeyword)
                                .forEach(a -> allResults.add(new SearchResultDto(a.getName(), "animal", "동물",
                                                "/wiki/collections/animal/" + URLEncoder.encode(a.getName(), StandardCharsets.UTF_8),
                                                a.getLocation())));

                collectionService.searchCookings(searchKeyword)
                                .forEach(c -> allResults.add(new SearchResultDto(c.getName(), "cooking", "요리",
                                                "/wiki/items/cooking/" + URLEncoder.encode(c.getName(), StandardCharsets.UTF_8),
                                                c.getLevel() + " Lv")));

                collectionService.searchFlowers(searchKeyword)
                                .forEach(f -> allResults.add(new SearchResultDto(f.getName(), "flower", "꽃",
                                                "/wiki/items/flowers/" + URLEncoder.encode(f.getName(), StandardCharsets.UTF_8),
                                                f.getLevel() + " Lv")));

                collectionService.searchCrops(searchKeyword)
                                .forEach(c -> allResults.add(new SearchResultDto(c.getName(), "crop", "작물",
                                                "/wiki/items/crops/" + URLEncoder.encode(c.getName(), StandardCharsets.UTF_8),
                                                c.getLevel() + " Lv")));

                collectionService.searchForageables(searchKeyword)
                                .forEach(f -> allResults.add(new SearchResultDto(f.getName(), "forageable", "채집",
                                                "/wiki/collections/forageable/" + URLEncoder.encode(f.getName(), StandardCharsets.UTF_8),
                                                f.getLocation())));

                villagerService.getAllVillagers().stream()
                                .filter(v -> v.getName().contains(searchKeyword))
                                .forEach(v -> allResults.add(new SearchResultDto(v.getName(), "villager", "주민",
                                                "/wiki/others/villagers",
                                                v.getSubTitle() != null ? v.getSubTitle() : "")));

                if (allResults.size() == 1) {
                        return "redirect:" + allResults.get(0).detailUrl();
                }

                Map<String, List<SearchResultDto>> groupedResults = new LinkedHashMap<>();
                for (SearchResultDto result : allResults) {
                        groupedResults.computeIfAbsent(result.categoryLabel(), k -> new ArrayList<>()).add(result);
                }

                model.addAttribute("keyword", searchKeyword);
                model.addAttribute("totalCount", allResults.size());
                model.addAttribute("groupedResults", groupedResults);
                model.addAttribute("pageTitle", "'" + searchKeyword + "' 검색 결과");
                model.addAttribute("pageDescription", "두근두근라이프에서 '" + searchKeyword + "' 관련 도감 검색 결과입니다.");

                return "wiki/search-results";
        }

        @GetMapping("/search/suggest")
        @org.springframework.web.bind.annotation.ResponseBody
        public List<Map<String, String>> suggest(
                        @RequestParam(name = "q", required = false, defaultValue = "") String keyword) {
                String q = keyword.trim();
                if (q.isEmpty() || q.length() < 1) return List.of();

                List<Map<String, String>> results = new ArrayList<>();

                collectionService.searchFish(q).forEach(f -> results.add(Map.of(
                                "name", f.getName(), "category", "fish", "label", "물고기",
                                "url", "/wiki/collections/fish/" + URLEncoder.encode(f.getName(), StandardCharsets.UTF_8),
                                "sub", f.getLocation() + " · " + f.getLevel() + " Lv", "icon", "🐟")));

                collectionService.searchBugs(q).forEach(b -> results.add(Map.of(
                                "name", b.getName(), "category", "bug", "label", "벌레",
                                "url", "/wiki/collections/bug/" + URLEncoder.encode(b.getName(), StandardCharsets.UTF_8),
                                "sub", b.getLocation() + " · " + b.getLevel() + " Lv", "icon", "🦋")));

                collectionService.searchBirds(q).forEach(b -> results.add(Map.of(
                                "name", b.getName(), "category", "bird", "label", "새",
                                "url", "/wiki/collections/bird/" + URLEncoder.encode(b.getName(), StandardCharsets.UTF_8),
                                "sub", b.getLocation() + " · " + b.getLevel() + " Lv", "icon", "🐦")));

                collectionService.searchAnimals(q).forEach(a -> results.add(Map.of(
                                "name", a.getName(), "category", "animal", "label", "동물",
                                "url", "/wiki/collections/animal/" + URLEncoder.encode(a.getName(), StandardCharsets.UTF_8),
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
                                "url", "/wiki/collections/forageable/" + URLEncoder.encode(f.getName(), StandardCharsets.UTF_8),
                                "sub", f.getLocation(), "icon", "🥐")));

                villagerService.getAllVillagers().stream()
                                .filter(v -> v.getName().contains(q))
                                .forEach(v -> results.add(Map.of(
                                                "name", v.getName(), "category", "villager", "label", "주민",
                                                "url", "/wiki/others/villagers",
                                                "sub", v.getSubTitle() != null ? v.getSubTitle() : "", "icon", "👤")));

                return results.size() > 10 ? results.subList(0, 10) : results;
        }

}