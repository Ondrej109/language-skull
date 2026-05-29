# ARCHITECTURE – Language Skull

This document is the **single source of truth** for the architectural principles of Language Skull. All code must follow these rules. Cursor and human developers should treat this document as authoritative.

## 1. Core Architectural Style

**Clean Architecture + Repository Pattern + MVVM with Observation**

Language Skull follows a strict layered architecture with clear separation of concerns:

- **Presentation Layer** → Views + ViewModels
- **Domain / Business Logic Layer** → Services, Engines, Use Cases
- **Data Access Layer** → Repositories + SwiftData

The goal is to keep the UI as thin as possible and make the core logic testable, maintainable, and independent of SwiftUI.

## 2. Layer Responsibilities (Strict)

### Presentation Layer (Features/)

**Allowed:**
- UI layout, styling, animations, and gestures
- Binding to ViewModel state
- Handling user input and forwarding it to the ViewModel
- Displaying loading, empty, and error states
- Navigation coordination (simple cases)

**Forbidden:**
- Business logic
- Direct SwiftData access
- Network calls or complex data transformation
- Knowledge of repository internals

Every View must have realistic `#Preview`s covering multiple states.

### ViewModel Layer

ViewModels act as the bridge between the UI and the business logic.

**Responsibilities:**
- Own the observable state for a screen/feature
- Orchestrate calls to Repositories and Services
- Transform raw data into UI-friendly models
- Handle user actions and delegate complex logic to Services/Engines
- Manage loading and error states for the view

**Rules:**
- Use `@Observable` (not `@StateObject` / `@ObservedObject` where avoidable)
- Keep ViewModels focused on one screen or closely related flow
- Do **not** put heavy business logic here (move to `Core/Services/`)

### Business Logic Layer (Core/Services/)

This is where the important domain logic lives.

**Key Components:**
- `StudyPlanEngine` — The heart of the app. Owns all logic for assembling Morning/Evening sessions, D-1 and D-3 revision rules, grammar progression, and current day calculation.
- `SubscriptionManager` — Trial tracking, purchase handling, entitlement checks
- `ContentSeeder` / Content Import logic
- Future: Referral engine, analytics event builders, etc.

**Rules:**
- Services and Engines should be implemented as `actor` when they perform I/O or need thread safety.
- They must be independent of SwiftUI.
- They should be unit testable in isolation.

### Data Access Layer (Core/Data/)

**Repositories** are the only place allowed to talk to SwiftData (or future remote sources).

**Responsibilities:**
- CRUD operations for their domain
- Proper relationship handling and delete rules
- Query optimization and pagination where needed
- Mapping between `@Model` objects and domain models (when useful)

**Rules:**
- One repository per major domain (User, Content, Progress)
- Repositories **must** be actors
- Never expose `ModelContext` directly to ViewModels or Views
- All write operations should go through repositories

### SwiftData Models (Core/Data/SwiftData/Models/)

- All `@Model` classes live here exclusively.
- Follow the exact definitions in `docs/04_DATA_MODELS_FULL.md`.
- Use `@Attribute(.unique)` and proper `@Relationship(inverse:deleteRule:)`.
- Do not put business logic or computed properties that belong in Services inside the models (keep models relatively dumb).

## 3. Communication Rules Between Layers

- Views → only talk to their ViewModel
- ViewModels → talk to Repositories **and** Services/Engines
- Services/Engines → talk to Repositories when they need data
- Repositories → only talk to SwiftData (and each other when necessary)
- Never create shortcuts that bypass layers

## 4. Key Architectural Decisions

| Decision                        | Chosen Approach                          | Rationale |
|--------------------------------|------------------------------------------|---------|
| State Management              | SwiftUI Observation (`@Observable`)     | Modern, simple, performant |
| Persistence                   | SwiftData only (MVP)                    | Native, type-safe, offline-first |
| Business Logic Location       | `Core/Services/` (especially `StudyPlanEngine`) | Testability + separation from UI |
| Data Access                   | Repository pattern + actors             | Thread safety + clear ownership |
| Admin Mode                    | Feature-flagged in `Features/Admin/`    | Easy to completely remove before release |
| Error Handling                | `async throws` + `Result` + user alerts | Clear, consistent, user-friendly |

## 5. StudyPlanEngine (Special Role)

The `StudyPlanEngine` is the most important service in the app. It is responsible for:

- Calculating the current day for a user
- Assembling the exact list of activities for Morning and Evening sessions
- Correctly implementing D-1 and D-3 revision logic (original learning order)
- Handling grammar section progression
- Supporting both repeating weekly plans and progressive multi-week plans

It must be implemented as an `actor` and live in `Core/Services/`. All session assembly logic belongs here, not in ViewModels or Views.

## 6. Admin Mode & Feature Flags

Admin functionality must be:
- Located exclusively under `Features/Admin/`
- Guarded by a clear feature flag (defined in `App/FeatureFlags.swift`)
- Easy to completely disable and remove before App Store submission

## 7. Future Evolution

This architecture is designed to support future additions with minimal disruption:

- CloudKit / remote sync (add a new Repository implementation)
- Background refresh
- Multiple courses / languages
- More advanced analytics

New complex logic should be placed in `Core/Services/` rather than bloating ViewModels.

## 8. Relationship to Other Documents

- Detailed coding standards → `docs/11_CODING_STANDARDS_AND_TECH.md`
- Study plan & activity rules → `docs/06_STUDY_PLAN_AND_ACTIVITIES.md`
- Data models → `docs/04_DATA_MODELS_FULL.md`
- Project folder structure → `docs/PROJECT_STRUCTURE.md`
- Phased build plan → `docs/13_INCREMENTAL_BUILD_PLAN.md`
- Master agent instructions → `docs/00_AGENT_MASTER_INSTRUCTIONS.md` + `.cursorrules`

---

This architecture exists so that Language Skull remains clean, testable, and maintainable as it grows from MVP through multiple phases and potential future features.