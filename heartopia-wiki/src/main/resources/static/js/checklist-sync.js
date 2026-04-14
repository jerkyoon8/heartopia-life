/**
 * Checklist Global Sync UI Handler
 * - 모든 페이지에서 .sync-item 이 존재하면 ChecklistCore와 연동합니다.
 */

document.addEventListener('DOMContentLoaded', () => {
    if (typeof window.ChecklistCore === 'undefined') return;
    
    const core = window.ChecklistCore;
    const syncItems = document.querySelectorAll('.sync-item');
    if (syncItems.length === 0) return;

    // UI 상태 갱신
    function renderItemStatus(itemEl, val) {
        const checkBtn = itemEl.querySelector('.sync-check-btn');
        const stars = itemEl.querySelectorAll('.sync-star-icon');
        
        if (val !== undefined && val !== null) {
            // 수집 완료
            itemEl.classList.add('checked');
            stars.forEach(star => {
                const sVal = parseInt(star.getAttribute('data-val'));
                if (sVal <= val) {
                    star.classList.add('filled');
                } else {
                    star.classList.remove('filled');
                }
            });
        } else {
            // 수집 취소
            itemEl.classList.remove('checked');
            stars.forEach(star => star.classList.remove('filled'));
        }
    }

    // 한 화면 내의 모든 아이템 스캔 후 최신화
    function syncAll() {
        const data = core.getData();
        syncItems.forEach(itemEl => {
            const key = itemEl.getAttribute('data-sync-key');
            renderItemStatus(itemEl, data[key]);
        });
    }

    // 전역 상태가 바뀌면(다른 탭 등에서) 자동 최신화
    core.subscribe(() => {
        syncAll();
    });

    // 1회 초기 렌더링
    syncAll();

    // 이벤트 리스너 등록 (상세 뷰 및 리스트 뷰 공통)
    syncItems.forEach(itemEl => {
        const key = itemEl.getAttribute('data-sync-key');
        if (!key) return;

        const checkBtn = itemEl.querySelector('.sync-check-btn');
        const stars = itemEl.querySelectorAll('.sync-star-icon');

        // 체크 버튼 토글
        if (checkBtn) {
            checkBtn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation(); // 클릭 시 부모 <a> 이동 방지
                
                if (itemEl.classList.contains('checked')) {
                    core.removeItem(key);
                } else {
                    core.setItem(key, 0);
                }
                // (renderItemStatus는 subscribe 콜백을 통해 자동호출됨)
            });
        }

        // 별점 토글
        stars.forEach(star => {
            star.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                
                const val = parseInt(star.getAttribute('data-val'));
                core.setItem(key, val);
            });
        });
    });
});
