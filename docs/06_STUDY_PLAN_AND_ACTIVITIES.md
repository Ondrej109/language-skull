# 06 STUDY PLAN & ACTIVITIES – FULL DETAILED END-TO-END SPEC

## 6.1 Overall Philosophy

The study plan is the heart of Language Skull. It must feel like a real coach designed it — clear, repeatable, and progressive. Every user following the same course sees the exact same activities on the same calendar day. This removes decision fatigue and builds strong habits.

The plan is defined by the admin and is **universal** for all learners on that course. Users only mark activities as done. The app recommends the next session but does not enforce strict daily completion.

## 6.2 Core Data Flow (Detailed)

1. Admin defines a `StudyPlan` (initially in code or via Admin Import in MVP).
2. `StudyPlan` contains `DayPlan` objects (either in a repeating 7-day cycle or progressive multi-week structure).
3. Each `DayPlan` has two ordered arrays: `morningActivities` and `eveningActivities` of type `[ActivityDefinition]`.
4. On any given day, the `StudyPlanEngine` calculates the current day number for the user.
5. It assembles the list of activities for Morning and/or Evening.
6. The user completes activities → `UserActivityCompletion` records are created/updated with timestamp and linked to the specific `activityId`.
7. Progress is reflected on Home, Calendar, and streak views.

## 6.3 ActivityDefinition (Detailed)

```swift
struct ActivityDefinition: Identifiable, Codable {
    let id: String                    // Unique identifier for this activity instance in the plan
    let type: ActivityType
    let metadata: [String: String]    // Flexible parameters (e.g. direction, sectionNumber)
    let order: Int                    // Sort order within the session
}
```

**Why `metadata` dictionary?**
It allows the same `ActivityType` to carry different parameters without creating many subclasses. Examples:
- Flashcards: `["direction": "EF"]` or `["direction": "FE"]`
- Grammar: `["sectionNumber": "3"]`
- Future: `["difficulty": "medium"]` or `["tag": "greetings"]`

## 6.4 ActivityType Enum (Complete MVP List with Examples)

```swift
enum ActivityType: String, Codable {
    // WORDS
    case newWordsList                 // Two-column list (E → F)
    case newWordsFlashcardsEF         // English → Foreign
    case newWordsFlashcardsFE         // Foreign → English
    case revisionWordsD1              // Only words from previous day
    case revisionWordsD3              // Words from last 3 days, original order

    // PHRASES (same structure as Words)
    case newPhrasesList
    case newPhrasesFlashcardsEF
    case newPhrasesFlashcardsFE
    case revisionPhrasesD1
    case revisionPhrasesD3

    // GRAMMAR
    case grammarParagraph             // Shows GrammarSection with matching number
}
```

## 6.5 D-3 Revision Rules (Critical – Must Be Exact)

When presenting a `revisionWordsD3` or `revisionPhrasesD3` activity:

1. Collect **all** words/phrases where `dayIntroduced` is in the range `(currentDay - 3) ... (currentDay - 1)`.
2. Sort them **strictly by `dayIntroduced` ascending**, then by their original order within the same day.
3. Present them as **one continuous session** (no shuffling, no SRS ordering).
4. User goes through the entire combined set once.
5. Mark the whole activity as completed when the user finishes the last item.

This preserves the "original learning order" requirement from the product vision.

## 6.6 Grammar Flow (Detailed)

- Grammar activities are **sequential** by design.
- The plan usually starts with `grammarParagraph` metadata `["sectionNumber": "1"]`.
- When the user completes it, the app records completion for that section.
- The next grammar activity in the plan automatically uses the next section number.
- If the user views a past day, they see the grammar section that was originally scheduled for that day.
- Grammar content is pulled live from the `GrammarSection` model matching the number.

## 6.7 Daily Session Assembly Logic (Detailed Pseudocode)

```swift
func getTodaySession(timeOfDay: TimeOfDay) -> [ActivityDefinition] {
    let currentDay = calculateCurrentDayNumber()   // based on user start date or calendar
    let dayPlan = studyPlan.getDayPlan(for: currentDay)
    
    let rawActivities = (timeOfDay == .morning) 
        ? dayPlan.morningActivities 
        : dayPlan.eveningActivities
    
    return rawActivities.sorted { $0.order < $1.order }
}

// For D-3 revision inside the engine
func getD3RevisionItems(currentDay: Int, type: ActivityType) -> [Word] {
    let startDay = currentDay - 3
    let items = allWords.filter { $0.dayIntroduced >= startDay && $0.dayIntroduced < currentDay }
    return items.sorted { $0.dayIntroduced < $1.dayIntroduced }
}
```

## 6.8 Edge Cases

- User skips days → still show the plan for the current calendar day (no auto-catch-up).
- User jumps to a past day from Calendar → show the exact activities that were scheduled for that day + their completion status.
- Admin updates the plan while users are mid-course → new activities appear for future days; past days remain as originally scheduled.

## 6.9 Cursor Implementation Requirements

- Create a `StudyPlanEngine` actor/service as the single source of truth for session assembly.
- It must correctly implement D-3 revision ordering (original learning order, not randomized).
- Support both repeating 7-day cycles and progressive multi-week plans.
- All activity completion must be recorded with `activityId` + normalized date.
- The engine must be testable in isolation.
- Make sure grammar section numbers advance correctly based on completion.

This engine is critical. Almost every other feature depends on it working correctly.