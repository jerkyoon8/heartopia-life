package com.heartopia.wiki.service;

import org.junit.jupiter.api.Test;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.concurrent.ConcurrentMapCacheManager;

import java.util.Arrays;

import static org.assertj.core.api.Assertions.assertThat;

class CatalogCacheServiceTest {
    @Test
    void clearsAllCatalogCachesAndPreservesOtherCaches() {
        ConcurrentMapCacheManager manager = new ConcurrentMapCacheManager();
        for (String name : CatalogCacheService.CATALOG_CACHE_NAMES) {
            manager.getCache(name).put("item", "old data");
        }
        manager.getCache("sessions").put("user", "logged in");
        manager.getCache("weather").put("today", "sunny");
        CatalogCacheService service = new CatalogCacheService(manager);

        service.clearCatalogCaches();
        service.clearCatalogCaches();

        for (String name : CatalogCacheService.CATALOG_CACHE_NAMES) {
            assertThat(manager.getCache(name).get("item")).as(name).isNull();
        }
        assertThat(manager.getCache("sessions").get("user", String.class)).isEqualTo("logged in");
        assertThat(manager.getCache("weather").get("today", String.class)).isEqualTo("sunny");
    }

    @Test
    void doesNotCreateUnusedCaches() {
        ConcurrentMapCacheManager manager = new ConcurrentMapCacheManager();
        new CatalogCacheService(manager).clearCatalogCaches();
        assertThat(manager.getCacheNames()).isEmpty();
    }

    @Test
    void allowlistCoversCachesDeclaredByCatalogServices() {
        for (Class<?> type : new Class<?>[]{CollectionService.class}) {
            Arrays.stream(type.getDeclaredMethods()).forEach(method -> {
                Cacheable annotation = method.getAnnotation(Cacheable.class);
                if (annotation != null) {
                    Arrays.stream(annotation.value()).forEach(name ->
                            assertThat(CatalogCacheService.CATALOG_CACHE_NAMES).contains(name));
                    Arrays.stream(annotation.cacheNames()).forEach(name ->
                            assertThat(CatalogCacheService.CATALOG_CACHE_NAMES).contains(name));
                }
            });
        }
    }
}
