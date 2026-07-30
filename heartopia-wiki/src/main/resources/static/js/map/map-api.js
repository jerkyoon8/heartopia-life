window.MapApp = window.MapApp || {};

const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;

window.MapApp.api = {
    saveNewPin: async function (pinData) {
        try {
            pinData.mapKey = pinData.mapKey || window.MapApp.state.activeMapKey || 'town';
            const headers = { 'Content-Type': 'application/json' };
            if (csrfToken && csrfHeader) headers[csrfHeader] = csrfToken;

            const response = await fetch('/wiki/map/api/pins', {
                method: 'POST',
                headers: headers,
                body: JSON.stringify(pinData)
            });
            if (!response.ok) throw new Error('등록 실패');
            return await response.json();
        } catch (err) {
            console.error('핀 등록 에러:', err);
            throw err;
        }
    },
    deletePin: async function (pinId) {
        try {
            const headers = {};
            if (csrfToken && csrfHeader) headers[csrfHeader] = csrfToken;

            const response = await fetch('/wiki/map/api/pins/' + pinId, {
                method: 'DELETE',
                headers: headers
            });
            if (!response.ok) throw new Error('삭제 실패');
            return await response.json();
        } catch (err) {
            console.error('핀 삭제 에러:', err);
            throw err;
        }
    },
    loadAllZones: async function () {
        try {
            const mapKey = window.MapApp.state.activeMapKey || 'town';
            const res = await fetch('/wiki/map/api/zones?mapKey=' + encodeURIComponent(mapKey));
            if (!res.ok) throw new Error('Zone 로드 실패');
            const zones = await res.json();
            window.MapApp.state.allZones = zones.filter(window.MapApp.belongsToActiveMap);
            return window.MapApp.state.allZones;
        } catch (e) {
            console.error('Zone 로드 실패:', e);
            throw e;
        }
    },
    saveZonePosition: async function (zoneKey, mapX, mapY) {
        try {
            const mapKey = window.MapApp.state.activeMapKey || 'town';
            const headers = { 'Content-Type': 'application/json' };
            if (csrfToken && csrfHeader) headers[csrfHeader] = csrfToken;
            const response = await fetch('/wiki/map/api/zones/' + zoneKey + '/position', {
                method: 'PUT',
                headers: headers,
                body: JSON.stringify({ mapKey: mapKey, mapX: mapX, mapY: mapY })
            });
            if (!response.ok) throw new Error('Zone 위치 저장 실패');
            return await response.json();
        } catch (err) {
            console.error('Zone 위치 저장 에러:', err);
            throw err;
        }
    }
};
