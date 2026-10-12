window.MapApp = window.MapApp || {};

window.MapApp.CATEGORY_CONFIG = {
    villager: { icon: '👤', color: '#4dabf7', label: '주민' },
    fish: { icon: '🐟', color: '#69db7c', label: '생선' },
    insect: { icon: '🦗', color: '#a9e34b', label: '곤충' },
    bird: { icon: '🐦', color: '#ffd43b', label: '새' },
    animal: { icon: '🐾', color: '#ff922b', label: '동물' },
    bus: { icon: '🚌', color: '#da77f2', label: '버스' },
    shop: { icon: '🏠', color: '#f06595', label: '상점' },
    resource: { icon: '💎', color: '#20c997', label: '자원' },
    forageable: { icon: '🌿', color: '#37b24d', label: '채집물' },
    dynamic_resource: { icon: '🔄', color: '#845ef7', label: '변동 자원' },
    trend_season: { icon: '★', color: '#e599f7', label: '트렌드 시즌' }
};

window.MapApp.MULTI_LOCATION_CATEGORIES = ['forageable', 'dynamic_resource'];

window.MapApp.getItemVisibilityKey = function (category, item) {
    return window.MapApp.MULTI_LOCATION_CATEGORIES.includes(category)
        ? `${category}:${item.name}`
        : item.id;
};

window.MapApp.MAPS = {
    town: {
        key: 'town',
        label: '고래섬',
        description: '기본 고래섬 지도',
        imageUrl: '/images/map/heartopia-map.webp',
        dataCategories: ['forageable', 'fish', 'bird', 'insect', 'animal', 'villager', 'dynamic_resource'],
        isDefault: true
    },
    second: {
        key: 'second',
        label: '고래낙하 협곡',
        description: '고래 탐사 시즌 지도',
        imageUrl: '/images/map/second-map.webp',
        dataCategories: ['forageable', 'animal', 'dynamic_resource'],
        isDefault: false
    }
};

window.MapApp.getInitialMapKey = function () {
    const params = new URLSearchParams(window.location.search);
    const mapKey = params.get('mapKey') || 'town';
    return window.MapApp.MAPS[mapKey] ? mapKey : 'town';
};

window.MapApp.getActiveMap = function () {
    return window.MapApp.MAPS[window.MapApp.state.activeMapKey] || window.MapApp.MAPS.town;
};

window.MapApp.getActiveDataCategories = function () {
    const activeMap = window.MapApp.getActiveMap();
    return activeMap.dataCategories || window.MapApp.MAPS.town.dataCategories;
};

window.MapApp.belongsToActiveMap = function (item) {
    const activeMap = window.MapApp.getActiveMap();
    if (!item || !activeMap) return false;
    return activeMap.isDefault ? (!item.mapKey || item.mapKey === activeMap.key) : item.mapKey === activeMap.key;
};

window.MapApp.state = {
    map: null,
    activeMapKey: window.MapApp.getInitialMapKey(),
    allPins: [],
    masterForageables: [],
    masterFish: [],
    masterBirds: [],
    masterInsects: [],
    masterAnimals: [],
    masterVillagers: [],
    masterDynamicResources: [],
    allZones: [],           // 전체 zone 목록
    activeZoneLayers: [],   // 현재 표시 중인 폴리곤 레이어들
    zoneEditMode: {
        active: false,
        targetZoneKey: null,
        points: []          // 수집 중인 좌표 배열
    },
    markers: {}, // pinId -> marker
    categoryVisible: { trend_season: true },
    itemVisible: {}, // Used for forageable names to toggle all pins of that name
    expandedCategories: {},
    allVisible: true,
    placementMode: {
        active: false,
        pinTemplate: null,
        isContinuous: false
    }
};

window.MapApp.imageUrl = window.MapApp.getActiveMap().imageUrl;

window.MapApp.getInitialItemVisibility = function (category, item) {
    const state = window.MapApp.state;
    const isSeasonItem = state.masterDynamicResources.some(resource => resource.eventName && resource.name === item.name &&
        (resource.forageableId ? category === 'forageable' : category === 'dynamic_resource'));
    return state.categoryVisible[category] || (isSeasonItem && state.categoryVisible.trend_season === true);
};
