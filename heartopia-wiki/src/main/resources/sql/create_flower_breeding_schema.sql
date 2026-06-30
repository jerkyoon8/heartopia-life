-- 꽃 성급/색상 및 교배 조합 저장 구조
-- 기존 flower_images는 호환용으로 유지하고, 신규 데이터는 아래 테이블을 사용한다.

CREATE TABLE IF NOT EXISTS flower_variants (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    flower_id     INT          NOT NULL,
    stars         INT          NULL,
    color_name    VARCHAR(100) NULL,
    image_url     VARCHAR(500) NOT NULL,
    sort_order    INT          NOT NULL DEFAULT 0,
    CONSTRAINT fk_flower_variants_flower
        FOREIGN KEY (flower_id) REFERENCES flower_collections(id) ON DELETE CASCADE,
    INDEX idx_flower_variants_flower_id (flower_id),
    INDEX idx_flower_variants_sort (flower_id, sort_order)
);

CREATE TABLE IF NOT EXISTS flower_breeding_rules (
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    flower_id         INT          NOT NULL,
    result_variant_id BIGINT       NOT NULL,
    note              VARCHAR(255) NULL,
    sort_order        INT          NOT NULL DEFAULT 0,
    CONSTRAINT fk_flower_breeding_rules_flower
        FOREIGN KEY (flower_id) REFERENCES flower_collections(id) ON DELETE CASCADE,
    CONSTRAINT fk_flower_breeding_rules_result
        FOREIGN KEY (result_variant_id) REFERENCES flower_variants(id) ON DELETE CASCADE,
    INDEX idx_flower_breeding_rules_flower_id (flower_id),
    INDEX idx_flower_breeding_rules_sort (flower_id, sort_order)
);

CREATE TABLE IF NOT EXISTS flower_breeding_rule_options (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    rule_id    BIGINT      NOT NULL,
    side       VARCHAR(10) NOT NULL,
    variant_id BIGINT      NOT NULL,
    CONSTRAINT fk_flower_breeding_options_rule
        FOREIGN KEY (rule_id) REFERENCES flower_breeding_rules(id) ON DELETE CASCADE,
    CONSTRAINT fk_flower_breeding_options_variant
        FOREIGN KEY (variant_id) REFERENCES flower_variants(id) ON DELETE CASCADE,
    INDEX idx_flower_breeding_options_rule_side (rule_id, side)
);
