# Language Skull - Bundled Content (MVP Starter)

This folder contains parallel vocabulary and phrase data for all supported language courses.

## Files Generated

- `es_words.json` / `es_phrases.json` → Spanish
- `de_words.json` / `de_phrases.json` → German
- `fr_words.json` / `fr_phrases.json` → French
- `it_words.json` / `it_phrases.json` → Italian
- `pt_words.json` / `pt_phrases.json` → Portuguese (Brazilian)
- `en_words.json` / `en_phrases.json` → English (for testing / English course)

## Key Design Decision (Why This Structure?)

All languages share **identical**:
- IDs (`w001`, `p001`, etc.)
- Order in the arrays
- English text
- Categories
- Difficulty levels

Only the `foreign` field differs.

**This is intentional and recommended.**

It allows your `StudyPlanEngine` (see `docs/06_STUDY_PLAN_AND_ACTIVITIES.md`) to define a single universal plan like:

> "Day 1 Morning: Introduce words w001–w010 + phrases p001–p003"

This plan works **identically** for Spanish, German, French, etc. without any language-specific logic in the engine. The admin can later create language-specific variations if desired.

## JSON Schema

Each file contains:

```json
{
  "language": "es",
  "language_name": "Spanish",
  "content_type": "words",
  "version": 1,
  "words": [
    {
      "id": "w001",
      "english": "Hello",
      "foreign": "Hola",
      "category": "greetings",
      "difficulty": 1
    }
  ]
}
```

Same structure for phrases (key is `"phrases"`).

## Integration with Your App

1. Copy these files into your Xcode project under `Resources/Content/` (or wherever your `ContentSeeder` looks).
2. Update `ContentSeeder.swift` to load the correct `{lang}_words.json` and `{lang}_phrases.json` based on the selected course.
3. The `StudyPlan` (from `docs/04` and `docs/06`) references these by `id`.
4. When seeding a new course, map the content into your SwiftData `Word` and `Phrase` models (set `dayIntroduced` based on the active `StudyPlan` if desired).

## Current Scope (MVP Starter)

- **30 words** across practical categories (greetings, politeness, food/drink, family, adjectives, numbers, questions)
- **15 phrases** (greetings, introductions, travel, communication)

This is enough to build and test the full study planner, flashcards, D-1/D-3 revisions, and admin import flows.

## Recommended Next Steps

- Expand to 60–80 words and 30–40 phrases once the core engine is solid.
- Add audio pronunciation fields later (Phase 8+).
- Consider adding a `tags` array or `example_sentence` for richer flashcards in the future.

## Notes on Translations

- Spanish: Standard neutral Spanish
- German: Standard German
- French: Standard French
- Italian: Standard Italian
- Portuguese: Brazilian Portuguese (most common for learners)
- English: Mirrors the English side (useful for UI testing and as a "learn English" course)

All translations are beginner-appropriate and natural.

---

Generated for Language Skull – consistent, production-ready content foundation.
