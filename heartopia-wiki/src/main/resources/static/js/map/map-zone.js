window.MapApp = window.MapApp || {};

const LOCATION_TO_ZONE = {
    '강 전체': '강', '강': '강', '강변': '강',
    '거목 강': '거목강', '고요한 강': '고요한강', '노을 강': '노을강', '얕은 강': '얕은강',
    '바다 전체': '바다', '바다': '바다', '잔잔한 바다': '잔잔한바다',
    '고래 바다': '고래바다', '고래바다 해변': '고래바다',
    '구해': '구해', '구해 해변': '구해', '동해': '동해', '동해 해변': '동해',
    '호수 전체': '호수', '호수': '호수', '근교 호수': '근교호수', '숲속 호수': '숲속호수', '숲 호수': '숲속호수',
    '온천산 호수': '온천산호수', '초원 호수': '초원호수', '도시 근교 호수': '근교도시호수',
    '숲 전체': '숲', '숲': '숲', '영혼의 참나무 숲': '영혼참나무', '영혼의 참나무': '영혼참나무',
    '순록탑': '순록탑', '숲속 섬': '숲속섬', '점핑 플랫폼': '점핑플랫폼', '호숫가': '숲호숫가', '숲 호숫가': '숲호숫가',
    '꽃밭 전체': '꽃밭', '꽃밭': '꽃밭', '고래산': '고래산꽃밭', '보라빛 해변': '보라빛해변', '풍차꽃밭': '풍차꽃밭',
    '어촌 전체': '어촌', '어촌': '어촌', '부두': '어촌부두', '동쪽 부두': '동쪽부두',
    '등대': '어촌등대', '어촌 광장': '어촌광장', '광장': '어촌광장',
    '온천산 전체': '온천산', '온천산': '온천산', '온천': '온천', '바위절벽': '바위절벽',
    '유적': '온천산유적', '화산 호수': '화산호수', '온천산 호숫가': '온천산호숫가',
    '도시 전체': '도시', '도시': '도시', '도시 근교': '도시근교', '근교': '도시근교', '도심': '도심',
    '해변': '해변', '물가': '물가'
};
window.LOCATION_TO_ZONE = LOCATION_TO_ZONE;

window.MapApp.zone = {
    resolveZoneKeys: function (location, subLocation) {
        const keys = new Set();
        if (!location) return [];

        // "전체" subLocation은 무시하고 부모 zone으로 처리
        const isWhole = !subLocation || subLocation === '-' || subLocation === '' || subLocation.endsWith('전체');

        if (!isWhole) {
            const subKey = LOCATION_TO_ZONE[subLocation];
            if (subKey) keys.add(subKey);
        }

        const locKey = LOCATION_TO_ZONE[location];
        if (locKey) keys.add(locKey);

        const state = window.MapApp.state;

        // 부모 zone의 상위 zone도 포함
        keys.forEach(k => {
            const z = state.allZones.find(z2 => z2.zoneKey === k);
            if (z && z.parentZoneKey) keys.add(z.parentZoneKey);
        });

        // "전체" 케이스: 부모 zone만 있으면 모든 하위 zone 자동 포함
        if (isWhole && locKey) {
            const childZones = state.allZones.filter(z => z.parentZoneKey === locKey);
            if (childZones.length > 0) {
                childZones.forEach(c => keys.add(c.zoneKey));
            }
        }

        return [...keys];
    },
    highlightZones: function (zoneKeys) {
        const state = window.MapApp.state;

        state.activeZoneLayers.forEach(layer => state.map.removeLayer(layer));
        state.activeZoneLayers = [];

        if (!zoneKeys || zoneKeys.length === 0) return;

        zoneKeys.forEach(key => {
            const zone = state.allZones.find(z => z.zoneKey === key);
            if (!zone || !zone.polygonPoints) return;

            let points;
            try {
                points = typeof zone.polygonPoints === 'string' ? JSON.parse(zone.polygonPoints) : zone.polygonPoints;
            } catch (e) { return; }

            const mapHeight = 3000;
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

            polygon.bindTooltip(zone.displayName, { permanent: false, direction: 'center', className: 'zone-tooltip' });
            state.activeZoneLayers.push(polygon);
        });

        if (state.activeZoneLayers.length > 0) {
            const group = L.featureGroup(state.activeZoneLayers);
            state.map.fitBounds(group.getBounds().pad(0.3));
        }
    },
    enterZoneEditMode: function (zoneKey) {
        window.MapApp.state.zoneEditMode.active = true;
        window.MapApp.state.zoneEditMode.targetZoneKey = zoneKey;
        window.MapApp.state.zoneEditMode.points = [];
        const placementBanner = document.getElementById('placementBanner');
        const placementText = document.getElementById('placementText');
        if (placementBanner) placementBanner.classList.add('active');
        if (placementText) placementText.textContent = `📍 [${zoneKey}] 위치 지정 모드 — 맵에서 원하는 지점을 클릭하세요`;
    },
    exitZoneEditMode: function () {
        window.MapApp.state.zoneEditMode.active = false;
        window.MapApp.state.zoneEditMode.targetZoneKey = null;
        window.MapApp.state.zoneEditMode.points = [];
        const placementBanner = document.getElementById('placementBanner');
        if (placementBanner) placementBanner.classList.remove('active');
    }
};
