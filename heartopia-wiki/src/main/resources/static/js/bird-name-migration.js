(function (root, factory) {
    const api = factory();
    if (typeof module !== 'undefined' && module.exports) module.exports = api;
    if (root) root.HeartopiaBirdNameMigration = api;
})(typeof window !== 'undefined' ? window : null, function () {
    'use strict';

    const STORAGE_KEY = 'heartopia_checklist';
    const OLD_KEY = 'bird_쇠찌르레기';
    const NEW_KEY = 'bird_보라등찌르레기';

    function migrateBirdChecklistData(source) {
        const data = { ...source };
        let changed = false;
        for (const prefix of ['', 'mastery_']) {
            const oldKey = prefix + OLD_KEY;
            const newKey = prefix + NEW_KEY;
            if (!Object.prototype.hasOwnProperty.call(data, oldKey)) continue;
            if (Object.prototype.hasOwnProperty.call(data, newKey)) {
                const oldRating = Number(data[oldKey]);
                const newRating = Number(data[newKey]);
                // Invalid conflicting values must not cause the original data to be lost.
                if (!Number.isFinite(oldRating) || !Number.isFinite(newRating)) {
                    throw new Error('Invalid bird checklist rating');
                }
                data[newKey] = Math.max(oldRating, newRating);
            } else {
                data[newKey] = data[oldKey];
            }
            delete data[oldKey];
            changed = true;
        }
        return { data, changed };
    }

    function migrateBirdChecklistStorage(storage) {
        try {
            const raw = storage.getItem(STORAGE_KEY);
            if (raw === null) return false;
            const source = JSON.parse(raw);
            if (!source || typeof source !== 'object' || Array.isArray(source)) return false;
            const result = migrateBirdChecklistData(source);
            // One atomic replacement; do not remove the old keys in storage separately.
            // Always inspect the keys again on the next load: an older tab may write them back.
            if (result.changed) storage.setItem(STORAGE_KEY, JSON.stringify(result.data));
            return result.changed;
        } catch (error) {
            return false;
        }
    }

    return { migrateBirdChecklistData, migrateBirdChecklistStorage };
});
