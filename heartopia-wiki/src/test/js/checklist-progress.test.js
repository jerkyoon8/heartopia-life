const test = require('node:test');
const assert = require('node:assert/strict');

const { countChecklistProgress } = require('../../main/resources/static/js/checklist-sync.js');

test('카테고리 접두사의 일반 체크 키만 완료 수로 센다', () => {
    const data = {
        fish_연어: 0,
        fish_농어: 3,
        mastery_fish_연어: 1,
        bug_나비: 0
    };

    assert.equal(countChecklistProgress(data, 'fish_', 10), 2);
});

test('ID 기반 퍼즐과 모래 조각 키를 각각 집계한다', () => {
    const data = {
        puzzle_id_1: 0,
        puzzle_id_2: 0,
        sandbox_id_1: 0
    };

    assert.equal(countChecklistProgress(data, 'puzzle_id_', 90), 2);
    assert.equal(countChecklistProgress(data, 'sandbox_id_', 30), 1);
});

test('저장 키가 전체 개수보다 많아도 완료 수는 전체를 넘지 않는다', () => {
    const data = {
        achievement_하나: 0,
        achievement_둘: 0,
        achievement_오래된항목: 0
    };

    assert.equal(countChecklistProgress(data, 'achievement_', 2), 2);
});

test('데이터나 전체 수가 유효하지 않으면 안전하게 0을 반환한다', () => {
    assert.equal(countChecklistProgress(null, 'fish_', 10), 0);
    assert.equal(countChecklistProgress({}, '', 10), 0);
    assert.equal(countChecklistProgress({ fish_연어: 0 }, 'fish_', -1), 0);
});
