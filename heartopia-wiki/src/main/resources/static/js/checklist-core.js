/**
 * Heartopia Checklist Core Module
 * 로컬스토리지를 일관되게 관리하기 위한 싱글톤 객체
 */
const ChecklistCore = (function() {
    const STORAGE_KEY = 'heartopia_checklist';
    let collectionData = {};
    const observers = [];

    // 초기 데이터 로드 (클로저 내부)
    function loadStorage() {
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

    // 데이터를 스토리지에 덮어쓰기
    function saveStorage() {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(collectionData));
        notifyObservers();
    }

    // 변경사항 전파
    function notifyObservers() {
        observers.forEach(callback => callback(collectionData));
    }

    // 멀티 탭 실시간 동기화 지원 (다른 탭에서 변경 시)
    window.addEventListener('storage', (e) => {
        if (e.key === STORAGE_KEY) {
            loadStorage();
            notifyObservers();
        }
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
