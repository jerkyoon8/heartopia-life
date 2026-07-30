(function () {
    'use strict';

    const ASIA_SERVER_ZONE = 'Asia/Seoul';
    const EMPTY_LOCATION = '위치 정보 없음';
    const RETRY_DELAY_MS = 60 * 1000;
    let refreshTimer = null;

    document.addEventListener('DOMContentLoaded', () => {
        const root = document.getElementById('headerDailyResourceLocations');
        if (!root) return;

        const fluorite = document.getElementById('headerFluoriteLocation');
        const oak = document.getElementById('headerOakLocation');

        function render(data) {
            fluorite.textContent = data && data.fluoriteLocation
                ? data.fluoriteLocation
                : EMPTY_LOCATION;
            oak.textContent = data && data.oakLocation
                ? data.oakLocation
                : EMPTY_LOCATION;
        }

        function asiaWallClock(date) {
            const formatter = new Intl.DateTimeFormat('en-CA', {
                timeZone: ASIA_SERVER_ZONE,
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hourCycle: 'h23'
            });
            const parts = Object.fromEntries(
                formatter.formatToParts(date)
                    .filter(part => part.type !== 'literal')
                    .map(part => [part.type, Number(part.value)])
            );
            return new Date(Date.UTC(
                parts.year,
                parts.month - 1,
                parts.day,
                parts.hour,
                parts.minute,
                parts.second
            ));
        }

        function millisecondsUntilNextBoundary(serverTime) {
            const asiaNow = asiaWallClock(new Date(serverTime));
            const nextBoundary = new Date(asiaNow);
            nextBoundary.setUTCHours(6, 0, 0, 0);
            if (nextBoundary <= asiaNow) {
                nextBoundary.setUTCDate(nextBoundary.getUTCDate() + 1);
            }
            return Math.max(1000, nextBoundary.getTime() - asiaNow.getTime() + 1000);
        }

        function scheduleRefresh(serverTime) {
            window.clearTimeout(refreshTimer);
            refreshTimer = window.setTimeout(loadCurrent, millisecondsUntilNextBoundary(serverTime));
        }

        async function loadCurrent() {
            try {
                const response = await fetch('/api/daily-resource-locations/current', {
                    headers: { Accept: 'application/json' },
                    cache: 'no-store'
                });
                if (!response.ok) throw new Error('daily resource location request failed');
                const data = await response.json();
                render(data);
                scheduleRefresh(data.serverTime);
            } catch (error) {
                render(null);
                window.clearTimeout(refreshTimer);
                refreshTimer = window.setTimeout(loadCurrent, RETRY_DELAY_MS);
            }
        }

        document.addEventListener('visibilitychange', () => {
            if (document.visibilityState === 'visible') {
                loadCurrent();
            }
        });

        loadCurrent();
    });
})();
