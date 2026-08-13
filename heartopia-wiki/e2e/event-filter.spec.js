const { test, expect } = require('@playwright/test');

const FISH_URL = '/wiki/collections/fish';
const GENERAL = '__general__';
const EVENT_ROUTES = [
  '/wiki/collections/fish',
  '/wiki/collections/bug',
  '/wiki/collections/bird',
  '/wiki/collections/animal',
  '/wiki/collections/forageable',
  '/wiki/items/cooking',
  '/wiki/items/flowers',
  '/wiki/items/crops',
  '/wiki/others/sandbox',
  '/wiki/others/sea-cleaning'
];

function escapeAttribute(value) {
  return String(value).replace(/\\/g, '\\\\').replace(/"/g, '\\"');
}

function quickOption(page, value) {
  return page.locator(`.quick-event-option input[value="${escapeAttribute(value)}"]`);
}

function detailOption(page, value) {
  return page.locator(`.event-dropdown-opt input[value="${escapeAttribute(value)}"]`);
}

async function readEventState(page) {
  return page.evaluate(() => ({
    quick: [...document.querySelectorAll('.quick-event-option input:not(:disabled)')].map(input => input.value),
    current: [...document.querySelectorAll('.current-event-value')].map(input => input.value),
    available: [...document.querySelectorAll('.event-dropdown-opt input:not(:disabled)')].map(input => input.value)
  }));
}

async function openFilterPage(page) {
  await page.goto(FISH_URL, { waitUntil: 'domcontentloaded' });
  await expect(page.locator('#quickEventOnlyToggle')).toBeAttached();
  await expect(page.locator('#eventFilter')).toBeAttached();
}

async function inlineVisibleEvents(page, selector) {
  return page.locator(selector).evaluateAll(elements => elements
    .filter(element => element.style.display !== 'none')
    .map(element => (element.dataset.event || '').trim()));
}

function monitorPage(page) {
  const pageErrors = [];
  const localFailures = [];
  const consoleErrors = [];
  page.on('pageerror', error => pageErrors.push(error.message));
  page.on('console', message => {
    if (message.type() === 'error' && !message.text().includes('ERR_NETWORK_ACCESS_DENIED')) {
      consoleErrors.push(message.text());
    }
  });
  page.on('requestfailed', request => {
    const url = new URL(request.url());
    if (url.hostname === '127.0.0.1' || url.hostname === 'localhost') {
      localFailures.push(`${request.url()} ${request.failure()?.errorText || ''}`);
    }
  });
  return { pageErrors, localFailures, consoleErrors };
}

const pageMonitors = new WeakMap();

test.beforeEach(async ({ page }) => {
  pageMonitors.set(page, monitorPage(page));
});

test.afterEach(async ({ page }) => {
  const monitor = pageMonitors.get(page);
  expect(monitor.pageErrors).toEqual([]);
  expect(monitor.localFailures).toEqual([]);
  expect(monitor.consoleErrors).toEqual([]);
});

test('initial state is general plus current events, with quick-only off', async ({ page }) => {
  const monitor = monitorPage(page);
  await openFilterPage(page);
  const state = await readEventState(page);

  await expect(detailOption(page, GENERAL)).toBeChecked();
  await expect(page.locator('.event-general-options .event-current-badge')).toHaveCount(0);
  for (const value of state.current.filter(value => state.available.includes(value))) {
    await expect(detailOption(page, value)).toBeChecked();
  }
  for (const value of state.available.filter(value => value !== GENERAL && !state.current.includes(value))) {
    await expect(detailOption(page, value)).not.toBeChecked();
  }
  await expect(page.locator('#quickEventOnlyToggle')).not.toBeChecked();

  const visible = await inlineVisibleEvents(page, '.wiki-item-card, .wiki-table-row');
  expect(visible.length).toBeGreaterThan(0);
  expect(visible.every(value => value === '' || state.current.includes(value))).toBe(true);
  expect(monitor.pageErrors).toEqual([]);
  expect(monitor.localFailures).toEqual([]);
  expect(monitor.consoleErrors).toEqual([]);
});

test('multi-select stays selected but reload resets general on and quick-only off', async ({ page }) => {
  await openFilterPage(page);
  const state = await readEventState(page);
  test.skip(state.quick.length < 2, '관리자 빠른 이벤트가 2개 이상이어야 복수 선택을 검증할 수 있습니다.');
  const selectedQuick = state.quick.slice(0, 2);

  await page.locator('#quickEventTrigger').click();
  for (const value of selectedQuick) await quickOption(page, value).check();
  await expect(page.locator('#quickEventTrigger .trigger-label')).toHaveText('2개 이벤트');

  await page.locator('.quick-event-toggle-button').click();
  await expect(page.locator('#quickEventOnlyToggle')).toBeChecked();
  await expect(detailOption(page, GENERAL)).not.toBeChecked();
  for (const value of selectedQuick) await expect(detailOption(page, value)).toBeChecked();
  for (const value of state.available.filter(value => value !== GENERAL && !selectedQuick.includes(value))) {
    await expect(detailOption(page, value)).not.toBeChecked();
  }

  const activeCards = await inlineVisibleEvents(page, '.wiki-item-card');
  const activeRows = await inlineVisibleEvents(page, '.wiki-table-row');
  expect(activeCards.length).toBeGreaterThan(0);
  expect(activeCards.every(value => selectedQuick.includes(value))).toBe(true);
  expect(activeRows.every(value => selectedQuick.includes(value))).toBe(true);
  expect(await page.locator('.quick-event-toggle-state').evaluate(element => getComputedStyle(element, '::before').content)).toBe('"ON"');

  await page.reload({ waitUntil: 'domcontentloaded' });
  await expect(page.locator('#quickEventOnlyToggle')).not.toBeChecked();
  await expect(detailOption(page, GENERAL)).toBeChecked();
  for (const value of selectedQuick) await expect(quickOption(page, value)).toBeChecked();
  expect((await inlineVisibleEvents(page, '.wiki-item-card')).some(value => value === '')).toBe(true);

  await page.locator('#resetBtn').click();
  await expect(detailOption(page, GENERAL)).toBeChecked();
  for (const value of state.current.filter(value => state.available.includes(value))) {
    await expect(detailOption(page, value)).toBeChecked();
  }
  await expect(page.locator('#quickEventOnlyToggle')).not.toBeChecked();
});

test('moving from cooking quick-only to sea cleaning restores general results', async ({ page }) => {
  await page.goto('/wiki/items/cooking', { waitUntil: 'domcontentloaded' });
  const state = await readEventState(page);
  test.skip(state.quick.length === 0, '요리 도감에서 선택 가능한 빠른 이벤트가 필요합니다.');

  await page.locator('#quickEventTrigger').click();
  await quickOption(page, state.quick[0]).check();
  await page.locator('.quick-event-toggle-button').click();
  await expect(page.locator('#quickEventOnlyToggle')).toBeChecked();
  await expect(detailOption(page, GENERAL)).not.toBeChecked();

  await page.goto('/wiki/others/sea-cleaning', { waitUntil: 'domcontentloaded' });
  await expect(page.locator('#quickEventOnlyToggle')).not.toBeChecked();
  await expect(detailOption(page, GENERAL)).toBeChecked();
  expect((await inlineVisibleEvents(page, '.wiki-item-card, .wiki-table-row')).length).toBeGreaterThan(0);
});

test('turning on without a selected quick event opens the picker and preserves results', async ({ page }) => {
  await openFilterPage(page);
  const state = await readEventState(page);
  test.skip(state.quick.length === 0, '관리자 빠른 이벤트 설정이 필요합니다.');

  await page.locator('#quickEventTrigger').click();
  for (const value of state.quick) await quickOption(page, value).uncheck();
  await page.locator('.quick-event-toggle-button').click();

  await expect(page.locator('#quickEventOnlyToggle')).not.toBeChecked();
  await expect(page.locator('#quickEventDropdown')).toBeVisible();
  await expect(page.locator('#quickEventTrigger')).toHaveAttribute('aria-expanded', 'true');
  await expect(detailOption(page, GENERAL)).toBeChecked();
  expect((await inlineVisibleEvents(page, '.wiki-item-card')).length).toBeGreaterThan(0);
});

test('detailed selection synchronizes back to the quick picker', async ({ page }) => {
  await openFilterPage(page);
  const state = await readEventState(page);
  test.skip(state.quick.length === 0, '관리자 빠른 이벤트 설정이 필요합니다.');
  const target = state.quick[0];

  await page.locator('.btn-filter-toggle').click();
  await page.locator('#eventTrigger').click();
  await detailOption(page, target).uncheck();
  await expect(quickOption(page, target)).not.toBeChecked();
  await detailOption(page, target).check();
  await expect(quickOption(page, target)).toBeChecked();
});

test('keyboard controls and corrupt saved JSON fail safely', async ({ page }) => {
  const monitor = monitorPage(page);
  await page.addInitScript(() => localStorage.setItem('wikiEventFilterOverrides', '{invalid-json'));
  await openFilterPage(page);
  await expect(detailOption(page, GENERAL)).toBeChecked();

  const toggle = page.locator('#quickEventOnlyToggle');
  await expect(toggle).toHaveAccessibleName('이벤트만 보기');
  await toggle.focus();
  await page.keyboard.press('Space');
  await expect(toggle).toBeChecked();
  await page.keyboard.press('Space');
  await expect(toggle).not.toBeChecked();

  await page.locator('#quickEventTrigger').focus();
  await page.keyboard.press('Enter');
  await expect(page.locator('#quickEventDropdown')).toBeVisible();
  await page.locator('.page-header').click();
  await expect(page.locator('#quickEventDropdown')).not.toBeVisible();
  await expect(page.locator('#quickEventTrigger')).toHaveAttribute('aria-expanded', 'false');
  expect(monitor.pageErrors).toEqual([]);
  expect(monitor.consoleErrors).toEqual([]);
});

test('all event pages render at desktop and 375px without local failures or overflow', async ({ page }) => {
  const monitor = monitorPage(page);
  for (const viewport of [{ width: 1280, height: 800 }, { width: 375, height: 812 }]) {
    await page.setViewportSize(viewport);
    for (const route of EVENT_ROUTES) {
      await page.goto(route, { waitUntil: 'domcontentloaded' });
      await expect(page.locator('#quickEventFilter')).toBeVisible();
      const split = await page.locator('#quickEventFilter').boundingBox();
      expect(split).not.toBeNull();
      expect(split.x).toBeGreaterThanOrEqual(0);
      expect(split.x + split.width).toBeLessThanOrEqual(viewport.width);
      expect(await page.evaluate(() => document.documentElement.scrollWidth <= document.documentElement.clientWidth)).toBe(true);
    }
  }
  expect(monitor.pageErrors).toEqual([]);
  expect(monitor.localFailures).toEqual([]);
  expect(monitor.consoleErrors).toEqual([]);
});

test('375px dark mode keeps both split segments and the dropdown inside the viewport', async ({ browser }) => {
  const context = await browser.newContext({ viewport: { width: 375, height: 812 } });
  await context.addInitScript(() => localStorage.setItem('theme', 'dark'));
  const page = await context.newPage();
  const monitor = monitorPage(page);
  await openFilterPage(page);
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'dark');

  const split = await page.locator('#quickEventFilter').boundingBox();
  const left = await page.locator('.quick-event-toggle-button').boundingBox();
  const right = await page.locator('.quick-event-picker').boundingBox();
  expect(split.x + split.width).toBeLessThanOrEqual(375);
  expect(Math.abs(left.y - right.y)).toBeLessThan(1);
  expect(Math.abs(split.height - 40)).toBeLessThan(1);

  await page.locator('#quickEventTrigger').click();
  const dropdown = await page.locator('#quickEventDropdown').boundingBox();
  expect(dropdown.x).toBeGreaterThanOrEqual(0);
  expect(dropdown.x + dropdown.width).toBeLessThanOrEqual(375);
  expect(monitor.pageErrors).toEqual([]);
  expect(monitor.localFailures).toEqual([]);
  expect(monitor.consoleErrors).toEqual([]);
  await context.close();
});
