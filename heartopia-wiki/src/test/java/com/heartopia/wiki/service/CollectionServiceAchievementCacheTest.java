package com.heartopia.wiki.service;

import org.junit.jupiter.api.Test;
import org.springframework.cache.annotation.CacheEvict;

import java.lang.reflect.Method;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class CollectionServiceAchievementCacheTest {

    @Test
    void achievementWritesEvictListAndDetailCaches() throws NoSuchMethodException {
        for (Method method : List.of(
                CollectionService.class.getMethod("addAchievement", com.heartopia.wiki.model.Achievement.class),
                CollectionService.class.getMethod("updateAchievement", com.heartopia.wiki.model.Achievement.class),
                CollectionService.class.getMethod("deleteAchievement", Integer.class))) {
            CacheEvict eviction = method.getAnnotation(CacheEvict.class);

            assertThat(eviction).as(method.getName()).isNotNull();
            assertThat(eviction.allEntries()).as(method.getName()).isTrue();
            assertThat(eviction.value()).as(method.getName())
                    .contains("allAchievements", "achievementDetail");
        }
    }
}
