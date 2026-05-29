# 11 CODING STANDARDS AND TECHNOLOGY – FULL DETAILED END-TO-END SPEC

## 11.1 Language and Framework Rules (Strict)

- **Swift 6** only. No Swift 5.9 or earlier features that are deprecated in Swift 6.
- **SwiftUI** only for all UI. No UIKit unless there is absolutely no SwiftUI equivalent (very rare in MVP).
- Target: **iOS 18+**.
- Use `async/await` everywhere for asynchronous work. No completion handlers or Combine unless strictly necessary for legacy integration.

## 11.2 Architecture (Mandatory)

**Clean Architecture + Repository pattern + MVVM** using `@Observable`.

- **Views** contain only UI logic and bind to ViewModels.
- **ViewModels** (or Use Cases) contain business logic and call Repositories.
- **Repositories** are the single source of truth for data access (SwiftData, file system, etc.).
- Never put business logic, networking, or persistence directly in Views.

Use `@Observable` classes for ViewModels. Avoid `@StateObject` / `@ObservedObject` where possible in favor of the newer Observation framework.

## 11.3 State Management

- Primary: SwiftUI Observation framework (`@Observable`).
- Use `@Environment` and custom environment objects for theme, feature flags, and shared services.
- Keep `@State` and `@Binding` for local view state only.

## 11.4 Data Layer (SwiftData)

- Use SwiftData exclusively in MVP.
- All models must have proper `@Relationship` with `inverse` and correct `deleteRule`.
- Use `@Attribute(.unique)` on all identifier fields.
- Create a dedicated `Repository` for each major domain (e.g., `UserRepository`, `ContentRepository`, `ProgressRepository`).
- Make repositories actors when they perform I/O to ensure thread safety.

## 11.5 Error Handling

- Use `Result` types or `async throws` for all fallible operations.
- Never silently swallow errors.
- Show user-friendly messages via alerts or banners.
- Log technical details using a centralized logging service (can be simple `print` + OSLog in MVP).
- For critical flows (subscription, content import), provide retry mechanisms.

## 11.6 Accessibility (First Class)

- Every interactive element must have proper `accessibilityLabel`, `accessibilityHint`, and `accessibilityValue` where appropriate.
- Support Dynamic Type.
- Maintain sufficient color contrast.
- Test with VoiceOver during development.

## 11.7 Previews (Mandatory)

- Every SwiftUI View must have at least one `#Preview`.
- Previews must cover multiple states: loading, empty, populated, error.
- Use preview data factories so previews are realistic and maintainable.

## 11.8 Feature Flags

- Use a simple `FeatureFlag` enum or struct with `@AppStorage` or environment values.
- All admin functionality must be behind a flag that can be easily disabled before submission.
- Document every flag clearly in code comments.

## 11.9 Git and Commit Practices

- Make small, focused commits with clear messages (e.g., "Add D-3 revision logic to StudyPlanEngine").
- Commit after completing logical units of work (especially after each phase).
- Never commit secrets, API keys, or `GoogleService-Info.plist`.

## 11.10 Testing Expectations (MVP)

- Unit test critical logic in `StudyPlanEngine`, `ContentSeeder`, and `SubscriptionManager`.
- Add basic XCUITest smoke tests for main flows (onboarding, session completion).
- At minimum, ensure the app builds and runs without crashes in Simulator for every phase.

## 11.11 Cursor-Specific Rules

- When Cursor generates code, always review for proper architecture (no logic in Views).
- Prefer small, focused files over large monolithic ones.
- Add clear comments explaining "why" for complex logic (especially around D-3 ordering, trial handling, and referral capture).
- After any significant change, run the build and basic Simulator test before moving to the next task.

These standards exist so the final codebase is clean, maintainable, and easy for a human developer to take over after Cursor finishes the MVP.