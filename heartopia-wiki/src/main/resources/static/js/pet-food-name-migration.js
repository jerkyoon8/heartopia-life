(function (root, factory) {
    const api = factory();
    if (typeof module !== 'undefined' && module.exports) module.exports = api;
    if (root) root.HeartopiaGaafishPetFoodMigration = api;
})(typeof window !== 'undefined' ? window : null, function () {
    'use strict';

    const STORAGE_KEY = 'heartopia_pet_food_profiles';
    const VERSION_KEY = 'heartopia_pet_food_gaafish_version';
    const VERSION = '1';
    const NAME_MAPPINGS = [
        ['갈색 얼룩 동갈치', '갈색 얼룩 가아피쉬'],
        ['검은 얼룩 동갈치', '검은 얼룩 가아피쉬'],
        ['연금색 동갈치', '연금색 가아피쉬'],
        ['은색 동갈치', '은색 가아피쉬']
    ];

    function cloneProfiles(sourceProfiles) {
        return sourceProfiles.map(pet => {
            if (!pet || typeof pet !== 'object' || Array.isArray(pet)) return pet;
            return {
                ...pet,
                customFoods: Array.isArray(pet.customFoods)
                    ? pet.customFoods.map(food => food && typeof food === 'object' ? { ...food } : food)
                    : pet.customFoods,
                preferences: pet.preferences && typeof pet.preferences === 'object' && !Array.isArray(pet.preferences)
                    ? { ...pet.preferences }
                    : pet.preferences,
                tried: pet.tried && typeof pet.tried === 'object' && !Array.isArray(pet.tried)
                    ? { ...pet.tried }
                    : pet.tried,
                hiddenFoodIds: Array.isArray(pet.hiddenFoodIds) ? [...pet.hiddenFoodIds] : pet.hiddenFoodIds
            };
        });
    }

    function mergeFoodState(pet, sourceFood, targetFood) {
        if (!sourceFood || !targetFood || sourceFood.id == null || targetFood.id == null) return;
        const sourceId = String(sourceFood.id);
        const targetId = String(targetFood.id);
        if (sourceId === targetId) return;

        if (pet.preferences && typeof pet.preferences === 'object' && !Array.isArray(pet.preferences)
                && Object.prototype.hasOwnProperty.call(pet.preferences, sourceId)) {
            const targetPreference = pet.preferences[targetId];
            if (!Object.prototype.hasOwnProperty.call(pet.preferences, targetId)
                    || targetPreference == null || targetPreference === 'neutral') {
                pet.preferences[targetId] = pet.preferences[sourceId];
            }
            delete pet.preferences[sourceId];
        }

        if (pet.tried && typeof pet.tried === 'object' && !Array.isArray(pet.tried)
                && Object.prototype.hasOwnProperty.call(pet.tried, sourceId)) {
            pet.tried[targetId] = Boolean(pet.tried[targetId]) || Boolean(pet.tried[sourceId]);
            delete pet.tried[sourceId];
        }

        if (Array.isArray(pet.hiddenFoodIds)) {
            const hiddenIds = pet.hiddenFoodIds.map(String);
            if (hiddenIds.includes(sourceId)) hiddenIds.push(targetId);
            pet.hiddenFoodIds = [...new Set(hiddenIds.filter(id => id !== sourceId))];
        }
    }

    function migratePetProfile(pet) {
        if (!pet || typeof pet !== 'object' || !Array.isArray(pet.customFoods)) return false;
        let changed = false;

        NAME_MAPPINGS.forEach(([legacyName, currentName]) => {
            const matchesName = (food, name) => food && typeof food === 'object'
                && typeof food.name === 'string' && food.name.trim() === name;
            let targetFood = pet.customFoods.find(food => matchesName(food, currentName));
            const legacyFoods = pet.customFoods.filter(food => matchesName(food, legacyName));
            if (legacyFoods.length === 0) return;

            if (!targetFood) {
                targetFood = legacyFoods.shift();
                targetFood.name = currentName;
                changed = true;
            }

            legacyFoods.forEach(legacyFood => {
                mergeFoodState(pet, legacyFood, targetFood);
                const index = pet.customFoods.indexOf(legacyFood);
                if (index >= 0) pet.customFoods.splice(index, 1);
                changed = true;
            });
        });

        return changed;
    }

    function migrateGaafishPetProfiles(sourceProfiles) {
        const data = Array.isArray(sourceProfiles) ? cloneProfiles(sourceProfiles) : [];
        let changed = false;
        data.forEach(pet => { if (migratePetProfile(pet)) changed = true; });
        return { data, changed };
    }

    function migrateGaafishPetFoodStorage(storage) {
        try {
            if (storage.getItem(VERSION_KEY) === VERSION) return false;
            const raw = storage.getItem(STORAGE_KEY);
            if (raw === null) {
                storage.setItem(VERSION_KEY, VERSION);
                return false;
            }

            const sourceProfiles = JSON.parse(raw);
            if (!Array.isArray(sourceProfiles)) return false;
            const result = migrateGaafishPetProfiles(sourceProfiles);
            if (result.changed) storage.setItem(STORAGE_KEY, JSON.stringify(result.data));
            storage.setItem(VERSION_KEY, VERSION);
            return result.changed;
        } catch (error) {
            return false;
        }
    }

    return {
        migrateGaafishPetProfiles,
        migrateGaafishPetFoodStorage
    };
});
