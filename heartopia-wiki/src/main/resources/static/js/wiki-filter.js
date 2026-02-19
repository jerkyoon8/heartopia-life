/**
 * WikiFilter.js
 * Generic Class for Client-Side Filtering and Sorting in Heartopia Wiki
 */
class WikiFilter {
    constructor(config) {
        this.config = Object.assign({
            gridId: 'wikiGrid',
            itemSelector: '.wiki-item-card',
            searchId: 'searchInput',
            sortGroupId: 'sortGroup', // Changed from sortId
            resetId: 'resetBtn',
            noResultsId: 'noResults',
            filters: [] // Array of { id: '...', dataKey: '...', autoPopulate: false }
        }, config);

        // Default Sort State
        this.currentSort = {
            key: 'name',
            order: 'asc'
        };

        this.init();
    }

    init() {
        this.grid = document.getElementById(this.config.gridId);
        if (!this.grid) return;

        this.items = Array.from(this.grid.querySelectorAll(this.config.itemSelector));
        this.noResults = document.getElementById(this.config.noResultsId);

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

                // Add Event Listener
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
    }

    populateOptions(selectElement, dataKey) {
        const values = new Set();
        this.items.forEach(item => {
            const val = item.dataset[dataKey];
            if (val && val !== '-' && val !== '') {
                values.add(val);
            }
        });

        const sortedValues = Array.from(values).sort(); // Basic sort for options

        // Custom sort for numeric strings if needed?
        // But usually locations/shadows are just strings. 

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

        // Toggle order if clicking the same key
        if (this.currentSort.key === sortKey) {
            newOrder = this.currentSort.order === 'asc' ? 'desc' : 'asc';
        } else {
            // Default order for new key
            // Price is usually high-to-low (desc) by default? Or low-to-high? 
            // User likely expects "High Price" first? 
            // Let's stick to 'desc' default for price, 'asc' for others.
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

            // Remove active class and icon
            btn.classList.remove('active');
            const icon = btn.querySelector('i');
            if (icon) icon.remove();

            // Set Active State
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

        this.items.forEach(item => {
            let isMatch = true;

            // 1. Search Text (Name)
            if (searchText) {
                const name = item.dataset.name ? item.dataset.name.toLowerCase() : '';
                if (!name.includes(searchText)) {
                    isMatch = false;
                }
            }

            // 2. Custom Filters
            if (isMatch) {
                for (const f of this.filterElements) {
                    const selectedValue = f.element.value;
                    if (selectedValue === 'all') continue;

                    const itemValue = item.dataset[f.key];

                    if (f.key === 'level' && selectedValue === '10') {
                        if (parseInt(itemValue) < 10) isMatch = false;
                    }
                    else {
                        const values = itemValue ? String(itemValue).split(/\s+/) : [];
                        if (!values.includes(selectedValue)) isMatch = false;
                    }

                    if (!isMatch) break;
                }
            }

            if (isMatch) {
                item.style.display = 'flex';
                visibleCount++;
            } else {
                item.style.display = 'none';
            }
        });

        if (this.noResults) {
            this.noResults.style.display = visibleCount === 0 ? 'block' : 'none';
        }

        // Re-apply sort because filtering might show hidden items, 
        // but DOM order is preserved so applySort isn't strictly needed unless we remove/add items.
        // However, applySort uses 'visibleItems' logic? No, it sorts everything or just reorders DOM.
        // Let's just re-sort to be safe/consistent.
        this.applySort();
    }

    applySort() {
        const { key, order } = this.currentSort;

        // We sort ALL items (to keep DOM consistent) but only visible ones matter for display
        // Actually sorting all items is better.

        this.items.sort((a, b) => {
            let valA = a.dataset[key];
            let valB = b.dataset[key];

            // Handle Numerics
            if (key === 'level' || key === 'price') {
                valA = parseInt(valA) || 0;
                valB = parseInt(valB) || 0;
                return order === 'asc' ? valA - valB : valB - valA;
            }

            // Handle Strings
            valA = valA || '';
            valB = valB || '';
            return order === 'asc'
                ? valA.localeCompare(valB, 'ko')
                : valB.localeCompare(valA, 'ko');
        });

        // Re-append to Grid
        // Appending moves them in DOM.
        this.items.forEach(item => {
            this.grid.insertBefore(item, this.noResults);
        });
    }

    reset() {
        if (this.searchInput) this.searchInput.value = '';

        this.filterElements.forEach(f => {
            f.element.value = 'all';
        });

        this.currentSort = { key: 'name', order: 'asc' };
        this.updateSortUI();

        this.applyFilter(); // This calls applySort at the end
    }
}
