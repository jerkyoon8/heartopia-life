window.MapApp = window.MapApp || {};

document.addEventListener('DOMContentLoaded', function () {
    const state = window.MapApp.state;
    const api = window.MapApp.api;
    const ui = window.MapApp.ui;
    const zone = window.MapApp.zone;

    // Sidebar Elements
    const mapSidePanel = document.getElementById('mapSidePanel');
    const sidebarToggleBtn = document.getElementById('sidebarToggleBtn');

    if (sidebarToggleBtn && mapSidePanel) {
        sidebarToggleBtn.addEventListener('click', () => {
            mapSidePanel.classList.toggle('collapsed');
            if (state.map) {
                setTimeout(() => state.map.invalidateSize(), 300);
            }
        });
        if (window.innerWidth <= 768) {
            mapSidePanel.classList.add('collapsed');
        }
    }

    // Header buttons (ShowAll / HideAll / Search)
    const setAllVisibility = (isVisible) => {
        Object.keys(window.MapApp.CATEGORY_CONFIG).forEach(cat => state.categoryVisible[cat] = isVisible);
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
        // zone 라벨도 연동
        if (state.zoneVisible) {
            Object.keys(state.zoneVisible).forEach(k => { state.zoneVisible[k] = isVisible; });
        }
        if (state.allZones) {
            state.allZones.forEach(z => {
                if (!state.zoneVisible) state.zoneVisible = {};
                state.zoneVisible[z.zoneKey] = isVisible;
            });
        }
        if (window.MapApp.updateZoneLabelVisibility) window.MapApp.updateZoneLabelVisibility();
        ui.updateMarkerVisibility();
        ui.renderCategoryList();
    };

    const showAllBtn = document.getElementById('showAll');
    if(showAllBtn) showAllBtn.addEventListener('click', () => setAllVisibility(true));
    
    const hideAllBtn = document.getElementById('hideAll');
    if(hideAllBtn) hideAllBtn.addEventListener('click', () => setAllVisibility(false));

    const pinSearch = document.getElementById('pinSearch');
    if (pinSearch) {
        pinSearch.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase();
            document.querySelectorAll('.pin-item').forEach(item => {
                const name = item.dataset.name.toLowerCase();
                item.style.display = name.includes(query) ? 'flex' : 'none';
            });
        });
    }

    const placementCancel = document.getElementById('placementCancel');
    if (placementCancel) {
        placementCancel.addEventListener('click', () => ui.exitPlacementMode());
    }

    const infoBoxClose = document.getElementById('infoBoxClose');
    if(infoBoxClose) infoBoxClose.addEventListener('click', ui.hideInfoBox);

    // Initial Marker creation logic
    function createMarker(pin, map, mapHeight) {
        const lat = mapHeight - pin.mapY;
        const lng = pin.mapX;
        const config = window.MapApp.CATEGORY_CONFIG[pin.category] || { icon: '📍', color: '#888' };

        const marker = L.marker([lat, lng], {
            icon: L.divIcon({
                className: 'custom-map-marker',
                html: pin.iconUrl
                    ? `<div style="width: 36px; height: 36px; background-image: url('${pin.iconUrl}'); background-size: cover; border-radius: 50%; border: 2.5px solid ${config.color}; box-shadow: 0 2px 6px rgba(0,0,0,0.25); background-color: white;"></div>`
                    : `<div style="width: 32px; height: 32px; background: ${config.color}; border-radius: 50%; border: 2px solid white; box-shadow: 0 2px 6px rgba(0,0,0,0.25); display: flex; align-items: center; justify-content: center; font-size: 18px; line-height: 1; overflow: hidden;"><span style="display: block; transform: scale(0.65);">${config.icon}</span></div>`,
                iconSize: [36, 36],
                iconAnchor: [18, 18]
            })
        }).addTo(map);

        let popupHtml = `<div class="map-popup-container">`;
        popupHtml += `<div class="map-popup-title">${pin.name}</div>`;
        if (pin.details && Object.keys(pin.details).length > 0) {
            popupHtml += `<div class="map-popup-details">`;
            for (const [key, value] of Object.entries(pin.details)) {
                if (value && value !== 'null') {
                    const keyMap = { '역할': 'role', '위치': 'loc', '해금': 'unlock', '날씨': 'weather', '선호 날씨': 'weather', '시간': 'time', '가격': 'price', '가격(1성)': 'price', '에너지': 'energy', '선호 음식': 'food' };
                    const keyClass = keyMap[key] || 'default';
                    popupHtml += `<div class="detail-item"><span class="detail-key label-${keyClass}">${key}:</span> <span class="detail-val">${value}</span></div>`;
                }
            }
            popupHtml += `</div>`;
        }
        if (pin.linkUrl) popupHtml += `<a href="${pin.linkUrl}" class="map-popup-link">상세 페이지 이동</a>`;
        if (pin.category === 'forageable' && window.isAdmin) {
            popupHtml += `<div style="margin-top: 10px; border-top: 1px solid #eee; padding-top: 8px;">
                    <button class="popup-delete-btn" onclick="document.dispatchEvent(new CustomEvent('delete-pin', {detail: ${pin.id}}))" style="background: #ff8787; color: white; border: none; padding: 4px 10px; border-radius: 4px; font-size: 11px; cursor: pointer;">
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
            api.deletePin(id).then(res => {
                if (res.success) {
                    state.allPins = state.allPins.filter(p => String(p.id) !== String(id));
                    if (state.markers[id]) {
                        state.map.removeLayer(state.markers[id]);
                        delete state.markers[id];
                    }
                    ui.renderCategoryList();
                    ui.showToast('삭제되었습니다.');
                } else ui.showToast('❌ 삭제 처리에 실패했습니다.');
            }).catch(err => ui.showToast('❌ 서버 오류로 삭제할 수 없습니다.'));
        }
    });

    // Handle deep link logic within core since it needs resolveZoneKeys etc.
    function handleDeepLink(map, mapHeight) {
        const params = new URLSearchParams(window.location.search);
        let category = params.get('cat') || params.get('category');
        if (category === 'bug') category = 'insect';
        const name = params.get('name');
        const zoneParam = params.get('zone'); 

        if (zoneParam) {
            // LOCATION_TO_ZONE 매핑 시도 (한국어 이름 → zoneKey)
            const LOCATION_TO_ZONE = window.LOCATION_TO_ZONE || {};
            const resolvedKey = LOCATION_TO_ZONE[zoneParam] || zoneParam;
            const zoneObj = state.allZones.find(z => z.zoneKey === resolvedKey);
            if (zoneObj && zoneObj.mapX && zoneObj.mapY) {
                const lat = mapHeight - zoneObj.mapY;
                const lng = zoneObj.mapX;
                map.setView([lat, lng], 1, { animate: true });
                ui.showToast(`📍 ${zoneObj.displayName}`);
            } else {
                // fallback: 폴리곤 기반 하이라이트 시도
                const zoneKeys = zoneParam.split(',').map(k => k.trim()).filter(Boolean);
                zone.highlightZones(zoneKeys);
            }
            return;
        }

        if (!category || !name) return;

        state.categoryVisible[category] = true;
        state.allPins.forEach(p => {
            if (p.category === category) {
                const isMatch = p.name === name || p.name.includes(name) || name.includes(p.name);
                const key = category === 'forageable' ? `forageable:${p.name}` : p.id;
                state.itemVisible[key] = isMatch;
            }
        });

        ui.updateMarkerVisibility();
        ui.renderCategoryList();

        if (['fish', 'insect', 'bird', 'animal', 'villager', 'forageable'].includes(category)) {
            let masters = [];
            if (category === 'fish') masters = state.masterFish;
            else if (category === 'bird') masters = state.masterBirds;
            else if (category === 'insect') masters = state.masterInsects;
            else if (category === 'animal') masters = state.masterAnimals;
            else if (category === 'villager') masters = state.masterVillagers;
            else if (category === 'forageable') masters = state.masterForageables;

            const master = masters.find(m => m.name === name);
            if (master) {
                ui.showInfoBox(master, category);
                if (master.location) {
                    const zoneKeys = zone.resolveZoneKeys(master.location, master.subLocation);
                    // 해당 zone만 켜고 나머지 전부 끄기
                    if (state.allZones && zoneKeys.length > 0) {
                        if (!state.zoneVisible) state.zoneVisible = {};
                        state.allZones.forEach(z => { state.zoneVisible[z.zoneKey] = false; });
                        zoneKeys.forEach(k => { state.zoneVisible[k] = true; });
                        if (window.MapApp.updateZoneLabelVisibility) window.MapApp.updateZoneLabelVisibility();
                        ui.renderCategoryList();
                    }
                    // mapX/mapY 좌표로 카메라 이동
                    let moved = false;
                    if (zoneKeys.length > 0) {
                        const zoneObj = state.allZones.find(z => z.zoneKey === zoneKeys[0]);
                        if (zoneObj && zoneObj.mapX && zoneObj.mapY) {
                            const lat = mapHeight - zoneObj.mapY;
                            const lng = zoneObj.mapX;
                            map.setView([lat, lng], 1, { animate: true });
                            moved = true;
                        }
                    }
                    // fallback: polygonPoints 기반 하이라이트
                    if (!moved) zone.highlightZones(zoneKeys);
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


    // INIT MAP
    const img = new Image();
    img.onload = function () {
        const mapWidth = this.naturalWidth;
        const mapHeight = this.naturalHeight;
        state.mapHeight = mapHeight;
        const bounds = [[0, 0], [mapHeight, mapWidth]];

        state.map = L.map('map', { crs: L.CRS.Simple, minZoom: -2, maxZoom: 2, zoomSnap: 0.25, attributionControl: false, maxBounds: bounds, maxBoundsViscosity: 1.0 });
        L.imageOverlay(window.MapApp.imageUrl, bounds).addTo(state.map);
        state.map.fitBounds(bounds);

        Promise.all([
            fetch('/wiki/map/api/pins?t=' + new Date().getTime()).then(res => res.json()),
            api.loadAllZones()
        ]).then(([pins]) => {
            state.allPins = pins;

            // --- UI 핀 개수 렌더링 (CI/CD용 배포 확인) ---
            const countEl = document.getElementById('mapTotalPinCount');
            if (countEl) countEl.innerText = `총 ${pins.length}개 핀`;

            pins.forEach(pin => {
                if (state.categoryVisible[pin.category] === undefined) {
                    const defaultVisible = ['villager', 'animal', 'bus'];
                    state.categoryVisible[pin.category] = defaultVisible.includes(pin.category);
                }
                const key = pin.category === 'forageable' ? `forageable:${pin.name}` : pin.id;
                if (state.itemVisible[key] === undefined) state.itemVisible[key] = state.categoryVisible[pin.category];
            });

            pins.forEach(pin => { if (pin.mapX && pin.mapY) createMarker(pin, state.map, mapHeight); });
            ui.updateMarkerVisibility();
            ui.renderCategoryList();

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

                const masterMapInit = { 'forageable': forageables, 'fish': fish, 'bird': birds, 'insect': insects, 'animal': animals, 'villager': villagers };
                Object.entries(masterMapInit).forEach(([cat, masters]) => {
                    if (state.categoryVisible[cat] === undefined) {
                        const defaultVisible = ['villager', 'animal', 'bus'];
                        state.categoryVisible[cat] = defaultVisible.includes(cat);
                    }
                    if (masters) {
                        masters.forEach(m => {
                            const key = cat === 'forageable' ? `forageable:${m.name}` : `m-${m.name}`;
                            if (state.itemVisible[key] === undefined) state.itemVisible[key] = state.categoryVisible[cat];
                        });
                    }
                });

                ui.renderCategoryList();
                handleDeepLink(state.map, mapHeight);
                renderZoneLabels(state.map, mapHeight);
            });

    // Zone 위치명 라벨 표시
    function renderZoneLabels(map, mapHeight) {
        if (!state.allZones) return;
        state.zoneLabelMap = {}; // zoneKey → marker
        if (!state.zoneVisible) state.zoneVisible = {};
        state.allZones.forEach(z => {
            if (z.mapX && z.mapY && !z.parentZoneKey) return;
            if (!z.mapX || !z.mapY) return;
            // 기본값: 명시적으로 true가 아닌 이상 꺼짐(false)
            if (state.zoneVisible[z.zoneKey] === undefined) state.zoneVisible[z.zoneKey] = false;
            const lat = mapHeight - z.mapY;
            const lng = z.mapX;
            const label = L.marker([lat, lng], {
                icon: L.divIcon({
                    className: 'zone-label-marker',
                    html: `<span class="zone-label-text" style="color: ${z.color || '#333'}">${z.displayName}</span>`,
                    iconSize: [0, 0],
                    iconAnchor: [0, 0]
                }),
                interactive: false
            });
            // 초기 가시성 적용 (기본 켜짐)
            if (state.zoneVisible[z.zoneKey] !== false) label.addTo(map);
            state.zoneLabelMap[z.zoneKey] = label;
        });
        // zoom에 따라 라벨 크기 조절
        function updateLabelSize() {
            const zoom = map.getZoom();
            const size = Math.max(10, Math.min(22, 12 + (zoom + 2) * 3));
            document.querySelectorAll('.zone-label-text').forEach(el => {
                el.style.fontSize = size + 'px';
            });
        }
        map.on('zoomend', updateLabelSize);
        updateLabelSize();
    }

    // 개별 zone 라벨 가시성 업데이트
    window.MapApp.updateZoneLabelVisibility = function () {
        if (!state.zoneLabelMap) return;
        Object.entries(state.zoneLabelMap).forEach(([zoneKey, label]) => {
            if (state.zoneVisible[zoneKey] !== false) {
                if (!state.map.hasLayer(label)) label.addTo(state.map);
            } else {
                if (state.map.hasLayer(label)) state.map.removeLayer(label);
            }
        });
    };

            state.map.on('click', function (e) {
                const lat = e.latlng.lat; const lng = e.latlng.lng;
                const x = Math.round(lng); const y = Math.round(mapHeight - lat);

                // Zone 편집 모드: 클릭 한 번으로 위치 좌표 지정
                if (state.zoneEditMode.active) {
                    const zoneKey = state.zoneEditMode.targetZoneKey;
                    
                    // API로 좌표 저장
                    api.saveZonePosition(zoneKey, x, y).then(result => {
                        // state 업데이트
                        const zoneObj = state.allZones.find(z => z.zoneKey === zoneKey);
                        if (zoneObj) { zoneObj.mapX = x; zoneObj.mapY = y; }
                        
                        zone.exitZoneEditMode();
                        
                        // 저장된 위치에 마커 표시
                        const marker = L.circleMarker([lat, lng], {
                            radius: 8, color: zoneObj?.color || '#667eea',
                            fillColor: zoneObj?.color || '#667eea', fillOpacity: 0.6, weight: 2
                        }).addTo(state.map);
                        marker.bindTooltip(zoneObj?.displayName || zoneKey, { permanent: false, direction: 'top' });
                        setTimeout(() => state.map.removeLayer(marker), 3000);
                        
                        ui.showToast(`✅ ${zoneObj?.displayName || zoneKey} 위치 저장 완료! (${x}, ${y})`);
                        ui.renderCategoryList();
                    }).catch(err => {
                        ui.showToast('❌ 위치 저장 실패');
                    });
                    return;
                }

                if (state.placementMode.active && state.placementMode.pinTemplate) {
                    const template = state.placementMode.pinTemplate;
                    if (!state.placementMode.isContinuous && template.id && !template.isMaster) {
                        api.deletePin(template.id).then(() => {
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
                        api.saveNewPin(newPin).then(savedPin => {
                            state.allPins.push(savedPin);
                            createMarker(savedPin, state.map, mapHeight);
                            ui.showToast(`✅ ${savedPin.name} 배치 완료!`);
                            if (!state.placementMode.isContinuous) ui.exitPlacementMode();
                            ui.renderCategoryList();
                        });
                    }
                } else {
                    L.popup().setLatLng(e.latlng).setContent(`
                        <div style="text-align: center;">
                            <div style="font-weight:bold; margin-bottom:5px;">좌표 (Pixels)</div>
                            <div style="margin-bottom:8px; font-family:monospace; background:#f0f0f0; padding:4px;">x: ${x}, y: ${y}</div>
                            <button onclick="navigator.clipboard.writeText('${x}, ${y}')" style="background:#333; color:white; border:none; padding:4px 8px; border-radius:4px; cursor:pointer; font-size:12px;">📋 좌표 복사</button>
                        </div>
                    `).openOn(state.map);
                }
            });
        }).catch(err => console.error('Error loading pins/zones:', err));
    };
    img.src = window.MapApp.imageUrl;
});
