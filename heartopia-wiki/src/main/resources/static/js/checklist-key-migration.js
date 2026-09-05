(function (root, factory) {
    const api = factory();
    if (typeof module !== 'undefined' && module.exports) module.exports = api;
    if (root) root.HeartopiaGaafishChecklistMigration = api;
})(typeof window !== 'undefined' ? window : null, function () {
    'use strict';

    const STORAGE_KEY = 'heartopia_checklist';
    const VERSION_KEY = 'heartopia_checklist_gaafish_version';
    const VERSION = '1';
    const NAME_MAPPINGS = [
        ['fish_갈색 얼룩 동갈치', 'fish_갈색 얼룩 가아피쉬'],
        ['fish_검은 얼룩 동갈치', 'fish_검은 얼룩 가아피쉬'],
        ['fish_연금색 동갈치', 'fish_연금색 가아피쉬'],
        ['fish_은색 동갈치', 'fish_은색 가아피쉬'],
        ['cooking_선인장 갈색 얼룩 동갈치 수프', 'cooking_선인장 갈색 얼룩 가아피쉬 수프'],
        ['cooking_선인장 검은 얼룩 동갈치 수프', 'cooking_선인장 검은 얼룩 가아피쉬 수프'],
        ['cooking_선인장 연금색 동갈치 수프', 'cooking_선인장 연금색 가아피쉬 수프'],
        ['cooking_선인장 은색 동갈치 수프', 'cooking_선인장 은색 가아피쉬 수프'],
        ['cooking_선인장 황금 동갈치 수프', 'cooking_선인장 황금 가아피쉬 수프']
    ];

    function mergeRating(currentValue, legacyValue) {
        const currentNumber = Number(currentValue);
        const legacyNumber = Number(legacyValue);
        if (Number.isFinite(currentNumber) && Number.isFinite(legacyNumber)) {
            return Math.max(currentNumber, legacyNumber);
        }
        return currentValue;
    }

    function migrateGaafishChecklistData(sourceData) {
        const data = sourceData && typeof sourceData === 'object' && !Array.isArray(sourceData)
            ? { ...sourceData }
            : {};
        let changed = false;

        const migrateKey = (legacyKey, currentKey) => {
            if (!Object.prototype.hasOwnProperty.call(data, legacyKey)) return;
            if (Object.prototype.hasOwnProperty.call(data, currentKey)) {
                data[currentKey] = mergeRating(data[currentKey], data[legacyKey]);
            } else {
                data[currentKey] = data[legacyKey];
            }
            delete data[legacyKey];
            changed = true;
        };

        NAME_MAPPINGS.forEach(([legacyKey, currentKey]) => {
            migrateKey(legacyKey, currentKey);
            migrateKey('mastery_' + legacyKey, 'mastery_' + currentKey);
        });

        return { data, changed };
    }

    function migrateGaafishChecklistStorage(storage) {
        try {
            if (storage.getItem(VERSION_KEY) === VERSION) return false;
            const raw = storage.getItem(STORAGE_KEY);
            if (raw === null) {
                storage.setItem(VERSION_KEY, VERSION);
                return false;
            }

            const sourceData = JSON.parse(raw);
            if (!sourceData || typeof sourceData !== 'object' || Array.isArray(sourceData)) return false;
            const result = migrateGaafishChecklistData(sourceData);
            if (result.changed) storage.setItem(STORAGE_KEY, JSON.stringify(result.data));
            storage.setItem(VERSION_KEY, VERSION);
            return result.changed;
        } catch (error) {
            return false;
        }
    }

    return {
        migrateGaafishChecklistData,
        migrateGaafishChecklistStorage
    };
});
