# Phase 9: Final Testing & Handover (Production-Grade)

**Goal**  
Deliver a stable, well-tested, production-ready MVP that is ready for TestFlight and App Store submission.

## Strict Requirements (Do Not Skip)

### 1. Full End-to-End Testing
Test every major flow thoroughly:
- Fresh install → Onboarding (guest + Sign in with Apple) → Content seeding → Home screen
- Complete Morning and Evening sessions for multiple days
- D-3 revision sessions in correct original order
- Jumping to past days from Calendar and re-doing activities
- Trial expiry flow and paywall
- Subscription purchase and restore in Sandbox
- Manage Plan screen
- Avatar menu (Profile, Manage Plan, Refer a Friend, Sign Out)
- Admin Import and Study Plan Editor
- Referral share + link capture + benefit flag

### 2. Bug Fixing
- Fix any crashes or major bugs found during testing.
- Address any performance issues (especially flashcard swipe/flip).
- Ensure all animations are smooth and premium.

### 3. Documentation & Code Cleanup
- Update any outdated comments or documentation.
- Remove or clearly comment any remaining MVP stubs (especially referral benefit application).
- Ensure Admin mode is completely hidden in the release build configuration.
- Final code review pass for architecture, naming, and consistency.

### 4. Build Preparation
- Create a clean release build.
- Prepare for TestFlight:
  - Proper app icon and launch screen
  - All required screenshots and metadata ready in App Store Connect
  - Privacy Policy URL live
  - App Privacy section completed

### 5. Final Validation
- Run the app on a physical device (not just Simulator).
- Test Sign in with Apple on real device.
- Test subscription flow end-to-end in Sandbox on device.
- Verify no Admin tab appears in release build.
- Confirm analytics events are firing correctly.

### 6. Git Discipline
Example commits:
- `chore: Final end-to-end testing and bug fixes`
- `chore: Hide Admin mode for release build`
- `chore: Prepare TestFlight build and metadata`
- `docs: Final documentation cleanup`

## Final Deliverables for Phase 9

- [ ] Full end-to-end testing of all major flows completed
- [ ] All critical bugs fixed
- [ ] Admin mode hidden in release build
- [ ] Privacy Policy and App Privacy section ready
- [ ] Clean release build prepared for TestFlight
- [ ] App tested successfully on physical device
- [ ] Ready for App Store submission
- [ ] Git history is clean

## Cursor Instructions (Follow Exactly)

This is the final polish phase. Be thorough and honest about readiness.

After completing this phase, respond with:

```
✅ Phase 9 Completed

Checklist:
- [ ] Full E2E testing done
- [ ] Bugs fixed
- [ ] Admin hidden
- [ ] Privacy + compliance ready
- [ ] TestFlight build prepared
- [ ] Physical device tested

Missing items / decisions needed:
- 

App is ready for TestFlight / App Store submission.
```

This completes the MVP build.