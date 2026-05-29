# 09 END-TO-END USER FLOWS – FULL DETAILED END-TO-END SPEC

## 9.1 First Launch Flow (Complete Detailed Path)

1. Cold launch → Show splash screen with stylized skull logo and subtle parchment/glow animation.
2. Check if a `UserProfile` exists in SwiftData.
3. **If no profile exists**:
   - Create a new guest `UserProfile`.
   - Proceed to Optional Quick Guest Demo (see 03_ONBOARDING_FLOW.md).
4. **If profile exists but no active course**:
   - Trigger language + proficiency selection (or resume onboarding if incomplete).
5. **If everything exists**:
   - Navigate directly to Home/Dashboard showing Today’s Morning session with progress.

Onboarding must feel low-pressure and give the user immediate value (at least one activity) before asking for Sign in with Apple.

## 9.2 Daily Usage Flow – Morning Example (Step by Step)

1. User opens the app in the morning.
2. Home screen shows:
   - Greeting ("Good morning")
   - Today’s date and current streak
   - Morning progress ring/card with completion percentage
   - Evening card (grayed or with estimated time)
3. User taps the Morning card.
4. Sees a clean linear list of activities for the session, each with:
   - Activity name/type
   - Short description
   - "Mark as Done" button (or checkmark if already completed)
5. User completes activities one by one. Each tap creates/updates a `UserActivityCompletion` record.
6. After the last activity:
   - Show success animation / confetti
   - Clear message: "Great work! Evening session recommended."
7. Home screen updates the Morning progress ring to 100%.
8. If all Morning activities are done, gently highlight the Evening card.

## 9.3 Daily Usage Flow – Evening

Similar to Morning, but triggered from the Evening card on Home.
After completion, show overall daily progress and a gentle message about tomorrow’s plan.

## 9.4 Jumping to Past Days (from Calendar)

1. User opens Calendar tab.
2. Taps any past day.
3. App shows the exact activities that were scheduled for that day.
4. Completed activities show as checked / with completion time.
5. User can re-do activities if desired (creates new completion record or updates existing one).

## 9.5 Trial Expiry Flow (Detailed)

1. On launch (and before showing locked content), `SubscriptionManager` checks `SubscriptionStatus.trialEndDate`.
2. If trial has ended and user has no active subscription:
   - Mark user as trial-expired in the model.
   - Show contextual paywall (value-first, not aggressive).
3. User can still view previously unlocked content and completed sessions.
4. New days, new languages, and new grammar sections are locked.
5. Clear, friendly messaging: "Your 7-day trial has ended. Subscribe to continue building your progress."
6. Prominent "Subscribe" and "Restore Purchases" buttons.

## 9.6 Referral Flow (MVP Stub – Detailed)

1. User taps "Refer a Friend" in the avatar menu.
2. Native share sheet appears with pre-filled message: "Join me on Language Skull and we both get 3 months free!" + unique referral link.
3. The link contains a referral code generated and stored locally in the user’s profile.
4. When a new user installs the app via the link and opens it for the first time, the app reads the referral code (via `onOpenURL` or Universal Links).
5. The code is stored in the new user’s `UserProfile.referredBy`.
6. On successful subscription, a local flag is set marking the referrer as eligible for the 3-month benefit (stub for MVP).

Full automatic application of the 3-month credit via StoreKit happens in Phase 2.

## 9.7 Session Completion & Streak Logic

- A day is considered "complete" when all Morning + Evening activities are marked done.
- Streak increments only on days where the user completed at least one full session (Morning or Evening).
- Missed days do not break the streak immediately (grace period of 1–2 days can be discussed).

## 9.8 Cursor Implementation Requirements

- Create clear, linear flows using `NavigationStack` and state-driven navigation.
- Make the `StudyPlanEngine` the single source of truth for what activities belong to any given day.
- All completion recording must go through a central `ProgressRepository`.
- Trial expiry checks must happen on launch and before showing locked content.
- Referral link handling must work reliably on first launch after install.
- Keep all flows testable and easy to follow in code.

These flows must feel smooth, respectful, and consistent with the "personal coach" feeling of the app.