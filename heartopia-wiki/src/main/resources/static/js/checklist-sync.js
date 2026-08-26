/**
 * Checklist Global Sync UI Handler
 * - 모든 페이지에서 .sync-item 이 존재하면 ChecklistCore와 연동합니다.
 * - 로그인 시 DB와 동기화합니다.
 */

const SEA_CLEANING_CHECKLIST_VERSION_KEY = 'heartopia_checklist_sea_cleaning_version';
const SEA_CLEANING_CHECKLIST_VERSION = '2';

function countChecklistProgress(sourceData, prefix, total) {
    if (!sourceData || typeof sourceData !== 'object' || Array.isArray(sourceData)
            || typeof prefix !== 'string' || prefix.length === 0
            || !Number.isInteger(total) || total < 0) {
        return 0;
    }

    const completed = Object.keys(sourceData)
        .filter(key => key.startsWith(prefix))
        .length;
    return Math.min(completed, total);
}

function migrateSeaCleaningChecklistData(sourceData, mappings) {
    const data = sourceData && typeof sourceData === 'object' && !Array.isArray(sourceData)
        ? { ...sourceData }
        : {};
    let changed = false;

    const migrateKey = (legacyKey, currentKey) => {
        if (!legacyKey || !currentKey || legacyKey === currentKey
                || !Object.prototype.hasOwnProperty.call(data, legacyKey)) {
            return;
        }

        const legacyValue = data[legacyKey];
        if (Object.prototype.hasOwnProperty.call(data, currentKey)) {
            const currentValue = data[currentKey];
            data[currentKey] = typeof legacyValue === 'number' && typeof currentValue === 'number'
                ? Math.max(legacyValue, currentValue)
                : currentValue;
        } else {
            data[currentKey] = legacyValue;
        }
        delete data[legacyKey];
        changed = true;
    };

    Array.from(mappings || []).forEach(mapping => {
        if (!mapping) return;
        migrateKey(mapping.legacyKey, mapping.currentKey);
        migrateKey('mastery_' + mapping.legacyKey, 'mastery_' + mapping.currentKey);
    });

    return { data, changed };
}

function collectSeaCleaningChecklistMappings(root) {
    const mappings = new Map();
    root.querySelectorAll('[data-legacy-sync-key]').forEach(element => {
        const legacyKey = element.dataset.legacySyncKey;
        const currentKey = element.dataset.syncKey || element.dataset.key;
        if (legacyKey && currentKey) mappings.set(legacyKey, { legacyKey, currentKey });
    });
    return Array.from(mappings.values());
}

function migrateSeaCleaningLocalChecklist(core, root, storage) {
    try {
        if (storage.getItem(SEA_CLEANING_CHECKLIST_VERSION_KEY) === SEA_CLEANING_CHECKLIST_VERSION) {
            return false;
        }

        const mappings = collectSeaCleaningChecklistMappings(root);
        if (mappings.length === 0) return false;

        const original = { ...core.getData() };
        const migrated = migrateSeaCleaningChecklistData(original, mappings);
        if (migrated.changed) {
            mappings.forEach(({ legacyKey, currentKey }) => {
                const masteryLegacyKey = 'mastery_' + legacyKey;
                const masteryCurrentKey = 'mastery_' + currentKey;
                if (Object.prototype.hasOwnProperty.call(migrated.data, currentKey)) {
                    core.setItem(currentKey, migrated.data[currentKey]);
                }
                if (Object.prototype.hasOwnProperty.call(migrated.data, masteryCurrentKey)) {
                    core.setItem(masteryCurrentKey, migrated.data[masteryCurrentKey]);
                }
                if (Object.prototype.hasOwnProperty.call(original, legacyKey)) core.removeItem(legacyKey);
                if (Object.prototype.hasOwnProperty.call(original, masteryLegacyKey)) core.removeItem(masteryLegacyKey);
            });
        }

        storage.setItem(SEA_CLEANING_CHECKLIST_VERSION_KEY, SEA_CLEANING_CHECKLIST_VERSION);
        return migrated.changed;
    } catch (error) {
        return false;
    }
}

async function loadChecklistData(core, root, storage) {
    const hasChecklistConsumer = root.querySelector(
        '.sync-item, .collectible-item, [data-checklist-prefix][data-total]'
    );
    if (!hasChecklistConsumer) return { ok: true, source: 'unused' };

    const syncEnabled = window._heartopiaChecklistSyncEnabled || false;
    if (!syncEnabled) {
        migrateSeaCleaningLocalChecklist(core, root, storage);
        return { ok: true, source: 'local' };
    }

    if (window._checklistMergeOnLogin) await window._checklistMergeOnLogin;
    try {
        const response = await fetch('/api/user/checklist');
        if (!response.ok) return { ok: false, source: 'account' };

        const dbData = await response.json();
        if (typeof core.replaceData === 'function') {
            core.replaceData(dbData);
        } else {
            Object.keys(dbData).forEach(key => core.setItem(key, dbData[key]));
        }
        return { ok: true, source: 'account' };
    } catch (error) {
        return { ok: false, source: 'account' };
    }
}

if (typeof document !== 'undefined' && typeof window !== 'undefined') {
    window._heartopiaChecklistReady = new Promise(resolve => {
        const start = () => {
            if (typeof window.ChecklistCore === 'undefined') {
                resolve({ ok: false, source: 'unavailable' });
                return;
            }
            loadChecklistData(window.ChecklistCore, document, window.localStorage).then(resolve);
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', start, { once: true });
        } else {
            start();
        }
    });
}

if (typeof document !== 'undefined') document.addEventListener('DOMContentLoaded', async () => {
    if (typeof window.ChecklistCore === 'undefined') return;

    const core = window.ChecklistCore;
    const syncEnabled = window._heartopiaChecklistSyncEnabled || false;
    const loadResult = window._heartopiaChecklistReady
        ? await window._heartopiaChecklistReady
        : { ok: true, source: syncEnabled ? 'account' : 'local' };
    const syncItems = document.querySelectorAll('.sync-item');
    const progressItems = document.querySelectorAll('[data-checklist-prefix][data-total]');
    if (syncItems.length === 0 && progressItems.length === 0) return;

    function getCsrf() {
        return {
            token: document.querySelector('meta[name="_csrf"]')?.getAttribute('content'),
            header: document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content')
        };
    }

    // UI 상태 갱신
    function renderItemStatus(itemEl, val) {
        const stars = itemEl.querySelectorAll('.sync-star-icon');
        const checkBtn = itemEl.querySelector('.sync-check-btn');

        if (val !== undefined && val !== null) {
            itemEl.classList.add('checked');
            if (checkBtn) checkBtn.setAttribute('aria-pressed', 'true');
            stars.forEach(star => {
                const sVal = parseInt(star.getAttribute('data-val'));
                if (sVal <= val) {
                    star.classList.add('filled');
                } else {
                    star.classList.remove('filled');
                }
            });
        } else {
            itemEl.classList.remove('checked');
            if (checkBtn) checkBtn.setAttribute('aria-pressed', 'false');
            stars.forEach(star => star.classList.remove('filled'));
        }
    }

    function renderProgressStatus(data) {
        progressItems.forEach(element => {
            if (!loadResult.ok && syncEnabled) {
                element.textContent = '진행도 불러오기 실패';
                element.classList.add('is-error');
                return;
            }

            const prefix = element.getAttribute('data-checklist-prefix');
            const total = Number.parseInt(element.getAttribute('data-total'), 10);
            const completed = countChecklistProgress(data, prefix, total);
            element.textContent = `${completed} / ${Number.isInteger(total) && total >= 0 ? total : 0} 완료`;
            element.classList.remove('is-error');
        });
    }

    function renderMasteryStatus(itemEl, val) {
        const masteryBtn = itemEl.querySelector('.sync-mastery-btn');
        if (!masteryBtn) return;
        if (masteryBtn.getAttribute('aria-disabled') === 'true') {
            itemEl.classList.remove('mastered');
            return;
        }
        if (val !== undefined && val !== null) {
            itemEl.classList.add('mastered');
            masteryBtn.setAttribute('aria-pressed', 'true');
        } else {
            itemEl.classList.remove('mastered');
            masteryBtn.setAttribute('aria-pressed', 'false');
        }
    }

    // 한 화면 내의 모든 아이템 스캔 후 최신화
    function syncAll() {
        const data = core.getData();
        syncItems.forEach(itemEl => {
            const key = itemEl.getAttribute('data-sync-key');
            renderItemStatus(itemEl, data[key]);
            renderMasteryStatus(itemEl, data['mastery_' + key]);
        });
        renderProgressStatus(data);
    }

    // 전역 상태가 바뀌면(다른 탭 등에서) 자동 최신화
    core.subscribe(() => {
        syncAll();
    });

    // 1회 초기 렌더링
    syncAll();

    // 이벤트 리스너 등록 (상세 뷰 및 리스트 뷰 공통)
    syncItems.forEach(itemEl => {
        const key = itemEl.getAttribute('data-sync-key');
        if (!key) return;

        const checkBtn = itemEl.querySelector('.sync-check-btn');
        const masteryBtn = itemEl.querySelector('.sync-mastery-btn');
        const stars = itemEl.querySelectorAll('.sync-star-icon');

        // 체크 버튼 토글
        if (checkBtn) {
            checkBtn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();

                if (itemEl.classList.contains('checked')) {
                    core.removeItem(key);
                    if (syncEnabled) {
                        const csrf = getCsrf();
                        fetch('/api/user/checklist/item', {
                            method: 'DELETE',
                            headers: { 'Content-Type': 'application/json', [csrf.header]: csrf.token },
                            body: JSON.stringify({ key })
                        }).catch(() => {});
                    }
                } else {
                    core.setItem(key, 0);
                    if (syncEnabled) {
                        const csrf = getCsrf();
                        fetch('/api/user/checklist/item', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json', [csrf.header]: csrf.token },
                            body: JSON.stringify({ key, val: 0 })
                        }).catch(() => {});
                    }
                }
            });
        }

        // 명인 토글
        if (masteryBtn) {
            masteryBtn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();

                if (masteryBtn.getAttribute('aria-disabled') === 'true') return;

                const masteryKey = 'mastery_' + key;
                if (itemEl.classList.contains('mastered')) {
                    core.removeItem(masteryKey);
                    if (syncEnabled) {
                        const csrf = getCsrf();
                        fetch('/api/user/checklist/item', {
                            method: 'DELETE',
                            headers: { 'Content-Type': 'application/json', [csrf.header]: csrf.token },
                            body: JSON.stringify({ key: masteryKey })
                        }).catch(() => {});
                    }
                } else {
                    core.setItem(masteryKey, 1);
                    if (syncEnabled) {
                        const csrf = getCsrf();
                        fetch('/api/user/checklist/item', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json', [csrf.header]: csrf.token },
                            body: JSON.stringify({ key: masteryKey, val: 1 })
                        }).catch(() => {});
                    }
                }
            });
        }

        // 별점 토글
        stars.forEach(star => {
            star.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();

                const val = parseInt(star.getAttribute('data-val'));
                core.setItem(key, val);
                if (syncEnabled) {
                    const csrf = getCsrf();
                    fetch('/api/user/checklist/item', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json', [csrf.header]: csrf.token },
                        body: JSON.stringify({ key, val })
                    }).catch(() => {});
                }
            });
        });
    });
});

if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        countChecklistProgress,
        migrateSeaCleaningChecklistData,
        migrateSeaCleaningLocalChecklist
    };
}
