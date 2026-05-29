# Language Skull – Setup & How to Build with Cursor

This repository contains everything needed to build **Language Skull**, a premium structured language learning iOS app, using Cursor AI.

## Quick Start

1. Clone this repo
2. Open the project folder in Cursor
3. Start with **Phase 1**

## How to Use the Phase Prompts

All prompts live in the `prompts/` folder.

### Recommended Workflow

For each phase:

1. Open the corresponding file in `prompts/` (e.g. `01_Phase_1_Foundation.md`)
2. Copy the **entire content** of the file
3. In Cursor, open a new chat (or use Composer with `Cmd + I`)
4. Paste the prompt
5. Add one of these starter lines:
   - "Build this phase exactly as described."
   - "Implement Phase X following the instructions in this prompt."
6. Let Cursor work through the phase

### After Cursor Finishes a Phase

Cursor should respond with a completion report in this format:

```
✅ Phase X Completed

Checklist:
- [ ] ...

Missing items / decisions needed:
- ...

Ready for Phase Y.
```

**Do not move to the next phase** until you have reviewed the report and are satisfied with the results.

## Phase Order

Follow this order strictly:

1. Phase 1: Foundation
2. Phase 2: Onboarding & Auth
3. Phase 3: Content Pipeline & Study Engine
4. Phase 4: Sessions & Activities UI
5. Phase 5: Navigation, Home & Calendar
6. Phase 6: Monetization & Trial
7. Phase 7: Admin Mode & Profile
8. Phase 8: Polish, Referrals, Analytics, Compliance
9. Phase 9: Final Testing & Submission

## Important Documents

- `docs/` → Full detailed specifications (data models, flows, UI rules, etc.)
- `.cursor/rules/` → **Primary rules system** (`core.mdc` for architecture/coding standards + `design.mdc` for quality bar, colors, and aesthetic). Both use `alwaysApply: true` so Cursor enforces them automatically in every session.
- `.cursorrules` → Legacy global rules file (kept as fallback for older setups; all original content preserved)
- `prompts/` → Phase-by-phase build instructions

## Cursor Rules Migration Note

We have migrated from the single `.cursorrules` file to Cursor's modern `.cursor/rules/` directory structure. This provides:
- Better organization and maintainability
- YAML frontmatter for metadata (`alwaysApply`, `description`, globs if needed)
- Logical split: core engineering rules vs. design system rules
- Future-proofing as the project grows

Cursor will pick up the `.mdc` files automatically. The legacy file remains for compatibility.

## Prerequisites

Before starting Phase 1 you should have:
- Apple Developer Program membership
- Xcode 16+ with iOS 18 SDK
- Basic familiarity with SwiftUI and SwiftData

## Tips for Best Results

- Always test in Simulator after major components (as specified in each phase prompt)
- Make clean git commits after each logical piece of work
- Be strict about the checklists in each phase prompt
- If something is ambiguous, ask Cursor to clarify using the docs
- The rules in `.cursor/rules/core.mdc` and `design.mdc` are non-negotiable and loaded automatically

## Support

If Cursor produces code that doesn't match the spec, paste the relevant section from the docs and ask it to fix it.

Good luck building Language Skull!