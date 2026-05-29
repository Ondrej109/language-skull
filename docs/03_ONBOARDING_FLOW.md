# 03 ONBOARDING FLOW – FULL DETAILED END-TO-END SPEC (No Forced Signup)

## 3.1 Core Philosophy

Language Skull must feel transparent and respectful from the first second. Users should be able to try the core experience immediately as a guest. Apple Sign In is strongly encouraged but never forced before the user has seen value.

This approach matches the best modern apps and reduces early churn.

## 3.2 Complete First-Launch Flow (Step by Step)

### Step 1: Launch Screen
- Show stylized skull logo with subtle parchment/glow animation.
- Large primary button: “Begin Training”
- Small secondary text: “No account needed to start”

Tapping “Begin Training” immediately creates a guest `UserProfile` and proceeds to quick demo or language selection.

### Step 2: Optional Quick Guest Demo (Strongly Recommended)

After creating the guest profile:
1. Show a single short activity (e.g., New Words two-column list for a sample language like Spanish).
2. Let the user complete it or skip.
3. After completion/skipping → move to full onboarding questions.

This gives the user an immediate taste of the product before asking for any information.

### Step 3: Onboarding Questions (Progressive Disclosure)

Use a linear flow with progress indicator at the top.

**Question 1: First Name (Optional)**
- Text field
- Placeholder: “What should we call you?”
- Clear “Skip” or “Continue as Guest” button

**Question 2: Target Language**
- Show 5 locale-aware options (use `Locale.current` to prioritize).
- Example for English device: Spanish, French, German, Italian, Portuguese.
- Each option shows flag + native name + English name.
- Use a clean list or segmented control.

**Question 3: Current Proficiency**
- Single choice: Beginner / Know Basic Words / Intermediate / Advanced / Fluent
- This determines the starting `dayIntroduced` offset when seeding content.

**Question 4: Notifications (Morning Reminder)**
- Clear explanation: “We’ll send one gentle reminder each morning so you never miss your training.”
- Native iOS notification permission prompt.
- User can deny; app still works fully.

### Step 4: Apple Sign In (Strongly Encouraged)

- Large primary button: “Sign in with Apple”
- Smaller text below: “Sync your progress across devices and never lose your streak.”
- Prominent “Continue as Guest” option

When user signs in:
- Create or update `UserProfile` with `appleUserID`
- Merge any existing guest progress into the signed-in profile (do not duplicate completions).

### Step 5: Content Seeding + First Session

After language + proficiency selection:
1. `ContentSeeder` loads the chosen language’s bundled content.
2. Calculates starting day based on proficiency (e.g. Beginner = Day 1, Intermediate = Day 4, etc.).
3. Creates initial `StudyPlan` and `UserActivityCompletion` records if needed.
4. Navigates user directly to Home/Dashboard showing Today’s Morning session.

## 3.3 Guest → Signed-In Merge Logic (Critical)

When a guest user later signs in with Apple:
- Find existing `UserProfile` by `appleUserID` or create new one.
- Copy all `UserActivityCompletion` records from the guest profile to the signed-in profile.
- Update `targetLanguage`, `proficiencyLevel`, and notification preference from guest profile.
- Delete or mark the old guest profile (or keep it for analytics).
- Never lose progress.

## 3.4 Edge Cases & Error Handling

- User denies all permissions → still create profile and let them use the app.
- User closes app during onboarding → on next launch, resume from last completed step or start fresh if no profile exists.
- Invalid language selection → fall back to English content with clear message.
- Sign in with Apple fails → show clear error and offer to continue as guest.

## 3.5 UI & Navigation Requirements

- Use `NavigationStack` with large titles.
- Progress bar or stepper at top of onboarding screens.
- All screens support swipe-back gesture.
- Use default iOS dark appearance + our gothic color palette.
- Keep copy warm, encouraging, and low-pressure.

## 3.6 Cursor Implementation Rules

- Create an `OnboardingCoordinator` or use a state machine to manage the multi-step flow.
- Make guest profile creation idempotent.
- Implement a clear `mergeGuestProgress(into:)` function.
- Track onboarding completion event for analytics.
- Do not force Sign in with Apple before the user has completed at least one activity.

This flow must feel respectful and low-friction while still guiding the user into the core habit.