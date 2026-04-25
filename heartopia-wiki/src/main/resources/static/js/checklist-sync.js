/**
 * Checklist Global Sync UI Handler
 * - 모든 페이지에서 .sync-item 이 존재하면 ChecklistCore와 연동합니다.
 * - 로그인 시 DB와 동기화합니다.
 */

document.addEventListener('DOMContentLoaded', async () => {
    if (typeof window.ChecklistCore === 'undefined') return;

    const core = window.ChecklistCore;
    const syncItems = document.querySelectorAll('.sync-item');
    if (syncItems.length === 0) return;

    const syncEnabled = window._heartopiaChecklistSyncEnabled || false;

    function getCsrf() {
        return {
            token: document.querySelector('meta[name="_csrf"]')?.getAttribute('content'),
            header: document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content')
        };
    }

    // 동기화 ON: 머지 완료 후 DB에서 체크리스트 로드
    if (syncEnabled) {
        if (window._checklistMergeOnLogin) await window._checklistMergeOnLogin;
        try {
            const res = await fetch('/api/user/checklist');
            if (res.ok) {
                const dbData = await res.json();
                Object.keys(dbData).forEach(key => core.setItem(key, dbData[key]));
            }
        } catch (e) { /* DB 실패 시 메모리 상태 유지 */ }
    }

    // UI 상태 갱신
    function renderItemStatus(itemEl, val) {
        const stars = itemEl.querySelectorAll('.sync-star-icon');

        if (val !== undefined && val !== null) {
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
                e.stopPropagation();

                if (itemEl.classList.contains('checked')) {
                    core.removeItem(key);
                    if (syncEnabled) {
                        const csrf = getCsrf();
                        fetch('/api/user/checklist/item', {
                            method: 'DELETE',
                            headers: { 'Content-Type': 'application/json', [csrf.header]: csrf.token },
                            body: JSON.stringify({ key })
                        }).catch(() => {});
                    }
                } else {
                    core.setItem(key, 0);
                    if (syncEnabled) {
                        const csrf = getCsrf();
                        fetch('/api/user/checklist/item', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json', [csrf.header]: csrf.token },
                            body: JSON.stringify({ key, val: 0 })
                        }).catch(() => {});
                    }
                }
            });
        }

        // 별점 토글
        stars.forEach(star => {
            star.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();

                const val = parseInt(star.getAttribute('data-val'));
                core.setItem(key, val);
                if (syncEnabled) {
                    const csrf = getCsrf();
                    fetch('/api/user/checklist/item', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json', [csrf.header]: csrf.token },
                        body: JSON.stringify({ key, val })
                    }).catch(() => {});
                }
            });
        });
    });
});
