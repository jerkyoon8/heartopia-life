/**
 * Heartopia Collection Checklist Logic
 */

document.addEventListener('DOMContentLoaded', () => {

    // --- 1. Storage Manager (ChecklistCore 연동) --- //
    // ChecklistCore.js가 먼저 로드된 상태라고 가정
    const getCollectionData = () => window.ChecklistCore.getData();

    // --- 2. Initial DOM Sync (빠른 렌더링 덮어쓰기) --- //
    const allItems = document.querySelectorAll('.collectible-item');
    const categoryCards = document.querySelectorAll('.category-card');
    
    // 전체 통계용 변수
    let totalItemsCount = allItems.length;

    function syncDOMWithStorage() {
        const data = getCollectionData();
        // 아이템의 UI 복원
        allItems.forEach(itemEl => {
            const key = itemEl.getAttribute('data-key');
            if(data.hasOwnProperty(key)) {
                const starVal = data[key];
                // 체크박스 활성화
                itemEl.classList.add('checked');
                // 별점 활성화
                const stars = itemEl.querySelectorAll('.star-icon');
                stars.forEach(starEl => {
                    const val = parseInt(starEl.getAttribute('data-val'));
                    if(val <= starVal) {
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

    // 통계 및 프로그레스바 갱신
    function updateProgressUI() {
        let totalCollected = Object.keys(getCollectionData()).length;

        // Overall Update
        document.getElementById('overall-collected').textContent = totalCollected;
        document.getElementById('overall-total').textContent = totalItemsCount;
        let overallPercent = totalItemsCount > 0 ? Math.round((totalCollected / totalItemsCount) * 100) : 0;
        document.getElementById('overall-progress-bar').style.width = overallPercent + '%';
        document.getElementById('overall-percent').textContent = overallPercent + '% 달성';

        // Category Cards Update
        categoryCards.forEach(card => {
            const catName = card.getAttribute('data-target');
            const totalInCat = parseInt(card.getAttribute('data-total')) || 0;
            
            // 해당 카테고리 접두사가 붙은 키의 개수를 센다
            const collectedInCat = Object.keys(getCollectionData()).filter(k => k.startsWith(catName + '_')).length;
            
            card.querySelector('#count-' + catName).textContent = collectedInCat;
            let catPercent = totalInCat > 0 ? (collectedInCat / totalInCat) * 100 : 0;
            card.querySelector('#progress-bar-' + catName).style.width = catPercent + '%';
        });
    }

    // 초기화 과정이었던 loadStorage() 제거 (ChecklistCore가 담당)
    syncDOMWithStorage();

    // 멀티탭/외부 갱신 시 상태 최신화 (Wow 팩터)
    window.ChecklistCore.subscribe(() => {
        syncDOMWithStorage();
    });


    // --- 3. Events: Category Tab Switching --- //
    categoryCards.forEach(card => {
        card.addEventListener('click', () => {
            if(card.classList.contains('active')) return;

            // 라디오 버튼처럼 동작
            categoryCards.forEach(c => c.classList.remove('active'));
            card.classList.add('active');

            const targetCat = card.getAttribute('data-target');
            
            document.querySelectorAll('.category-container').forEach(container => {
                if(container.getAttribute('data-category') === targetCat) {
                    container.classList.add('active');
                } else {
                    container.classList.remove('active');
                }
            });
        });
    });

    // --- 4. Events: Drag/Click and Stars --- //
    let isDragging = false;
    let dragMode = null;
    let isContinuousSelectionEnabled = false; // 기본값: 연속 선택 꺼짐
    let touchFired = false; // 모바일 ghost click 방지 플래그

    const continuousBtn = document.getElementById('continuousBtn');
    if (continuousBtn) {
        continuousBtn.addEventListener('click', () => {
            isContinuousSelectionEnabled = !isContinuousSelectionEnabled;
            if (isContinuousSelectionEnabled) {
                continuousBtn.innerHTML = '<i class="fas fa-hand-pointer"></i> 연속 선택: 켜짐';
                continuousBtn.classList.add('active');
            } else {
                continuousBtn.innerHTML = '<i class="fas fa-mouse-pointer"></i> 연속 선택: 꺼짐';
                continuousBtn.classList.remove('active');
            }
        });
    }

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
    }

    allItems.forEach(itemEl => {
        const key = itemEl.getAttribute('data-key');
        const stars = itemEl.querySelectorAll('.star-icon');

        // 기본 텍스트 드래그 블록
        itemEl.style.userSelect = 'none';

        // 1) 마우스 누를 때 (이름, 체크박스 영역 공통)
        //    touchFired 플래그가 켜져 있으면 모바일 ghost click이므로 무시
        itemEl.addEventListener('mousedown', (e) => {
            if (touchFired) return; // 터치 직후 발사된 가짜 mousedown 차단
            if (e.target.closest('.star-icon') || e.button !== 0) return;
            isDragging = true;
            dragMode = itemEl.classList.contains('checked') ? 'uncheck' : 'check';
            setItemStatus(itemEl, dragMode);
        });

        // 2) 마우스로 드래그하며 진입할 때
        itemEl.addEventListener('mouseenter', () => {
            if (isContinuousSelectionEnabled && isDragging && dragMode) {
                setItemStatus(itemEl, dragMode);
            }
        });

        // 3) 모바일 터치 시작 (이름, 빈칸 공용)
        itemEl.addEventListener('touchstart', (e) => {
            if (e.target.closest('.star-icon')) return;
            // ghost click 방지: 터치 직후 400ms 동안 mousedown 무시
            touchFired = true;
            clearTimeout(itemEl._touchTimer);
            itemEl._touchTimer = setTimeout(() => { touchFired = false; }, 400);
            isDragging = true;
            dragMode = itemEl.classList.contains('checked') ? 'uncheck' : 'check';
            setItemStatus(itemEl, dragMode);
        }, {passive: true});

        // 4) 별점 클릭 세팅 (단독 지정)
        stars.forEach(starEl => {
            starEl.addEventListener('click', (e) => {
                e.stopPropagation(); // 드래그 토글과 충돌 방지
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

                // 별점 클릭 후 진행도 즉시 업뎃
                updateProgressUI();
            });
            
            // 모바일 별점 터치 시 드래그 동작 방지
            starEl.addEventListener('touchstart', (e) => {
                 e.stopPropagation();
            }, {passive: true});
        });
    });

    // 드래그 종료 공통 처리 (마우스업)
    window.addEventListener('mouseup', () => {
        if (isDragging) {
            isDragging = false;
            dragMode = null;
            updateProgressUI();
        }
    });

    // 모바일 드래그 중인 위치의 엘리먼트 감지 및 상태 변경
    window.addEventListener('touchmove', (e) => {
        if (!isContinuousSelectionEnabled || !isDragging || !dragMode) return;
        const touch = e.touches[0];
        const el = document.elementFromPoint(touch.clientX, touch.clientY);
        if (el) {
            const itemEl = el.closest('.collectible-item');
            if (itemEl) {
                setItemStatus(itemEl, dragMode);
            }
        }
    }, {passive: true});

    // 모바일 드래그 종료 (저장)
    window.addEventListener('touchend', () => {
        if (isDragging) {
            isDragging = false;
            dragMode = null;
            updateProgressUI();
        }
    });

    // 기본 브라우저 드래그 앤 드롭 방지
    document.addEventListener('dragstart', (e) => e.preventDefault());

    // --- 5. Search Filtering --- //
    const searchInput = document.getElementById('searchInput');
    if(searchInput) {
        searchInput.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase().trim();
            const activeContainer = document.querySelector('.category-container.active');
            if(!activeContainer) return;

            const visibleItems = activeContainer.querySelectorAll('.collectible-item');
            visibleItems.forEach(item => {
                const name = item.getAttribute('data-searchname').toLowerCase();
                if(name.includes(query)) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        });

        // 카테고리 탭 바뀔 때 검색어 초기화 (편의성)
        categoryCards.forEach(card => {
            card.addEventListener('click', () => {
                searchInput.value = '';
                document.querySelectorAll('.collectible-item').forEach(item => item.style.display = 'flex');
            });
        });
    }

    // --- 6. Reset Data --- //
    const resetBtn = document.getElementById('resetBtn');
    if(resetBtn) {
        resetBtn.addEventListener('click', () => {
            if(confirm("정말로 모든 수집 도감 데이터를 초기화하시겠습니까? 이 작업은 복구할 수 없습니다.")) {
                window.ChecklistCore.clear();
                syncDOMWithStorage();
            }
        });
    }
});
