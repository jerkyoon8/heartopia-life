const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { snowMatches } = require('../../main/resources/static/js/snow.js');
const data = JSON.parse(fs.readFileSync(path.join(__dirname, '../../main/resources/static/snow/catalog/snow-sculptures.json'), 'utf8'));
const items = data.items.map(i => ({name:i.name_ko, level:i.filter_level, weather:i.weather.join('|')}));
const filters = (overrides = {}) => ({query:'', level:'all', weather:'all', ...overrides});
test('weather filter includes all-weather sculptures and the matching special sculpture', () => {
    assert.equal(items.filter(i => snowMatches(i, filters({weather:'맑음'}))).length, 14);
    assert.equal(items.filter(i => snowMatches(i, filters({weather:'눈'}))).length, 14);
    assert.equal(items.filter(i => snowMatches(i, filters({weather:'무지개'}))).length, 15);
});
test('sunny rabbit does not appear in rain and rainy bear does not appear in sun', () => {
    assert.equal(items.filter(i => snowMatches(i, filters({query:'토끼', weather:'비'}))).length, 0);
    assert.equal(items.filter(i => snowMatches(i, filters({query:'베어', weather:'맑음'}))).length, 0);
});
test('conflicting unlock levels remain separate instead of appearing as confirmed levels', () => {
    assert.equal(items.filter(i => snowMatches(i, filters({level:'unverified'}))).length, 2);
    assert.equal(items.filter(i => snowMatches(i, filters({query:'마시모',level:'3'}))).length, 0);
});
test('search trims whitespace and combines with level and weather', () => {
    assert.equal(items.filter(i => snowMatches(i, filters({query:'  이글루  ',level:'1',weather:'눈'}))).length, 1);
    assert.equal(items.filter(i => snowMatches(i, filters({query:'없는 조각'}))).length, 0);
});
test('unfiltered catalog preserves all 15 sculptures', () => {
    assert.equal(items.filter(i => snowMatches(i, filters())).length, 15);
});
