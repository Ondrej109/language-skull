# 01 PROJECT VISION AND BUSINESS RULES – FULL DETAILED END-TO-END SPEC

## 1.1 Core Tagline and Philosophy

**Tagline:** "My language trainer told me exactly what to do today."

Language Skull turns language learning into a **structured daily training program** (Morning + Evening sessions) that feels like having a personal coach. It removes decision fatigue by giving every user on the same course the exact same plan each day. Users simply mark activities as done. The app gently recommends the next session but never forces strict tracking or gamification.

This creates consistency, habit formation, and a premium "coach-like" feeling that most language apps lack.

## 1.2 Branding & Aesthetic (Strict Guidance)

**Name:** Language Skull

**Style:** Sophisticated dark academia — think **Old Oxford or Harvard of 100 years ago**. Polished, elegant, a little dark and mysterious. Refined and premium, with subtle mystery. **Not** parchment, wax, overly ornate gothic, or heavy fantasy aesthetics.

**Color Palette (Exact):**
- Background: #050505
- Surfaces/Cards: #111111 + .ultraThinMaterial / .regularMaterial
- Accent (buttons, progress, highlights): #4A1C1C (muted burgundy)
- Subtle parchment highlight (used sparingly): #D4C4A8
- Text Primary: #FFFFFF
- Text Secondary: #E5E5E5

**UI Philosophy:** Default iOS components first (NavigationStack, TabView, native sheets, liquid glass). The app must feel **modern, ultra-polished, and buttery smooth**. Every interaction should be a joy to use. Flashcard interactions in particular must be world-class: super smooth, satisfying, visually stunning, and delightful.

**Header Rule:** Right side of navigation bar = circular User Avatar. Tap opens native menu with Profile, Manage Plan, Refer a Friend, Sign Out. No skull logo in the header.

## 1.3 Business & Monetization Model (Clear Rules)

- **Free to download** with no forced signup or paywall on first launch.
- Every new user receives a **full 7-day Pro trial** (all languages, all features, admin mode).
- After trial: Monthly auto-renewable subscription required for continued access to new content and new languages.
- Trial languages: Top 5 based on device locale.
- Full catalog (major living + dead + fictional languages) unlocked after subscription.
- Referral program: "You and your friend both get 3 months free" (MVP = local tracking stub + UI; real StoreKit credit in Phase 2).

## 1.4 Target User & Success Criteria

**Target User:** Serious language learners who want structure and consistency rather than gamification or chaotic flashcard decks.

**MVP Success Criteria:**
- User can complete onboarding as guest in under 2 minutes.
- User can complete a full Morning or Evening session on day one.
- Trial-to-paid conversion flow is functional and non-intrusive.
- Admin has a working method to import new content without rebuilding the app.
- All core activity types (lists, flashcards, D-1/D-3 revisions, grammar) work correctly.
- Data persists correctly across launches and guest-to-signed-in transitions.

## 1.5 Content Strategy

**MVP:** Manual content via bundled JSON + Markdown + in-app Admin Import flow (see docs/05 for full details).

**Phase 2+:** Algorithmic generation of daily word sets based on user proficiency and performance (stub architecture prepared in MVP).

## 1.6 Overall MVP Scope Reminder

The MVP must feel like a premium, native iOS app with a clear daily coach-like structure and **world-class interactions** (especially flashcards). Everything else (spaced repetition, audio, cloud sync, web admin, community features) is explicitly out of scope for Phase 1.

This document, combined with the other expanded docs (especially 02, 03, 04, and 05), gives Cursor everything needed to build a functional, shippable end-to-end MVP.