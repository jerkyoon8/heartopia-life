const test = require('node:test');
const assert = require('node:assert/strict');

const {
    migrateSeaCleaningChecklistData,
    migrateSeaCleaningLocalChecklist
} = require('../../main/resources/static/js/checklist-sync.js');

test('바다청소 일반 키와 명인 키를 ID 키로 함께 변환한다', () => {
    const result = migrateSeaCleaningChecklistData({
        'sea_cleaning_오래된 조개': 3,
        'mastery_sea_cleaning_오래된 조개': 1,
        'fish_배스': 2
    }, [{
        legacyKey: 'sea_cleaning_오래된 조개',
        currentKey: 'sea_cleaning_id_17'
    }]);

    assert.deepEqual(result.data, {
        'sea_cleaning_id_17': 3,
        'mastery_sea_cleaning_id_17': 1,
        'fish_배스': 2
    });
    assert.equal(result.changed, true);
});

test('구형 키와 ID 키가 충돌하면 더 높은 별점을 보존한다', () => {
    const result = migrateSeaCleaningChecklistData({
        'sea_cleaning_오래된 조개': 5,
        'sea_cleaning_id_17': 2
    }, [{
        legacyKey: 'sea_cleaning_오래된 조개',
        currentKey: 'sea_cleaning_id_17'
    }]);

    assert.deepEqual(result.data, { 'sea_cleaning_id_17': 5 });
});

test('매핑되지 않은 키와 다른 도감 키는 변경하지 않는다', () => {
    const source = {
        'sea_cleaning_삭제된 조개': 4,
        'achievement_수집가': 0
    };
    const result = migrateSeaCleaningChecklistData(source, []);

    assert.deepEqual(result.data, source);
    assert.notEqual(result.data, source);
    assert.equal(result.changed, false);
});

test('마이그레이션 버전이 완료 상태면 DOM과 체크리스트를 순회하지 않는다', () => {
    const core = { getData: () => assert.fail('체크리스트를 읽으면 안 된다') };
    const root = { querySelectorAll: () => assert.fail('DOM을 순회하면 안 된다') };
    const storage = {
        getItem: () => '2',
        setItem: () => assert.fail('버전을 다시 저장하면 안 된다')
    };

    assert.equal(migrateSeaCleaningLocalChecklist(core, root, storage), false);
});

test('로컬 변환이 끝난 뒤에만 버전 2를 기록한다', () => {
    const data = { 'sea_cleaning_오래된 조개': 4 };
    const core = {
        getData: () => data,
        setItem: (key, value) => { data[key] = value; },
        removeItem: key => { delete data[key]; }
    };
    const root = {
        querySelectorAll: () => [{
            dataset: {
                legacySyncKey: 'sea_cleaning_오래된 조개',
                syncKey: 'sea_cleaning_id_17'
            }
        }]
    };
    const versions = new Map();
    const storage = {
        getItem: key => versions.get(key) || null,
        setItem: (key, value) => versions.set(key, value)
    };

    assert.equal(migrateSeaCleaningLocalChecklist(core, root, storage), true);
    assert.deepEqual(data, { 'sea_cleaning_id_17': 4 });
    assert.equal(versions.get('heartopia_checklist_sea_cleaning_version'), '2');
});
