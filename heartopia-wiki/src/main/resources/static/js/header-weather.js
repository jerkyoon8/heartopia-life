(function () {
    'use strict';

    const WEATHER = {
        SUNNY: { label: '맑음', icon: '/images/weather/sunny.webp' },
        RAIN: { label: '비', icon: '/images/weather/rain.webp' },
        RAINBOW: { label: '무지개', icon: '/images/weather/rainbow.webp' },
        METEOR_SHOWER: { label: '유성우', icon: '/images/weather/meteor-shower.webp' },
        HEATWAVE: { label: '폭염', icon: '/images/weather/heatwave.webp' }
    };
    const WEATHER_CODES = Object.keys(WEATHER);
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
            updatedText: document.getElementById('weatherUpdatedText'),
            voteStart: document.getElementById('weatherVoteStart'),
            voteModal: document.getElementById('weatherVoteModal'),
            voteBackdrop: document.getElementById('weatherVoteBackdrop'),
            voteClose: document.getElementById('weatherVoteClose'),
            voteCancel: document.getElementById('weatherVoteCancel'),
            voteSubmit: document.getElementById('weatherVoteSubmit'),
            voteDetailGrid: document.getElementById('weatherVoteDetailGrid'),
            voteDailyGrid: document.getElementById('weatherVoteDailyGrid'),
            voteSelectionCount: document.getElementById('weatherVoteSelectionCount')
        };

        const state = {
            forecast: null,
            pending: new Map(),
            serverBaseTime: null,
            receivedAt: 0,
            currentSlotKey: null,
            loading: false,
            modalReturnFocus: null
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
            const parts = Object.fromEntries(
                formatter.formatToParts(date)
                    .filter(part => part.type !== 'literal')
                    .map(part => [part.type, part.value])
            );
            return parts;
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
            return `<img class="${className}" src="${weather.icon}" alt="">`;
        }

        function resultPresentation(result) {
            if (!result || result.status === 'EMPTY') {
                return { label: '제보 필요', code: null, stateClass: 'is-empty' };
            }
            if (result.status === 'TIED') {
                return { label: '확인 중', code: null, stateClass: 'is-tied' };
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

            const current = forecast.detailSlots[0];
            const currentView = resultPresentation(current?.result);
            elements.headerText.textContent = currentView.label;
            if (currentView.code) {
                elements.headerIcon.src = WEATHER[currentView.code].icon;
                elements.headerIcon.alt = '';
                elements.headerIcon.hidden = false;
            } else {
                elements.headerIcon.hidden = true;
                elements.headerIcon.removeAttribute('src');
            }

            elements.detailList.innerHTML = forecast.detailSlots.map((slot, index) => {
                const view = resultPresentation(slot.result);
                const voters = slot.result?.voterCount
                    ? `<span>${slot.result.voterCount}명 제보</span>`
                    : '<span>첫 제보를 기다려요</span>';
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
                        ${voters}
                    </article>`;
            }).join('');

            elements.dailyList.innerHTML = forecast.dailyForecasts.map((day, index) => {
                const view = resultPresentation(day.result);
                const date = dateParts(day.forecastDate);
                const weekday = KOREAN_WEEKDAYS[date.weekday];
                return `
                    <article class="weather-day-card ${view.stateClass}">
                        <span>${index === 0 ? '내일' : weekday}</span>
                        <small>${date.month}/${date.day}</small>
                        ${weatherImage(view.code, 'weather-day-card__icon')}
                        <strong>${view.label}</strong>
                    </article>`;
            }).join('');

            const parsedServerTime = new Date(forecast.serverNow);
            elements.updatedText.textContent = Number.isNaN(parsedServerTime.getTime())
                ? '사용자 제보를 모아 표시합니다.'
                : `${new Intl.DateTimeFormat('ko-KR', {
                    timeZone: 'Asia/Seoul',
                    hour: '2-digit',
                    minute: '2-digit',
                    hourCycle: 'h23'
                }).format(parsedServerTime)} 기준 · 사용자 제보 집계`;
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
                elements.voteStart?.removeAttribute('disabled');
                if (!elements.voteModal.hidden) renderVoteEditor();
            } catch (error) {
                showForecastError();
                elements.voteStart?.setAttribute('disabled', '');
            } finally {
                state.loading = false;
            }
        }

        function setPanelOpen(open) {
            elements.panel.hidden = !open;
            elements.weatherButton.setAttribute('aria-expanded', open ? 'true' : 'false');
            document.getElementById('headerWeather')?.classList.toggle('is-open', open);
        }

        function voteKey(date, slotHour) {
            return `${date}:${slotHour}`;
        }

        function selectedVote(item) {
            return state.pending.get(voteKey(item.forecastDate, item.slotHour))?.weatherCode || item.myVote;
        }

        function weatherOptions(item) {
            const selected = selectedVote(item);
            const pending = state.pending.get(voteKey(item.forecastDate, item.slotHour));
            return WEATHER_CODES.map(code => {
                const isSelected = selected === code;
                const isPending = pending?.weatherCode === code;
                return `
                    <button type="button"
                            class="weather-choice ${isSelected ? 'is-selected' : ''} ${isPending ? 'is-pending' : ''}"
                            data-forecast-date="${item.forecastDate}"
                            data-slot-hour="${item.slotHour}"
                            data-weather-code="${code}"
                            aria-pressed="${isSelected}">
                        ${weatherImage(code, 'weather-choice__icon')}
                        <span>${WEATHER[code].label}</span>
                    </button>`;
            }).join('');
        }

        function renderVoteEditor() {
            const forecast = state.forecast;
            if (!forecast) return;

            elements.voteDetailGrid.innerHTML = forecast.detailSlots.map((slot, index) => `
                <article class="weather-vote-row">
                    <div class="weather-vote-row__label">
                        <span>${dateBadge(slot.forecastDate)}</span>
                        <strong>${slotLabel(slot.slotHour)}</strong>
                    </div>
                    <div class="weather-choice-list">${weatherOptions(slot)}</div>
                </article>`).join('');

            elements.voteDailyGrid.innerHTML = forecast.dailyForecasts.map((day, index) => {
                const date = dateParts(day.forecastDate);
                return `
                    <article class="weather-vote-row weather-vote-row--daily">
                        <div class="weather-vote-row__label">
                            <span>${index === 0 ? '내일' : KOREAN_WEEKDAYS[date.weekday] + '요일'}</span>
                            <strong>${date.month}/${date.day}</strong>
                        </div>
                        <div class="weather-choice-list">${weatherOptions({
                            forecastDate: day.forecastDate,
                            slotHour: -1,
                            myVote: day.myVote
                        })}</div>
                    </article>`;
            }).join('');

            const count = state.pending.size;
            elements.voteSelectionCount.textContent = count
                ? `${count}개 예보를 새로 적용합니다.`
                : '새로 선택한 예보가 없습니다.';
            elements.voteSubmit.disabled = count === 0;
        }

        function setVoteModalOpen(open) {
            if (open && !state.forecast) return;
            elements.voteModal.hidden = !open;
            document.body.classList.toggle('weather-modal-open', open);
            if (open) {
                state.modalReturnFocus = document.activeElement;
                state.pending.clear();
                renderVoteEditor();
                elements.voteClose.focus();
            } else {
                state.modalReturnFocus?.focus?.();
                state.modalReturnFocus = null;
            }
        }

        function trapModalFocus(event) {
            if (event.key !== 'Tab' || elements.voteModal.hidden) return;
            const focusable = Array.from(elements.voteModal.querySelectorAll(
                'button:not([disabled]), a[href], input:not([disabled]), select:not([disabled]), [tabindex]:not([tabindex="-1"])'
            )).filter(element => element.offsetParent !== null);
            if (focusable.length === 0) return;

            const first = focusable[0];
            const last = focusable[focusable.length - 1];
            if (event.shiftKey && document.activeElement === first) {
                event.preventDefault();
                last.focus();
            } else if (!event.shiftKey && document.activeElement === last) {
                event.preventDefault();
                first.focus();
            }
        }

        function handleWeatherChoice(event) {
            const button = event.target.closest('.weather-choice');
            if (!button) return;

            const forecastDate = button.dataset.forecastDate;
            const slotHour = Number(button.dataset.slotHour);
            const weatherCode = button.dataset.weatherCode;
            const key = voteKey(forecastDate, slotHour);
            const pending = state.pending.get(key);

            const source = slotHour === -1
                ? state.forecast.dailyForecasts.find(item => item.forecastDate === forecastDate)
                : state.forecast.detailSlots.find(item =>
                    item.forecastDate === forecastDate && item.slotHour === slotHour);
            const original = source?.myVote || null;

            if ((pending && pending.weatherCode === weatherCode) || (!pending && original === weatherCode)) {
                state.pending.delete(key);
            } else if (original === weatherCode) {
                state.pending.delete(key);
            } else {
                state.pending.set(key, { forecastDate, slotHour, weatherCode });
            }
            renderVoteEditor();
        }

        async function submitVotes() {
            if (state.pending.size === 0 || elements.voteSubmit.disabled) return;

            const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');
            if (!csrfToken || !csrfHeader) {
                elements.voteSelectionCount.textContent = '로그인 정보를 확인하지 못했습니다. 새로고침해 주세요.';
                return;
            }

            elements.voteSubmit.disabled = true;
            elements.voteSubmit.textContent = '적용 중…';
            try {
                const response = await fetch('/api/weather/votes', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        [csrfHeader]: csrfToken
                    },
                    body: JSON.stringify({ votes: Array.from(state.pending.values()) })
                });
                const body = await response.json().catch(() => ({}));
                if (!response.ok) throw new Error(body.message || '날씨 제보 저장에 실패했습니다.');

                state.forecast = body;
                state.serverBaseTime = new Date(body.serverNow);
                state.receivedAt = Date.now();
                state.pending.clear();
                renderForecast();
                setVoteModalOpen(false);
                setPanelOpen(true);
            } catch (error) {
                elements.voteSelectionCount.textContent = error.message;
                elements.voteSubmit.disabled = false;
            } finally {
                elements.voteSubmit.textContent = '제보 적용하기';
            }
        }

        elements.weatherButton.addEventListener('click', event => {
            event.stopPropagation();
            setPanelOpen(elements.panel.hidden);
        });
        elements.panel.addEventListener('click', event => event.stopPropagation());
        elements.panelClose.addEventListener('click', () => setPanelOpen(false));
        elements.voteStart?.addEventListener('click', () => setVoteModalOpen(true));
        elements.voteClose.addEventListener('click', () => setVoteModalOpen(false));
        elements.voteCancel.addEventListener('click', () => setVoteModalOpen(false));
        elements.voteBackdrop.addEventListener('click', () => setVoteModalOpen(false));
        elements.voteDetailGrid.addEventListener('click', handleWeatherChoice);
        elements.voteDailyGrid.addEventListener('click', handleWeatherChoice);
        elements.voteSubmit.addEventListener('click', submitVotes);

        document.addEventListener('click', () => setPanelOpen(false));
        document.addEventListener('keydown', event => {
            trapModalFocus(event);
            if (event.key !== 'Escape') return;
            if (!elements.voteModal.hidden) {
                setVoteModalOpen(false);
            } else if (!elements.panel.hidden) {
                setPanelOpen(false);
                elements.weatherButton.focus();
            }
        });

        updateClock();
        window.setInterval(updateClock, 1000);
        loadForecast();
    });
})();
