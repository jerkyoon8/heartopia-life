/**
 * WikiFilter.js
 * Generic Class for Client-Side Filtering, Sorting, and View Toggle in Heartopia Wiki
 */
class WikiFilter {
    constructor(config) {
        this.config = Object.assign({
            gridId: 'wikiGrid',
            tableId: 'wikiTable',
            itemSelector: '.wiki-item-card',
            tableRowSelector: '.wiki-table-row',
            searchId: 'searchInput',
            sortGroupId: 'sortGroup',
            viewToggleId: 'viewToggle',
            resetId: 'resetBtn',
            noResultsId: 'noResults',
            viewStorageKey: 'wikiViewMode',
            filters: []
        }, config);

        this.currentSort = {
            key: 'default',
            order: 'asc'
        };

        this.currentView = 'card';

        this.init();
    }

    init() {
        this.grid = document.getElementById(this.config.gridId);
        if (!this.grid) return;

        this.items = Array.from(this.grid.querySelectorAll(this.config.itemSelector));
        this.noResults = document.getElementById(this.config.noResultsId);

        // Table elements
        this.tableContainer = document.getElementById(this.config.tableId);
        if (this.tableContainer) {
            this.tableRows = Array.from(this.tableContainer.querySelectorAll(this.config.tableRowSelector));
        } else {
            this.tableRows = [];
        }

        // Inputs
        this.searchInput = document.getElementById(this.config.searchId);
        this.resetBtn = document.getElementById(this.config.resetId);
        this.sortGroup = document.getElementById(this.config.sortGroupId);

        // Initialize Custom Filters
        this.filterElements = [];
        this.config.filters.forEach(f => {
            const el = document.getElementById(f.id);
            if (el) {
                this.filterElements.push({
                    element: el,
                    key: f.dataKey,
                    parentFilter: f.parentFilter || null,
                    parentKey: f.parentKey || null,
                    wrapper: f.wrapperId ? document.getElementById(f.wrapperId) : null,
                    autoPopulate: !!f.autoPopulate
                });

                if (f.autoPopulate && !f.parentFilter) {
                    this.populateOptions(el, f.dataKey);
                }

                el.addEventListener('change', () => this.applyFilter());
            }
        });

        // Setup parent->child dependent dropdowns (disabled-toggle style)
        this.filterElements.forEach(child => {
            if (!child.parentFilter) return;
            const parent = this.filterElements.find(p => p.element.id === child.parentFilter);
            if (!parent) return;

            const setChildDisabled = (disabled) => {
                child.element.disabled = disabled;
                if (child.wrapper) {
                    child.wrapper.classList.toggle('filter-disabled', disabled);
                }
            };

            const refreshChild = () => {
                const parentVal = parent.element.value;
                if (parentVal === 'all') {
                    child.element.value = 'all';
                    while (child.element.options.length > 1) child.element.remove(1);
                    setChildDisabled(true);
                } else {
                    const values = new Set();
                    this.items.forEach(item => {
                        const pv = item.dataset[parent.key];
                        const cv = item.dataset[child.key];
                        if (pv === parentVal && cv && cv !== '-' && cv !== '') {
                            values.add(cv);
                        }
                    });
                    const sorted = Array.from(values).sort();
                    const prevVal = child.element.value;
                    while (child.element.options.length > 1) child.element.remove(1);
                    sorted.forEach(v => {
                        const opt = document.createElement('option');
                        opt.value = v;
                        opt.textContent = v;
                        child.element.appendChild(opt);
                    });
                    if (prevVal !== 'all' && sorted.includes(prevVal)) {
                        child.element.value = prevVal;
                    } else {
                        child.element.value = 'all';
                    }
                    setChildDisabled(sorted.length === 0);
                }
            };

            parent.element.addEventListener('change', () => {
                refreshChild();
                this.applyFilter();
            });
            refreshChild();
        });

        // Event Listeners
        if (this.searchInput) {
            this.searchInput.addEventListener('input', () => this.applyFilter());
        }

        if (this.sortGroup) {
            this.sortButtons = this.sortGroup.querySelectorAll('.sort-chip');
            this.sortButtons.forEach(btn => {
                btn.addEventListener('click', (e) => this.handleSortClick(e.currentTarget));
            });
        }

        if (this.resetBtn) {
            this.resetBtn.addEventListener('click', () => this.reset());
        }

        // New Toggle Listeners
        this.hideCollectedBtn = document.getElementById('btn-hide-collected');
        if (this.hideCollectedBtn) {
            const savedHide = localStorage.getItem('wikiHideCollected');
            if (savedHide === 'true') {
                this.hideCollectedBtn.checked = true;
                // 저장된 상태를 페이지 로드 시 즉시 적용
                setTimeout(() => this.applyFilter(), 0);
            }
            this.hideCollectedBtn.addEventListener('change', () => {
                localStorage.setItem('wikiHideCollected', this.hideCollectedBtn.checked);
                this.applyFilter();
            });
        }

        // ChecklistCore Subscribe for auto-hide
        if (typeof window.ChecklistCore !== 'undefined') {
            window.ChecklistCore.subscribe(() => {
                if (this.hideCollectedBtn && this.hideCollectedBtn.checked) {
                    setTimeout(() => this.applyFilter(), 10);
                }
            });
        }

        // 설정 드롭다운에서 N★ 임계값 변경 시 즉시 재필터링
        this._onHideThresholdChanged = () => {
            if (this.hideCollectedBtn && this.hideCollectedBtn.checked) {
                this.applyFilter();
            }
        };
        window.addEventListener('heartopia:hide-threshold-changed', this._onHideThresholdChanged);

        // Time Filter setup
        this.timeStartFilter = document.getElementById('timeStartFilter');
        this.timeEndFilter = document.getElementById('timeEndFilter');
        this.includeAlwaysBtn = document.getElementById('btn-include-always');
        
        if (this.timeStartFilter && this.timeEndFilter) {
            const applyTimeFilter = () => this.applyFilter();
            this.timeStartFilter.addEventListener('change', applyTimeFilter);
            this.timeEndFilter.addEventListener('change', applyTimeFilter);
            if (this.includeAlwaysBtn) {
                this.includeAlwaysBtn.addEventListener('change', applyTimeFilter);
            }
        }

        // View Toggle
        this.initViewToggle();
    }

    initViewToggle() {
        const viewToggle = document.getElementById(this.config.viewToggleId);
        if (!viewToggle) return;

        this.viewButtons = viewToggle.querySelectorAll('.view-toggle-btn');

        // Restore saved view preference
        const savedView = localStorage.getItem(this.config.viewStorageKey);
        if (savedView && (savedView === 'card' || savedView === 'table')) {
            this.switchView(savedView);
        }

        this.viewButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                const viewMode = btn.dataset.view;
                this.switchView(viewMode);
            });
        });
    }

    switchView(mode) {
        this.currentView = mode;
        localStorage.setItem(this.config.viewStorageKey, mode);

        // Update button states
        if (this.viewButtons) {
            this.viewButtons.forEach(btn => {
                btn.classList.toggle('active', btn.dataset.view === mode);
            });
        }

        // Toggle grid/table visibility
        if (mode === 'table' && this.tableContainer) {
            this.grid.classList.add('hidden');
            this.tableContainer.classList.add('active');
        } else {
            this.grid.classList.remove('hidden');
            if (this.tableContainer) {
                this.tableContainer.classList.remove('active');
            }
        }
    }

    populateOptions(selectElement, dataKey) {
        const values = new Set();
        this.items.forEach(item => {
            const val = item.dataset[dataKey];
            if (val && val !== '-' && val !== '') {
                values.add(val);
            }
        });

        const sortedValues = Array.from(values).sort();

        while (selectElement.options.length > 1) {
            selectElement.remove(1);
        }

        sortedValues.forEach(val => {
            const option = document.createElement('option');
            option.value = val;
            option.textContent = val;
            selectElement.appendChild(option);
        });
    }

    handleSortClick(clickedBtn) {
        const sortKey = clickedBtn.dataset.sort;
        let newOrder = 'asc';

        if (this.currentSort.key === sortKey) {
            newOrder = this.currentSort.order === 'asc' ? 'desc' : 'asc';
        } else {
            if (sortKey === 'price') {
                newOrder = 'desc';
            } else {
                newOrder = 'asc';
            }
        }

        this.currentSort = { key: sortKey, order: newOrder };
        this.updateSortUI();
        this.applySort();
    }

    updateSortUI() {
        if (!this.sortButtons) return;

        this.sortButtons.forEach(btn => {
            const key = btn.dataset.sort;

            btn.classList.remove('active');
            
            // Remove only the dynamically added directional arrow, not original icons
            const dynamicArrow = btn.querySelector('.sort-dir-arrow');
            if (dynamicArrow) dynamicArrow.remove();

            if (key === this.currentSort.key) {
                btn.classList.add('active');

                const newIcon = document.createElement('i');
                newIcon.className = this.currentSort.order === 'asc'
                    ? 'fas fa-arrow-up sort-dir-arrow ms-1'
                    : 'fas fa-arrow-down sort-dir-arrow ms-1';
                btn.appendChild(newIcon);
            }
        });
    }

    applyFilter() {
        const searchText = this.searchInput ? this.searchInput.value.toLowerCase() : '';
        let visibleCount = 0;

        // Filter cards
        this.items.forEach(item => {
            const isMatch = this._matchesFilters(item, searchText);
            if (isMatch) {
                item.style.display = 'flex';
                visibleCount++;
            } else {
                item.style.display = 'none';
            }
        });

        // Filter table rows (sync with cards)
        this.tableRows.forEach(row => {
            const isMatch = this._matchesFilters(row, searchText);
            row.style.display = isMatch ? '' : 'none';
        });

        if (this.noResults) {
            this.noResults.style.display = visibleCount === 0 ? 'block' : 'none';
        }

        this.applySort();
    }

    _matchesFilters(element, searchText) {
        let isMatch = true;

        // 1. Search Text (Name)
        if (searchText) {
            const name = element.dataset.name ? element.dataset.name.toLowerCase() : '';
            if (!name.includes(searchText)) {
                isMatch = false;
            }
        }

        // 2. Custom Filters
        if (isMatch) {
            for (const f of this.filterElements) {
                const selectedValue = f.element.value;
                if (selectedValue === 'all') continue;

                const itemValue = element.dataset[f.key];

                if (f.key === 'level') {
                    if (parseInt(itemValue) !== parseInt(selectedValue)) {
                        isMatch = false;
                    }
                }
                else if (f.key === 'weather' && selectedValue === 'only-무지개') {
                    if (!itemValue || String(itemValue).trim() !== '무지개') {
                        isMatch = false;
                    }
                }
                else {
                    if (!itemValue || !String(itemValue).includes(selectedValue)) {
                        isMatch = false;
                    }
                }

                if (!isMatch) break;
            }
        }

        // 3. Hide Collected Filter (with N★ threshold modifier from settings)
        if (isMatch && this.hideCollectedBtn && this.hideCollectedBtn.checked) {
            const rawThreshold = localStorage.getItem('wikiHideThreshold');
            const threshold = rawThreshold === null ? 0 : parseInt(rawThreshold, 10);
            const syncKey = element.dataset.syncKey;

            if (threshold === 0) {
                // 기본: 수집된 모든 항목(별점 무관) 숨김 — 기존 동작과 동일
                if (element.classList.contains('checked')) {
                    isMatch = false;
                }
            } else if (syncKey && typeof window.ChecklistCore !== 'undefined') {
                // N★ 이상만 숨김 (체크만 한 0★ 항목은 보임)
                const val = window.ChecklistCore.getItem(syncKey);
                if (typeof val === 'number' && val >= threshold) {
                    isMatch = false;
                }
            }
        }

        // 4. Time Range Filter (Overlap Logic)
        if (isMatch && this.timeStartFilter && this.timeEndFilter) {
            const userStartStr = this.timeStartFilter.value;
            const userEndStr = this.timeEndFilter.value;

            if (userStartStr && userEndStr) {
                const itemTimeStr = String(element.dataset.time || '').trim();
                
                // If item time is "상시" or empty, handled by includeAlwaysBtn
                if (itemTimeStr === '상시' || itemTimeStr === '') {
                    if (this.includeAlwaysBtn && !this.includeAlwaysBtn.checked) {
                        isMatch = false;
                    }
                } else {
                    // Extract minutes
                    const [usH, usM] = userStartStr.split(':').map(Number);
                    const [ueH, ueM] = userEndStr.split(':').map(Number);
                    const uStart = usH * 60 + usM;
                    const uEnd = ueH * 60 + ueM;
                    const uCrossesMidnight = uEnd < uStart;

                    // Parse ALL ranges (e.g. "0~6 / 18~24" → 두 구간 모두 검사)
                    const rangeRegex = /(\d{1,2})[:시]?(\d{0,2})?\s*[~-]\s*(\d{1,2})[:시]?(\d{0,2})?/g;
                    const matches = [...itemTimeStr.matchAll(rangeRegex)];

                    if (matches.length > 0) {
                        const hasOverlap = (s1, e1, s2, e2) => Math.max(s1, s2) < Math.min(e1, e2);

                        const checkOverlap = (st1, en1, cross1, st2, en2, cross2) => {
                            const intervals1 = cross1 ? [[st1, 1440], [0, en1]] : [[st1, en1]];
                            const intervals2 = cross2 ? [[st2, 1440], [0, en2]] : [[st2, en2]];

                            for (const iv1 of intervals1) {
                                for (const iv2 of intervals2) {
                                    if (hasOverlap(iv1[0], iv1[1], iv2[0], iv2[1])) return true;
                                }
                            }
                            return false;
                        };

                        const anyMatch = matches.some(m => {
                            const iStart = parseInt(m[1]) * 60 + (parseInt(m[2]) || 0);
                            const iEnd = parseInt(m[3]) * 60 + (parseInt(m[4]) || 0);
                            const iCrossesMidnight = iEnd < iStart;
                            return checkOverlap(uStart, uEnd, uCrossesMidnight, iStart, iEnd, iCrossesMidnight);
                        });

                        if (!anyMatch) {
                            isMatch = false;
                        }
                    } else {
                        // Unparseable string not matching "상시" hides from range search
                        isMatch = false;
                    }
                }
            }
        }

        return isMatch;
    }

    applySort() {
        const { key, order } = this.currentSort;

        const sortFn = (a, b) => {
            const targetKey = key === 'default' ? 'id' : key;
            let valA = a.dataset[targetKey];
            let valB = b.dataset[targetKey];

            if (targetKey === 'id' || targetKey === 'level' || targetKey === 'price') {
                valA = parseInt(valA, 10) || 0;
                valB = parseInt(valB, 10) || 0;
                return order === 'asc' ? valA - valB : valB - valA;
            }

            valA = valA || '';
            valB = valB || '';
            return order === 'asc'
                ? valA.localeCompare(valB, 'ko')
                : valB.localeCompare(valA, 'ko');
        };

        // Sort cards
        this.items.sort(sortFn);
        this.items.forEach(item => {
            this.grid.insertBefore(item, this.noResults);
        });

        // Sort table rows
        if (this.tableRows.length > 0 && this.tableContainer) {
            const tbody = this.tableContainer.querySelector('tbody');
            if (tbody) {
                this.tableRows.sort(sortFn);
                this.tableRows.forEach(row => {
                    tbody.appendChild(row);
                });
            }
        }
    }

    reset() {
        if (this.searchInput) this.searchInput.value = '';

        this.filterElements.forEach(f => {
            f.element.value = 'all';
            // Clear dependent child options and disable
            if (f.parentFilter) {
                while (f.element.options.length > 1) f.element.remove(1);
                f.element.disabled = true;
                if (f.wrapper) f.wrapper.classList.add('filter-disabled');
            }
        });

        if (this.hideCollectedBtn) this.hideCollectedBtn.checked = false;
        if (this.timeStartFilter) this.timeStartFilter.value = '';
        if (this.timeEndFilter) this.timeEndFilter.value = '';
        if (this.includeAlwaysBtn) this.includeAlwaysBtn.checked = true;

        this.currentSort = { key: 'name', order: 'asc' };
        this.updateSortUI();

        this.applyFilter();
    }
}
