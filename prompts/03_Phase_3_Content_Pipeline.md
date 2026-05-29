# Phase 3: Content Pipeline & Study Engine (Production-Grade)

**Goal**  
Build a robust, production-ready content system and study plan engine. The engine must correctly handle D-3 revisions in **original learning order** and support both bundled content and future Admin imports.

## Strict Requirements (Do Not Skip)

### 1. ContentSeeder (docs/05)
- Implement as an `actor` for thread safety.
- Support loading from bundled `Content/<Language>/` folder containing:
  - `words.json`
  - `phrases.json`
  - `grammar.md` (numbered sections)
- Seeding must be **idempotent** (safe to run multiple times without duplicates).
- Store `contentVersion` on `Course` model.
- On first launch after onboarding, seed the chosen language.

### 2. Admin Import Flow (MVP)
- In Admin tab, allow importing:
  - Entire language folder (select folder)
  - Individual files
- Support **Replace** (overwrite) and **Merge** (add/update) modes.
- Show clear progress + success/error messages.
- Validate JSON structure before importing.
- **Never** delete or modify existing `UserActivityCompletion` records.

### 3. StudyPlanEngine (docs/06)
This is the **core** of the app. Implement with the following rules:

- `StudyPlan` contains `DayPlan` objects (7-day cycle or progressive multi-week).
- Each `DayPlan` has ordered `morningActivities` and `eveningActivities` arrays of `ActivityDefinition`.
- `ActivityDefinition` uses `type: ActivityType` + flexible `metadata: [String: String]`.

**D-3 Revision Logic (Critical - Original Order)**
When building a `revisionWordsD3` or `revisionPhrasesD3` activity:
1. Collect all words/phrases where `dayIntroduced` is in `(currentDay - 3) ... (currentDay - 1)`.
2. Sort **strictly by `dayIntroduced` ascending**, then by original order within the same day.
3. Present as **one continuous session** (no shuffling, no SRS).
4. Mark the whole activity complete only after the last item.

### 4. Activity Types to Implement
Implement all types from docs/06:
- New Words/Phrases: List + Flashcards EF/FE
- Revision D-1 and D-3
- Grammar Paragraph (sequential by section number)

### 5. User Progress
- Create `UserActivityCompletion` records when user taps "Mark as Done".
- Support viewing past days from Calendar (show exact scheduled activities + completion status).

### 6. Testing & Validation Discipline
After each major component:
1. Build + run in Simulator.
2. Test content seeding (fresh install + re-seed).
3. Test D-3 revision ordering (create words across 3 days → verify correct order).
4. Test Admin import (Replace and Merge).
5. Test jumping to past days from Calendar.
6. Only proceed after successful tests.

### 7. Git Discipline
Example commits:
- `feat: Implement ContentSeeder as actor`
- `feat: Add Admin Import with Replace/Merge`
- `feat: Build StudyPlanEngine with D-3 original order logic`
- `feat: Wire up UserActivityCompletion and past day viewing`

## Final Deliverables for Phase 3

- [ ] ContentSeeder works (bundled + idempotent)
- [ ] Admin Import flow works (folder + files, Replace + Merge)
- [ ] StudyPlanEngine correctly assembles Morning/Evening sessions
- [ ] D-3 revisions show words in original learning order
- [ ] All ActivityTypes implemented
- [ ] User can mark activities done and view past days
- [ ] All flows tested successfully in Simulator
- [ ] Git history is clean

## Cursor Instructions (Follow Exactly)

The StudyPlanEngine is the heart of the app. Get the D-3 ordering logic **exactly right**.

After completing this phase, respond with:

```
✅ Phase 3 Completed

Checklist:
- [ ] ContentSeeder working
- [ ] Admin Import working
- [ ] StudyPlanEngine + D-3 logic working
- [ ] All activity types implemented
- [ ] Past day viewing working
- [ ] Simulator tested successfully

Missing items / decisions needed:
- 

Ready for Phase 4.
```

Do **not** move to Phase 4 until the above report is given.