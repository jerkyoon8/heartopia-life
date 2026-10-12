(() => {
    const search = document.getElementById('pumpkinSearch');
    const filters = ['Level', 'Size', 'Part'].map(key => document.getElementById('pumpkin' + key));
    const cards = [...document.querySelectorAll('.pumpkin-card')];
    function apply() {
        const query = search.value.trim().toLocaleLowerCase('ko');
        let visible = 0;
        for (const card of cards) {
            const match = card.dataset.name.toLocaleLowerCase('ko').includes(query)
                && filters.every((filter, index) => filter.value === 'all' || card.dataset[['level', 'size', 'part'][index]] === filter.value);
            card.hidden = !match;
            if (match) visible++;
        }
        document.getElementById('pumpkinCount').textContent = visible + ' / ' + cards.length + '종';
        document.getElementById('pumpkinEmpty').hidden = visible !== 0;
    }
    search.addEventListener('input', apply);
    filters.forEach(filter => filter.addEventListener('change', apply));
    document.getElementById('pumpkinReset').addEventListener('click', () => {
        search.value = '';
        filters.forEach(filter => { filter.value = 'all'; });
        apply();
    });
    apply();
})();
