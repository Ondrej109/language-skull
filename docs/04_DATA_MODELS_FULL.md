# 04 DATA MODELS – Complete SwiftData Schema (FULL DETAILED END-TO-END SPEC)

## 4.1 Philosophy and Design Principles

The data layer is the foundation of Language Skull. Every model must be:
- Clear in purpose
- Correctly related (no orphaned data)
- Future-proof for migrations and new features (spaced repetition, cloud sync, multiple courses per user, etc.)
- Easy for Cursor to implement without guessing relationships or delete rules

We use **SwiftData** exclusively in the MVP. No Core Data fallback.

## 4.2 High-Level Model Overview

| Model                    | Purpose                                      | Key Relationships                          | Notes |
|--------------------------|----------------------------------------------|--------------------------------------------|-------|
| `UserProfile`            | One record per user (guest or signed-in)    | Has SubscriptionStatus + many Completions | Central user record |
| `SubscriptionStatus`     | Trial + subscription state                   | Belongs to one UserProfile                 | Critical for monetization |
| `Course`                 | A language/course                            | Has many Words, Phrases, GrammarSections, one StudyPlan | Content container |
| `Word` / `Phrase`        | Individual learning items                    | Belongs to one Course                      | Core learning content |
| `GrammarSection`         | Numbered grammar explanations                | Belongs to one Course                      | Sequential content |
| `StudyPlan`              | The daily schedule template                  | Belongs to one Course                      | Defines Morning/Evening activities |
| `DayPlan`                | One day’s Morning + Evening activities     | Part of a StudyPlan                        | Contains ActivityDefinitions |
| `ActivityDefinition`     | Reusable activity template                   | Part of DayPlan                            | The building block of every session |
| `UserActivityCompletion` | Record that a user finished an activity      | Belongs to one UserProfile                 | Progress tracking |

## 4.3 Detailed Model Definitions

### 4.3.1 UserProfile

```swift
@Model
final class UserProfile {
    @Attribute(.unique) var id: String
    var firstName: String?
    var appleUserID: String?           // nil = guest mode
    var createdAt: Date
    var targetLanguage: String
    var proficiencyLevel: ProficiencyLevel
    var notificationEnabled: Bool = false

    @Relationship(deleteRule: .cascade, inverse: \SubscriptionStatus.user)
    var subscriptionStatus: SubscriptionStatus?

    @Relationship(deleteRule: .cascade, inverse: \UserActivityCompletion.user)
    var completions: [UserActivityCompletion] = []

    init(...) { ... }
}
```

**Design Notes**:
- One `UserProfile` per person (even in guest mode).
- `appleUserID` is set only after successful Sign in with Apple.
- Guest progress must be mergeable later when the user signs in.
- `proficiencyLevel` is used during initial seeding to decide starting day.

### 4.3.2 SubscriptionStatus

```swift
@Model
final class SubscriptionStatus {
    var isPro: Bool = false
    var trialEndDate: Date?
    var subscriptionEndDate: Date?
    var lastReceiptValidationDate: Date?

    @Relationship(inverse: \UserProfile.subscriptionStatus)
    var user: UserProfile?
}
```

**Important**: This model must be updated both from StoreKit transactions **and** from receipt validation on launch.

### 4.3.3 Course, Word, Phrase, GrammarSection

These are the **content** models. They are mostly immutable after import.

- `Course` is the top-level container for one language.
- `Word` and `Phrase` have `dayIntroduced` which controls when they first appear in the study plan.
- `GrammarSection` uses `number` for sequential unlocking.

**Relationship Rules**:
- When a `Course` is deleted, all its Words, Phrases, and GrammarSections must cascade delete.
- User progress (`UserActivityCompletion`) must **never** be deleted when content is re-imported.

### 4.3.4 StudyPlan, WeekPlan, DayPlan, ActivityDefinition

This hierarchy defines the daily schedule.

- `StudyPlan` belongs to one `Course`.
- It contains `WeekPlan` objects (or direct `DayPlan` for simple repeating plans).
- Each `DayPlan` has two arrays: `morningActivities` and `eveningActivities`.
- `ActivityDefinition` is the reusable template (type + metadata + order).

**Why this structure?**
- Allows both simple 7-day repeating plans and progressive multi-week plans.
- `metadata` dictionary on `ActivityDefinition` lets the same activity type carry different parameters (e.g. flashcard direction, grammar section number).

### 4.3.5 UserActivityCompletion

```swift
@Model
final class UserActivityCompletion {
    var date: Date                      // normalized to start of day
    var activityId: String              // matches ActivityDefinition.id
    var isCompleted: Bool = false
    var completedAt: Date?

    @Relationship(inverse: \UserProfile.completions)
    var user: UserProfile?
}
```

This is the main progress record. Every time a user taps "Mark as Done", one of these is created or updated.

## 4.4 Seeding & Admin Import Interaction

- `ContentSeeder` creates initial `Course`, `Word`, `Phrase`, `GrammarSection`, and `StudyPlan` objects from bundled JSON/Markdown.
- Admin Import can **replace or merge** content.
- When merging, existing `Word`/`Phrase` records are updated by `id`. New ones are added. User completions are never touched.

## 4.5 Migration Strategy

Use SwiftData’s `SchemaMigrationPlan` from the beginning.

Planned future changes that require migration:
- Adding `lastSeenDate` and performance stats to `Word`/`Phrase` (for spaced repetition)
- Allowing a user to have multiple active courses
- Adding cloud sync identifiers

Create the migration plan early even if the first version has no migrations.

## 4.6 Cursor Implementation Requirements

- Implement **all** models exactly as shown.
- Use `@Attribute(.unique)` on all `id` fields.
- Define proper `inverse` relationships on every `@Relationship`.
- Use `.cascade` delete rules appropriately (content cascades, progress does not).
- Create a `ContentSeeder` actor with clear methods.
- Create a `StudyPlanEngine` that can build daily sessions from these models.
- Make sure admin import never deletes user progress records.

These models must be correct the first time. Changing relationships later is painful.