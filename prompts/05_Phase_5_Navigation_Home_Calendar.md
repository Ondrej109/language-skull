# Phase 5: Navigation, Home & Calendar (Production-Grade)

**Goal**  
Build the main navigation structure and key screens (Home, Calendar, Avatar Menu) so the app feels cohesive, premium, and easy to navigate.

## Strict Requirements (Do Not Skip)

### 1. Home / Dashboard
- Clean, spacious layout with excellent breathing room.
- Greeting (e.g. “Good morning”) in elegant typography.
- Two large, refined **progress rings** for Morning and Evening sessions.
- Cards with subtle material/glass effect.
- Tapping a card navigates to the session’s activity list.
- Immediate update of progress rings when activities are completed.
- Subtle skull motif used very sparingly (watermark or empty state only).

### 2. Bottom Tab Bar
Use native `TabView` with exactly these 4 tabs:
- **Home** (main dashboard)
- **Calendar** (past days + completion status)
- **Admin** (content & plan management – easy to hide later)
- **Profile** (or combine with avatar menu)

Selected tab uses the muted burgundy accent color.

### 3. Calendar View
- Show a calendar or list of past days.
- Tapping a past day shows the exact activities scheduled for that day.
- Completed activities show clear visual state (checkmark + timestamp if available).
- User can re-do activities from past days (creates new completion record).

### 4. Avatar Menu (Non-Negotiable)
Right side of navigation bar on most screens = circular User Avatar.
Tapping it opens a **native menu** with exactly these items in order:
1. **Profile** – User info, streak, words/phrases learned, current plan
2. **Manage Plan** – Billing info, trial/subscription status, cancel/upgrade
3. **Refer a Friend** – Share sheet with pre-filled message
4. **Sign Out** – Sign out and return to guest/launch state

Use native `Menu` + `Button` or `.contextMenu`.

### 5. Testing & Validation Discipline
After implementing each major screen:
1. Build + run in Simulator.
2. Test full navigation between tabs.
3. Test tapping Morning/Evening cards → session list.
4. Test Calendar → past day viewing + re-doing activities.
5. Test Avatar menu on multiple screens.
6. Only proceed after successful tests.

### 6. Git Discipline
Example commits:
- `feat: Build Home dashboard with progress rings`
- `feat: Add bottom TabView navigation`
- `feat: Implement Calendar view with past day support`
- `feat: Add Avatar menu with Profile, Manage Plan, Refer, Sign Out`

## Final Deliverables for Phase 5

- [ ] Home screen with elegant progress rings and cards
- [ ] Bottom TabView works correctly
- [ ] Calendar shows past days and completion status
- [ ] Avatar menu works on multiple screens
- [ ] All navigation feels smooth and native
- [ ] Simulator tested successfully
- [ ] Git history is clean

## Cursor Instructions (Follow Exactly)

Focus on making the app feel cohesive and premium through navigation and the Home experience.

After completing this phase, respond with:

```
✅ Phase 5 Completed

Checklist:
- [ ] Home dashboard done
- [ ] TabView navigation done
- [ ] Calendar view done
- [ ] Avatar menu done
- [ ] Simulator tested successfully

Missing items / decisions needed:
- 

Ready for Phase 6.
```

Do **not** move to Phase 6 until the above report is given.