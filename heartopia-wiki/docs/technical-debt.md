# Technical Debt Notes

## Collection Hide + Mastery Filter

### 1. `wikiHideThreshold` value validation

- Current state: `wiki-filter.js` reads `localStorage.wikiHideThreshold` and parses it as an integer.
- Risk: Normal UI only stores `0~5`, so this is safe in ordinary use. If localStorage is manually edited to an invalid value, the threshold can become `NaN`.
- Impact: Low. The hide filter may not behave as expected for that browser until the setting is reset.
- Future fix: Clamp invalid values to `0`.

Example:

```js
const parsedThreshold = parseInt(rawThreshold, 10);
const threshold = Number.isInteger(parsedThreshold) && parsedThreshold >= 0 && parsedThreshold <= 5
    ? parsedThreshold
    : 0;
```

### 2. Mastery key can remain after collection key is removed

- Current state: Collection and mastery are stored as separate checklist keys.
  - Collection: `fish_붕어`
  - Mastery: `mastery_fish_붕어`
- Risk: If a user unchecks collection after checking mastery, the mastery key can remain.
- Impact: Low. The hide filter still requires the base collection key before hiding, so an uncollected item is not hidden only because mastery remains.
- Future fix: When removing a collection key, also remove the matching `mastery_` key.

### 3. Mastery hide setting is local-only

- Current state: `wikiRequireMasteryForHide` is stored in localStorage, same as `wikiHideThreshold`.
- Risk: The setting does not follow the user across devices.
- Impact: Low. This matches the current filter settings behavior.
- Future fix: If filter preferences become account-level later, store these settings on the user profile.

### 4. Hide-collected toggle is local-only

- Current state: `wikiHideCollected` is stored in localStorage.
- Risk: If a user turns on "수집된 항목 숨기기" on one device, the setting does not apply on another device after login.
- Impact: Low. This is a view preference, not collection progress data.
- Future fix: If filter preferences should follow the logged-in account, add account-level preference storage for this toggle.

### 5. Hide threshold setting is local-only

- Current state: `wikiHideThreshold` is stored in localStorage.
- Risk: A user's selected hide threshold such as `1★ 이상`, `3★ 이상`, or `5★ 만` does not follow the account across devices.
- Impact: Low. The actual collection/star data still syncs; only the page view preference is local.
- Future fix: If account-level filter preferences are added, store this threshold together with `wikiHideCollected` and `wikiRequireMasteryForHide`.

## Visitor Counter

### 1. Exact 12-hour rolling count is not supported by the current schema

- Current state: Visitor counts are stored by date in `visitor_stats`.
- Risk: The system cannot remove only the first 12 hours from a 24-hour window because hourly or half-day data is not stored.
- Impact: Low. Current cost is low and behavior is simple, but the daily count resets by date.
- Future fix: Only if needed, add a half-day or hourly aggregate table. Do not do this unless the product need is clear.
