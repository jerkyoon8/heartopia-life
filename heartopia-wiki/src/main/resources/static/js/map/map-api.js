window.MapApp = window.MapApp || {};

const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;

window.MapApp.api = {
    saveNewPin: async function (pinData) {
        try {
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
            const res = await fetch('/wiki/map/api/zones');
            window.MapApp.state.allZones = await res.json();
        } catch (e) {
            console.error('Zone 로드 실패:', e);
        }
    }
};
