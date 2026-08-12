package com.heartopia.wiki.service;

import java.util.Arrays;
import java.util.List;

public final class MasteryThresholdValidator {

    private MasteryThresholdValidator() {
    }

    public static void validate(Integer beginnerMax, Integer introMin, Integer expertMin, Integer masterMin) {
        List<Integer> values = Arrays.asList(beginnerMax, introMin, expertMin, masterMin);
        long supplied = values.stream().filter(value -> value != null).count();

        if (supplied == 0) {
            return;
        }
        if (supplied != values.size()) {
            throw new IllegalArgumentException("명인 수치는 네 단계를 모두 입력하거나 모두 비워야 합니다.");
        }
        if (values.stream().anyMatch(value -> value < 0)) {
            throw new IllegalArgumentException("명인 수치는 0 이상이어야 합니다.");
        }
        if (beginnerMax > introMin || introMin > expertMin || expertMin > masterMin) {
            throw new IllegalArgumentException("명인 수치는 초보자, 입문자, 숙련자, 명인 순서로 입력해야 합니다.");
        }
    }
}
