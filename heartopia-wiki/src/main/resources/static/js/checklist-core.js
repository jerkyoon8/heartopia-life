/**
 * Heartopia Checklist Core Module
 * 싱글톤. 비로그인/동기화OFF 유저는 localStorage 사용, 동기화ON 유저는 메모리만.
 */
const ChecklistCore = (function() {
    const STORAGE_KEY = 'heartopia_checklist';
    let collectionData = {};
    const observers = [];

    // sync ON이면 localStorage 완전 무시 (DB가 진실)
    function isSyncMode() {
        return !!window._heartopiaChecklistSyncEnabled;
    }

    // 초기 데이터 로드
    function loadStorage() {
        if (isSyncMode()) {
            // 동기화 모드: localStorage 무시하고 빈 상태로 시작.
            // 페이지 스크립트가 DB에서 로드해서 채움.
            // localStorage 삭제는 common-head의 머지 성공 시 처리 (실패 시 데이터 보존).
            collectionData = {};
            return;
        }
        const rawData = localStorage.getItem(STORAGE_KEY);
        if (!rawData) {
            collectionData = {};
            return;
        }
        try {
            collectionData = JSON.parse(rawData);
            if (typeof collectionData !== 'object' || collectionData === null) {
                collectionData = {};
            }
        } catch (e) {
            console.error("데이터 파싱 오류. 캐시가 오염되어 초기화합니다.", e);
            collectionData = {};
        }
    }

    // 데이터를 스토리지에 덮어쓰기 (sync 모드면 localStorage 안 건드림)
    function saveStorage() {
        if (!isSyncMode()) {
            localStorage.setItem(STORAGE_KEY, JSON.stringify(collectionData));
        }
        notifyObservers();
    }

    // 변경사항 전파
    function notifyObservers() {
        observers.forEach(callback => callback(collectionData));
    }

    // 멀티 탭 실시간 동기화 지원 (다른 탭에서 변경 시)
    window.addEventListener('storage', (e) => {
        if (e.key !== STORAGE_KEY) return;
        // sync 모드인데 다른 탭이 localStorage를 변경했다 = 다른 탭에서 토글 OFF로 전환됨.
        // 현재 탭은 stale 상태이므로 reload로 새 플래그/데이터를 받는다.
        if (isSyncMode() && e.newValue !== null) {
            window.location.reload();
            return;
        }
        loadStorage();
        notifyObservers();
    });

    // 최초 로드 실행
    loadStorage();

    return {
        // 데이터 전체 가져오기
        getData: function() {
            return collectionData;
        },
        // 값 반환 (없으면 undefined)
        getItem: function(key) {
            return collectionData[key];
        },
        // 새로 저장하거나 덮어쓰기
        setItem: function(key, val) {
            collectionData[key] = val;
            saveStorage();
        },
        // 항목 제거
        removeItem: function(key) {
            if (collectionData.hasOwnProperty(key)) {
                delete collectionData[key];
                saveStorage();
            }
        },
        // 전체 제거
        clear: function() {
            collectionData = {};
            saveStorage();
        },
        // 상태 변경 리스너 등록
        subscribe: function(callback) {
            if(typeof callback === 'function') {
                observers.push(callback);
            }
        }
    };
})();

// 글로벌 변수로 노출
window.ChecklistCore = ChecklistCore;
