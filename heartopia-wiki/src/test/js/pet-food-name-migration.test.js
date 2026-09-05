const test = require('node:test');
const assert = require('node:assert/strict');

const {
    migrateGaafishPetProfiles,
    migrateGaafishPetFoodStorage
} = require('../../main/resources/static/js/pet-food-name-migration.js');

test('펫 먹이 네 이름을 가아피쉬로 바꾸고 기존 상태를 유지한다', () => {
    const source = [{
        id: 'pet-1',
        customFoods: [
            { id: 'old-brown', name: '갈색 얼룩 동갈치' },
            { id: 'old-black', name: '검은 얼룩 동갈치' },
            { id: 'old-pale', name: '연금색 동갈치' },
            { id: 'old-silver', name: '은색 동갈치' }
        ],
        preferences: { 'old-brown': 'like' },
        tried: { 'old-brown': true },
        hiddenFoodIds: ['old-black']
    }];

    const result = migrateGaafishPetProfiles(source);

    assert.deepEqual(result.data[0].customFoods.map(food => food.name), [
        '갈색 얼룩 가아피쉬', '검은 얼룩 가아피쉬', '연금색 가아피쉬', '은색 가아피쉬'
    ]);
    assert.deepEqual(result.data[0].preferences, { 'old-brown': 'like' });
    assert.deepEqual(result.data[0].tried, { 'old-brown': true });
    assert.deepEqual(result.data[0].hiddenFoodIds, ['old-black']);
    assert.equal(result.changed, true);
});

test('구·신 펫 먹이가 중복되면 신 항목으로 상태를 병합한다', () => {
    const result = migrateGaafishPetProfiles([{
        id: 'pet-1',
        customFoods: [
            { id: 'new-id', name: '은색 가아피쉬' },
            { id: 'old-id', name: '은색 동갈치' }
        ],
        preferences: { 'new-id': 'neutral', 'old-id': 'like' },
        tried: { 'new-id': false, 'old-id': true },
        hiddenFoodIds: ['old-id']
    }]);
    const pet = result.data[0];

    assert.deepEqual(pet.customFoods, [{ id: 'new-id', name: '은색 가아피쉬' }]);
    assert.deepEqual(pet.preferences, { 'new-id': 'like' });
    assert.deepEqual(pet.tried, { 'new-id': true });
    assert.deepEqual(pet.hiddenFoodIds, ['new-id']);
});

test('펫 스토리지 마이그레이션은 한 번만 실행한다', () => {
    const values = new Map([['heartopia_pet_food_profiles', JSON.stringify([{
        id: 'pet-1', customFoods: [{ id: 'food-1', name: '연금색 동갈치' }]
    }])]]);
    const storage = {
        getItem: key => values.has(key) ? values.get(key) : null,
        setItem: (key, value) => values.set(key, value)
    };

    assert.equal(migrateGaafishPetFoodStorage(storage), true);
    assert.equal(JSON.parse(values.get('heartopia_pet_food_profiles'))[0].customFoods[0].name, '연금색 가아피쉬');
    assert.equal(values.get('heartopia_pet_food_gaafish_version'), '1');
    assert.equal(migrateGaafishPetFoodStorage(storage), false);
});

test('손상된 펫 JSON은 덮어쓰거나 완료 처리하지 않는다', () => {
    const values = new Map([['heartopia_pet_food_profiles', '[broken']]);
    const storage = {
        getItem: key => values.has(key) ? values.get(key) : null,
        setItem: (key, value) => values.set(key, value)
    };

    assert.equal(migrateGaafishPetFoodStorage(storage), false);
    assert.equal(values.get('heartopia_pet_food_profiles'), '[broken');
    assert.equal(values.has('heartopia_pet_food_gaafish_version'), false);
});
