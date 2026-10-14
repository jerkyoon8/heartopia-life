window.MapApp = window.MapApp || {};

window.MapApp.ui = {
    escapeHtml: function (value) {
        return String(value ?? '')
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#039;');
    },
    renderSidebarIcon: function (iconUrl, fallback, isExpanded) {
        if (!iconUrl) return `<span class="pin-item-icon">${fallback}</span>`;
        // 접힌 목록은 src를 생략해 요청하지 않고, 펼친 목록만 지연 로딩한다.
        const source = isExpanded ? ` src="${this.escapeHtml(iconUrl)}"` : '';
        return `<img class="pin-item-icon"${source} loading="lazy" decoding="async" width="24" height="24" alt="">`;
    },
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
        const selectedItem = Array.from(document.querySelectorAll('.pin-item')).find(el => el.dataset.name === pinTemplate.name);
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

            const season = state.masterDynamicResources.find(r => r.eventName && r.name === pin.name &&
                (r.forageableId ? pin.category === 'forageable' : pin.category === 'dynamic_resource'));
            let shouldBeVisible = season && !season.forageableId
                ? state.categoryVisible.trend_season !== false
                : state.categoryVisible[pin.category] !== false || (season && state.categoryVisible.trend_season === true);
            const visibilityKey = window.MapApp.getItemVisibilityKey(pin.category, pin);
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
    openResourceForm: function (resource, trend = false) {
        if (!window.isAdmin) return;
        const form = document.getElementById('dynamicResourceForm');
        form.reset();
        document.getElementById('dynamicResourceId').value = resource?.id || '';
        document.getElementById('dynamicResourceName').value = resource?.name || '';
        document.getElementById('dynamicResourceName').readOnly = !!resource?.forageableId;
        document.getElementById('dynamicResourceEvent').value = resource?.eventName || '';
        document.getElementById('dynamicResourceEvent').required = trend;
        document.getElementById('dynamicResourceDescription').value = resource?.description || '';
        const linked = document.getElementById('dynamicResourceForageable');
        linked.innerHTML = '<option value="">지도 전용 아이템</option>' +
            window.MapApp.state.masterForageables.map(f => `<option value="${f.id}">${this.escapeHtml(f.name)}</option>`).join('');
        linked.value = resource?.forageableId || '';
        linked.disabled = !!resource || window.MapApp.state.activeMapKey !== 'town';
        document.getElementById('dynamicResourceModalLabel').textContent = resource ? '지도 아이템 수정' : trend ? '트렌드 시즌 아이템 추가' : '변동 자원 추가';
        document.getElementById('dynamicResourceSubmit').textContent = resource ? '수정 저장' : '등록 후 배치';
        document.getElementById('dynamicResourceKeepImage').hidden = !resource;
        if (resource) form.querySelector('input[value="keep"]').checked = true;
        const error = document.getElementById('dynamicResourceFormError');
        error.textContent = ''; error.classList.remove('show');
        form.syncDynamicResourceImageInput?.();
        bootstrap.Modal.getOrCreateInstance(document.getElementById('dynamicResourceModal')).show();
    },
    renderTrendSeasons: function (categoryList) {
        const state = window.MapApp.state;
        const escape = this.escapeHtml;
        const resources = state.masterDynamicResources.filter(r => r.eventName);
        const seasons = [...new Set(resources.map(r => r.eventName))].sort((a,b) => a.localeCompare(b));
        const group = document.createElement('div');
        group.className = 'category-group';
        group.dataset.trendGroup = 'true';
        group.innerHTML = `<div class="category-header" data-category="trend_season">
            <span class="category-arrow ${state.expandedCategories.trend_season ? 'expanded' : ''}">▶</span>
            <span class="category-color-bar" style="background:#e599f7"></span><span class="category-name">트렌드 시즌</span>
            <div class="category-controls">${window.isAdmin ? '<button class="dynamic-resource-add-btn" data-trend="true" aria-label="트렌드 시즌 아이템 추가"><i class="fas fa-plus"></i></button>' : ''}
            <button class="category-toggle ${state.categoryVisible.trend_season === false ? 'off' : ''}" data-category="trend_season"><i class="fas fa-eye"></i></button></div></div>
            <div class="category-items ${state.expandedCategories.trend_season ? 'expanded' : ''}">
            ${seasons.length ? seasons.map(eventName => `<div class="trend-season-name">${escape(eventName)} ${window.isAdmin ? `<button class="trend-season-rename" data-event="${escape(eventName)}" title="시즌명 수정"><i class="fas fa-pen"></i></button>` : ''}</div>` + resources.filter(r => r.eventName === eventName).map(r => {
                const category = r.forageableId ? 'forageable' : 'dynamic_resource';
                const pins = state.allPins.filter(p => p.category === category && p.name === r.name);
                const id = escape(pins[0]?.id || 'm-' + r.name);
                const visible = state.itemVisible[`${category}:${r.name}`] !== false;
                return `<div class="pin-item" data-id="${id}" data-category="${category}" data-name="${escape(r.name)}">
                    ${this.renderSidebarIcon(r.iconUrl, '★', state.expandedCategories.trend_season === true)}
                    <span class="pin-item-name">${escape(r.name)} (${pins.length})</span><div class="pin-item-controls">
                    ${pins.length ? `<button class="item-visibility-toggle ${visible ? '' : 'off'}" data-id="${id}" data-category="${category}" data-name="${escape(r.name)}" title="표시/숨기기"><i class="fas fa-eye"></i></button>` : ''}
                    ${window.isAdmin ? `<button class="trend-resource-edit" data-resource-id="${r.id}" title="아이템 수정"><i class="fas fa-pen"></i></button><button class="item-add-btn" data-category="${category}" data-name="${escape(r.name)}" title="연속 배치"><i class="fas fa-plus"></i></button>` : ''}
                    </div></div>`;
            }).join('')).join('') : '<div class="dynamic-resource-empty">등록된 트렌드 시즌이 없습니다.</div>'}</div>`;
        categoryList.prepend(group);
        group.querySelectorAll('.trend-season-rename').forEach(button => button.addEventListener('click', async e => {
            e.stopPropagation();
            const newName = window.prompt('새 시즌명을 입력해 주세요.', button.dataset.event)?.trim();
            if (!newName || newName === button.dataset.event) return;
            try {
                const body = new FormData();
                body.append('mapKey', state.activeMapKey); body.append('oldName', button.dataset.event); body.append('newName', newName);
                const headers = {};
                if (csrfToken && csrfHeader) headers[csrfHeader] = csrfToken;
                const response = await fetch('/wiki/map/api/dynamic-resources/rename-event', { method:'POST', headers, body });
                if (!response.ok) throw new Error('시즌명 수정에 실패했습니다.');
                resources.filter(r => r.eventName === button.dataset.event).forEach(r => r.eventName = newName);
                this.renderCategoryList();
            } catch (error) { this.showToast(error.message); }
        }));
        group.querySelectorAll('.trend-resource-edit').forEach(button => button.addEventListener('click', e => {
            e.stopPropagation();
            this.openResourceForm(resources.find(r => String(r.id) === button.dataset.resourceId), true);
        }));
    },
    bindDynamicResourceForm: function () {
        const form = document.getElementById('dynamicResourceForm');
        if (!form || form.dataset.bound === 'true') return;
        form.dataset.bound = 'true';

        const imageChoices = form.querySelectorAll('input[name="dynamicResourceImageChoice"]');
        const imageFileInput = document.getElementById('dynamicResourceImageFile');
        const uploadField = document.getElementById('dynamicResourceUploadField');
        const linkedSelect = document.getElementById('dynamicResourceForageable');
        linkedSelect?.addEventListener('change', () => {
            const master = window.MapApp.state.masterForageables.find(f => String(f.id) === linkedSelect.value);
            document.getElementById('dynamicResourceName').readOnly = !!master;
            if (master) document.getElementById('dynamicResourceName').value = master.name;
            syncImageInput();
        });
        const syncImageInput = () => {
            const selected = form.querySelector('input[name="dynamicResourceImageChoice"]:checked');
            const editing = !!document.getElementById('dynamicResourceId').value;
            const linked = !!linkedSelect?.value;
            const isUpload = selected?.value === 'upload' && !linked;
            document.getElementById('dynamicResourceImages').hidden = linked;
            if (imageFileInput) {
                imageFileInput.disabled = !isUpload;
                imageFileInput.required = isUpload;
                if (!isUpload) imageFileInput.value = '';
            }
            if (uploadField) uploadField.classList.toggle('show', isUpload);
        };
        imageChoices.forEach(choice => choice.addEventListener('change', syncImageInput));
        form.syncDynamicResourceImageInput = syncImageInput;
        syncImageInput();

        form.addEventListener('submit', async (event) => {
            event.preventDefault();
            const submitButton = document.getElementById('dynamicResourceSubmit');
            const errorBox = document.getElementById('dynamicResourceFormError');
            const name = document.getElementById('dynamicResourceName').value.trim();
            const description = document.getElementById('dynamicResourceDescription').value.trim();
            const id = document.getElementById('dynamicResourceId').value;
            const eventName = document.getElementById('dynamicResourceEvent').value.trim();
            const selectedImage = form.querySelector('input[name="dynamicResourceImageChoice"]:checked');
            const isUpload = selectedImage?.value === 'upload' && !linkedSelect?.value;

            if (isUpload && (!imageFileInput || imageFileInput.files.length === 0)) {
                if (errorBox) {
                    errorBox.textContent = '업로드할 이미지를 선택해 주세요.';
                    errorBox.classList.add('show');
                }
                return;
            }

            if (errorBox) {
                errorBox.textContent = '';
                errorBox.classList.remove('show');
            }
            if (submitButton) submitButton.disabled = true;

            try {
                const formData = new FormData();
                formData.append('mapKey', window.MapApp.state.activeMapKey || 'town');
                formData.append('name', name);
                formData.append('description', description);
                formData.append('eventName', eventName);
                if (linkedSelect?.value) formData.append('forageableId', linkedSelect.value);
                formData.append('imageMode', isUpload ? 'UPLOAD' : selectedImage?.value === 'keep' ? 'KEEP' : 'PRESET');
                if (isUpload) {
                    formData.append('imageFile', imageFileInput.files[0]);
                } else {
                    formData.append('iconUrl', selectedImage?.value || '/images/map/dynamic-resources/pink-bubble.webp');
                }

                const resource = await window.MapApp.api.createDynamicResource(formData, id);
                const state = window.MapApp.state;
                const before = state.masterDynamicResources.find(r => String(r.id) === id);
                if (before) {
                    state.masterDynamicResources = state.masterDynamicResources.map(r => r.id === resource.id ? resource : r);
                    if (!resource.forageableId) state.allPins.forEach(p => {
                        if (p.category === 'dynamic_resource' && p.name === before.name) {
                            p.name = resource.name; p.description = resource.description;
                        }
                    });
                } else state.masterDynamicResources.push(resource);
                window.MapApp.state.expandedCategories.dynamic_resource = true;
                window.MapApp.state.categoryVisible.dynamic_resource = true;
                window.MapApp.state.itemVisible[`dynamic_resource:${resource.name}`] = true;
                if (resource.eventName) {
                    state.expandedCategories.trend_season = true;
                    state.categoryVisible.trend_season = true;
                }
                if (id) {
                    const pins = await fetch('/wiki/map/api/pins?mapKey=' + encodeURIComponent(state.activeMapKey)).then(r => {
                        if (!r.ok) throw new Error('변경된 위치 정보를 불러오지 못했습니다.');
                        return r.json();
                    });
                    state.allPins = pins.filter(window.MapApp.belongsToActiveMap);
                    Object.values(state.markers).forEach(marker => state.map?.removeLayer(marker));
                    state.markers = {};
                    state.allPins.forEach(pin => {
                        if (pin.mapX != null && pin.mapY != null) window.MapApp.createMarker(pin, state.map, state.mapHeight);
                    });
                }
                window.MapApp.ui.updateMarkerVisibility();
                window.MapApp.ui.renderCategoryList();
                form.reset();
                syncImageInput();
                bootstrap.Modal.getOrCreateInstance(document.getElementById('dynamicResourceModal')).hide();
                const template = {
                    mapKey: resource.mapKey,
                    category: resource.forageableId ? 'forageable' : 'dynamic_resource',
                    name: resource.name,
                    iconUrl: resource.iconUrl || null,
                    description: resource.description || null,
                    linkUrl: null
                };
                if (!id) window.MapApp.ui.enterPlacementMode(template, true);
                else window.MapApp.ui.exitPlacementMode();
                window.MapApp.ui.showToast(`✅ ${resource.name} 등록 완료 — 지도에서 위치를 선택하세요.`);
            } catch (error) {
                if (errorBox) {
                    errorBox.textContent = error.message;
                    errorBox.classList.add('show');
                }
            } finally {
                if (submitButton) submitButton.disabled = false;
            }
        });
    },
    renderCategoryList: function () {
        const state = window.MapApp.state;
        const configMap = window.MapApp.CATEGORY_CONFIG;
        const categoryList = document.getElementById('categoryList');
        if (!categoryList) return;

        const grouped = {};
        state.allPins.forEach(pin => {
            if (pin.category === 'dynamic_resource' && state.masterDynamicResources.some(r => r.eventName && r.name === pin.name)) return;
            if (!grouped[pin.category]) grouped[pin.category] = [];
            grouped[pin.category].push(pin);
        });
        if (!grouped.dynamic_resource) grouped.dynamic_resource = [];

        const masterMap = {
            'forageable': state.masterForageables, 'fish': state.masterFish,
            'bird': state.masterBirds, 'insect': state.masterInsects,
            'animal': state.masterAnimals, 'villager': state.masterVillagers,
            'dynamic_resource': state.masterDynamicResources
        };

        Object.entries(masterMap).forEach(([category, masters]) => {
            if (masters && masters.length > 0) {
                if (!grouped[category]) grouped[category] = [];
                masters.forEach(master => {
                    if (category === 'dynamic_resource' && (master.eventName || master.forageableId)) return;
                    const hasPin = state.allPins.some(p => {
                        if (p.category !== category) return false;
                        if (category === 'dynamic_resource') return p.name === master.name;
                        return p.name === master.name || p.name.includes(master.name) || master.name.includes(p.name);
                    });
                    if (!hasPin) {
                        grouped[category].push({
                            id: 'm-' + master.name, category: category, name: master.name,
                            iconUrl: master.imageUrl || master.iconUrl || null,
                            description: master.description || null,
                            mapX: null, mapY: null, isMaster: true
                        });
                    }
                });
            }
        });

        categoryList.innerHTML = '';
        const categoryOrder = ['dynamic_resource', 'villager', 'animal', 'bus', 'forageable', 'fish', 'insect', 'bird'];
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
            const isMultiLocation = window.MapApp.MULTI_LOCATION_CATEGORIES.includes(category);
            if (isMultiLocation) {
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
                        ${category === 'dynamic_resource' && window.isAdmin ? `
                            <button class="dynamic-resource-add-btn" type="button" title="변동 자원 추가"
                                aria-label="변동 자원 추가"><i class="fas fa-plus"></i></button>
                        ` : ''}
                        <button class="category-toggle ${isCatVisible ? '' : 'off'}" data-category="${category}">
                            <i class="fas ${isCatVisible ? 'fa-eye' : 'fa-eye-slash'}"></i>
                        </button>
                    </div>
                </div>
                <div class="category-items ${isExpanded ? 'expanded' : ''}">
                    ${displayItems.length === 0
                        ? '<div class="dynamic-resource-empty">등록된 변동 자원이 없습니다.</div>'
                        : displayItems.sort((a, b) => a.name.localeCompare(b.name)).map(pin => {
                const isUnplaced = !pin.mapX && !pin.mapY;
                const isMultiLocation = window.MapApp.MULTI_LOCATION_CATEGORIES.includes(category);
                const isPlacing = state.placementMode.active && state.placementMode.pinTemplate && state.placementMode.pinTemplate.name === pin.name;
                const pinCount = isMultiLocation ? state.allPins.filter(p => p.category === category && p.name === pin.name).length : 0;
                const hasVisibilityToggle = ['villager', 'animal', 'forageable', 'dynamic_resource', 'bus'].includes(category);
                const visibilityKey = window.MapApp.getItemVisibilityKey(category, pin);
                const isItemVisible = state.itemVisible[visibilityKey] !== false;
                const safeName = window.MapApp.ui.escapeHtml(pin.name);

                return `
                    <div class="pin-item ${isPlacing ? 'placing' : ''}" data-id="${pin.id}" data-name="${safeName}" data-category="${category}">
                        ${isUnplaced ? '<span class="pin-unplaced" title="미배치"></span>' : ''}
                        ${window.MapApp.ui.renderSidebarIcon(pin.iconUrl, config.icon, isExpanded)}
                        <span class="pin-item-name">${safeName} ${isMultiLocation ? `(${pinCount})` : ''}</span>
                        <div class="pin-item-controls">
                            ${(hasVisibilityToggle && !isUnplaced) || (isMultiLocation && pinCount > 0) ? `
                                <button class="item-visibility-toggle ${isItemVisible ? '' : 'off'}" 
                                    data-id="${pin.id}" data-category="${category}" data-name="${safeName}" title="표시/숨기기">
                                    <i class="fas ${isItemVisible ? 'fa-eye' : 'fa-eye-slash'}"></i>
                                </button>
                            ` : ''}
                            ${['fish', 'bird', 'insect'].includes(category) ? '' : (isMultiLocation ? `
                                <button class="item-add-btn" data-category="${category}" data-name="${safeName}" title="연속 배치"
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

        window.MapApp.ui.renderTrendSeasons(categoryList);
        window.MapApp.ui.bindCategoryEvents();
        window.MapApp.ui.renderLocationList();
    },
    bindCategoryEvents: function() {
        const state = window.MapApp.state;
        const ui = window.MapApp.ui;
        // Category Expand/Collapse
        document.querySelectorAll('.category-header').forEach(header => {
            header.addEventListener('click', (e) => {
                if (e.target.closest('button')) return;
                const cat = header.dataset.category;
                state.expandedCategories[cat] = !state.expandedCategories[cat];
                ui.renderCategoryList();
            });
        });

        document.querySelectorAll('.dynamic-resource-add-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                ui.openResourceForm(null, btn.dataset.trend === 'true');
            });
        });

        // Category Toggle Visibility
        document.querySelectorAll('.category-toggle').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const cat = btn.dataset.category;
                const nextVisible = !state.categoryVisible[cat];
                state.categoryVisible[cat] = nextVisible;
                if (cat === 'trend_season') {
                    state.masterDynamicResources.filter(r => r.eventName).forEach(r => {
                        const category = r.forageableId ? 'forageable' : 'dynamic_resource';
                        state.itemVisible[`${category}:${r.name}`] = nextVisible;
                    });
                }
                state.allPins.forEach(pin => {
                    if (pin.category === cat) {
                        const key = window.MapApp.getItemVisibilityKey(cat, pin);
                        state.itemVisible[key] = nextVisible;
                    }
                });
                const masterMap = {
                    'forageable': state.masterForageables, 'fish': state.masterFish,
                    'bird': state.masterBirds, 'insect': state.masterInsects,
                    'animal': state.masterAnimals, 'villager': state.masterVillagers,
                    'dynamic_resource': state.masterDynamicResources
                };
                if (masterMap[cat]) {
                    masterMap[cat].forEach(m => {
                        const key = window.MapApp.getItemVisibilityKey(cat, { id: `m-${m.name}`, name: m.name });
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
                const key = window.MapApp.getItemVisibilityKey(cat, { id: id, name: name });
                const nextVisible = state.itemVisible[key] === false ? true : false;
                state.itemVisible[key] = nextVisible;
                if (nextVisible) {
                    state.categoryVisible[cat] = true;
                    if (btn.closest('[data-trend-group]')) state.categoryVisible.trend_season = true;
                }
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
                    if (master) {
                        ui.showInfoBox(master, category);
                        
                        // 구역으로 카메라 이동 및 오버레이 폴리곤 하이라이트
                        if (master.location) {
                            const zone = window.MapApp.zone;
                            const zoneKeys = zone.resolveZoneKeys(master.location, master.subLocation);
                            const isWhole = !master.subLocation || master.subLocation === '-' || master.subLocation === '' || master.subLocation.endsWith('전체');

                            // 해당 zone 라벨만 켜기
                            if (state.allZones && zoneKeys.length > 0) {
                                if (!state.zoneVisible) state.zoneVisible = {};
                                state.allZones.forEach(z => { state.zoneVisible[z.zoneKey] = false; });
                                zoneKeys.forEach(k => { state.zoneVisible[k] = true; });
                                if (window.MapApp.updateZoneLabelVisibility) window.MapApp.updateZoneLabelVisibility();
                            }

                            if (isWhole && zoneKeys.length > 1) {
                                // "전체" 케이스: 모든 핀 끄고, 하위 zone 라벨만 표시, fitBounds
                                Object.keys(state.categoryVisible).forEach(cat => { state.categoryVisible[cat] = false; });
                                state.allPins.forEach(p => {
                                    const key = window.MapApp.getItemVisibilityKey(p.category, p);
                                    state.itemVisible[key] = false;
                                });
                                const masterMapAll = {
                                    'forageable': state.masterForageables, 'fish': state.masterFish,
                                    'bird': state.masterBirds, 'insect': state.masterInsects,
                                    'animal': state.masterAnimals, 'villager': state.masterVillagers,
                                    'dynamic_resource': state.masterDynamicResources
                                };
                                Object.entries(masterMapAll).forEach(([cat, ms]) => {
                                    if (ms) ms.forEach(m => {
                                        const key = window.MapApp.getItemVisibilityKey(cat, { id: `m-${m.name}`, name: m.name });
                                        state.itemVisible[key] = false;
                                    });
                                });
                                ui.updateMarkerVisibility();
                                ui.renderCategoryList();

                                // 하위 zone 좌표로 fitBounds
                                const mapHeight = state.mapHeight || 3000;
                                const childCoords = [];
                                zoneKeys.forEach(k => {
                                    const zoneObj = state.allZones.find(z => z.zoneKey === k);
                                    if (zoneObj && zoneObj.mapX && zoneObj.mapY && zoneObj.parentZoneKey) {
                                        childCoords.push([mapHeight - zoneObj.mapY, zoneObj.mapX]);
                                    }
                                });
                                if (childCoords.length > 0) {
                                    const bounds = L.latLngBounds(childCoords);
                                    state.map.fitBounds(bounds.pad(0.3), { animate: true });
                                }

                                zone.highlightZones(zoneKeys);
                            } else {
                                // 기존 로직: 단일 zone 좌표로 카메라 이동
                                let moved = false;
                                if (zoneKeys.length > 0) {
                                    const zoneObj = state.allZones.find(z => z.zoneKey === zoneKeys[0]);
                                    if (zoneObj && zoneObj.mapX && zoneObj.mapY) {
                                        const mapHeight = state.mapHeight || 3000;
                                        const lat = mapHeight - zoneObj.mapY;
                                        const lng = zoneObj.mapX;
                                        state.map.setView([lat, lng], 1, { animate: true });
                                        moved = true;
                                    }
                                }
                                // fallback: 폴리곤 하이라이트
                                if (!moved) {
                                    zone.highlightZones(zoneKeys);
                                }
                            }
                        }
                    }
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
                const masters = category === 'dynamic_resource'
                    ? state.masterDynamicResources
                    : state.masterForageables;
                const master = masters.find(m => m.name === name);
                const template = existing ? { ...existing } : {
                    mapKey: state.activeMapKey || 'town',
                    category: category,
                    name: name,
                    iconUrl: master ? (master.imageUrl || master.iconUrl) : null,
                    description: master ? master.description : null,
                    linkUrl: null
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
                const item = btn.closest('.pin-item');
                const category = item?.dataset.category;
                const name = item?.dataset.name;
                let template = pin ? { ...pin } : null;

                if (!template && category === 'animal') {
                    const master = state.masterAnimals.find(animal => animal.name === name);
                    if (master) {
                        template = {
                            mapKey: state.activeMapKey || 'town',
                            category: 'animal',
                            name: master.name,
                            iconUrl: master.imageUrl || null,
                            description: master.description || null,
                            linkUrl: null
                        };
                    }
                }

                if (!template) {
                    ui.showToast('❌ 배치할 동물 정보를 찾지 못했습니다.');
                    return;
                }

                const activeTemplate = state.placementMode.pinTemplate;
                const isSameTemplate = activeTemplate
                    && activeTemplate.category === template.category
                    && activeTemplate.name === template.name;
                if (state.placementMode.active && isSameTemplate) {
                    ui.exitPlacementMode();
                } else {
                    ui.enterPlacementMode(template, false);
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
