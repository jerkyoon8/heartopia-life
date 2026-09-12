const { test, expect } = require('@playwright/test');

const PROFILE_KEY = 'heartopia_pet_food_profiles';

test.beforeEach(async ({ page }) => {
  await page.addInitScript(({ key }) => {
    localStorage.setItem(key, JSON.stringify([{
      id: 'pet-untried-test',
      name: '테스트 강아지',
      type: 'dog',
      inHotel: false,
      preferences: {},
      tried: { '강아지전용사료': true },
      customFoods: [],
      hiddenFoodIds: []
    }]));
  }, { key: PROFILE_KEY });
});

test('안 먹여본 음식만 표시하고 검색 조건을 함께 적용한다', async ({ page }) => {
  await page.goto('/wiki/others/pets', { waitUntil: 'domcontentloaded' });

  await expect(page.locator('.food-card')).toHaveCount(30);
  await page.getByRole('button', { name: '안 먹여본 음식', exact: true }).click();
  await expect(page.locator('.food-card')).toHaveCount(29);
  await expect(page.getByRole('heading', { name: '강아지 전용 사료', exact: true })).toHaveCount(0);

  await page.locator('#foodSearchInput').fill('미트버거');
  await expect(page.locator('.food-card')).toHaveCount(1);
  await expect(page.getByRole('heading', { name: '미트버거', exact: true })).toBeVisible();

  await page.locator('#foodSearchInput').fill('');
  await page.getByRole('button', { name: '먹여본 음식', exact: true }).click();
  await expect(page.locator('.food-card')).toHaveCount(1);
  await expect(page.getByRole('heading', { name: '강아지 전용 사료', exact: true })).toBeVisible();

  await page.getByRole('button', { name: '전체', exact: true }).click();
  await expect(page.locator('.food-card')).toHaveCount(30);
});

test('안 먹여본 음식에 먹여봄 표시를 하면 현재 결과에서 즉시 제외한다', async ({ page }) => {
  await page.goto('/wiki/others/pets', { waitUntil: 'domcontentloaded' });
  await page.getByRole('button', { name: '안 먹여본 음식', exact: true }).click();

  const firstFood = page.locator('.food-card').first();
  const firstFoodName = await firstFood.locator('.food-name').textContent();
  await firstFood.getByRole('button', { name: '먹여보기', exact: true }).click();

  await expect(page.locator('.food-card')).toHaveCount(28);
  await expect(page.getByRole('heading', { name: firstFoodName, exact: true })).toHaveCount(0);
});
