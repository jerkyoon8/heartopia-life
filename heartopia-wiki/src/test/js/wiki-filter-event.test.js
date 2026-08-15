const test = require('node:test');
const assert = require('node:assert/strict');

const {
    WIKI_GENERAL_EVENT_VALUE,
    wikiMatchesEventSelection,
    wikiBuildQuickOnlySelection,
    wikiDeriveQuickFilterState,
    wikiPrepareEventOverrides,
    wikiShouldHideCollected
} = require('../../main/resources/static/js/wiki-filter.js');

test('일반 선택은 event_name이 없는 항목만 포함한다', () => {
    assert.equal(wikiMatchesEventSelection('', [WIKI_GENERAL_EVENT_VALUE]), true);
    assert.equal(wikiMatchesEventSelection('   ', [WIKI_GENERAL_EVENT_VALUE]), true);
    assert.equal(wikiMatchesEventSelection('고래 탐사 시즌', [WIKI_GENERAL_EVENT_VALUE]), false);
});

test('복수 이벤트 선택은 선택된 이벤트의 합집합만 포함한다', () => {
    const selected = ['고래 탐사 시즌', '데이브 더 다이버'];

    assert.equal(wikiMatchesEventSelection('고래 탐사 시즌', selected), true);
    assert.equal(wikiMatchesEventSelection('데이브 더 다이버', selected), true);
    assert.equal(wikiMatchesEventSelection('빙설 시즌', selected), false);
    assert.equal(wikiMatchesEventSelection('', selected), false);
});

test('빠른 전용 보기를 켜면 일반과 빠른 후보가 아닌 이벤트를 제거한다', () => {
    const transition = wikiBuildQuickOnlySelection(
        [WIKI_GENERAL_EVENT_VALUE, '고래 탐사 시즌', '빙설 시즌'],
        ['고래 탐사 시즌', '데이브 더 다이버'],
        true);

    assert.deepEqual(transition, { applied: true, values: ['고래 탐사 시즌'] });
});

test('빠른 전용 보기를 끄면 이벤트 선택을 유지하고 일반을 다시 포함한다', () => {
    const transition = wikiBuildQuickOnlySelection(
        ['고래 탐사 시즌', '데이브 더 다이버'],
        ['고래 탐사 시즌', '데이브 더 다이버'],
        false);

    assert.deepEqual(transition, {
        applied: true,
        values: [WIKI_GENERAL_EVENT_VALUE, '고래 탐사 시즌', '데이브 더 다이버']
    });
});

test('빠른 이벤트가 선택되지 않으면 전용 보기를 적용하지 않는다', () => {
    const selected = [WIKI_GENERAL_EVENT_VALUE, '빙설 시즌'];
    const transition = wikiBuildQuickOnlySelection(
        selected,
        ['고래 탐사 시즌', '데이브 더 다이버'],
        true);

    assert.deepEqual(transition, { applied: false, values: selected });
});

test('최초 빠른 선택은 현재 선택과 관리자 빠른 후보의 교집합이다', () => {
    const state = wikiDeriveQuickFilterState(
        [WIKI_GENERAL_EVENT_VALUE, '고래 탐사 시즌', '빙설 시즌'],
        ['고래 탐사 시즌', '데이브 더 다이버']);

    assert.deepEqual(state, {
        selectedQuick: ['고래 탐사 시즌'],
        quickOnly: false
    });
});

test('일반 없이 빠른 후보만 복수 선택했을 때만 전용 보기로 판정한다', () => {
    assert.equal(wikiDeriveQuickFilterState(
        ['고래 탐사 시즌', '데이브 더 다이버'],
        ['고래 탐사 시즌', '데이브 더 다이버']).quickOnly, true);
    assert.equal(wikiDeriveQuickFilterState(
        ['고래 탐사 시즌', '빙설 시즌'],
        ['고래 탐사 시즌', '데이브 더 다이버']).quickOnly, false);
});

test('새 페이지 진입 시 일반 해제 재정의만 제거한다', () => {
    assert.deepEqual(wikiPrepareEventOverrides({
        [WIKI_GENERAL_EVENT_VALUE]: false,
        '고래 탐사 시즌': true,
        '빙설 시즌': false
    }), {
        '고래 탐사 시즌': true,
        '빙설 시즌': false
    });
});

test('별점이 없는 수집 항목은 별점 기준치보다 수집 여부를 먼저 적용한다', () => {
    assert.equal(wikiShouldHideCollected({
        isCollected: true,
        checklistValue: 0,
        threshold: 3,
        supportsStarRating: false
    }), true);
    assert.equal(wikiShouldHideCollected({
        isCollected: false,
        checklistValue: undefined,
        threshold: 3,
        supportsStarRating: false
    }), false);
});

test('별점이 있는 수집 항목에는 설정된 숨김 기준치를 후적용한다', () => {
    assert.equal(wikiShouldHideCollected({
        isCollected: true,
        checklistValue: 0,
        threshold: 3,
        supportsStarRating: true
    }), false);
    assert.equal(wikiShouldHideCollected({
        isCollected: true,
        checklistValue: 3,
        threshold: 3,
        supportsStarRating: true
    }), true);
});
