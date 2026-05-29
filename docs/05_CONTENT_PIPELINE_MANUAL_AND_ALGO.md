# 05 CONTENT PIPELINE – Manual + Future Algorithmic Layer (FULL DETAILED SPEC)

## 5.1 Overview and Goals

The content pipeline is the backbone of Language Skull. It must be reliable, easy for a small content team to maintain, and ready for future automation.

**MVP Goal**: Allow the admin (you) to easily add and update words, phrases, and grammar sections **out of the box** with a working method on day one. The app must load this content on first launch and keep it in sync with user progress.

**Future Goal (Phase 2+)**: Move toward algorithmic generation of personalized daily word sets based on user proficiency and spaced repetition signals.

## 5.2 MVP: Manual Content Pipeline (Current Focus) – Working Out of the Box

### 5.2.1 Concrete Admin Method for Pushing New Lessons (MVP – Functional Day One)

**Primary Method: In-App Admin Import (Recommended for MVP)**

This is the working method the admin uses immediately:

1. Admin opens the app and goes to the **Admin tab** (visible in MVP).
2. Taps **"Import / Update Content"**.
3. Chooses one of two options:
   - **Import Entire Language Folder** (select a folder containing `words.json`, `phrases.json`, `grammar.md`)
   - **Import Individual Files** (select one or more JSON/Markdown files)
4. App performs validation (see 5.2.6).
5. Admin chooses **Replace** or **Merge** for existing content.
6. Content is parsed and saved to SwiftData.
7. User progress is **never deleted**.
8. Admin can immediately use "Preview as Learner" to test the new content.

This flow gives the admin a fully working way to push new lessons without needing to rebuild the app or touch code.

**Secondary Method (for initial content or bulk updates): Bundled JSON + Markdown**

Initial content ships in the app bundle under `Content/<Language>/`. On first launch (or when a new course is added), the `ContentSeeder` automatically loads it. This is useful for the very first set of lessons.

### 5.2.2 Content Sources (Shipped with App)

All initial content lives in the app bundle under `Content/<Language>/`:

- `words.json`
- `phrases.json`
- `grammar.md`

Example folder structure:
```
Content/
├── Spanish/
│   ├── words.json
│   ├── phrases.json
│   └── grammar.md
└── Latin/
    ├── words.json
    ...
```

### 5.2.3 words.json Format (Strict)

```json
[
  {
    "id": "w_spanish_001",
    "english": "Hello",
    "foreign": "Hola",
    "dayIntroduced": 1,
    "difficulty": 1,
    "tags": ["greetings", "basic"]
  },
  {
    "id": "w_spanish_002",
    "english": "Goodbye",
    "foreign": "Adiós",
    "dayIntroduced": 1,
    "difficulty": 1,
    "tags": ["greetings"]
  }
]
```

**Rules**:
- Every word must have a unique `id` (use `w_<language>_<number>` pattern).
- `dayIntroduced` determines when the word first appears in the study plan.
- `difficulty` is used for future algorithmic sorting (1 = easiest).
- `tags` are optional but recommended for future filtering.

### 5.2.4 phrases.json Format
Identical structure to words.json. Use `p_<language>_<number>` for IDs.

### 5.2.5 grammar.md Format

Use simple Markdown with numbered H1 headings:

```markdown
# 1. Basic Greetings

Hola = Hello
Buenos días = Good morning

# 2. Common Verbs

Ser = To be
Estar = To be (location/state)
```

The app parses H1 headings as section numbers.

### 5.2.6 First Launch & Seeding Flow (Detailed)

1. App launches for the first time.
2. `ContentSeeder` service runs.
3. It reads the device locale.
4. It loads the corresponding `Content/<Language>/` folder.
5. It parses `words.json`, `phrases.json`, and `grammar.md`.
6. It creates `Course`, `Word`, `Phrase`, and `GrammarSection` objects in SwiftData.
7. It creates a default `StudyPlan` based on the admin-defined template.
8. It marks the course as the user’s active course.

**Error Handling**:
- If JSON is malformed → show clear error + fallback to English content.
- If grammar.md has no numbered headings → log warning and skip grammar sections.

### 5.2.7 Admin Import Validation Rules (Must Be Implemented)

- All word/phrase IDs must be unique within the language.
- `dayIntroduced` must be a positive integer.
- Grammar sections must have sequential numbers starting from 1.
- File size and structure validation with clear error messages shown to the admin.

## 5.3 Phase 2: Algorithmic Layer (Future)

### 5.3.1 High-Level Idea
Instead of fixed daily word lists, the app can generate personalized daily sets based on:
- Words the user has seen before
- User accuracy/streak on those words
- Spaced repetition signals
- Target difficulty progression

### 5.3.2 Data Needed for Algorithm
- Per-word user performance (correct/incorrect count, last seen date, streak)
- User’s current "mastery level" per topic/tag
- Admin-defined rules for daily new vs review ratio

### 5.3.3 Recommended Approach for Phase 2
Start simple:
- Local on-device algorithm (no backend needed initially).
- Use a basic SM-2 or custom spaced repetition formula.
- Generate 10–15 new/unknown words + 10–15 review words per day.
- Allow admin to set daily new word cap and review cap.

**Do NOT implement in MVP.** Only create the data model hooks and a stub service so the architecture is ready.

## 5.4 Cursor Instructions for This File

When implementing:
- Create a `ContentSeeder` actor/service with clear methods: `seedInitialContent()`, `importLanguageFolder(url:)`, `validateContentFiles(url:)`.
- Make seeding idempotent (safe to run multiple times).
- Store content version in `Course.contentVersion` so future imports can detect updates.
- Never delete user progress during import.
- Log clear, actionable errors for the admin.
- The in-app Admin Import flow must be fully functional on day one of MVP.

This pipeline must feel rock-solid. Content is the product. The admin must have a reliable, working method to push new lessons without rebuilding the app.