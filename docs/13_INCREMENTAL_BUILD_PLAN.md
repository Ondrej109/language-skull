# 13 INCREMENTAL BUILD PLAN – FULL DETAILED END-TO-END SPEC

## 13.1 Philosophy

We build Language Skull in clear, testable phases. After each phase, the app should be in a runnable, demonstrable state. This allows early validation and reduces risk.

After completing each phase, Cursor must output:
- "✅ Phase X Completed"
- Detailed checklist of what was implemented
- Any missing deliverables or decisions needed
- "Ready for Phase Y"

## 13.2 Phase Breakdown

### Phase 1: Foundation
**Goal**: Project skeleton + data layer + basic theming that compiles and runs.

**Tasks**:
- Create new SwiftUI iOS 18+ project
- Set up `.cursorrules` and docs/ folder
- Implement all SwiftData models from docs/04
- Create `ContentSeeder` with bundled JSON/Markdown loading
- Basic gothic dark color palette + Theme
- Simple Home screen with placeholder cards
- Admin feature flag (hidden by default in release builds)

**Deliverables**:
- App launches without crash
- Sample content seeds correctly
- Basic navigation works
- Admin toggle exists

### Phase 2: Onboarding & Auth
**Goal**: Complete guest + Sign in with Apple onboarding flow.

**Tasks**:
- Implement full onboarding flow from docs/03
- Guest profile creation and persistence
- Apple Sign In integration + merge logic
- Notification permission request
- First content seeding based on chosen language + proficiency
- Navigate to Home after onboarding

**Deliverables**:
- User can complete onboarding as guest
- Sign in with Apple works and merges progress
- First session is shown after onboarding

### Phase 3: Content Pipeline & Study Engine
**Goal**: Robust content loading + daily session assembly.

**Tasks**:
- Finalize `ContentSeeder` and Admin Import flow
- Build `StudyPlanEngine` with D-1 and D-3 revision logic
- Implement all `ActivityType` cases
- Connect activities to `UserActivityCompletion` records
- Support jumping to past days from Calendar

**Deliverables**:
- All activity types work correctly
- D-3 revisions show correct original order
- Sessions assemble properly for any day

### Phase 4: Sessions & Activities UI
**Goal**: Polished, usable activity screens.

**Tasks**:
- Two-column list view
- Flashcard view (tap to flip + swipe)
- Grammar paragraph view
- "Mark as Done" with proper persistence and animation
- Session completion celebration

**Deliverables**:
- All activity UIs are functional and feel native
- Progress is saved correctly

### Phase 5: Navigation, Home & Calendar
**Goal**: Main app navigation and progress visualization.

**Tasks**:
- Home/Dashboard with Morning/Evening cards and progress rings
- Bottom TabView (Home, Calendar, Admin, Profile)
- Calendar view showing past days + completion status
- Avatar menu with Profile / Manage Plan / Refer a Friend / Sign Out

**Deliverables**:
- Smooth navigation between tabs
- Calendar correctly shows historical data
- Avatar menu works as specified

### Phase 6: Monetization & Trial
**Goal**: Working 7-day trial + subscription flow.

**Tasks**:
- `SubscriptionManager` with StoreKit 2
- Trial tracking and expiry logic
- Contextual paywall
- Manage Plan screen with full billing info
- Restore Purchases
- Receipt validation on launch

**Deliverables**:
- 7-day trial works end-to-end
- Paywall appears correctly after trial
- Subscription and restore function in Sandbox

### Phase 7: Admin Mode & Profile
**Goal**: Functional admin tools + profile management.

**Tasks**:
- Full Admin tab (Content Import, Study Plan Editor, Preview as Learner)
- Profile screen with progress stats
- Referral share sheet + local tracking stub
- Easy "Hide Admin Mode" toggle for release

**Deliverables**:
- Admin can import content and edit plans
- Preview mode works
- Referral flow is functional (stub)

### Phase 8: Polish, Referrals, Analytics, Compliance
**Goal**: Production readiness.

**Tasks**:
- Firebase Analytics + Crashlytics integration
- Full referral flow testing
- Accessibility audit + Dynamic Type
- Privacy Policy + App Privacy section
- Final App Store compliance checks
- Remove/hide Admin mode for release build

**Deliverables**:
- Analytics events firing correctly
- Crashes symbolicated in Firebase
- App is ready for App Store review

### Phase 9: Final Testing & Handover
**Goal**: Stable, tested MVP ready for submission.

**Tasks**:
- Full end-to-end testing of all flows
- Fix any remaining bugs
- Update documentation if needed
- Prepare TestFlight build
- Final code review pass

**Deliverables**:
- Stable build that passes basic QA
- All major flows work without crashes
- Ready for App Store submission

## 13.3 Cursor Instructions

Follow this plan strictly, one phase at a time.
After each phase, provide the completion report as described in 13.1.
Do not skip phases or combine them unless explicitly instructed.