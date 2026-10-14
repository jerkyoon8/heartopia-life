const test = require('node:test');
const assert = require('node:assert/strict');
const vm = require('node:vm');
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '../../main/resources/static/js/map');
function setup(admin=false) {
    const list = { children:[], prepend(el){this.children.unshift(el);}, appendChild(el){this.children.push(el);} };
    const document = {
        createElement(){return {dataset:{},innerHTML:'',querySelectorAll(){return [];}};},
        getElementById(id){return id === 'categoryList' ? list : null;},
        querySelectorAll(){return [];}
    };
    const context = vm.createContext({window:{isAdmin:admin,location:{search:''}},document,URLSearchParams,setTimeout});
    for (const file of ['map-state.js','map-ui.js']) vm.runInContext(fs.readFileSync(path.join(root,file),'utf8'),context);
    const app=context.window.MapApp;
    app.ui.renderLocationList=()=>{};
    app.state.masterForageables=[{id:44,name:'뽕나무버섯',imageUrl:'/mushroom.webp'}];
    app.state.masterDynamicResources=[
        {id:1,name:'뽕나무버섯',forageableId:44,eventName:'밤의 점술회',iconUrl:'/mushroom.webp'},
        {id:2,name:'속이 빈 나무',eventName:'밤의 점술회',iconUrl:'/tree.webp'}
    ];
    return {app,list,context};
}
test('mushroom appears in both lists; tree appears only in the season',()=>{
    const {app,list}=setup(); app.ui.renderCategoryList();
    const trend=list.children[0].innerHTML;
    const forage=list.children.find(c=>c.innerHTML.includes('class="category-header" data-category="forageable"'));
    assert.match(trend,/밤의 점술회/); assert.match(trend,/뽕나무버섯/); assert.match(trend,/속이 빈 나무/);
    assert.match(forage.innerHTML,/뽕나무버섯/); assert.doesNotMatch(forage.innerHTML,/속이 빈 나무/);
    const dynamic=list.children.find(c=>c.innerHTML.includes('class="category-header" data-category="dynamic_resource"'));
    assert.doesNotMatch(dynamic.innerHTML,/속이 빈 나무/);
});
test('season mushroom actions use the original forageable identity and pin count',()=>{
    const {app,list}=setup(true);
    app.state.allPins=[{id:10,category:'forageable',name:'뽕나무버섯',mapX:100,mapY:200}];
    app.ui.renderCategoryList();
    assert.match(list.children[0].innerHTML,/data-id="10" data-category="forageable"/);
    assert.match(list.children[0].innerHTML,/뽕나무버섯 \(1\)/);
    assert.equal(app.state.allPins.length,1);
    app.state.allPins[0].mapX=300; app.ui.renderCategoryList();
    assert.equal(app.state.allPins.length,1); assert.equal(app.state.allPins[0].mapX,300);
    app.state.allPins=[]; app.ui.renderCategoryList();
    assert.match(list.children[0].innerHTML,/뽕나무버섯 \(0\)/);
});
test('visitors have no season registration or edit controls; admins do',()=>{
    const visitor=setup();visitor.app.ui.renderCategoryList();
    assert.doesNotMatch(visitor.list.children[0].innerHTML,/trend-resource-edit|trend-season-rename|dynamic-resource-add-btn/);
    const admin=setup(true);admin.app.ui.renderCategoryList();
    assert.match(admin.list.children[0].innerHTML,/trend-resource-edit/);
    assert.match(admin.list.children[0].innerHTML,/trend-season-rename/);
    assert.match(admin.list.children[0].innerHTML,/data-trend="true"/);
});
test('new season and edited season names render from metadata rather than fixed code',()=>{
    const {app,list}=setup();app.state.masterDynamicResources[1].eventName='새 시즌';
    app.ui.renderCategoryList();assert.match(list.children[0].innerHTML,/새 시즌/);
    app.state.masterDynamicResources.forEach(r=>r.eventName='다음 시즌');app.ui.renderCategoryList();
    assert.match(list.children[0].innerHTML,/다음 시즌/);assert.doesNotMatch(list.children[0].innerHTML,/밤의 점술회/);
});
test('season names and item names cannot inject markup',()=>{
    const {app,list}=setup();app.state.masterDynamicResources[1].eventName='<img onerror=bad>';
    app.state.masterDynamicResources[1].name='"<script>bad</script>';
    app.ui.renderCategoryList();assert.doesNotMatch(list.children[0].innerHTML,/<script>|<img onerror/);
    assert.match(list.children[0].innerHTML,/&lt;img onerror/);
});
test('shared mushroom has one marker even when both lists are visible',()=>{
    const {app}=setup(); const marker={};const layers=new Set();let additions=0;
    app.state.map={hasLayer:m=>layers.has(m),addLayer(m){layers.add(m);additions++;},removeLayer:m=>layers.delete(m)};
    app.state.allPins=[{id:10,category:'forageable',name:'뽕나무버섯'}];app.state.markers[10]=marker;
    app.state.categoryVisible.forageable=false;app.state.categoryVisible.trend_season=true;
    app.ui.updateMarkerVisibility();assert.equal(layers.size,1);
    app.state.categoryVisible.forageable=true;app.ui.updateMarkerVisibility();assert.equal(additions,1);
    app.state.itemVisible['forageable:뽕나무버섯']=false;app.ui.updateMarkerVisibility();assert.equal(layers.size,0);
});
test('fresh season visibility is on so its first toggle disables it',()=>{
    const {app,list}=setup(); assert.equal(app.state.categoryVisible.trend_season,true);
    app.ui.renderCategoryList();assert.doesNotMatch(list.children[0].innerHTML,/category-toggle off/);
    app.state.categoryVisible.trend_season=!app.state.categoryVisible.trend_season;
    app.ui.renderCategoryList();assert.match(list.children[0].innerHTML,/category-toggle off/);
});

test('season forageable starts visible while ordinary forageables stay hidden',()=>{
    const {app}=setup();
    app.state.categoryVisible.forageable=false;
    app.state.categoryVisible.dynamic_resource=true;
    assert.equal(app.getInitialItemVisibility('forageable',{name:'뽕나무버섯'}),true);
    assert.equal(app.getInitialItemVisibility('forageable',{name:'일반 채집물'}),false);
    assert.equal(app.getInitialItemVisibility('dynamic_resource',{name:'속이 빈 나무'}),true);
    app.state.categoryVisible.trend_season=false;
    assert.equal(app.getInitialItemVisibility('forageable',{name:'뽕나무버섯'}),false);
});

test('ordinary dynamic resource control attributes escape names',()=>{
    const {app,list}=setup(true);
    const name='"<script>bad</script>';
    app.state.masterDynamicResources=[{id:3,name,iconUrl:'/tree.webp'}];
    app.state.allPins=[{id:20,name,category:'dynamic_resource',mapX:10,mapY:20}];
    app.ui.renderCategoryList();
    const group=list.children.find(c=>c.innerHTML.includes('data-category="dynamic_resource"'));
    assert.doesNotMatch(group.innerHTML,/<script>|data-name=""/);
    assert.match(group.innerHTML,/data-name="&quot;&lt;script&gt;bad&lt;\/script&gt;"/);
});

test('collapsed ordinary and season lists do not activate image requests',()=>{
    const {app,list}=setup();app.ui.renderCategoryList();
    for (const group of list.children) {
        assert.doesNotMatch(group.innerHTML,/<img\b[^>]*\ssrc=/);
    }
    assert.match(list.children[0].innerHTML,/<img\b[^>]*width="24"[^>]*height="24"/);
});

test('expanding either list activates only its lazy images and survives rerender',()=>{
    const {app,list}=setup();
    const render=()=>{list.children=[];app.ui.renderCategoryList();};
    const forage=()=>list.children.find(c=>c.innerHTML.includes('class="category-header" data-category="forageable"'));
    app.state.expandedCategories.forageable=true;render();
    assert.match(forage().innerHTML,/<img\b[^>]*src="\/mushroom.webp"[^>]*loading="lazy"/);
    assert.doesNotMatch(list.children[0].innerHTML,/<img\b[^>]*\ssrc=/);
    app.state.expandedCategories.trend_season=true;render();
    assert.match(list.children[0].innerHTML,/<img\b[^>]*src="\/tree.webp"[^>]*loading="lazy"/);
    app.state.itemVisible['forageable:뽕나무버섯']=false;render();
    assert.match(forage().innerHTML,/src="\/mushroom.webp"/);
    app.state.expandedCategories.forageable=false;render();
    assert.doesNotMatch(forage().innerHTML,/<img\b[^>]*\ssrc=/);
    app.state.expandedCategories.forageable=true;render();
    assert.match(forage().innerHTML,/src="\/mushroom.webp"/);
});

test('lazy sidebar images preserve escaped URLs',()=>{
    const {app,list}=setup();
    app.state.masterDynamicResources[1].iconUrl='/uploads/tree.webp?name="<&';
    app.state.expandedCategories.trend_season=true;app.ui.renderCategoryList();
    assert.match(list.children[0].innerHTML,/src="\/uploads\/tree.webp\?name=&quot;&lt;&amp;"/);
});
