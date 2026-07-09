ALTER TABLE fish_collections
    ADD COLUMN mastery_beginner_max INT NULL AFTER event_name,
    ADD COLUMN mastery_intro_min INT NULL AFTER mastery_beginner_max,
    ADD COLUMN mastery_expert_min INT NULL AFTER mastery_intro_min,
    ADD COLUMN mastery_master_min INT NULL AFTER mastery_expert_min;

ALTER TABLE bug_collections
    ADD COLUMN mastery_beginner_max INT NULL AFTER event_name,
    ADD COLUMN mastery_intro_min INT NULL AFTER mastery_beginner_max,
    ADD COLUMN mastery_expert_min INT NULL AFTER mastery_intro_min,
    ADD COLUMN mastery_master_min INT NULL AFTER mastery_expert_min;

ALTER TABLE bird_collections
    ADD COLUMN mastery_beginner_max INT NULL AFTER stretch_time,
    ADD COLUMN mastery_intro_min INT NULL AFTER mastery_beginner_max,
    ADD COLUMN mastery_expert_min INT NULL AFTER mastery_intro_min,
    ADD COLUMN mastery_master_min INT NULL AFTER mastery_expert_min;

ALTER TABLE cooking_collections
    ADD COLUMN mastery_beginner_max INT NULL AFTER event_name,
    ADD COLUMN mastery_intro_min INT NULL AFTER mastery_beginner_max,
    ADD COLUMN mastery_expert_min INT NULL AFTER mastery_intro_min,
    ADD COLUMN mastery_master_min INT NULL AFTER mastery_expert_min;

ALTER TABLE crop_collections
    ADD COLUMN mastery_beginner_max INT NULL AFTER event_name,
    ADD COLUMN mastery_intro_min INT NULL AFTER mastery_beginner_max,
    ADD COLUMN mastery_expert_min INT NULL AFTER mastery_intro_min,
    ADD COLUMN mastery_master_min INT NULL AFTER mastery_expert_min;

ALTER TABLE flower_collections
    ADD COLUMN mastery_beginner_max INT NULL AFTER event_name,
    ADD COLUMN mastery_intro_min INT NULL AFTER mastery_beginner_max,
    ADD COLUMN mastery_expert_min INT NULL AFTER mastery_intro_min,
    ADD COLUMN mastery_master_min INT NULL AFTER mastery_expert_min;
