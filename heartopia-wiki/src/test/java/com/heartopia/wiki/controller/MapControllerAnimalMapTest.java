package com.heartopia.wiki.controller;

import com.heartopia.wiki.mapper.LocationZoneMapper;
import com.heartopia.wiki.model.AnimalCollection;
import com.heartopia.wiki.service.CollectionService;
import com.heartopia.wiki.service.MapPinService;
import com.heartopia.wiki.service.VillagerService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class MapControllerAnimalMapTest {

    @Mock
    private MapPinService mapPinService;

    @Mock
    private CollectionService collectionService;

    @Mock
    private VillagerService villagerService;

    @Mock
    private LocationZoneMapper locationZoneMapper;

    @InjectMocks
    private MapController mapController;

    private AnimalCollection townAnimal;
    private AnimalCollection secondMapAnimal;

    @BeforeEach
    void setUp() {
        townAnimal = animal("수달", "강");
        secondMapAnimal = animal("돌고래", "고래낙하 협곡");
        when(collectionService.getAllAnimals()).thenReturn(List.of(townAnimal, secondMapAnimal));
    }

    @Test
    @DisplayName("동물 API는 기본 지도에서 고래낙하 협곡 동물을 제외한다")
    void getAnimalMasterList_filtersTownAnimals() {
        List<AnimalCollection> result = mapController.getAnimalMasterList("town");

        assertEquals(List.of("수달"), result.stream().map(AnimalCollection::getName).toList());
        assertTrue(result.stream().allMatch(animal -> "town".equals(animal.getMapKey())));
    }

    @Test
    @DisplayName("동물 API는 두 번째 지도에서 고래낙하 협곡 동물만 반환한다")
    void getAnimalMasterList_filtersSecondMapAnimals() {
        List<AnimalCollection> result = mapController.getAnimalMasterList("second");

        assertEquals(List.of("돌고래"), result.stream().map(AnimalCollection::getName).toList());
        assertTrue(result.stream().allMatch(animal -> "second".equals(animal.getMapKey())));
    }

    @Test
    @DisplayName("동물 API의 지도 키를 생략하면 기본 지도로 처리한다")
    void getAnimalMasterList_defaultsToTown() {
        List<AnimalCollection> result = mapController.getAnimalMasterList(null);

        assertEquals(List.of("수달"), result.stream().map(AnimalCollection::getName).toList());
        assertEquals("town", result.get(0).getMapKey());
    }

    private AnimalCollection animal(String name, String location) {
        AnimalCollection animal = new AnimalCollection();
        animal.setName(name);
        animal.setLocation(location);
        return animal;
    }
}
