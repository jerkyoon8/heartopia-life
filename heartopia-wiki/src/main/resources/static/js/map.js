document.addEventListener('DOMContentLoaded', function () {
    const imageUrl = '/images/map/heartopia-map.png';

    // Category config: icon + color for each category
    const CATEGORY_CONFIG = {
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

    // State
    // State
    const state = {
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

    // ===== DOM Elements =====
    const categoryList = document.getElementById('categoryList');
    const pinSearch = document.getElementById('pinSearch');
    const showAllBtn = document.getElementById('showAll');
    const hideAllBtn = document.getElementById('hideAll');
    const placementBanner = document.getElementById('placementBanner');
    const placementText = document.getElementById('placementText');
    const placementCancel = document.getElementById('placementCancel');
    const mapToast = document.getElementById('mapToast');
    const mapToastText = document.getElementById('mapToastText');
    const mapInfoBox = document.getElementById('mapInfoBox');
    const infoBoxContent = document.getElementById('infoBoxContent');
    const infoBoxClose = document.getElementById('infoBoxClose');
    
    // Sidebar Elements
    const mapSidePanel = document.getElementById('mapSidePanel');
    const sidebarToggleBtn = document.getElementById('sidebarToggleBtn');

    // Sidebar Toggle Logic
    if (sidebarToggleBtn && mapSidePanel) {
        sidebarToggleBtn.addEventListener('click', () => {
            mapSidePanel.classList.toggle('collapsed');
            
            // Re-calculate map size so tiles don't stretch
            if (state.map) {
                setTimeout(() => {
                    state.map.invalidateSize();
                }, 300); // 300ms matches CSS transition duration
            }
        });

        // Auto-collapse on mobile initially
        if (window.innerWidth <= 768) {
            mapSidePanel.classList.add('collapsed');
        }
    }

    // Helper function for Show All / Hide All
    function setAllVisibility(isVisible) {
        Object.keys(CATEGORY_CONFIG).forEach(cat => state.categoryVisible[cat] = isVisible);
        state.allPins.forEach(pin => {
            const key = pin.category === 'forageable' ? `forageable:${pin.name}` : pin.id;
            state.itemVisible[key] = isVisible;
        });
        const masterMap = {
            'forageable': state.masterForageables, 'fish': state.masterFish,
            'bird': state.masterBirds, 'insect': state.masterInsects,
            'animal': state.masterAnimals, 'villager': state.masterVillagers
        };
        Object.entries(masterMap).forEach(([cat, masters]) => {
            if (masters) {
                masters.forEach(m => {
                    const key = cat === 'forageable' ? `forageable:${m.name}` : `m-${m.name}`;
                    state.itemVisible[key] = isVisible;
                });
            }
        });
        updateMarkerVisibility();
        renderCategoryList();
    }

    // Show All All
    showAllBtn.addEventListener('click', () => setAllVisibility(true));

    // Hide All All
    hideAllBtn.addEventListener('click', () => setAllVisibility(false));

    pinSearch.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        document.querySelectorAll('.pin-item').forEach(item => {
            const name = item.dataset.name.toLowerCase();
            item.style.display = name.includes(query) ? 'flex' : 'none';
        });
    });

    // ===== Placement Mode =====
    placementCancel.addEventListener('click', () => {
        exitPlacementMode();
    });

    function enterPlacementMode(pinTemplate, isContinuous = false) {
        state.placementMode.active = true;
        state.placementMode.pinTemplate = pinTemplate;
        state.placementMode.isContinuous = isContinuous;

        // Update banner
        placementBanner.classList.add('active');
        placementText.textContent = `[${pinTemplate.name}] ${isContinuous ? '연속 ' : ''}배치 중 — 클릭하여 핀을 추가하세요`;

        // Change cursor
        document.getElementById('map').classList.add('placement-mode-cursor');

        // Highlight selected item
        document.querySelectorAll('.pin-item').forEach(el => el.classList.remove('placing'));
        const selectedItem = document.querySelector(`.pin-item[data-name="${pinTemplate.name}"]`);
        if (selectedItem) selectedItem.classList.add('placing');
    }

    function exitPlacementMode() {
        state.placementMode.active = false;
        state.placementMode.pinTemplate = null;
        state.placementMode.isContinuous = false;

        placementBanner.classList.remove('active');
        document.getElementById('map').classList.remove('placement-mode-cursor');
        document.querySelectorAll('.pin-item').forEach(el => el.classList.remove('placing'));
    }

    function showToast(message, duration = 2500) {
        mapToastText.textContent = message;
        mapToast.classList.add('show');
        setTimeout(() => {
            mapToast.classList.remove('show');
        }, duration);
    }

    async function saveNewPin(pinData) {
        try {
            const response = await fetch(`/wiki/map/api/pins`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(pinData)
            });
            if (!response.ok) throw new Error('등록 실패');
            return await response.json();
        } catch (err) {
            console.error('핀 등록 에러:', err);
            throw err;
        }
    }

    async function deletePin(pinId) {
        try {
            const response = await fetch(`/wiki/map/api/pins/${pinId}`, {
                method: 'DELETE'
            });
            if (!response.ok) throw new Error('삭제 실패');
            return await response.json();
        } catch (err) {
            console.error('핀 삭제 에러:', err);
            throw err;
        }
    }

    // ===== Map Init =====
    const img = new Image();
    img.onload = function () {
        const mapWidth = this.naturalWidth;
        const mapHeight = this.naturalHeight;

        const bounds = [[0, 0], [mapHeight, mapWidth]];

        const map = L.map('map', {
            crs: L.CRS.Simple,
            minZoom: -2,
            maxZoom: 2,
            zoomSnap: 0.25,
            attributionControl: false,
            maxBounds: bounds,
            maxBoundsViscosity: 1.0
        });
        state.map = map; // Store instance

        // Add the image overlay
        L.imageOverlay(imageUrl, bounds).addTo(map);

        // Fit map to bounds and set it as the view
        map.fitBounds(bounds);

        // ===== Load Pins + Zones =====
        Promise.all([
            fetch('/wiki/map/api/pins?t=' + new Date().getTime()).then(res => res.json()),
            loadAllZones()
        ]).then(([pins]) => {
                state.allPins = pins;

                // Group by category and init visibility
                pins.forEach(pin => {
                    if (state.categoryVisible[pin.category] === undefined) {
                        // Only show specific categories by default
                        const defaultVisible = ['villager', 'animal', 'bus'];
                        state.categoryVisible[pin.category] = defaultVisible.includes(pin.category);
                    }
                    const key = pin.category === 'forageable' ? `forageable:${pin.name}` : pin.id;
                    if (state.itemVisible[key] === undefined) {
                        state.itemVisible[key] = state.categoryVisible[pin.category];
                    }
                });

                // Create markers
                pins.forEach(pin => {
                    if (pin.mapX && pin.mapY) {
                        createMarker(pin, map, mapHeight);
                    }
                });

                // Initial Draw
                updateMarkerVisibility();
                renderCategoryList();

                // Load Master Lists
                Promise.all([
                    fetch('/wiki/map/api/forageables').then(res => res.json()),
                    fetch('/wiki/map/api/fish').then(res => res.json()),
                    fetch('/wiki/map/api/birds').then(res => res.json()),
                    fetch('/wiki/map/api/insects').then(res => res.json()),
                    fetch('/wiki/map/api/animals').then(res => res.json()),
                    fetch('/wiki/map/api/villagers').then(res => res.json())
                ]).then(([forageables, fish, birds, insects, animals, villagers]) => {
                    state.masterForageables = forageables;
                    state.masterFish = fish;
                    state.masterBirds = birds;
                    state.masterInsects = insects;
                    state.masterAnimals = animals;
                    state.masterVillagers = villagers;

                    const masterMapInit = {
                        'forageable': state.masterForageables, 'fish': state.masterFish,
                        'bird': state.masterBirds, 'insect': state.masterInsects,
                        'animal': state.masterAnimals, 'villager': state.masterVillagers
                    };
                    Object.entries(masterMapInit).forEach(([cat, masters]) => {
                        if (state.categoryVisible[cat] === undefined) {
                            const defaultVisible = ['villager', 'animal', 'bus'];
                            state.categoryVisible[cat] = defaultVisible.includes(cat);
                        }
                        if (masters) {
                            masters.forEach(m => {
                                const key = cat === 'forageable' ? `forageable:${m.name}` : `m-${m.name}`;
                                if (state.itemVisible[key] === undefined) {
                                    state.itemVisible[key] = state.categoryVisible[cat];
                                }
                            });
                        }
                    });

                    renderCategoryList();

                    // Deep link handling (Master lists are now ready)
                    handleDeepLink(map, mapHeight);
                });

                // ===== Map Click Handler =====
                map.on('click', function (e) {
                    const lat = e.latlng.lat;
                    const lng = e.latlng.lng;
                    const x = Math.round(lng);
                    const y = Math.round(mapHeight - lat);

                    if (state.placementMode.active && state.placementMode.pinTemplate) {
                        const template = state.placementMode.pinTemplate;

                        // Specialized logic for non-continuous (classic) pins: Replace old pin
                        if (!state.placementMode.isContinuous && template.id && !template.isMaster) {
                            // Delete old one before adding new
                            deletePin(template.id).then(() => {
                                state.allPins = state.allPins.filter(p => p.id !== template.id);
                                if (state.markers[template.id]) {
                                    state.map.removeLayer(state.markers[template.id]);
                                    delete state.markers[template.id];
                                }
                                addNewPin();
                            });
                        } else {
                            addNewPin();
                        }

                        function addNewPin() {
                            const newPin = { ...template, id: null, mapX: x, mapY: y };
                            saveNewPin(newPin)
                                .then(savedPin => {
                                    state.allPins.push(savedPin);
                                    createMarker(savedPin, map, mapHeight);
                                    showToast(`✅ ${savedPin.name} 배치 완료!`);
                                    if (!state.placementMode.isContinuous) exitPlacementMode();
                                    renderCategoryList();
                                });
                        }
                    } else {
                        // === Normal Mode: 좌표 표시 (개발용) ===
                        L.popup()
                            .setLatLng(e.latlng)
                            .setContent(`
                                <div style="text-align: center;">
                                    <div style="font-weight:bold; margin-bottom:5px;">좌표 (Pixels)</div>
                                    <div style="margin-bottom:8px; font-family:monospace; background:#f0f0f0; padding:4px;">
                                        x: ${x}, y: ${y}
                                    </div>
                                    <button onclick="navigator.clipboard.writeText('${x}, ${y}')" 
                                        style="
                                            background:#333; color:white; border:none; padding:4px 8px; 
                                            border-radius:4px; cursor:pointer; font-size:12px;">
                                        📋 좌표 복사
                                    </button>
                                </div>
                            `)
                            .openOn(map);
                    }
                });
        }).catch(err => console.error('Error loading pins/zones:', err));
    };
    // ===== Zone 관련 함수 =====

    // Zone 전체 로드
    async function loadAllZones() {
        try {
            const res = await fetch('/wiki/map/api/zones');
            state.allZones = await res.json();
        } catch (e) {
            console.error('Zone 로드 실패:', e);
        }
    }

    // Location/SubLocation → zoneKey 변환 매핑
    const LOCATION_TO_ZONE = {
        // 강 계열
        '강 전체': '강', '강': '강', '강변': '강',
        '거목 강': '거목강',
        '고요한 강': '고요한강',
        '노을 강': '노을강',
        '얕은 강': '얕은강',
        // 바다 계열
        '바다 전체': '바다', '바다': '바다', '잔잔한 바다': '잔잔한바다',
        '고래 바다': '고래바다', '고래바다 해변': '고래바다',
        '구해': '구해', '구해 해변': '구해',
        '동해': '동해', '동해 해변': '동해',
        // 호수 계열
        '호수 전체': '호수', '호수': '호수',
        '근교 호수': '근교호수',
        '숲속 호수': '숲속호수', '숲 호수': '숲속호수',
        '온천산 호수': '온천산호수',
        '초원 호수': '초원호수',
        '도시 근교 호수': '근교도시호수', '근교 호수': '근교호수',
        // 숲 계열
        '숲 전체': '숲', '숲': '숲',
        '영혼의 참나무 숲': '영혼참나무', '영혼의 참나무': '영혼참나무',
        '순록탑': '순록탑',
        '숲속 섬': '숲속섬',
        '점핑 플랫폼': '점핑플랫폼',
        '호숫가': '숲호숫가', '숲 호숫가': '숲호숫가',
        // 꽃밭 계열
        '꽃밭 전체': '꽃밭', '꽃밭': '꽃밭',
        '고래산': '고래산꽃밭',
        '보라빛 해변': '보라빛해변',
        '풍차꽃밭': '풍차꽃밭',
        // 어촌 계열
        '어촌 전체': '어촌', '어촌': '어촌',
        '부두': '어촌부두',
        '동쪽 부두': '동쪽부두',
        '등대': '어촌등대',
        '어촌 광장': '어촌광장', '광장': '어촌광장',
        // 온천산 계열
        '온천산 전체': '온천산', '온천산': '온천산',
        '온천': '온천',
        '바위절벽': '바위절벽',
        '유적': '온천산유적',
        '화산 호수': '화산호수',
        '온천산 호숫가': '온천산호숫가',
        // 도시 계열
        '도시 전체': '도시', '도시': '도시',
        '도시 근교': '도시근교', '근교': '도시근교',
        '도심': '도심',
        // 기타
        '해변': '해변',
        '물가': '물가',
    };

    // location + subLocation → zoneKey 배열 반환
    function resolveZoneKeys(location, subLocation) {
        const keys = new Set();
        if (!location) return [];

        // subLocation 우선
        if (subLocation && subLocation !== '-' && subLocation !== '') {
            const subKey = LOCATION_TO_ZONE[subLocation];
            if (subKey) keys.add(subKey);
        }

        // location 자체도 추가
        const locKey = LOCATION_TO_ZONE[location];
        if (locKey) keys.add(locKey);

        // 상위 zone도 추가 (예: 거목강 → 강도 함께 표시)
        keys.forEach(k => {
            const zone = state.allZones.find(z => z.zoneKey === k);
            if (zone && zone.parentZoneKey) keys.add(zone.parentZoneKey);
        });

        return [...keys];
    }

    // 폴리곤 하이라이트 표시
    function highlightZones(zoneKeys) {
        // 기존 폴리곤 제거
        state.activeZoneLayers.forEach(layer => state.map.removeLayer(layer));
        state.activeZoneLayers = [];

        if (!zoneKeys || zoneKeys.length === 0) return;

        zoneKeys.forEach(key => {
            const zone = state.allZones.find(z => z.zoneKey === key);
            if (!zone || !zone.polygonPoints) return;

            let points;
            try {
                points = typeof zone.polygonPoints === 'string'
                    ? JSON.parse(zone.polygonPoints)
                    : zone.polygonPoints;
            } catch (e) { return; }

            // 픽셀 좌표 → Leaflet 좌표 변환 (y축 반전)
            const img = new Image();
            img.src = imageUrl;
            const mapHeight = img.naturalHeight || 3000;

            const latLngs = points.map(([px, py]) => [mapHeight - py, px]);
            const isParent = zoneKeys.some(k => {
                const z = state.allZones.find(z2 => z2.zoneKey === k);
                return z && z.parentZoneKey === zone.zoneKey;
            });

            const polygon = L.polygon(latLngs, {
                color: zone.color || '#4dabf7',
                fillColor: zone.color || '#4dabf7',
                fillOpacity: isParent ? 0.08 : 0.25,
                weight: isParent ? 1.5 : 2.5,
                dashArray: isParent ? '6, 4' : null
            }).addTo(state.map);

            polygon.bindTooltip(zone.displayName, {
                permanent: false,
                direction: 'center',
                className: 'zone-tooltip'
            });

            state.activeZoneLayers.push(polygon);
        });

        // 하이라이트 영역으로 맵 이동
        if (state.activeZoneLayers.length > 0) {
            const group = L.featureGroup(state.activeZoneLayers);
            state.map.fitBounds(group.getBounds().pad(0.3));
        }
    }

    // Zone 편집 모드 (좌표 수집용)
    function enterZoneEditMode(zoneKey) {
        state.zoneEditMode.active = true;
        state.zoneEditMode.targetZoneKey = zoneKey;
        state.zoneEditMode.points = [];
        placementBanner.classList.add('active');
        placementText.textContent = `[Zone: ${zoneKey}] 경계 좌표 입력 중 — 지점을 클릭하세요. 완료: 더블클릭`;
    }

    function exitZoneEditMode() {
        state.zoneEditMode.active = false;
        state.zoneEditMode.targetZoneKey = null;
        state.zoneEditMode.points = [];
        placementBanner.classList.remove('active');
    }

    img.src = imageUrl;

    // ===== Create Marker =====
    function createMarker(pin, map, mapHeight) {
        const lat = mapHeight - pin.mapY;
        const lng = pin.mapX;
        const config = CATEGORY_CONFIG[pin.category] || { icon: '📍', color: '#888' };

        const marker = L.marker([lat, lng], {
            icon: L.divIcon({
                className: 'custom-map-marker',
                html: pin.iconUrl
                    ? `<div style="
                        width: 36px; height: 36px;
                        background-image: url('${pin.iconUrl}');
                        background-size: cover;
                        border-radius: 50%;
                        border: 2.5px solid ${config.color};
                        box-shadow: 0 2px 6px rgba(0,0,0,0.25);
                        background-color: white;"></div>`
                    : `<div style="
                        width: 32px; height: 32px;
                        background: ${config.color};
                        border-radius: 50%;
                        border: 2px solid white;
                        box-shadow: 0 2px 6px rgba(0,0,0,0.25);
                        display: flex; align-items: center; justify-content: center;
                        font-size: 18px; line-height: 1; overflow: hidden;">
                        <span style="display: block; transform: scale(0.65);">${config.icon}</span>
                    </div>`,
                iconSize: [36, 36],
                iconAnchor: [18, 18]
            })
        }).addTo(map);

        // Popup with simplified details from DB
        let popupHtml = `<div class="map-popup-container">`;
        popupHtml += `<div class="map-popup-title">${pin.name}</div>`;

        // Add simplified details (Location, Weather, Price, etc.)
        if (pin.details && Object.keys(pin.details).length > 0) {
            popupHtml += `<div class="map-popup-details">`;
            for (const [key, value] of Object.entries(pin.details)) {
                if (value && value !== 'null') {
                    // Create a sanitized class name for the key (e.g., '위치' -> 'key-location')
                    const keyMap = {
                        '역할': 'role', '위치': 'loc', '해금': 'unlock',
                        '날씨': 'weather', '선호 날씨': 'weather', '시간': 'time',
                        '가격': 'price', '가격(1성)': 'price', '에너지': 'energy',
                        '선호 음식': 'food'
                    };
                    const keyClass = keyMap[key] || 'default';
                    popupHtml += `<div class="detail-item"><span class="detail-key label-${keyClass}">${key}:</span> <span class="detail-val">${value}</span></div>`;
                }
            }
            popupHtml += `</div>`;
        }

        if (pin.linkUrl) {
            popupHtml += `<a href="${pin.linkUrl}" class="map-popup-link">상세 페이지 이동</a>`;
        }

        // Multi-pin specific delete button in popup
        if (pin.category === 'forageable' && window.isAdmin) {
            popupHtml += `
                <div style="margin-top: 10px; border-top: 1px solid #eee; padding-top: 8px;">
                    <button class="popup-delete-btn" onclick="document.dispatchEvent(new CustomEvent('delete-pin', {detail: ${pin.id}}))"
                        style="background: #ff8787; color: white; border: none; padding: 4px 10px; border-radius: 4px; font-size: 11px; cursor: pointer;">
                        <i class="fas fa-trash"></i> 핀 삭제
                    </button>
                    <div style="font-size: 10px; color: #999; margin-top: 5px;">(x: ${pin.mapX}, y: ${pin.mapY})</div>
                </div>`;
        }
        marker.bindPopup(popupHtml);

        state.markers[pin.id] = marker;
    }

    // Global listener for popup delete
    document.addEventListener('delete-pin', (e) => {
        const id = e.detail;
        if (confirm('이 핀을 삭제하시겠습니까?')) {
            deletePin(id).then(res => {
                if (res.success) {
                    // Filter out the deleted pin (handling potential string/number mismatch)
                    state.allPins = state.allPins.filter(p => String(p.id) !== String(id));

                    if (state.markers[id]) {
                        state.map.removeLayer(state.markers[id]);
                        delete state.markers[id];
                    }
                    renderCategoryList();
                    showToast('삭제되었습니다.');
                } else {
                    showToast('❌ 삭제 처리에 실패했습니다.');
                }
            }).catch(err => {
                console.error('Delete error:', err);
                showToast('❌ 서버 오류로 삭제할 수 없습니다.');
            });
        }
    });

    // ===== Render Category List (Back to Simple UI) =====
    function renderCategoryList() {
        const grouped = {};

        // 1. Group existing pins
        state.allPins.forEach(pin => {
            if (!grouped[pin.category]) grouped[pin.category] = [];
            grouped[pin.category].push(pin);
        });

        // 2. Integration of Master Lists (Show items even if no pins exist)
        const masterMap = {
            'forageable': state.masterForageables,
            'fish': state.masterFish,
            'bird': state.masterBirds,
            'insect': state.masterInsects,
            'animal': state.masterAnimals,
            'villager': state.masterVillagers
        };

        Object.entries(masterMap).forEach(([category, masters]) => {
            if (masters && masters.length > 0) {
                if (!grouped[category]) grouped[category] = [];

                masters.forEach(master => {
                    const hasPin = state.allPins.some(p => {
                        if (p.category !== category) return false;
                        // 정확히 같거나, 한 이름이 다른 이름을 포함하는 경우 (예: "나니와" ↔ "나니와 (Naniwa)")
                        return p.name === master.name
                            || p.name.includes(master.name)
                            || master.name.includes(p.name);
                    });
                    if (!hasPin) {
                        grouped[category].push({
                            id: 'm-' + master.name,
                            category: category,
                            name: master.name,
                            iconUrl: master.imageUrl || null,
                            mapX: null,
                            mapY: null,
                            isMaster: true
                        });
                    }
                });
            }
        });

        categoryList.innerHTML = '';

        if (state.allPins.length === 0 &&
            state.masterForageables.length === 0 &&
            state.masterFish.length === 0 &&
            state.masterBirds.length === 0 &&
            state.masterInsects.length === 0 &&
            state.masterAnimals.length === 0 &&
            state.masterVillagers.length === 0) {
            categoryList.innerHTML = '<div class="no-pins">데이터가 없습니다.</div>';
            return;
        }

        const categoryOrder = ['villager', 'animal', 'bus', 'forageable', 'fish', 'insect', 'bird'];
        Object.keys(grouped).sort((a, b) => {
            let indexA = categoryOrder.indexOf(a);
            let indexB = categoryOrder.indexOf(b);
            if (indexA === -1) indexA = 99;
            if (indexB === -1) indexB = 99;
            return indexA - indexB;
        }).forEach(category => {
            const pins = grouped[category];
            const config = CATEGORY_CONFIG[category] || { icon: '📍', color: '#888', label: category };
            const isCatVisible = state.categoryVisible[category] !== false;
            const isExpanded = state.expandedCategories[category] === true;

            // For forageables, we show item names once. For others, we show as is.
            const displayItems = [];
            if (category === 'forageable') {
                const namesTracked = new Set();
                pins.forEach(p => {
                    if (!namesTracked.has(p.name)) {
                        displayItems.push(p);
                        namesTracked.add(p.name);
                    }
                });
            } else {
                pins.forEach(p => displayItems.push(p));
            }

            const group = document.createElement('div');
            group.className = 'category-group';
            group.innerHTML = `
                <div class="category-header" data-category="${category}">
                    <span class="category-arrow ${isExpanded ? 'expanded' : ''}">▶</span>
                    <span class="category-color-bar" style="background: ${config.color}"></span>
                    <span class="category-name">${config.label}</span>
                    <div class="category-controls">
                        <button class="category-toggle ${isCatVisible ? '' : 'off'}" data-category="${category}">
                            <i class="fas ${isCatVisible ? 'fa-eye' : 'fa-eye-slash'}"></i>
                        </button>
                    </div>
                </div>
                <div class="category-items ${isExpanded ? 'expanded' : ''}">
                    ${displayItems.sort((a, b) => a.name.localeCompare(b.name)).map(pin => {
                const isUnplaced = !pin.mapX && !pin.mapY;
                const isForageable = category === 'forageable';
                const isPlacing = state.placementMode.active && state.placementMode.pinTemplate && state.placementMode.pinTemplate.name === pin.name;

                // Count pins for forageables
                const pinCount = isForageable ? state.allPins.filter(p => p.category === category && p.name === pin.name).length : 0;

                // Controls logic: Individual Visibility Toggle + Placement
                const hasVisibilityToggle = ['villager', 'animal', 'forageable', 'bus'].includes(category);
                const visibilityKey = isForageable ? `forageable:${pin.name}` : pin.id;
                const isItemVisible = state.itemVisible[visibilityKey] !== false;

                return `
                            <div class="pin-item ${isPlacing ? 'placing' : ''}" data-id="${pin.id}" data-name="${pin.name}" data-category="${category}">
                                ${isUnplaced ? '<span class="pin-unplaced" title="미배치"></span>' : ''}
                                ${pin.iconUrl
                        ? `<img class="pin-item-icon" src="${pin.iconUrl}" alt="" />`
                        : `<span class="pin-item-icon">${config.icon}</span>`
                    }
                                <span class="pin-item-name">${pin.name} ${isForageable ? `(${pinCount})` : ''}</span>
                                <div class="pin-item-controls">
                                    ${(hasVisibilityToggle && !isUnplaced) || (isForageable && pinCount > 0) ? `
                                        <button class="item-visibility-toggle ${isItemVisible ? '' : 'off'}" 
                                            data-id="${pin.id}" data-category="${category}" data-name="${pin.name}" title="표시/숨기기">
                                            <i class="fas ${isItemVisible ? 'fa-eye' : 'fa-eye-slash'}"></i>
                                        </button>
                                    ` : ''}
                                    ${['fish', 'bird', 'insect'].includes(category) ? '' : (isForageable ? `
                                        <button class="item-add-btn" data-category="${category}" data-name="${pin.name}" title="연속 배치" 
                                            style="${window.isAdmin ? 'display: inline-block;' : 'display: none;'}">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    ` : `
                                        <button class="pin-place-btn ${isPlacing ? 'active' : ''}" data-id="${pin.id}" title="위치 변경" 
                                            style="${window.isAdmin ? 'display: inline-block;' : 'display: none;'}">
                                            <i class="fas fa-map-pin"></i>
                                        </button>
                                    `)}
                                </div>
                            </div>
                        `;
            }).join('')}
                </div>
            `;
            categoryList.appendChild(group);
        });

        // Event Listeners
        document.querySelectorAll('.category-header').forEach(header => {
            header.addEventListener('click', (e) => {
                if (e.target.closest('.category-toggle')) return;
                const cat = header.dataset.category;
                state.expandedCategories[cat] = !state.expandedCategories[cat];
                renderCategoryList();
            });
        });

        document.querySelectorAll('.category-toggle').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const cat = btn.dataset.category;
                const nextVisible = !state.categoryVisible[cat];
                state.categoryVisible[cat] = nextVisible;

                // Sync all items in this category to match category visibility
                state.allPins.forEach(pin => {
                    if (pin.category === cat) {
                        const key = cat === 'forageable' ? `forageable:${pin.name}` : pin.id;
                        state.itemVisible[key] = nextVisible;
                    }
                });

                // ALSO sync master items (unplaced items)
                const masterMap = {
                    'forageable': state.masterForageables, 'fish': state.masterFish,
                    'bird': state.masterBirds, 'insect': state.masterInsects,
                    'animal': state.masterAnimals, 'villager': state.masterVillagers
                };
                if (masterMap[cat]) {
                    masterMap[cat].forEach(m => {
                        const key = cat === 'forageable' ? `forageable:${m.name}` : `m-${m.name}`;
                        state.itemVisible[key] = nextVisible;
                    });
                }

                updateMarkerVisibility();
                renderCategoryList();
            });
        });

        // Individual Item Visibility Toggle
        document.querySelectorAll('.item-visibility-toggle').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const id = btn.dataset.id;
                const cat = btn.dataset.category;
                const name = btn.dataset.name;

                const key = cat === 'forageable' ? `forageable:${name}` : id;
                const nextVisible = state.itemVisible[key] === false ? true : false;
                state.itemVisible[key] = nextVisible;

                // If child is turned ON, turn ON parent automatically
                if (nextVisible) {
                    state.categoryVisible[cat] = true;
                }

                updateMarkerVisibility();
                renderCategoryList();
            });
        });

        document.querySelectorAll('.pin-item').forEach(item => {
            item.addEventListener('click', (e) => {
                if (e.target.closest('.pin-item-controls')) return;
                const id = item.dataset.id;
                const category = item.dataset.category;
                const name = item.dataset.name;

                // SPECIAL: Red-box categories show Info Box instead of zooming
                if (['fish', 'bird', 'insect'].includes(category)) {
                    // Find master data from state
                    let masters = [];
                    if (category === 'fish') masters = state.masterFish;
                    else if (category === 'bird') masters = state.masterBirds;
                    else if (category === 'insect') masters = state.masterInsects;

                    const master = masters.find(m => m.name === name);
                    if (master) {
                        showInfoBox(master, category);
                    }
                    return;
                }

                if (state.markers[id]) {
                    const marker = state.markers[id];
                    state.map.setView(marker.getLatLng(), 0);
                    marker.openPopup();
                }
            });
        });

        // Close Info Box
        infoBoxClose.addEventListener('click', hideInfoBox);

        // Continuous Add for Forageables
        document.querySelectorAll('.item-add-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const category = btn.dataset.category;
                const name = btn.dataset.name;
                const existing = state.allPins.find(p => p.category === category && p.name === name);
                const master = state.masterForageables.find(m => m.name === name);

                const template = existing ? { ...existing } : {
                    category: category,
                    name: name,
                    iconUrl: master ? master.imageUrl : null,
                    description: null,
                    linkUrl: null
                };

                if (state.placementMode.active && state.placementMode.pinTemplate && state.placementMode.pinTemplate.name === name) {
                    exitPlacementMode();
                } else {
                    enterPlacementMode(template, true);
                }
            });
        });

        // Classic Place Button (1 items categories)
        document.querySelectorAll('.pin-place-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const id = btn.dataset.id;
                const pin = state.allPins.find(p => p.id == id);

                if (state.placementMode.active && state.placementMode.pinTemplate && state.placementMode.pinTemplate.id == id) {
                    exitPlacementMode();
                } else {
                    const template = { ...pin };
                    enterPlacementMode(template, false);
                }
            });
        });
    }

    // ===== Update Marker Visibility =====
    function updateMarkerVisibility() {
        if (!state.map) return;
        state.allPins.forEach(pin => {
            const marker = state.markers[pin.id];
            if (!marker) return;

            // Basic Category Visibility
            let shouldBeVisible = (state.categoryVisible[pin.category] !== false);

            // Individual Item Visibility
            // For general pins, we use ID. For forageables, we use "forageable:NAME"
            const visibilityKey = pin.category === 'forageable' ? `forageable:${pin.name}` : pin.id;
            if (state.itemVisible[visibilityKey] === false) {
                shouldBeVisible = false;
            }

            if (shouldBeVisible) {
                if (!state.map.hasLayer(marker)) state.map.addLayer(marker);
            } else {
                if (state.map.hasLayer(marker)) state.map.removeLayer(marker);
            }
        });
    }

    // ===== Deep Link =====
    function handleDeepLink(map, mapHeight) {
        const params = new URLSearchParams(window.location.search);
        const category = params.get('cat') || params.get('category');
        const name = params.get('name');
        const zoneParam = params.get('zone'); // zone 파라미터: "거목강" 또는 "강,거목강"

        // zone 파라미터가 있으면 바로 하이라이트
        if (zoneParam) {
            const zoneKeys = zoneParam.split(',').map(k => k.trim()).filter(Boolean);
            highlightZones(zoneKeys);
            return;
        }

        if (!category || !name) return;

        // 0. 가시성 자동 전환 로직 정밀화 (요청된 특정 아이템만 활성화)
        state.categoryVisible[category] = true;

        // 해당 카테고리의 아이콘들을 순회하며 요청된 이름과 일치하는 것만 켭니다.
        state.allPins.forEach(p => {
            if (p.category === category) {
                const isMatch = p.name === name || p.name.includes(name) || name.includes(p.name);
                const key = category === 'forageable' ? `forageable:${p.name}` : p.id;
                state.itemVisible[key] = isMatch;
            }
        });

        updateMarkerVisibility();
        renderCategoryList();

        // 1. Info Box Categories (Fish, Insect, Bird, Animal, Villager)
        if (['fish', 'insect', 'bird', 'animal', 'villager'].includes(category)) {
            let masters = [];
            if (category === 'fish') masters = state.masterFish;
            else if (category === 'bird') masters = state.masterBirds;
            else if (category === 'insect') masters = state.masterInsects;
            else if (category === 'animal') masters = state.masterAnimals;
            else if (category === 'villager') masters = state.masterVillagers;

            const master = masters.find(m => m.name === name);
            if (master) {
                showInfoBox(master, category);
                // location/subLocation으로 zone 자동 하이라이트
                if (master.location) {
                    const zoneKeys = resolveZoneKeys(master.location, master.subLocation);
                    highlightZones(zoneKeys);
                }
            }
        }

        const pin = state.allPins.find(p => p.category === category && p.name === name);
        if (pin && state.markers[pin.id]) {
            const marker = state.markers[pin.id];
            map.setView(marker.getLatLng(), 0);
            setTimeout(() => marker.openPopup(), 300);
        }
    }

    // ===== Info Box Logic =====
    function showInfoBox(item, category) {
        const config = CATEGORY_CONFIG[category] || { icon: '❓', color: '#888' };

        const labels = {
            'location': '위치', 'weather': '날씨', 'time': '시간',
            'favoriteWeather': '선호 날씨', 'favoriteFood': '선호 음식',
            'price1': '가격(1성)', 'price': '가격',
            'subTitle': '역할', 'unlockCondition': '해금'
        };

        // "-" or empty mapping to "상시"
        const formatVal = (val) => (!val || val === '-') ? '<span class="status-always">상시</span>' : val;

        // Format Location display (add subLocation if exists)
        const formatLoc = (loc, sub) => (sub && sub !== '-' && sub !== '') ? `${loc} - ${sub}` : loc;

        const details = [
            { key: labels.location, val: formatLoc(item.location, item.subLocation) },
            { key: labels.subTitle, val: item.subTitle },
            { key: labels.unlockCondition, val: item.unlockCondition },
            { key: labels.weather || labels.favoriteWeather, val: item.weather || item.favoriteWeather, isCondition: true },
            { key: labels.time, val: item.time, isCondition: true },
            { key: labels.price1 || labels.price, val: item.price1 || item.price }
        ].filter(d => d.val).map(d => ({
            ...d,
            val: d.isCondition ? formatVal(d.val) : d.val
        }));

        infoBoxContent.innerHTML = `
            <div class="info-box-header">
                <div class="info-box-icon" style="color: ${config.color}">
                    ${item.imageUrl ? `<img src="${item.imageUrl}" style="width:100%; height:100%; object-fit: cover; border-radius:10px;"/>` : config.icon}
                </div>
                <div style="flex: 1;">
                    <h4 class="info-box-title">${item.name}</h4>
                    <span style="font-size:11px; color:#adb5bd;">${config.label} 정보</span>
                </div>
                <button class="info-box-minimize-btn" id="infoBoxMinimize"><i class="fas fa-chevron-down"></i></button>
            </div>
            <div class="info-box-body" id="infoBoxBody">
                <div class="info-box-details">
                    ${details.map(d => `
                        <div class="detail-item">
                            <span class="detail-key">${d.key}</span>
                            <span class="detail-val">${d.val}</span>
                        </div>
                    `).join('')}
                </div>
                <div class="info-box-footer">
                    <a href="${(() => {
                const urlCategory = category === 'insect' ? 'bug' : category;
                const prefix = ['fish', 'bug', 'bird', 'animal', 'forageable'].includes(urlCategory) ? 'collections' : 'items';
                return '/wiki/' + prefix + '/' + urlCategory + '/' + encodeURIComponent(item.name);
            })()}" class="map-popup-link" style="margin-top:0; width:100%; display:block;">상세 도감 페이지 이동</a>
                </div>
            </div>
        `;

        mapInfoBox.classList.remove('minimized');
        mapInfoBox.classList.add('show');

        // Minimize toggle
        document.getElementById('infoBoxMinimize').onclick = (e) => {
            e.stopPropagation();
            const body = document.getElementById('infoBoxBody');
            const isMin = mapInfoBox.classList.toggle('minimized');
            body.style.display = isMin ? 'none' : 'block';
            document.querySelector('#infoBoxMinimize i').className = `fas ${isMin ? 'fa-chevron-up' : 'fa-chevron-down'}`;
        };
    }

    function hideInfoBox() {
        mapInfoBox.classList.remove('show');
    }
});
