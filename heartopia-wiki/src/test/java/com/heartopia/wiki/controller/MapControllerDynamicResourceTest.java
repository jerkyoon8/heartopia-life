package com.heartopia.wiki.controller;

import com.heartopia.wiki.mapper.LocationZoneMapper;
import com.heartopia.wiki.model.DynamicMapResource;
import com.heartopia.wiki.model.MapPin;
import com.heartopia.wiki.service.CollectionService;
import com.heartopia.wiki.service.DynamicMapResourceService;
import com.heartopia.wiki.service.DailyResourceLocationService;
import com.heartopia.wiki.service.FileUploadService;
import com.heartopia.wiki.service.MapPinService;
import com.heartopia.wiki.service.VillagerService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockMultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class MapControllerDynamicResourceTest {

    @Mock
    private MapPinService mapPinService;
    @Mock
    private CollectionService collectionService;
    @Mock
    private VillagerService villagerService;
    @Mock
    private LocationZoneMapper locationZoneMapper;
    @Mock
    private DynamicMapResourceService dynamicMapResourceService;
    @Mock
    private FileUploadService fileUploadService;
    @Mock
    private DailyResourceLocationService dailyResourceLocationService;

    @InjectMocks
    private MapController mapController;

    @Test
    @DisplayName("직접 업로드한 이미지는 변동 자원 아이콘 URL로 저장한다")
    void uploadImageIsStoredAsDynamicResourceIcon() throws IOException {
        MockMultipartFile image = new MockMultipartFile(
                "imageFile", "pink-bubble.webp", "image/webp", new byte[]{1, 2, 3});
        when(fileUploadService.upload(image, "dynamic-resource"))
                .thenReturn("/uploads/images/dynamic-resource/1_pink-bubble.webp");
        when(dynamicMapResourceService.create(any(DynamicMapResource.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        ResponseEntity<?> response = mapController.createDynamicResource(
                "town", "핑크버블", null, "오늘의 위치", null, null, "UPLOAD", image);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        DynamicMapResource saved = (DynamicMapResource) response.getBody();
        assertEquals("/uploads/images/dynamic-resource/1_pink-bubble.webp", saved.getIconUrl());
        verify(fileUploadService).upload(image, "dynamic-resource");
    }

    @Test
    @DisplayName("이미지가 아닌 파일은 변동 자원에 업로드할 수 없다")
    void nonImageUploadIsRejected() throws IOException {
        MockMultipartFile textFile = new MockMultipartFile(
                "imageFile", "note.txt", "text/plain", new byte[]{1});

        ResponseEntity<?> response = mapController.createDynamicResource(
                "town", "텍스트", null, null, null, null, "UPLOAD", textFile);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        verify(fileUploadService, never()).upload(any(), any());
        verify(dynamicMapResourceService, never()).create(any());
    }

    @Test
    @DisplayName("업로드 후 자원 생성이 실패하면 저장된 파일을 정리한다")
    void uploadedImageIsDeletedWhenCreateFails() throws IOException {
        MockMultipartFile image = new MockMultipartFile(
                "imageFile", "pink-bubble.webp", "image/webp", new byte[]{1});
        String uploadedUrl = "/uploads/images/dynamic-resource/1_pink-bubble.webp";
        when(fileUploadService.upload(image, "dynamic-resource")).thenReturn(uploadedUrl);
        when(dynamicMapResourceService.create(any(DynamicMapResource.class)))
                .thenThrow(new IllegalArgumentException("중복"));

        ResponseEntity<?> response = mapController.createDynamicResource(
                "town", "핑크버블", null, null, null, null, "UPLOAD", image);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        verify(fileUploadService).delete(uploadedUrl);
    }

    @Test
    @DisplayName("고래섬 초기 핀 응답에는 저장된 수동 핀만 포함한다")
    void townPinsExcludeCurrentDailyResourcePins() {
        MapPin manualPin = new MapPin();
        manualPin.setId(101L);
        manualPin.setMapKey("town");
        manualPin.setCategory("dynamic_resource");
        manualPin.setName("핑크버블");
        manualPin.setMapX(900);
        manualPin.setMapY(700);

        when(mapPinService.getPinsByMapKey("town")).thenReturn(new ArrayList<>(List.of(manualPin)));
        when(collectionService.getAllFish()).thenReturn(List.of());
        when(collectionService.getAllBugs()).thenReturn(List.of());
        when(collectionService.getAllBirds()).thenReturn(List.of());
        when(collectionService.getAllAnimals()).thenReturn(List.of());
        when(collectionService.getAllForageables()).thenReturn(List.of());
        when(villagerService.getAllVillagers()).thenReturn(List.of());
        List<MapPin> pins = mapController.getPins(null, "town");

        assertEquals(1, pins.size());
        assertEquals("핑크버블", pins.get(0).getName());
        verifyNoInteractions(dailyResourceLocationService);
    }
}
