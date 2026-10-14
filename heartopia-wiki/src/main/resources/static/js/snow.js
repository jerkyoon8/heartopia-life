function snowMatches(item, filters) {
    const weather = item.weather.split('|');
    return item.name.toLocaleLowerCase('ko').includes(filters.query.trim().toLocaleLowerCase('ko'))
        && (filters.level === 'all' || item.level === filters.level)
        && (filters.weather === 'all' || weather.includes('모든 날씨') || weather.includes(filters.weather));
}
if (typeof module !== 'undefined' && module.exports) module.exports = { snowMatches };
if (typeof document !== 'undefined') document.addEventListener('DOMContentLoaded', () => {
    const search = document.getElementById('snowSearch');
    const level = document.getElementById('snowLevel');
    const weather = document.getElementById('snowWeather');
    const cards = [...document.querySelectorAll('.snow-item')];
    function apply() {
        let count = 0;
        cards.forEach(card => {
            card.hidden = !snowMatches(card.dataset, { query:search.value, level:level.value, weather:weather.value });
            if (!card.hidden) count++;
        });
        document.getElementById('snowCount').textContent = count + ' / ' + cards.length + '종';
        document.getElementById('snowEmpty').hidden = count !== 0;
    }
    search.addEventListener('input', apply);
    level.addEventListener('change', apply);
    weather.addEventListener('change', apply);
    document.getElementById('snowReset').addEventListener('click', () => {
        search.value = ''; level.value = 'all'; weather.value = 'all'; apply();
    });
    document.getElementById('snowFilterToggle').addEventListener('click', event => {
        const expanded = document.getElementById('snowAdvancedFilters').classList.toggle('show');
        event.currentTarget.setAttribute('aria-expanded', String(expanded));
    });
    apply();
});
