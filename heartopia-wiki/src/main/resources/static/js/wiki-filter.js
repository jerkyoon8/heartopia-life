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
            key: 'name',
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
                this.filterElements.push({ element: el, key: f.dataKey });

                if (f.autoPopulate) {
                    this.populateOptions(el, f.dataKey);
                }

                el.addEventListener('change', () => this.applyFilter());
            }
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
            const icon = btn.querySelector('i');
            if (icon) icon.remove();

            if (key === this.currentSort.key) {
                btn.classList.add('active');

                const newIcon = document.createElement('i');
                newIcon.className = this.currentSort.order === 'asc'
                    ? 'fas fa-arrow-up'
                    : 'fas fa-arrow-down';
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

                if (f.key === 'level' && selectedValue === '10') {
                    if (parseInt(itemValue) < 10) isMatch = false;
                }
                else {
                    if (!itemValue || !String(itemValue).includes(selectedValue)) {
                        isMatch = false;
                    }
                }

                if (!isMatch) break;
            }
        }

        return isMatch;
    }

    applySort() {
        const { key, order } = this.currentSort;

        const sortFn = (a, b) => {
            let valA = a.dataset[key];
            let valB = b.dataset[key];

            if (key === 'level' || key === 'price') {
                valA = parseInt(valA) || 0;
                valB = parseInt(valB) || 0;
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
        });

        this.currentSort = { key: 'name', order: 'asc' };
        this.updateSortUI();

        this.applyFilter();
    }
}
