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
    forageable: { icon: '🌿', color: '#37b24d', label: '채집물' }
};

window.MapApp.state = {
    map: null,
    allPins: [],
    masterForageables: [],
    masterFish: [],
    masterBirds: [],
    masterInsects: [],
    masterAnimals: [],
    masterVillagers: [],
    allZones: [],           // 전체 zone 목록
    activeZoneLayers: [],   // 현재 표시 중인 폴리곤 레이어들
    zoneEditMode: {
        active: false,
        targetZoneKey: null,
        points: []          // 수집 중인 좌표 배열
    },
    markers: {}, // pinId -> marker
    categoryVisible: {},
    itemVisible: {}, // Used for forageable names to toggle all pins of that name
    expandedCategories: {},
    allVisible: true,
    placementMode: {
        active: false,
        pinTemplate: null,
        isContinuous: false
    }
};

window.MapApp.imageUrl = '/images/map/heartopia-map.png';
