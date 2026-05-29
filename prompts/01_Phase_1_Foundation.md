# Phase 1: Foundation (Production-Grade)

**Goal**  
Create a clean, well-architected project skeleton with SwiftData models, basic theming, and a working ContentSeeder so the app compiles, runs, and seeds real data. This phase must feel like the start of a shippable product, not a prototype.

## Strict Requirements (Do Not Skip)

### 1. Project Setup
- Create a new **SwiftUI** app targeting **iOS 18+** named `LanguageSkull`.
- Use **Swift 6**.
- Enable **Strict Concurrency Checking**.
- Set up the following folder structure immediately:
  ```
  LanguageSkull/
  ├── Models/              # All @Model classes
  ├── Services/            # ContentSeeder, StudyPlanEngine, SubscriptionManager, etc.
  ├── ViewModels/          # @Observable classes
  ├── Views/               # All SwiftUI views
  ├── Resources/           # JSON, Markdown, Colors, etc.
  ├── Utils/               # Extensions, Helpers, Theme
  └── App/                 # App entry point + AppDelegate if needed
  ```

### 2. Architecture (Mandatory from Day 1)
- Follow **Clean Architecture + Repository pattern + MVVM** using `@Observable`.
- Views contain **zero** business logic or data access.
- Create a `Theme` struct/environment object for colors right away.
- All data access must go through services/repositories.

### 3. Data Layer (docs/04)
- Implement **every** model from `docs/04_DATA_MODELS_FULL.md` exactly as specified.
- Use proper `@Relationship` with `inverse` and correct `deleteRule`.
- Add `@Attribute(.unique)` on all `id` fields.
- Create a basic `SchemaMigrationPlan` (even if empty for now).

### 4. Content Seeding (docs/05)
- Create `ContentSeeder` as an `actor`.
- It must load bundled `Content/<Language>/words.json`, `phrases.json`, and `grammar.md`.
- Seeding must be **idempotent** (safe to run multiple times).
- On first launch, seed a default course (Spanish or device-locale aware).
- Store `contentVersion` on `Course`.

### 5. Theming & Branding (docs/07 + refined aesthetic)
- Implement the exact color palette:
  - Background: `#050505`
  - Surfaces: `#111111` + material
  - Accent: `#4A1C1C` (muted burgundy)
  - Subtle highlight: `#D4C4A8`
- Create a `Theme` object.
- Apply it globally using `.environment(\.theme, theme)` or similar.
- Use default iOS components + liquid glass. No heavy custom styling yet.

### 6. Basic UI
- Create a simple `HomeView` with:
  - Top navigation bar with avatar (right side)
  - Two large placeholder cards: **Morning** and **Evening**
  - Progress rings (even if static for now)
- Tapping a card should navigate to a placeholder session screen.
- Add a basic Admin toggle in Settings (feature flag).

### 7. Testing & Validation Discipline (Critical – from Medium article)
After **every major component** is implemented:
1. Build the project.
2. Run in Simulator.
3. Test the flow (launch → seeding → basic navigation).
4. Take a screenshot or note the result.
5. Only then move to the next piece.

### 8. Git Discipline
- Make **clean, atomic commits** after each logical piece:
  - `feat: Add SwiftData models`
  - `feat: Implement ContentSeeder`
  - `feat: Add basic Theme and HomeView`
- Never commit broken code.

## Final Deliverables for Phase 1

- [ ] Project compiles cleanly with no warnings
- [ ] App launches in Simulator
- [ ] Content seeds successfully on first launch (verify in SwiftData browser or logs)
- [ ] Basic Home screen with Morning/Evening cards renders
- [ ] Theme is applied globally
- [ ] Admin feature flag exists and works
- [ ] Git history is clean

## Cursor Instructions (Follow Exactly)

You are building a **production foundation**, not a prototype.

- Use the models exactly from `docs/04_DATA_MODELS_FULL.md`.
- Follow the refined aesthetic in `.cursorrules` and `docs/07`.
- After completing this phase, respond with:

```
✅ Phase 1 Completed

Checklist:
- [ ] Project structure created
- [ ] All models implemented
- [ ] ContentSeeder working
- [ ] Theme applied
- [ ] Basic HomeView working
- [ ] Simulator tested successfully

Missing items / decisions needed:
- 

Ready for Phase 2.
```

Do **not** move to Phase 2 until the above report is given.