(function () {
    'use strict';

    const WEATHER = {
        SUNNY: { label: '맑음', icon: '/images/weather/sunny.webp' },
        RAIN: { label: '비', icon: '/images/weather/rain.webp' },
        RAINBOW: { label: '무지개', icon: '/images/weather/rainbow.webp' },
        METEOR_SHOWER: { label: '유성우', icon: '/images/weather/meteor-shower.webp' },
        HEATWAVE: { label: '폭염', icon: '/images/weather/heatwave.webp' },
        SNOW: { label: '눈', emoji: '❄️' },
        AURORA: { label: '오로라', emoji: '🌌' }
    };
    const KOREAN_WEEKDAYS = ['일', '월', '화', '수', '목', '금', '토'];

    document.addEventListener('DOMContentLoaded', () => {
        const weatherButton = document.getElementById('headerWeatherButton');
        if (!weatherButton) return;

        const elements = {
            weatherButton,
            panel: document.getElementById('weatherForecastPanel'),
            panelClose: document.getElementById('weatherPanelClose'),
            serverDay: document.getElementById('headerServerDay'),
            serverTime: document.getElementById('headerServerTime'),
            headerIcon: document.getElementById('headerWeatherIcon'),
            headerText: document.getElementById('headerWeatherText'),
            detailList: document.getElementById('weatherDetailList'),
            dailyList: document.getElementById('weatherDailyList'),
            updatedText: document.getElementById('weatherUpdatedText')
        };

        const state = {
            forecast: null,
            serverBaseTime: null,
            receivedAt: 0,
            currentSlotKey: null,
            loading: false
        };

        function currentServerDate() {
            if (state.serverBaseTime) {
                return new Date(state.serverBaseTime.getTime() + (Date.now() - state.receivedAt));
            }
            return new Date();
        }

        function asiaParts(date) {
            const formatter = new Intl.DateTimeFormat('ko-KR', {
                timeZone: 'Asia/Seoul',
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                weekday: 'long',
                hour: '2-digit',
                minute: '2-digit',
                hourCycle: 'h23'
            });
            return Object.fromEntries(
                formatter.formatToParts(date)
                    .filter(part => part.type !== 'literal')
                    .map(part => [part.type, part.value])
            );
        }

        function updateClock() {
            const parts = asiaParts(currentServerDate());
            elements.serverDay.textContent = parts.weekday;
            elements.serverTime.textContent = `${parts.hour}:${parts.minute}`;

            const slotHour = Math.floor(Number(parts.hour) / 6) * 6;
            const slotKey = `${parts.year}-${parts.month}-${parts.day}:${slotHour}`;
            if (state.currentSlotKey && state.currentSlotKey !== slotKey && !state.loading) {
                loadForecast();
            }
            state.currentSlotKey = slotKey;
        }

        function weatherImage(code, className) {
            const weather = WEATHER[code];
            if (!weather) return '';
            if (weather.icon) {
                return `<img class="${className}" src="${weather.icon}" alt="">`;
            }
            return `<span class="${className}" aria-hidden="true">${weather.emoji}</span>`;
        }

        function resultPresentation(result) {
            if (!result || result.status === 'EMPTY') {
                return { label: '정보 없음', code: null, stateClass: 'is-empty' };
            }
            return {
                label: WEATHER[result.weatherCode]?.label || '정보 없음',
                code: result.weatherCode,
                stateClass: 'is-confirmed'
            };
        }

        function dateParts(dateString) {
            const [year, month, day] = dateString.split('-').map(Number);
            return {
                month,
                day,
                weekday: new Date(Date.UTC(year, month - 1, day)).getUTCDay()
            };
        }

        function dateBadge(dateString) {
            const parts = asiaParts(currentServerDate());
            const todayDate = new Date(Date.UTC(
                Number(parts.year),
                Number(parts.month) - 1,
                Number(parts.day)
            ));
            const today = todayDate.toISOString().slice(0, 10);
            todayDate.setUTCDate(todayDate.getUTCDate() + 1);
            const tomorrow = todayDate.toISOString().slice(0, 10);
            if (dateString === today) return '오늘';
            if (dateString === tomorrow) return '내일';
            const date = dateParts(dateString);
            return `${date.month}/${date.day}`;
        }

        function slotLabel(slotHour) {
            const endHour = slotHour === 18 ? 24 : slotHour + 6;
            return `${String(slotHour).padStart(2, '0')}–${String(endHour).padStart(2, '0')}시`;
        }

        function renderForecast() {
            const forecast = state.forecast;
            if (!forecast) return;

            const currentView = resultPresentation(forecast.detailSlots[0]?.result);
            elements.headerText.textContent = currentView.label;
            if (currentView.code) {
                const weather = WEATHER[currentView.code];
                if (weather.icon) {
                    elements.headerIcon.src = weather.icon;
                    elements.headerIcon.alt = '';
                    elements.headerIcon.hidden = false;
                } else {
                    elements.headerIcon.hidden = true;
                    elements.headerIcon.removeAttribute('src');
                }
            } else {
                elements.headerIcon.hidden = true;
                elements.headerIcon.removeAttribute('src');
            }

            elements.detailList.innerHTML = forecast.detailSlots.map(slot => {
                const view = resultPresentation(slot.result);
                return `
                    <article class="weather-detail-card ${view.stateClass}">
                        <div class="weather-detail-card__time">
                            <span>${dateBadge(slot.forecastDate)}</span>
                            <strong>${slotLabel(slot.slotHour)}</strong>
                        </div>
                        <div class="weather-detail-card__weather">
                            ${weatherImage(view.code, 'weather-detail-card__icon')}
                            <strong>${view.label}</strong>
                        </div>
                        <span>${view.code ? '관리자 예약' : '예약 없음'}</span>
                    </article>`;
            }).join('');

            elements.dailyList.innerHTML = forecast.dailyForecasts.map((day, index) => {
                const view = resultPresentation(day.result);
                const date = dateParts(day.forecastDate);
                return `
                    <article class="weather-day-card ${view.stateClass}">
                        <span>${index === 0 ? '내일' : KOREAN_WEEKDAYS[date.weekday]}</span>
                        <small>${date.month}/${date.day}</small>
                        ${weatherImage(view.code, 'weather-day-card__icon')}
                        <strong>${view.label}</strong>
                    </article>`;
            }).join('');

            const parsedServerTime = new Date(forecast.serverNow);
            elements.updatedText.textContent = Number.isNaN(parsedServerTime.getTime())
                ? '관리자가 예약한 날씨를 표시합니다.'
                : `${new Intl.DateTimeFormat('ko-KR', {
                    timeZone: 'Asia/Seoul',
                    hour: '2-digit',
                    minute: '2-digit',
                    hourCycle: 'h23'
                }).format(parsedServerTime)} 기준 · 관리자 예약 날씨`;
        }

        function showForecastError() {
            elements.headerIcon.hidden = true;
            elements.headerText.textContent = '정보 없음';
            elements.detailList.innerHTML = '<p class="weather-empty-message">날씨 정보를 불러오지 못했습니다.</p>';
            elements.dailyList.innerHTML = '';
            elements.updatedText.textContent = '잠시 후 다시 확인해 주세요.';
        }

        async function loadForecast() {
            if (state.loading) return;
            state.loading = true;
            try {
                const response = await fetch('/api/weather/forecast', {
                    headers: { Accept: 'application/json' }
                });
                if (!response.ok) throw new Error('forecast fetch failed');
                state.forecast = await response.json();
                state.serverBaseTime = new Date(state.forecast.serverNow);
                state.receivedAt = Date.now();
                renderForecast();
                updateClock();
            } catch (error) {
                showForecastError();
            } finally {
                state.loading = false;
            }
        }

        function setPanelOpen(open) {
            elements.panel.hidden = !open;
            elements.weatherButton.setAttribute('aria-expanded', open ? 'true' : 'false');
            document.getElementById('headerWeather')?.classList.toggle('is-open', open);
        }

        elements.weatherButton.addEventListener('click', event => {
            event.stopPropagation();
            setPanelOpen(elements.panel.hidden);
        });
        elements.panel.addEventListener('click', event => event.stopPropagation());
        elements.panelClose.addEventListener('click', () => setPanelOpen(false));

        document.addEventListener('click', () => setPanelOpen(false));
        document.addEventListener('keydown', event => {
            if (event.key === 'Escape' && !elements.panel.hidden) {
                setPanelOpen(false);
                elements.weatherButton.focus();
            }
        });

        updateClock();
        window.setInterval(updateClock, 1000);
        loadForecast();
    });
})();
