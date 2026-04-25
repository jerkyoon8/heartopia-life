/**
 * Heartopia Collection Checklist Logic
 */

document.addEventListener('DOMContentLoaded', async () => {

    // --- 1. Storage Manager (ChecklistCore 연동) --- //
    const getCollectionData = () => window.ChecklistCore.getData();

    const syncEnabled = window._heartopiaChecklistSyncEnabled || false;

    function getCsrf() {
        return {
            token: document.querySelector('meta[name="_csrf"]')?.getAttribute('content'),
            header: document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content')
        };
    }

    // --- 2. 동기화 ON: 머지 완료 후 DB에서 체크리스트 로드 --- //
    if (syncEnabled) {
        if (window._checklistMergeOnLogin) await window._checklistMergeOnLogin;
        try {
            const res = await fetch('/api/user/checklist');
            if (res.ok) {
                const dbData = await res.json();
                Object.keys(dbData).forEach(key =>
                    window.ChecklistCore.setItem(key, dbData[key])
                );
            }
        } catch (e) { /* DB 실패 시 메모리 상태 유지 */ }
    }

    // --- 3. Initial DOM Sync --- //
    const allItems = document.querySelectorAll('.collectible-item');
    const categoryCards = document.querySelectorAll('.category-card');

    let totalItemsCount = allItems.length;

    function syncDOMWithStorage() {
        const data = getCollectionData();
        allItems.forEach(itemEl => {
            const key = itemEl.getAttribute('data-key');
            if (data.hasOwnProperty(key)) {
                const starVal = data[key];
                itemEl.classList.add('checked');
                const stars = itemEl.querySelectorAll('.star-icon');
                stars.forEach(starEl => {
                    const val = parseInt(starEl.getAttribute('data-val'));
                    if (val <= starVal) {
                        starEl.classList.add('filled');
                    } else {
                        starEl.classList.remove('filled');
                    }
                });
            } else {
                itemEl.classList.remove('checked');
                itemEl.querySelectorAll('.star-icon').forEach(s => s.classList.remove('filled'));
            }
        });
        updateProgressUI();
    }

    function updateProgressUI() {
        let totalCollected = Object.keys(getCollectionData()).length;

        document.getElementById('overall-collected').textContent = totalCollected;
        document.getElementById('overall-total').textContent = totalItemsCount;
        let overallPercent = totalItemsCount > 0 ? Math.round((totalCollected / totalItemsCount) * 100) : 0;
        document.getElementById('overall-progress-bar').style.width = overallPercent + '%';
        document.getElementById('overall-percent').textContent = overallPercent + '% 달성';

        categoryCards.forEach(card => {
            const catName = card.getAttribute('data-target');
            const totalInCat = parseInt(card.getAttribute('data-total')) || 0;
            const collectedInCat = Object.keys(getCollectionData()).filter(k => k.startsWith(catName + '_')).length;

            card.querySelector('#count-' + catName).textContent = collectedInCat;
            let catPercent = totalInCat > 0 ? (collectedInCat / totalInCat) * 100 : 0;
            card.querySelector('#progress-bar-' + catName).style.width = catPercent + '%';
        });
    }

    syncDOMWithStorage();

    // 멀티탭/외부 갱신 시 상태 최신화
    window.ChecklistCore.subscribe(() => {
        syncDOMWithStorage();
    });


    // --- 4. Events: Category Tab Switching --- //
    categoryCards.forEach(card => {
        card.addEventListener('click', () => {
            if (card.classList.contains('active')) return;

            categoryCards.forEach(c => c.classList.remove('active'));
            card.classList.add('active');

            const targetCat = card.getAttribute('data-target');

            document.querySelectorAll('.category-container').forEach(container => {
                if (container.getAttribute('data-category') === targetCat) {
                    container.classList.add('active');
                } else {
                    container.classList.remove('active');
                }
            });
        });
    });

    // --- 5. Events: Click + Stars (drag 제거됨) --- //
    function setItemStatus(itemEl, mode) {
        const key = itemEl.getAttribute('data-key');
        const stars = itemEl.querySelectorAll('.star-icon');
        const isChecked = itemEl.classList.contains('checked');

        if (mode === 'check' && isChecked) return;
        if (mode === 'uncheck' && !isChecked) return;

        if (mode === 'check') {
            window.ChecklistCore.setItem(key, 0);
            itemEl.classList.add('checked');
        } else {
            window.ChecklistCore.removeItem(key);
            itemEl.classList.remove('checked');
            stars.forEach(s => s.classList.remove('filled'));
        }
        updateProgressUI();

        // 동기화 ON일 때만 즉시 DB 반영
        if (syncEnabled) {
            const csrf = getCsrf();
            if (mode === 'check') {
                fetch('/api/user/checklist/item', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', [csrf.header]: csrf.token },
                    body: JSON.stringify({ key, val: 0 })
                }).catch(() => {});
            } else {
                fetch('/api/user/checklist/item', {
                    method: 'DELETE',
                    headers: { 'Content-Type': 'application/json', [csrf.header]: csrf.token },
                    body: JSON.stringify({ key })
                }).catch(() => {});
            }
        }
    }

    allItems.forEach(itemEl => {
        const key = itemEl.getAttribute('data-key');
        const stars = itemEl.querySelectorAll('.star-icon');

        itemEl.style.userSelect = 'none';

        // 아이템 클릭 = 토글 (별점 영역은 별도 처리)
        itemEl.addEventListener('click', (e) => {
            if (e.target.closest('.star-icon')) return;
            const mode = itemEl.classList.contains('checked') ? 'uncheck' : 'check';
            setItemStatus(itemEl, mode);
        });

        // 별점 클릭 = 평점 세팅 + 즉시 DB 동기화
        stars.forEach(starEl => {
            starEl.addEventListener('click', (e) => {
                e.stopPropagation();
                const clickVal = parseInt(starEl.getAttribute('data-val'));

                window.ChecklistCore.setItem(key, clickVal);
                itemEl.classList.add('checked');

                stars.forEach(s => {
                    if (parseInt(s.getAttribute('data-val')) <= clickVal) {
                        s.classList.add('filled');
                    } else {
                        s.classList.remove('filled');
                    }
                });

                updateProgressUI();

                if (syncEnabled) {
                    const csrf = getCsrf();
                    fetch('/api/user/checklist/item', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json', [csrf.header]: csrf.token },
                        body: JSON.stringify({ key, val: clickVal })
                    }).catch(() => {});
                }
            });
        });
    });

    // --- 6. Search Filtering --- //
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase().trim();
            const activeContainer = document.querySelector('.category-container.active');
            if (!activeContainer) return;

            const visibleItems = activeContainer.querySelectorAll('.collectible-item');
            visibleItems.forEach(item => {
                const name = item.getAttribute('data-searchname').toLowerCase();
                if (name.includes(query)) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        });

        categoryCards.forEach(card => {
            card.addEventListener('click', () => {
                searchInput.value = '';
                document.querySelectorAll('.collectible-item').forEach(item => item.style.display = 'flex');
            });
        });
    }

    // --- 7. Reset Data --- //
    const resetBtn = document.getElementById('resetBtn');
    if (resetBtn) {
        resetBtn.addEventListener('click', () => {
            if (confirm("정말로 모든 수집 도감 데이터를 초기화하시겠습니까? 이 작업은 복구할 수 없습니다.")) {
                window.ChecklistCore.clear();
                if (syncEnabled) {
                    const csrf = getCsrf();
                    fetch('/api/user/checklist', {
                        method: 'DELETE',
                        headers: { [csrf.header]: csrf.token }
                    }).catch(() => {});
                }
                syncDOMWithStorage();
            }
        });
    }
});
