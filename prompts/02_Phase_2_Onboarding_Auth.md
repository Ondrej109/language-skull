# Phase 2: Onboarding & Auth (Production-Grade)

**Goal**  
Deliver a complete, smooth, premium-feeling onboarding experience that supports both guest mode and Sign in with Apple, with correct progress merging. This must feel like a high-quality native app from the first tap.

## Strict Requirements (Do Not Skip)

### 1. Onboarding Flow (docs/03)
Implement the **full progressive disclosure flow** exactly as specified:

1. **Launch Screen**  
   - Stylized skull logo with subtle parchment/glow animation  
   - Large primary button: “Begin Training”  
   - Small text: “No account needed to start”

2. **Optional Quick Guest Demo** (strongly recommended)  
   - One short activity (e.g. New Words two-column list)  
   - User can complete or skip  
   - Then proceed to full onboarding questions

3. **Onboarding Questions** (linear with progress indicator):
   - First name (optional) + “Continue as Guest” option
   - Target language selection (5 locale-aware options with flags)
   - Proficiency level (Beginner / Know Basic Words / Intermediate / Advanced / Fluent)
   - Notification permission request (morning reminder only, with clear explanation)

4. **Apple Sign In**  
   - Prominent “Sign in with Apple” button  
   - Smaller “Continue as Guest” option below

### 2. Guest Profile & Persistence
- Create a `UserProfile` on first launch if none exists.
- Store `targetLanguage`, `proficiencyLevel`, and `notificationEnabled`.
- Guest profiles must be mergeable later (see merge logic below).

### 3. Apple Sign In + Merge Logic (Critical)
- Implement full Sign in with Apple using `ASAuthorizationAppleIDProvider`.
- On successful sign-in:
  - Check if a profile already exists with this `appleUserID`.
  - If yes → merge all `UserActivityCompletion` records from the guest profile into the signed-in profile.
  - Never lose progress.
  - Update `firstName` if provided.
- Handle all error states gracefully with user-friendly messages.

### 4. Content Seeding After Onboarding
- After language + proficiency selection, trigger `ContentSeeder`.
- Calculate starting day based on proficiency level (e.g. Beginner = Day 1, Intermediate = Day 4, etc.).
- Seed the chosen language’s content.
- Create initial `StudyPlan` and navigate directly to `HomeView` showing Today’s Morning session.

### 5. Notification Permission
- Request notification permission with a clear, friendly explanation.
- Store the user’s choice in `UserProfile`.
- Do **not** block the user if they deny permission.

### 6. Testing & Validation Discipline
After implementing each major part:
1. Build + run in Simulator.
2. Test the full flow:
   - Fresh install → Launch screen → Quick demo → Onboarding questions → Apple Sign In (or guest) → Seeding → Home screen
3. Test merge logic (create guest progress → sign in → verify progress is preserved).
4. Only proceed after successful Simulator test.

### 7. Git Discipline
Make clean commits such as:
- `feat: Add launch screen and quick demo`
- `feat: Implement full onboarding questions flow`
- `feat: Add Apple Sign In with merge logic`
- `feat: Wire up content seeding after onboarding`

## Final Deliverables for Phase 2

- [ ] Full onboarding flow works smoothly
- [ ] Guest mode works end-to-end
- [ ] Apple Sign In works and merges progress correctly
- [ ] Notification permission request is implemented
- [ ] Content seeds correctly based on chosen language + proficiency
- [ ] User lands on Home screen with Today’s Morning session after onboarding
- [ ] All flows tested successfully in Simulator
- [ ] Git history is clean

## Cursor Instructions (Follow Exactly)

You are building a **premium onboarding experience**, not a basic form.

- Follow `docs/03_ONBOARDING_FLOW.md` strictly.
- Make every screen feel polished and native.
- After completing this phase, respond with:

```
✅ Phase 2 Completed

Checklist:
- [ ] Launch + quick demo working
- [ ] Full onboarding questions implemented
- [ ] Apple Sign In + merge logic working
- [ ] Content seeding after onboarding working
- [ ] Notification permission handled
- [ ] Simulator tested successfully

Missing items / decisions needed:
- 

Ready for Phase 3.
```

Do **not** move to Phase 3 until the above report is given.