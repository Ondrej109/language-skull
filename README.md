# Language Skull

**Premium structured language learning iOS app** built with SwiftUI + SwiftData.

Feels like having a personal coach: clear Morning + Evening daily plans, world-class flashcards, and a sophisticated dark academia aesthetic (Old Oxford / Harvard library vibe).

## Quick Start

1. Clone this repository
2. Open the folder in **Cursor**
3. Read `SETUP.md` for detailed instructions
4. Start with **Phase 1** using the prompts in the `prompts/` folder

## Repository Structure

- `docs/` – Full detailed specifications (data models, flows, UI rules, compliance, etc.)
- `prompts/` – 9 production-grade phase prompts to feed to Cursor
- `SETUP.md` – How to use the prompts + recommended workflow
- `.cursor/rules/` – **Modern Cursor rules system** (`core.mdc` + `design.mdc` with `alwaysApply: true`). These are the authoritative rules enforced in every session.
- `.cursorrules` – Legacy fallback (kept for compatibility; content preserved but deprecated in favor of `.cursor/rules/`)

## How to Build

Follow the phases **strictly in order**:

1. Phase 1: Foundation
2. Phase 2: Onboarding & Auth
3. Phase 3: Content Pipeline & Study Engine
4. Phase 4: Sessions & Activities UI
5. Phase 5: Navigation, Home & Calendar
6. Phase 6: Monetization & Trial
7. Phase 7: Admin Mode & Profile
8. Phase 8: Polish, Referrals, Analytics, Compliance
9. Phase 9: Final Testing & Submission

After each phase, Cursor should give you a completion report. Review it before moving to the next phase.

## Key Principles

- Build production-quality code from day one (no placeholders)
- Test in Simulator after every major component
- Make clean git commits
- Follow the docs and refined aesthetic exactly
- Cursor automatically loads rules from `.cursor/rules/` (alwaysApply files take precedence)

Good luck building Language Skull!