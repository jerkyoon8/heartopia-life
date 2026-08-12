package com.heartopia.wiki.service;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class MasteryThresholdValidatorTest {

    @Test
    void acceptsAllBlankOrCompleteOrderedThresholds() {
        assertThatCode(() -> MasteryThresholdValidator.validate(null, null, null, null))
                .doesNotThrowAnyException();
        assertThatCode(() -> MasteryThresholdValidator.validate(20, 20, 60, 120))
                .doesNotThrowAnyException();
    }

    @Test
    void rejectsPartialThresholds() {
        assertThatThrownBy(() -> MasteryThresholdValidator.validate(20, null, 60, 120))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("네 단계");
    }

    @Test
    void rejectsNegativeOrDescendingThresholds() {
        assertThatThrownBy(() -> MasteryThresholdValidator.validate(-1, 20, 60, 120))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("0 이상");
        assertThatThrownBy(() -> MasteryThresholdValidator.validate(20, 10, 60, 120))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("순서");
    }
}
