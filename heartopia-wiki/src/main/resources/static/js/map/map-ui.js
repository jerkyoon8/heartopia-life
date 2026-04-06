window.MapApp = window.MapApp || {};

window.MapApp.ui = {
    showToast: function (message, duration = 2500) {
        const mapToast = document.getElementById('mapToast');
        const mapToastText = document.getElementById('mapToastText');
        if (!mapToast || !mapToastText) return;
        mapToastText.textContent = message;
        mapToast.classList.add('show');
        setTimeout(() => mapToast.classList.remove('show'), duration);
    },
    enterPlacementMode: function (pinTemplate, isContinuous = false) {
        const state = window.MapApp.state;
        state.placementMode.active = true;
        state.placementMode.pinTemplate = pinTemplate;
        state.placementMode.isContinuous = isContinuous;

        const placementBanner = document.getElementById('placementBanner');
        const placementText = document.getElementById('placementText');
        if (placementBanner) placementBanner.classList.add('active');
        if (placementText) placementText.textContent = `[${pinTemplate.name}] ${isContinuous ? '연속 ' : ''}배치 중 — 클릭하여 핀을 추가하세요`;

        const mapEl = document.getElementById('map');
        if (mapEl) mapEl.classList.add('placement-mode-cursor');

        document.querySelectorAll('.pin-item').forEach(el => el.classList.remove('placing'));
        const selectedItem = document.querySelector(`.pin-item[data-name="${pinTemplate.name}"]`);
        if (selectedItem) selectedItem.classList.add('placing');
    },
    exitPlacementMode: function () {
        const state = window.MapApp.state;
        state.placementMode.active = false;
        state.placementMode.pinTemplate = null;
        state.placementMode.isContinuous = false;

        const placementBanner = document.getElementById('placementBanner');
        if (placementBanner) placementBanner.classList.remove('active');
        const mapEl = document.getElementById('map');
        if (mapEl) mapEl.classList.remove('placement-mode-cursor');
        document.querySelectorAll('.pin-item').forEach(el => el.classList.remove('placing'));
    },
    updateMarkerVisibility: function () {
        const state = window.MapApp.state;
        if (!state.map) return;
        state.allPins.forEach(pin => {
            const marker = state.markers[pin.id];
            if (!marker) return;

            let shouldBeVisible = (state.categoryVisible[pin.category] !== false);
            const visibilityKey = pin.category === 'forageable' ? `forageable:${pin.name}` : pin.id;
            if (state.itemVisible[visibilityKey] === false) shouldBeVisible = false;

            if (shouldBeVisible) {
                if (!state.map.hasLayer(marker)) state.map.addLayer(marker);
            } else {
                if (state.map.hasLayer(marker)) state.map.removeLayer(marker);
            }
        });
    },
    showInfoBox: function (item, category) {
        const config = window.MapApp.CATEGORY_CONFIG[category] || { icon: '❓', color: '#888' };
        const mapInfoBox = document.getElementById('mapInfoBox');
        const infoBoxContent = document.getElementById('infoBoxContent');
        if (!mapInfoBox || !infoBoxContent) return;

        const labels = {
            'location': '위치', 'weather': '날씨', 'time': '시간',
            'favoriteWeather': '선호 날씨', 'favoriteFood': '선호 음식',
            'price1': '가격(1성)', 'price': '가격',
            'subTitle': '역할', 'unlockCondition': '해금'
        };

        const formatVal = (val) => (!val || val === '-') ? '<span class="status-always">상시</span>' : val;
        const formatLoc = (loc, sub) => (sub && sub !== '-' && sub !== '') ? `${loc} - ${sub}` : loc;

        const details = [
            { key: labels.location, val: formatLoc(item.location, item.subLocation) },
            { key: labels.subTitle, val: item.subTitle },
            { key: labels.unlockCondition, val: item.unlockCondition },
            { key: labels.weather || labels.favoriteWeather, val: item.weather || item.favoriteWeather, isCondition: true },
            { key: labels.time, val: item.time, isCondition: true },
            { key: labels.price1 || labels.price, val: item.price1 || item.price }
        ].filter(d => d.val).map(d => ({
            ...d, val: d.isCondition ? formatVal(d.val) : d.val
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

        const minBtn = document.getElementById('infoBoxMinimize');
        if (minBtn) {
            minBtn.onclick = (e) => {
                e.stopPropagation();
                const body = document.getElementById('infoBoxBody');
                const isMin = mapInfoBox.classList.toggle('minimized');
                body.style.display = isMin ? 'none' : 'block';
                document.querySelector('#infoBoxMinimize i').className = `fas ${isMin ? 'fa-chevron-up' : 'fa-chevron-down'}`;
            };
        }
    },
    hideInfoBox: function () {
        const mapInfoBox = document.getElementById('mapInfoBox');
        if (mapInfoBox) mapInfoBox.classList.remove('show');
    },
    renderCategoryList: function () {
        const state = window.MapApp.state;
        const configMap = window.MapApp.CATEGORY_CONFIG;
        const categoryList = document.getElementById('categoryList');
        if (!categoryList) return;

        const grouped = {};
        state.allPins.forEach(pin => {
            if (!grouped[pin.category]) grouped[pin.category] = [];
            grouped[pin.category].push(pin);
        });

        const masterMap = {
            'forageable': state.masterForageables, 'fish': state.masterFish,
            'bird': state.masterBirds, 'insect': state.masterInsects,
            'animal': state.masterAnimals, 'villager': state.masterVillagers
        };

        Object.entries(masterMap).forEach(([category, masters]) => {
            if (masters && masters.length > 0) {
                if (!grouped[category]) grouped[category] = [];
                masters.forEach(master => {
                    const hasPin = state.allPins.some(p => {
                        if (p.category !== category) return false;
                        return p.name === master.name || p.name.includes(master.name) || master.name.includes(p.name);
                    });
                    if (!hasPin) {
                        grouped[category].push({
                            id: 'm-' + master.name, category: category, name: master.name,
                            iconUrl: master.imageUrl || null, mapX: null, mapY: null, isMaster: true
                        });
                    }
                });
            }
        });

        categoryList.innerHTML = '';
        if (state.allPins.length === 0 && Object.values(masterMap).every(arr => arr.length === 0)) {
            categoryList.innerHTML = '<div class="no-pins">데이터가 없습니다.</div>';
            return;
        }

        const categoryOrder = ['villager', 'animal', 'bus', 'forageable', 'fish', 'insect', 'bird'];
        Object.keys(grouped).sort((a, b) => {
            let idxA = categoryOrder.indexOf(a); let idxB = categoryOrder.indexOf(b);
            if (idxA === -1) idxA = 99; if (idxB === -1) idxB = 99;
            return idxA - idxB;
        }).forEach(category => {
            const pins = grouped[category];
            const config = configMap[category] || { icon: '📍', color: '#888', label: category };
            const isCatVisible = state.categoryVisible[category] !== false;
            const isExpanded = state.expandedCategories[category] === true;

            const displayItems = [];
            if (category === 'forageable') {
                const namesTracked = new Set();
                pins.forEach(p => {
                    if (!namesTracked.has(p.name)) {
                        displayItems.push(p); namesTracked.add(p.name);
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
                const pinCount = isForageable ? state.allPins.filter(p => p.category === category && p.name === pin.name).length : 0;
                const hasVisibilityToggle = ['villager', 'animal', 'forageable', 'bus'].includes(category);
                const visibilityKey = isForageable ? `forageable:${pin.name}` : pin.id;
                const isItemVisible = state.itemVisible[visibilityKey] !== false;

                return `
                    <div class="pin-item ${isPlacing ? 'placing' : ''}" data-id="${pin.id}" data-name="${pin.name}" data-category="${category}">
                        ${isUnplaced ? '<span class="pin-unplaced" title="미배치"></span>' : ''}
                        ${pin.iconUrl ? `<img class="pin-item-icon" src="${pin.iconUrl}" alt="" />` : `<span class="pin-item-icon">${config.icon}</span>`}
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
                    </div>`;}).join('')}
                </div>`;
            categoryList.appendChild(group);
        });

        window.MapApp.ui.bindCategoryEvents();
        window.MapApp.ui.renderLocationList();
    },
    bindCategoryEvents: function() {
        const state = window.MapApp.state;
        const ui = window.MapApp.ui;
        // Category Expand/Collapse
        document.querySelectorAll('.category-header').forEach(header => {
            header.addEventListener('click', (e) => {
                if (e.target.closest('.category-toggle')) return;
                const cat = header.dataset.category;
                state.expandedCategories[cat] = !state.expandedCategories[cat];
                ui.renderCategoryList();
            });
        });

        // Category Toggle Visibility
        document.querySelectorAll('.category-toggle').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const cat = btn.dataset.category;
                const nextVisible = !state.categoryVisible[cat];
                state.categoryVisible[cat] = nextVisible;
                state.allPins.forEach(pin => {
                    if (pin.category === cat) {
                        const key = cat === 'forageable' ? `forageable:${pin.name}` : pin.id;
                        state.itemVisible[key] = nextVisible;
                    }
                });
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
                ui.updateMarkerVisibility();
                ui.renderCategoryList();
            });
        });

        // Individual Item Toggle
        document.querySelectorAll('.item-visibility-toggle').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const id = btn.dataset.id;
                const cat = btn.dataset.category;
                const name = btn.dataset.name;
                const key = cat === 'forageable' ? `forageable:${name}` : id;
                const nextVisible = state.itemVisible[key] === false ? true : false;
                state.itemVisible[key] = nextVisible;
                if (nextVisible) state.categoryVisible[cat] = true;
                ui.updateMarkerVisibility();
                ui.renderCategoryList();
            });
        });

        // Pin Click (Navigate to Map or Show Info Box)
        document.querySelectorAll('.pin-item').forEach(item => {
            item.addEventListener('click', (e) => {
                if (e.target.closest('.pin-item-controls')) return;
                const id = item.dataset.id;
                const category = item.dataset.category;
                const name = item.dataset.name;

                if (['fish', 'bird', 'insect'].includes(category)) {
                    let masters = [];
                    if (category === 'fish') masters = state.masterFish;
                    else if (category === 'bird') masters = state.masterBirds;
                    else if (category === 'insect') masters = state.masterInsects;
                    const master = masters.find(m => m.name === name);
                    if (master) ui.showInfoBox(master, category);
                    return;
                }

                if (state.markers[id]) {
                    const marker = state.markers[id];
                    state.map.setView(marker.getLatLng(), 0);
                    setTimeout(() => marker.openPopup(), 300);
                }
            });
        });

        // Add Btn
        document.querySelectorAll('.item-add-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const category = btn.dataset.category;
                const name = btn.dataset.name;
                const existing = state.allPins.find(p => p.category === category && p.name === name);
                const master = state.masterForageables.find(m => m.name === name);
                const template = existing ? { ...existing } : {
                    category: category, name: name, iconUrl: master ? master.imageUrl : null, description: null, linkUrl: null
                };
                if (state.placementMode.active && state.placementMode.pinTemplate && state.placementMode.pinTemplate.name === name) {
                    ui.exitPlacementMode();
                } else {
                    ui.enterPlacementMode(template, true);
                }
            });
        });

        // Classic Place btn
        document.querySelectorAll('.pin-place-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const id = btn.dataset.id;
                const pin = state.allPins.find(p => p.id == id);
                if (state.placementMode.active && state.placementMode.pinTemplate && state.placementMode.pinTemplate.id == id) {
                    ui.exitPlacementMode();
                } else {
                    ui.enterPlacementMode({ ...pin }, false);
                }
            });
        });
    },

    // ==========================================
    // 위치 (Location/Zone) 섹션
    // ==========================================
    renderLocationList: function () {
        const state = window.MapApp.state;
        const categoryList = document.getElementById('categoryList');
        if (!categoryList || !state.allZones || state.allZones.length === 0) return;

        const isLocationExpanded = state.expandedCategories['_locationSection'] !== false; // 기본 열림

        // 구분선 (클릭으로 접기/펼치기)
        const divider = document.createElement('div');
        divider.className = 'location-divider';
        divider.style.cursor = 'pointer';
        divider.innerHTML = `<span class="category-arrow ${isLocationExpanded ? 'expanded' : ''}">▶</span><span>📍 위치</span>`;
        divider.addEventListener('click', () => {
            state.expandedCategories['_locationSection'] = !isLocationExpanded;
            window.MapApp.ui.renderCategoryList();
        });
        categoryList.appendChild(divider);

        if (!isLocationExpanded) return; // 접힌 상태면 여기서 끝

        // 부모 zone 그룹핑
        const parentZones = state.allZones.filter(z => !z.parentZoneKey);
        const childMap = {};
        state.allZones.forEach(z => {
            if (z.parentZoneKey) {
                if (!childMap[z.parentZoneKey]) childMap[z.parentZoneKey] = [];
                childMap[z.parentZoneKey].push(z);
            }
        });

        // zone 개별 가시성 초기화
        if (!state.zoneVisible) state.zoneVisible = {};

        parentZones.forEach(parent => {
            const children = childMap[parent.zoneKey] || [];
            const isExpanded = state.expandedCategories['loc_' + parent.zoneKey] === true;
            
            // 부모 zone 가시성: 자식 중 하나라도 켜진 게 있으면 켜짐
            const isParentVisible = children.length > 0
                ? children.some(c => state.zoneVisible[c.zoneKey] !== false)
                : state.zoneVisible[parent.zoneKey] !== false;

            const group = document.createElement('div');
            group.className = 'category-group location-group';
            group.innerHTML = `
                <div class="category-header location-header" data-zone-parent="${parent.zoneKey}">
                    <span class="category-arrow ${isExpanded ? 'expanded' : ''}">▶</span>
                    <span class="category-color-bar" style="background: ${parent.color || '#94a3b8'}"></span>
                    <span class="category-name">${parent.displayName.replace(' 전체', '')}</span>
                    <div class="category-controls">
                        <button class="category-toggle zone-group-toggle ${isParentVisible ? '' : 'off'}" data-zone-parent="${parent.zoneKey}">
                            <i class="fas ${isParentVisible ? 'fa-eye' : 'fa-eye-slash'}"></i>
                        </button>
                    </div>
                </div>
                <div class="category-items ${isExpanded ? 'expanded' : ''}">
                    ${children.map(child => {
                        const childHasPosition = !!(child.mapX && child.mapY);
                        const isChildVisible = state.zoneVisible[child.zoneKey] !== false;
                        return `
                        <div class="pin-item location-item" data-zone-key="${child.zoneKey}">
                            <span class="location-color-dot" style="background: ${child.color || parent.color || '#94a3b8'}"></span>
                            <span class="pin-item-name">${child.displayName}</span>
                            <div class="pin-item-controls">
                                ${childHasPosition ? `
                                    <button class="item-visibility-toggle zone-item-toggle ${isChildVisible ? '' : 'off'}" data-zone-key="${child.zoneKey}" title="표시/숨기기">
                                        <i class="fas ${isChildVisible ? 'fa-eye' : 'fa-eye-slash'}"></i>
                                    </button>
                                ` : '<span class="zone-status-dot empty" title="미지정"></span>'}
                                ${window.isAdmin ? `<button class="zone-edit-btn" data-zone-key="${child.zoneKey}" title="위치 지정"><i class="fas fa-map-pin"></i></button>` : ''}
                            </div>
                        </div>`;
                    }).join('')}
                </div>`;
            categoryList.appendChild(group);
        });

        // 독립 zone (parentZoneKey 없고 자식도 없는 것)
        const standaloneZones = state.allZones.filter(z => !z.parentZoneKey && !(childMap[z.zoneKey]?.length > 0) && !parentZones.some(p => p.zoneKey === z.zoneKey && childMap[p.zoneKey]?.length > 0));
        // 이미 parentZones에 포함된 것은 위에서 처리되므로, 자식이 없는 부모는 단독 항목으로 보여줌

        this.bindLocationEvents();
    },
    bindLocationEvents: function () {
        const state = window.MapApp.state;
        const zone = window.MapApp.zone;
        const ui = window.MapApp.ui;

        // 부모 zone 접기/펼치기
        document.querySelectorAll('.location-header').forEach(header => {
            header.addEventListener('click', (e) => {
                if (e.target.closest('.zone-edit-btn') || e.target.closest('.zone-group-toggle')) return;
                const parentKey = header.dataset.zoneParent;
                state.expandedCategories['loc_' + parentKey] = !state.expandedCategories['loc_' + parentKey];
                ui.renderCategoryList();
            });
        });

        // 부모 zone 전체 토글 (눈 아이콘)
        document.querySelectorAll('.zone-group-toggle').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const parentKey = btn.dataset.zoneParent;
                const children = state.allZones.filter(z => z.parentZoneKey === parentKey);
                // 현재 전체 켜짐 여부 확인
                const allVisible = children.every(c => state.zoneVisible[c.zoneKey] !== false);
                const newState = !allVisible;
                children.forEach(c => { state.zoneVisible[c.zoneKey] = newState; });
                window.MapApp.updateZoneLabelVisibility();
                ui.renderCategoryList();
            });
        });

        // 자식 zone 개별 토글 (눈 아이콘)
        document.querySelectorAll('.zone-item-toggle').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const zoneKey = btn.dataset.zoneKey;
                state.zoneVisible[zoneKey] = state.zoneVisible[zoneKey] === false ? true : false;
                window.MapApp.updateZoneLabelVisibility();
                ui.renderCategoryList();
            });
        });

        // 자식 zone 클릭 → x,y 좌표로 카메라 이동
        document.querySelectorAll('.location-item').forEach(item => {
            item.addEventListener('click', (e) => {
                if (e.target.closest('.pin-item-controls')) return;
                const zoneKey = item.dataset.zoneKey;
                const zoneObj = state.allZones.find(z => z.zoneKey === zoneKey);
                if (zoneObj && zoneObj.mapX && zoneObj.mapY) {
                    const mapHeight = state.mapHeight || 3000;
                    const lat = mapHeight - zoneObj.mapY;
                    const lng = zoneObj.mapX;
                    state.map.setView([lat, lng], 1, { animate: true });
                    ui.showToast(`📍 ${zoneObj.displayName}`);
                } else {
                    ui.showToast(`⚠️ ${zoneObj?.displayName || zoneKey} — 위치가 아직 지정되지 않았습니다`);
                }
            });
        });

        // Zone 편집 버튼 (관리자)
        document.querySelectorAll('.zone-edit-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const zoneKey = btn.dataset.zoneKey;
                if (state.zoneEditMode.active && state.zoneEditMode.targetZoneKey === zoneKey) {
                    zone.exitZoneEditMode();
                } else {
                    zone.enterZoneEditMode(zoneKey);
                }
            });
        });
    }
};
