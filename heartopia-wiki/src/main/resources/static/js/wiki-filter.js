/**
 * WikiFilter.js
 * Generic Class for Client-Side Filtering, Sorting, and View Toggle in Heartopia Wiki
 */
const WIKI_GENERAL_EVENT_VALUE = '__general__';

function wikiMatchesEventSelection(itemValue, selectedValues) {
    const normalizedItem = String(itemValue || '').trim();
    const selected = new Set(Array.from(selectedValues || [], value => String(value || '').trim()));
    return normalizedItem
        ? selected.has(normalizedItem)
        : selected.has(WIKI_GENERAL_EVENT_VALUE);
}

function wikiBuildQuickOnlySelection(selectedValues, quickValues, enabled) {
    const selected = Array.from(new Set(Array.from(selectedValues || [], value => String(value || '').trim())
        .filter(Boolean)));
    if (!enabled) {
        return { applied: true, values: [WIKI_GENERAL_EVENT_VALUE, ...selected.filter(value => value !== WIKI_GENERAL_EVENT_VALUE)] };
    }

    const quick = new Set(Array.from(quickValues || [], value => String(value || '').trim()).filter(Boolean));
    const targets = selected.filter(value => value !== WIKI_GENERAL_EVENT_VALUE && quick.has(value));
    return targets.length > 0
        ? { applied: true, values: targets }
        : { applied: false, values: selected };
}

function wikiDeriveQuickFilterState(selectedValues, quickValues) {
    const selected = Array.from(new Set(Array.from(selectedValues || [], value => String(value || '').trim())
        .filter(Boolean)));
    const quick = new Set(Array.from(quickValues || [], value => String(value || '').trim()).filter(Boolean));
    const selectedEvents = selected.filter(value => value !== WIKI_GENERAL_EVENT_VALUE);
    const selectedQuick = selectedEvents.filter(value => quick.has(value));
    return {
        selectedQuick,
        quickOnly: selectedEvents.length > 0
            && !selected.includes(WIKI_GENERAL_EVENT_VALUE)
            && selectedEvents.length === selectedQuick.length
    };
}

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
                if (f.type === 'event-multi') {
                    this.filterElements.push(this.initEventMultiFilter(el, f));
                } else if (f.type === 'multi') {
                    // 다중 선택 필터 객체화
                    const filterObj = {
                        element: el,
                        key: f.dataKey,
                        type: 'multi',
                        allLabel: f.allLabel || '모든 레벨',
                        valuePrefix: f.valuePrefix || 'Lv.',
                        trigger: el.querySelector('.multi-select-trigger'),
                        dropdown: el.querySelector('.multi-select-dropdown'),
                        allCheckbox: el.querySelector('input[type="checkbox"][value="all"]'),
                        checkboxes: Array.from(el.querySelectorAll('input[type="checkbox"]:not([value="all"])')),
                        getCheckedValues: function() {
                            if (this.allCheckbox && this.allCheckbox.checked) return [];
                            return this.checkboxes.filter(cb => cb.checked).map(cb => cb.value);
                        }
                    };
                    this.filterElements.push(filterObj);

                    const updateTriggerText = () => {
                        const checkedList = filterObj.getCheckedValues();
                        const labelSpan = filterObj.trigger ? filterObj.trigger.querySelector('.trigger-label') : null;
                        if (labelSpan) {
                            if (checkedList.length === 0) {
                                labelSpan.textContent = filterObj.allLabel;
                            } else if (checkedList.length <= 2) {
                                labelSpan.textContent = checkedList.map(v => filterObj.valuePrefix + v).join(', ');
                            } else {
                                labelSpan.textContent = checkedList.length + '개 선택';
                            }
                        }
                    };

                    if (filterObj.trigger && filterObj.dropdown) {
                        filterObj.trigger.addEventListener('click', (e) => {
                            e.stopPropagation();
                            this.filterElements.forEach(other => {
                                if ((other.type === 'multi' || other.type === 'event-multi')
                                        && other.element.id !== f.id && other.dropdown) {
                                    other.dropdown.classList.remove('show');
                                    other.trigger?.setAttribute('aria-expanded', 'false');
                                }
                            });
                            filterObj.dropdown.classList.toggle('show');
                        });
                    }

                    if (filterObj.allCheckbox) {
                        filterObj.allCheckbox.addEventListener('change', () => {
                            if (filterObj.allCheckbox.checked) {
                                filterObj.checkboxes.forEach(cb => cb.checked = false);
                            } else {
                                filterObj.allCheckbox.checked = true;
                            }
                            updateTriggerText();
                            this.applyFilter();
                        });
                    }

                    filterObj.checkboxes.forEach(cb => {
                        cb.addEventListener('change', () => {
                            if (cb.checked) {
                                if (filterObj.allCheckbox) filterObj.allCheckbox.checked = false;
                            } else {
                                const checkedCount = filterObj.checkboxes.filter(c => c.checked).length;
                                if (checkedCount === 0 && filterObj.allCheckbox) {
                                    filterObj.allCheckbox.checked = true;
                                }
                            }
                            updateTriggerText();
                            this.applyFilter();
                        });
                    });
                } else {
                    // 기존 단일 선택 필터 객체화
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
        this._onHideMasteryRequirementChanged = () => {
            if (this.hideCollectedBtn && this.hideCollectedBtn.checked) {
                this.applyFilter();
            }
        };
        window.addEventListener('heartopia:hide-mastery-requirement-changed', this._onHideMasteryRequirementChanged);

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

        // 전역 클릭 이벤트 (다중 선택 드롭다운 외부 클릭 시 닫기)
        document.addEventListener('click', (e) => {
            this.filterElements.forEach(f => {
                if ((f.type === 'multi' || f.type === 'event-multi')
                        && f.dropdown && !f.element.contains(e.target)) {
                    f.dropdown.classList.remove('show');
                    f.trigger?.setAttribute('aria-expanded', 'false');
                }
            });
        });

        this.applyFilter();
    }

    initEventMultiFilter(element, config) {
        const trigger = element.querySelector('.multi-select-trigger');
        const dropdown = element.querySelector('.multi-select-dropdown');
        const generalContainer = element.querySelector('.event-general-options');
        const currentContainer = element.querySelector('.event-current-options');
        const pastContainer = element.querySelector('.event-past-options');
        const currentSection = element.querySelector('.event-current-section');
        const pastSection = element.querySelector('.event-past-section');
        const emptyState = element.querySelector('.event-filter-empty');
        const currentValues = new Set(Array.from(element.querySelectorAll('.current-event-value'))
            .map(input => input.value.trim())
            .filter(Boolean));
        const quickValues = Array.from(new Set(Array.from(element.querySelectorAll('.quick-event-value'))
            .map(input => input.value.trim())
            .filter(Boolean)));
        const availableValues = Array.from(new Set(this.items
            .map(item => String(item.dataset[config.dataKey] || '').trim())
            .filter(Boolean)))
            .sort((a, b) => a.localeCompare(b, 'ko'));
        const availableValueSet = new Set(availableValues);
        const missingCurrentValues = Array.from(currentValues)
            .filter(eventName => !availableValueSet.has(eventName))
            .sort((a, b) => a.localeCompare(b, 'ko'));
        const overrides = this.readEventOverrides();

        const createOption = (
            eventName,
            defaultChecked,
            unavailable = false,
            labelText = eventName,
            showCurrentBadge = defaultChecked
        ) => {
            const option = document.createElement('div');
            option.className = 'dropdown-opt event-dropdown-opt';

            const label = document.createElement('label');
            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.value = eventName;
            checkbox.dataset.defaultChecked = String(defaultChecked);
            checkbox.disabled = unavailable;
            checkbox.checked = unavailable
                ? false
                : (Object.prototype.hasOwnProperty.call(overrides, eventName)
                    ? overrides[eventName] === true
                    : defaultChecked);

            const text = document.createElement('span');
            text.textContent = labelText;
            label.append(checkbox, text);
            if (showCurrentBadge) {
                const badge = document.createElement('small');
                badge.className = 'event-current-badge';
                badge.textContent = '진행 중';
                label.appendChild(badge);
            }
            if (unavailable) {
                const note = document.createElement('small');
                note.className = 'event-unavailable-note';
                note.textContent = '이 도감에 항목 없음';
                label.appendChild(note);
            }
            option.appendChild(label);
            return option;
        };

        const hasGeneralItems = this.items.some(item => !String(item.dataset[config.dataKey] || '').trim());
        generalContainer?.appendChild(createOption(
            WIKI_GENERAL_EVENT_VALUE,
            true,
            !hasGeneralItems,
            '일반',
            false));

        availableValues.forEach(eventName => {
            const current = currentValues.has(eventName);
            const option = createOption(eventName, current);
            (current ? currentContainer : pastContainer)?.appendChild(option);
        });
        missingCurrentValues.forEach(eventName => {
            currentContainer?.appendChild(createOption(eventName, true, true));
        });

        if (currentSection) {
            currentSection.hidden = !availableValues.some(value => currentValues.has(value))
                && missingCurrentValues.length === 0;
        }
        if (pastSection) pastSection.hidden = !availableValues.some(value => !currentValues.has(value));
        if (emptyState) emptyState.hidden = availableValues.length > 0 || missingCurrentValues.length > 0;
        element.classList.toggle('event-filter-unavailable', availableValues.length === 0);

        const filterObj = {
            element,
            key: config.dataKey,
            type: 'event-multi',
            trigger,
            dropdown,
            checkboxes: Array.from(element.querySelectorAll('.event-dropdown-opt input[type="checkbox"]')),
            getCheckedValues() {
                return this.checkboxes.filter(checkbox => checkbox.checked).map(checkbox => checkbox.value);
            }
        };

        const updateTriggerText = () => {
            const checked = filterObj.getCheckedValues();
            const displayValues = checked.map(value => value === WIKI_GENERAL_EVENT_VALUE ? '일반' : value);
            const label = trigger?.querySelector('.trigger-label');
            if (!label) return;
            if (checked.length === 0) {
                label.textContent = availableValues.length === 0 && !hasGeneralItems ? '이벤트 항목 없음' : '이벤트 선택';
            } else if (checked.length === 1) {
                label.textContent = displayValues[0];
            } else {
                label.textContent = checked.length + '개 선택';
            }
        };

        const quickFilter = document.getElementById('quickEventFilter');
        const quickToggle = quickFilter?.querySelector('#quickEventOnlyToggle');
        const quickTrigger = quickFilter?.querySelector('#quickEventTrigger');
        const quickDropdown = quickFilter?.querySelector('#quickEventDropdown');
        const quickOptions = quickFilter?.querySelector('.quick-event-options');
        const quickEmpty = quickFilter?.querySelector('.quick-event-empty');
        const checkboxByValue = new Map(filterObj.checkboxes.map(checkbox => [checkbox.value, checkbox]));

        const createQuickOption = eventName => {
            const option = document.createElement('div');
            option.className = 'dropdown-opt quick-event-option';
            const label = document.createElement('label');
            const checkbox = document.createElement('input');
            const detailCheckbox = checkboxByValue.get(eventName);
            checkbox.type = 'checkbox';
            checkbox.value = eventName;
            checkbox.disabled = !detailCheckbox || detailCheckbox.disabled;
            checkbox.checked = Boolean(detailCheckbox?.checked && !detailCheckbox.disabled);
            const text = document.createElement('span');
            text.textContent = eventName;
            label.append(checkbox, text);
            if (checkbox.disabled) {
                const note = document.createElement('small');
                note.className = 'event-unavailable-note';
                note.textContent = '이 도감에 항목 없음';
                label.appendChild(note);
            }
            option.appendChild(label);
            return option;
        };

        quickValues.forEach(eventName => quickOptions?.appendChild(createQuickOption(eventName)));
        const quickCheckboxes = Array.from(quickFilter?.querySelectorAll('.quick-event-option input[type="checkbox"]') || []);
        if (quickEmpty) quickEmpty.hidden = quickValues.length > 0;

        const persistCheckbox = checkbox => {
            if (!checkbox || checkbox.disabled) return;
            const defaultChecked = checkbox.dataset.defaultChecked === 'true';
            const savedOverrides = this.readEventOverrides();
            if (checkbox.checked === defaultChecked) {
                delete savedOverrides[checkbox.value];
            } else {
                savedOverrides[checkbox.value] = checkbox.checked;
            }
            this.writeEventOverrides(savedOverrides);
        };

        const syncQuickFilter = () => {
            const checkedValues = filterObj.getCheckedValues();
            quickCheckboxes.forEach(checkbox => {
                const detailCheckbox = checkboxByValue.get(checkbox.value);
                checkbox.checked = Boolean(detailCheckbox?.checked && !detailCheckbox.disabled);
            });
            const quickState = wikiDeriveQuickFilterState(checkedValues, quickValues);
            if (quickToggle) quickToggle.checked = quickState.quickOnly;

            const label = quickTrigger?.querySelector('.trigger-label');
            if (label) {
                label.textContent = quickState.selectedQuick.length === 0
                    ? '이벤트 선택'
                    : quickState.selectedQuick.length === 1
                        ? quickState.selectedQuick[0]
                        : quickState.selectedQuick.length + '개 이벤트';
            }
        };

        const refreshEventUi = () => {
            updateTriggerText();
            syncQuickFilter();
        };

        filterObj.checkboxes.forEach(checkbox => {
            const defaultChecked = checkbox.dataset.defaultChecked === 'true';
            if (Object.prototype.hasOwnProperty.call(overrides, checkbox.value)
                    && overrides[checkbox.value] === defaultChecked) {
                delete overrides[checkbox.value];
            }
            checkbox.addEventListener('change', () => {
                persistCheckbox(checkbox);
                refreshEventUi();
                this.applyFilter();
            });
        });
        this.writeEventOverrides(overrides);

        filterObj.resetToDefaults = () => {
            filterObj.checkboxes.forEach(checkbox => {
                checkbox.checked = checkbox.dataset.defaultChecked === 'true';
            });
            refreshEventUi();
        };

        quickCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', () => {
                const detailCheckbox = checkboxByValue.get(checkbox.value);
                if (!detailCheckbox || detailCheckbox.disabled) return;
                detailCheckbox.checked = checkbox.checked;
                persistCheckbox(detailCheckbox);
                if (quickToggle?.checked && !quickCheckboxes.some(candidate => candidate.checked)) {
                    const generalCheckbox = checkboxByValue.get(WIKI_GENERAL_EVENT_VALUE);
                    if (generalCheckbox && !generalCheckbox.disabled) {
                        generalCheckbox.checked = true;
                        persistCheckbox(generalCheckbox);
                    }
                }
                refreshEventUi();
                this.applyFilter();
            });
        });

        quickToggle?.addEventListener('change', () => {
            const transition = wikiBuildQuickOnlySelection(
                filterObj.getCheckedValues(),
                quickValues,
                quickToggle.checked);
            if (!transition.applied) {
                quickToggle.checked = false;
                quickDropdown?.classList.add('show');
                quickTrigger?.setAttribute('aria-expanded', 'true');
                return;
            }
            const nextValues = new Set(transition.values);
            filterObj.checkboxes.forEach(checkbox => {
                if (!checkbox.disabled) {
                    checkbox.checked = nextValues.has(checkbox.value);
                    persistCheckbox(checkbox);
                }
            });
            refreshEventUi();
            this.applyFilter();
        });

        if (quickTrigger && quickDropdown) {
            const toggleQuickDropdown = event => {
                event.stopPropagation();
                dropdown?.classList.remove('show');
                trigger?.setAttribute('aria-expanded', 'false');
                const open = quickDropdown.classList.toggle('show');
                quickTrigger.setAttribute('aria-expanded', String(open));
            };
            quickTrigger.addEventListener('click', toggleQuickDropdown);
            quickTrigger.addEventListener('keydown', event => {
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    toggleQuickDropdown(event);
                }
            });
            document.addEventListener('click', event => {
                if (!quickFilter.contains(event.target)) {
                    quickDropdown.classList.remove('show');
                    quickTrigger.setAttribute('aria-expanded', 'false');
                }
            });
        }

        if (trigger && dropdown) {
            trigger.addEventListener('click', event => {
                event.stopPropagation();
                this.filterElements.forEach(other => {
                    if ((other.type === 'multi' || other.type === 'event-multi')
                            && other.element !== element && other.dropdown) {
                        other.dropdown.classList.remove('show');
                        other.trigger?.setAttribute('aria-expanded', 'false');
                    }
                });
                const open = dropdown.classList.toggle('show');
                quickDropdown?.classList.remove('show');
                quickTrigger?.setAttribute('aria-expanded', 'false');
                trigger.setAttribute('aria-expanded', String(open));
            });
            trigger.addEventListener('keydown', event => {
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    trigger.click();
                }
            });
        }

        refreshEventUi();
        return filterObj;
    }

    readEventOverrides() {
        try {
            const parsed = JSON.parse(localStorage.getItem('wikiEventFilterOverrides') || '{}');
            return parsed && typeof parsed === 'object' && !Array.isArray(parsed) ? parsed : {};
        } catch (error) {
            return {};
        }
    }

    writeEventOverrides(overrides) {
        try {
            if (Object.keys(overrides).length === 0) {
                localStorage.removeItem('wikiEventFilterOverrides');
            } else {
                localStorage.setItem('wikiEventFilterOverrides', JSON.stringify(overrides));
            }
        } catch (error) {
            // 저장소 접근이 막혀도 현재 페이지 필터는 계속 동작한다.
        }
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
                if (f.type === 'event-multi') {
                    const itemValue = String(element.dataset[f.key] || '').trim();
                    if (!wikiMatchesEventSelection(itemValue, f.getCheckedValues())) {
                        isMatch = false;
                    }
                } else if (f.type === 'multi') {
                    const checkedValues = f.getCheckedValues();
                    if (checkedValues.length > 0) {
                        const itemValue = String(element.dataset[f.key] || '').trim();
                        // 다중 선택 정밀 매칭
                        if (!checkedValues.includes(itemValue)) {
                            isMatch = false;
                        }
                    }
                } else {
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
                }

                if (!isMatch) break;
            }
        }

        // 3. Hide Collected Filter (with N★ threshold modifier from settings)
        if (isMatch && this.hideCollectedBtn && this.hideCollectedBtn.checked) {
            const rawThreshold = localStorage.getItem('wikiHideThreshold');
            const threshold = rawThreshold === null ? 0 : parseInt(rawThreshold, 10);
            const syncKey = element.dataset.syncKey;
            const checklistValue = syncKey && typeof window.ChecklistCore !== 'undefined'
                ? window.ChecklistCore.getItem(syncKey)
                : undefined;
            const isCollected = element.classList.contains('checked')
                || (checklistValue !== undefined && checklistValue !== null);
            let shouldHideCollected = false;

            if (threshold === 0) {
                // 기본: 수집된 모든 항목(별점 무관) 숨김 — 기존 동작과 동일
                shouldHideCollected = isCollected;
            } else {
                // N★ 이상만 숨김 (체크만 한 0★ 항목은 보임)
                shouldHideCollected = typeof checklistValue === 'number' && checklistValue >= threshold;
            }

            if (shouldHideCollected && this._matchesMasteryHideRequirement(element, syncKey)) {
                isMatch = false;
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

    _matchesMasteryHideRequirement(element, syncKey) {
        if (localStorage.getItem('wikiRequireMasteryForHide') !== 'true') {
            return true;
        }

        const hasMastery = element.dataset.hasMastery === 'true'
            || element.querySelector('.sync-mastery-btn:not(.disabled)[aria-disabled="false"]') !== null;
        if (!hasMastery) {
            return true;
        }

        if (!syncKey || typeof window.ChecklistCore === 'undefined') {
            return element.classList.contains('mastered');
        }

        const masteryValue = window.ChecklistCore.getItem('mastery_' + syncKey);
        return element.classList.contains('mastered')
            || (masteryValue !== undefined && masteryValue !== null);
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
            if (f.type === 'event-multi') {
                this.writeEventOverrides({});
                f.resetToDefaults();
            } else if (f.type === 'multi') {
                if (f.allCheckbox) f.allCheckbox.checked = true;
                f.checkboxes.forEach(cb => cb.checked = false);
                const labelSpan = f.trigger ? f.trigger.querySelector('.trigger-label') : null;
                if (labelSpan) labelSpan.textContent = f.allLabel || '모든 레벨';
            } else {
                f.element.value = 'all';
                // Clear dependent child options and disable
                if (f.parentFilter) {
                    while (f.element.options.length > 1) f.element.remove(1);
                    f.element.disabled = true;
                    if (f.wrapper) f.wrapper.classList.add('filter-disabled');
                }
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

if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        WIKI_GENERAL_EVENT_VALUE,
        wikiMatchesEventSelection,
        wikiBuildQuickOnlySelection,
        wikiDeriveQuickFilterState
    };
}
