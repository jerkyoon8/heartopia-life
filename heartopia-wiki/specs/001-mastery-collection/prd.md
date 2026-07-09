# PRD: Mastery Collection

## 1. Summary

### Problem

The collection pages currently track only collected status and star rating. They do not show or track per-item mastery thresholds, so users cannot tell whether an item has mastery data or mark mastery progress from the collection UI.

### Proposed Solution

Add mastery threshold fields to fish, bug, bird, cooking, crop, and flower collection data. Show a mastery panel on detail pages and add a mastery toggle icon on collection cards, using the existing checklist sync storage flow.

### Success Criteria

- Fish, bug, bird, cooking, crop, and flower models expose four mastery threshold fields.
- Detail pages render a mastery panel for supported categories and show disabled state when mastery data is unavailable.
- Collection cards show a mastery icon that can be toggled independently from star collection status.
- Existing checklist localStorage and authenticated DB sync continue to work.

## 2. Users And Use Cases

### Primary Users

- Heartopia wiki users tracking collection completion and mastery progress.

### User Stories

- As a collection user, I want to see item mastery thresholds on detail pages, so that I know the required counts for each stage.
- As a collection user, I want to toggle mastery directly from item cards, so that I can track mastery without leaving the list.
- As a logged-in user with sync enabled, I want mastery toggles to persist like collection stars, so that my data follows my account.

## 3. Functional Scope

### In Scope

- Add four nullable mastery columns to fish, bug, bird, cooking, crop, and flower tables.
- Populate/update mastery values from `C:\Users\k\Desktop\user_kit\docs\명인 정보`.
- Render Korean stage labels in order: `초보자`, `입문자`, `숙련자`, `명인`.
- Treat `X` and missing values as unavailable mastery data.
- Add disabled mastery UI state for unavailable mastery data.
- Store mastery checklist status using the existing checklist storage and sync infrastructure.

### Out Of Scope

- Production DB deployment or server-side execution.
- Redesigning the whole checklist page.
- Adding new public JSON APIs beyond existing collection reads.
- Adding English mastery labels.

## 4. Acceptance Criteria

- The app builds after adding mastery fields and SQL mappings.
- Existing star check behavior still works on detail and list pages.
- Mastery toggle does not navigate to the detail page when clicked on a card.
- Disabled mastery icons do not write checklist data.
- The generated SQL can add columns and update values without requiring non-null defaults.

## 5. Constraints

- Tech: Java 17, Spring Boot, Thymeleaf, MyBatis XML, MySQL.
- Data: Korean item names from local mastery txt files are the source of truth.
- External Dependencies: None.

## 6. Risks

- Name mismatches between txt files and DB rows: generate SQL by name and leave unmatched rows as NULL.
- Checklist value shape changes could break existing saved data: store mastery as a separate key suffix instead of changing existing star value structure.

## 7. Open Questions

- None. User confirmed label order and disabled state for unavailable mastery data.
