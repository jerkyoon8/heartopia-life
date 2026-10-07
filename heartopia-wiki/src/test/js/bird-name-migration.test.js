const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const {
    migrateBirdChecklistData, migrateBirdChecklistStorage
} = require('../../main/resources/static/js/bird-name-migration.js');

function storageFor(raw) {
    const values = new Map(raw === undefined ? [] : [['heartopia_checklist', raw]]);
    return {
        values,
        getItem: key => values.get(key) ?? null,
        setItem: (key, value) => values.set(key, value)
    };
}

test('일반·명인 기록을 별도로 이관하고 충돌 시 높은 별점을 유지한다', () => {
    const source = {
        'bird_쇠찌르레기': 5, 'bird_보라등찌르레기': 2,
        'mastery_bird_쇠찌르레기': 1, 'mastery_bird_보라등찌르레기': 3,
        'fish_배스': 4
    };
    const result = migrateBirdChecklistData(source);
    assert.deepEqual(result.data, {
        'bird_보라등찌르레기': 5, 'mastery_bird_보라등찌르레기': 3, 'fish_배스': 4
    });
    assert.equal(source['bird_쇠찌르레기'], 5);
    assert.equal(result.changed, true);
});

test('신키가 없는 일반·명인 0점도 그대로 보존한다', () => {
    const storage = storageFor(JSON.stringify({
        'bird_쇠찌르레기': 0, 'mastery_bird_쇠찌르레기': 0
    }));
    assert.equal(migrateBirdChecklistStorage(storage), true);
    assert.deepEqual(JSON.parse(storage.getItem('heartopia_checklist')), {
        'bird_보라등찌르레기': 0, 'mastery_bird_보라등찌르레기': 0
    });
});

test('가아피쉬 이관 완료와 무관하게 실행하고 재유입된 구키도 재이관한다', () => {
    const storage = storageFor(JSON.stringify({ 'bird_쇠찌르레기': 4 }));
    storage.setItem('heartopia_checklist_gaafish_version', '1');
    assert.equal(migrateBirdChecklistStorage(storage), true);
    storage.setItem('heartopia_checklist', JSON.stringify({
        'bird_쇠찌르레기': 5, 'bird_보라등찌르레기': 4
    }));
    assert.equal(migrateBirdChecklistStorage(storage), true);
    assert.equal(JSON.parse(storage.getItem('heartopia_checklist'))['bird_보라등찌르레기'], 5);
    storage.setItem = () => assert.fail('구키가 없으면 저장하지 않는다');
    assert.equal(migrateBirdChecklistStorage(storage), false);
});

test('손상 JSON과 잘못된 루트 데이터는 덮어쓰지 않는다', () => {
    for (const raw of ['{broken', 'null', '[]', '4']) {
        const storage = storageFor(raw);
        assert.equal(migrateBirdChecklistStorage(storage), false);
        assert.equal(storage.getItem('heartopia_checklist'), raw);
    }
});

test('저장 실패 시 원본을 유지하고 다음 실행에서 재시도한다', () => {
    const raw = JSON.stringify({ 'bird_쇠찌르레기': 3 });
    const storage = storageFor(raw);
    const save = storage.setItem;
    storage.setItem = () => { throw new Error('quota'); };
    assert.equal(migrateBirdChecklistStorage(storage), false);
    assert.equal(storage.getItem('heartopia_checklist'), raw);
    storage.setItem = save;
    assert.equal(migrateBirdChecklistStorage(storage), true);
});

test('잘못된 충돌 값이 있으면 전체 원본을 보존한다', () => {
    const raw = JSON.stringify({ 'bird_쇠찌르레기': 'broken', 'bird_보라등찌르레기': 2 });
    const storage = storageFor(raw);
    assert.equal(migrateBirdChecklistStorage(storage), false);
    assert.equal(storage.getItem('heartopia_checklist'), raw);
});

test('빈 저장소는 쓰지 않는다', () => {
    const storage = storageFor();
    storage.setItem = () => assert.fail('빈 저장소를 변경하지 않는다');
    assert.equal(migrateBirdChecklistStorage(storage), false);
});

test('공통 헤드에서 로그인 병합 및 ChecklistCore 초기화 전에 이관한다', () => {
    const head = fs.readFileSync(path.join(__dirname,
        '../../main/resources/templates/fragments/common-head.html'), 'utf8');
    const script = head.indexOf('/js/bird-name-migration.js');
    const migrate = head.indexOf('HeartopiaBirdNameMigration?.migrateBirdChecklistStorage');
    assert.ok(script >= 0 && script < migrate);
    assert.ok(migrate < head.indexOf("fetch('/api/user/checklist/migrate'"));
    assert.ok(migrate < head.indexOf('/js/checklist-core.js'));
});

test('비로그인·동기화 OFF는 신키를 읽고 동기화 ON은 신키를 서버에 전송한다', async () => {
    const resource = file => fs.readFileSync(path.join(__dirname, '../../main/resources/', file), 'utf8');
    const head = resource('templates/fragments/common-head.html');
    const inline = head.match(/<script th:inline="javascript">([\s\S]*?)<\/script>/)[1];
    for (const sync of [false, true]) {
        const storage = storageFor(JSON.stringify({ 'bird_쇠찌르레기': 4, 'mastery_bird_쇠찌르레기': 2 }));
        storage.removeItem = key => storage.values.delete(key);
        const requests = [];
        const context = vm.createContext({
            localStorage: storage, console,
            document: { querySelector: () => ({ getAttribute: () => 'test-csrf' }) },
            fetch: (url, options) => {
                requests.push({ url, data: JSON.parse(options.body) });
                return Promise.resolve({ ok: true });
            },
            addEventListener: () => {}
        });
        context.window = context;
        vm.runInContext(resource('static/js/bird-name-migration.js'), context);
        vm.runInContext(inline.replace(
            /window\._heartopiaChecklistSyncEnabled = [^\n]+/,
            `window._heartopiaChecklistSyncEnabled = ${sync};`), context);
        vm.runInContext(resource('static/js/checklist-core.js'), context);
        await context._checklistMergeOnLogin;
        const expected = { 'bird_보라등찌르레기': 4, 'mastery_bird_보라등찌르레기': 2 };
        if (sync) {
            assert.equal(requests[0].url, '/api/user/checklist/migrate');
            assert.deepEqual(requests[0].data, expected);
            assert.equal(storage.getItem('heartopia_checklist'), null);
        } else {
            assert.equal(requests.length, 0);
            assert.deepEqual(JSON.parse(vm.runInContext('JSON.stringify(ChecklistCore.getData())', context)), expected);
        }
    }
});

test('동기화 ON에서 이관 저장 실패 시 병합·삭제하지 않고 다음 방문에 재시도한다', async () => {
    const resource = file => fs.readFileSync(path.join(__dirname, '../../main/resources/', file), 'utf8');
    const inline = resource('templates/fragments/common-head.html')
        .match(/<script th:inline="javascript">([\s\S]*?)<\/script>/)[1]
        .replace(/window\._heartopiaChecklistSyncEnabled = [^\n]+/,
            'window._heartopiaChecklistSyncEnabled = true;');
    const raw = JSON.stringify({ 'bird_쇠찌르레기': 5, 'mastery_bird_쇠찌르레기': 2 });
    const storage = storageFor(raw);
    const save = storage.setItem;
    storage.setItem = () => { throw new Error('quota'); };
    storage.removeItem = key => storage.values.delete(key);
    const requests = [];
    const context = vm.createContext({
        localStorage: storage,
        document: { querySelector: () => ({ getAttribute: () => 'test-csrf' }) },
        fetch: (url, options) => {
            requests.push(JSON.parse(options.body));
            return Promise.resolve({ ok: true });
        }
    });
    context.window = context;
    vm.runInContext(resource('static/js/bird-name-migration.js'), context);
    vm.runInContext(inline, context);
    await context._checklistMergeOnLogin;
    assert.equal(requests.length, 0);
    assert.equal(storage.getItem('heartopia_checklist'), raw);
    storage.setItem = save;
    vm.runInContext(inline, context);
    await context._checklistMergeOnLogin;
    assert.deepEqual(requests, [{ 'bird_보라등찌르레기': 5, 'mastery_bird_보라등찌르레기': 2 }]);
    assert.equal(storage.getItem('heartopia_checklist'), null);
});
