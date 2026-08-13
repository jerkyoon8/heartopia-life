const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './e2e',
  outputDir: 'build/playwright-results',
  timeout: 30_000,
  expect: { timeout: 5_000 },
  workers: 1,
  fullyParallel: false,
  reporter: [['list'], ['html', { outputFolder: 'build/reports/playwright', open: 'never' }]],
  use: {
    baseURL: process.env.PLAYWRIGHT_BASE_URL || 'http://127.0.0.1:8080',
    browserName: 'chromium',
    channel: process.env.PLAYWRIGHT_CHANNEL || 'chrome',
    headless: true,
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure'
  }
});
