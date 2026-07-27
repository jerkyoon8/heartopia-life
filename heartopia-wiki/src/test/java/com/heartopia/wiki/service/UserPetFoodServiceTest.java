package com.heartopia.wiki.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.heartopia.wiki.exception.PetFoodValidationException;
import com.heartopia.wiki.mapper.UserMapper;
import com.heartopia.wiki.mapper.UserPetFoodMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class UserPetFoodServiceTest {

    @Mock
    private UserPetFoodMapper mapper;

    @Mock
    private UserMapper userMapper;

    private UserPetFoodService service;

    @BeforeEach
    void setUp() {
        service = new UserPetFoodService(mapper, userMapper, new ObjectMapper());
    }

    @Test
    @DisplayName("신규 선택 필드가 없는 기존 프로필도 저장할 수 있다")
    void savePetFoodProfiles_acceptsLegacyProfile() {
        Map<String, Object> profile = baseProfile();

        service.savePetFoodProfiles(1L, List.of(profile));

        ArgumentCaptor<String> jsonCaptor = ArgumentCaptor.forClass(String.class);
        verify(mapper).upsertPetsJson(org.mockito.ArgumentMatchers.eq(1L), jsonCaptor.capture());
        assertTrue(jsonCaptor.getValue().contains("\"name\":\"몽이\""));
    }

    @Test
    @DisplayName("사용자 정의 먹이 이름은 80자를 초과할 수 없다")
    void savePetFoodProfiles_rejectsLongCustomFoodName() {
        Map<String, Object> profile = baseProfile();
        profile.put("customFoods", List.of(Map.of(
                "id", "custom-food-1",
                "name", "가".repeat(81)
        )));

        PetFoodValidationException exception = assertThrows(
                PetFoodValidationException.class,
                () -> service.savePetFoodProfiles(1L, List.of(profile))
        );

        assertTrue(exception.getMessage().contains("80자 이하"));
        verify(mapper, never()).upsertPetsJson(anyLong(), anyString());
    }

    @Test
    @DisplayName("사용자 정의 먹이는 반려동물당 100개를 초과할 수 없다")
    void savePetFoodProfiles_rejectsTooManyCustomFoods() {
        Map<String, Object> profile = baseProfile();
        List<Map<String, Object>> customFoods = new ArrayList<>();
        for (int index = 0; index < 101; index++) {
            customFoods.add(Map.of(
                    "id", "custom-food-" + index,
                    "name", "먹이" + index
            ));
        }
        profile.put("customFoods", customFoods);

        PetFoodValidationException exception = assertThrows(
                PetFoodValidationException.class,
                () -> service.savePetFoodProfiles(1L, List.of(profile))
        );

        assertTrue(exception.getMessage().contains("최대 100개"));
        verify(mapper, never()).upsertPetsJson(anyLong(), anyString());
    }

    @Test
    @DisplayName("사용자 정의 먹이는 배열 구조여야 한다")
    void savePetFoodProfiles_rejectsInvalidCustomFoodStructure() {
        Map<String, Object> profile = baseProfile();
        profile.put("customFoods", Map.of("id", "custom-food-1", "name", "닭가슴살"));

        assertThrows(
                PetFoodValidationException.class,
                () -> service.savePetFoodProfiles(1L, List.of(profile))
        );

        verify(mapper, never()).upsertPetsJson(anyLong(), anyString());
    }

    @Test
    @DisplayName("공백 차이만 있는 사용자 정의 먹이 이름은 중복으로 거부한다")
    void savePetFoodProfiles_rejectsDuplicateNormalizedFoodNames() {
        Map<String, Object> profile = baseProfile();
        profile.put("customFoods", List.of(
                Map.of("id", "custom-food-1", "name", "닭 가슴살"),
                Map.of("id", "custom-food-2", "name", "닭가슴살")
        ));

        PetFoodValidationException exception = assertThrows(
                PetFoodValidationException.class,
                () -> service.savePetFoodProfiles(1L, List.of(profile))
        );

        assertTrue(exception.getMessage().contains("중복된 사용자 정의 먹이 이름"));
        verify(mapper, never()).upsertPetsJson(anyLong(), anyString());
    }

    @Test
    @DisplayName("먹이 선호도와 먹여봄 기록의 값 타입을 검증한다")
    void savePetFoodProfiles_rejectsInvalidStateValues() {
        Map<String, Object> profile = baseProfile();
        profile.put("preferences", Map.of("사과", "favorite"));
        profile.put("tried", Map.of("사과", "true"));

        assertThrows(
                PetFoodValidationException.class,
                () -> service.savePetFoodProfiles(1L, List.of(profile))
        );

        verify(mapper, never()).upsertPetsJson(anyLong(), anyString());
    }

    @Test
    @DisplayName("동기화 요청도 저장 전에 동일한 검증을 적용한다")
    void toggleSync_rejectsInvalidLocalDataBeforeWrite() {
        Map<String, Object> profile = baseProfile();
        profile.put("type", "rabbit");

        assertThrows(
                PetFoodValidationException.class,
                () -> service.toggleSync(1L, true, List.of(profile))
        );

        verify(mapper, never()).upsertPetsJson(anyLong(), anyString());
        verify(userMapper, never()).updatePetFoodSyncEnabled(1L, true);
    }

    @Test
    @DisplayName("80자 이름과 사용자 정의 먹이 100개는 허용한다")
    void savePetFoodProfiles_acceptsBoundaryValues() {
        Map<String, Object> profile = baseProfile();
        profile.put("name", "펫".repeat(40));
        List<Map<String, Object>> customFoods = new ArrayList<>();
        for (int index = 0; index < 100; index++) {
            customFoods.add(Map.of(
                    "id", "custom-food-" + index,
                    "name", "먹이" + index
            ));
        }
        profile.put("customFoods", customFoods);

        service.savePetFoodProfiles(1L, List.of(profile));

        verify(mapper).upsertPetsJson(org.mockito.ArgumentMatchers.eq(1L), anyString());
    }

    @Test
    @DisplayName("호텔 입실 상태는 불리언으로 저장할 수 있다")
    void savePetFoodProfiles_acceptsHotelStatus() {
        Map<String, Object> profile = baseProfile();
        profile.put("inHotel", true);

        service.savePetFoodProfiles(1L, List.of(profile));

        ArgumentCaptor<String> jsonCaptor = ArgumentCaptor.forClass(String.class);
        verify(mapper).upsertPetsJson(org.mockito.ArgumentMatchers.eq(1L), jsonCaptor.capture());
        assertTrue(jsonCaptor.getValue().contains("\"inHotel\":true"));
    }

    @Test
    @DisplayName("호텔 입실 상태는 전체 프로필 20마리까지 저장할 수 있다")
    void savePetFoodProfiles_acceptsTwentyPetsInHotel() {
        service.savePetFoodProfiles(1L, hotelProfiles(20));

        verify(mapper).upsertPetsJson(org.mockito.ArgumentMatchers.eq(1L), anyString());
    }

    @Test
    @DisplayName("호텔 입실 상태는 불리언이어야 한다")
    void savePetFoodProfiles_rejectsInvalidHotelStatusType() {
        Map<String, Object> profile = baseProfile();
        profile.put("inHotel", "true");

        PetFoodValidationException exception = assertThrows(
                PetFoodValidationException.class,
                () -> service.savePetFoodProfiles(1L, List.of(profile))
        );

        assertTrue(exception.getMessage().contains("true 또는 false"));
        verify(mapper, never()).upsertPetsJson(anyLong(), anyString());
    }

    private List<Map<String, Object>> hotelProfiles(int count) {
        List<Map<String, Object>> profiles = new ArrayList<>();
        for (int index = 0; index < count; index++) {
            Map<String, Object> profile = baseProfile();
            profile.put("id", "pet-" + index);
            profile.put("name", "반려동물" + index);
            profile.put("inHotel", true);
            profiles.add(profile);
        }
        return profiles;
    }

    private Map<String, Object> baseProfile() {
        Map<String, Object> profile = new LinkedHashMap<>();
        profile.put("id", "pet-1");
        profile.put("name", "몽이");
        profile.put("type", "dog");
        profile.put("preferences", Map.of());
        profile.put("tried", Map.of());
        return profile;
    }
}
