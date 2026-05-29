# 08 ADMIN MODE – FULL DETAILED END-TO-END SPEC

## 8.1 Visibility in MVP

Admin mode is **visible by default** during development and internal testing.

A clear, obvious toggle exists (in Settings or via long-press on the Admin tab icon) that completely hides the Admin tab. This toggle must be easy to use before App Store submission, with a confirmation dialog and clear instructions in the code comments.

## 8.2 Admin Tab Contents (MVP – Fully Functional)

### 8.2.1 Content Management Section

- **Import / Update Content** button
  - Option 1: Import entire language folder (select folder containing `words.json`, `phrases.json`, `grammar.md`)
  - Option 2: Import individual files
  - Validation step with clear success/error messages
  - Choice between **Replace** (overwrite existing content) or **Merge** (add/update only)
  - Progress indicator during import
  - Warning that user progress is never deleted

- List of currently loaded courses/languages with basic stats (number of words, phrases, grammar sections)

### 8.2.2 Study Plan Editor (Form-Based for MVP)

Simple but functional editor:
- Select Course
- Select Day (1–7 or specific week/day for progressive plans)
- Select Morning or Evening
- List of current activities with drag-to-reorder or up/down buttons
- Add Activity button → shows list of available `ActivityType`s + metadata fields
- Edit / Delete existing activities
- Save button that updates the `StudyPlan` in SwiftData

This editor must be good enough for the admin to create and tweak real study plans during MVP.

### 8.2.3 Preview as Learner

- Prominent button: "Preview as Learner"
- When tapped, the app temporarily switches the current view to use the selected course and plan as if the admin were a normal user.
- Useful for quickly testing new content or plan changes without creating a separate test account.
- Clear banner or indicator that the user is in Preview mode.
- Easy way to exit preview and return to Admin mode.

## 8.3 How Admin Changes Affect Users

- New content imported via Admin becomes available immediately to all users on that course.
- Changes to the Study Plan affect future days. Past days remain as originally scheduled.
- User progress (`UserActivityCompletion` records) is **never** modified or deleted by admin actions.

## 8.4 Safety & App Store Readiness

- All admin functionality must be wrapped behind a simple `isAdminMode` feature flag (stored in `@AppStorage` or environment).
- Before submission, the admin must be able to completely disable the Admin tab with one action.
- Code comments must clearly explain how to remove/hide admin code for the final build.
- No sensitive operations (full data reset, etc.) should be exposed without confirmation dialogs.

## 8.5 Cursor Implementation Requirements

- Create an `AdminFeatureFlag` that controls visibility of the entire Admin tab and all related UI.
- Build the Content Import flow with proper file/folder picking, validation, and Replace vs Merge options.
- Implement a functional (even if simple) Study Plan Editor that can add, remove, and reorder activities.
- Add a Preview mode that temporarily overrides the current course/plan for testing.
- Make sure admin actions never touch user progress data.
- Keep the admin UI functional and clear, even if not pixel-perfect (we can polish after the learner experience is solid).

Admin mode must be powerful enough for real content and plan management during MVP, while remaining easy to completely disable before release.