# Phase 8: Polish, Referrals, Analytics, Compliance (Production-Grade)

**Goal**  
Polish the app for production quality, integrate analytics and crash reporting, complete the referral flow, ensure accessibility, and prepare everything for App Store submission.

## Strict Requirements (Do Not Skip)

### 1. Firebase Integration
- Add Firebase Analytics and Crashlytics.
- Log key events:
  - Onboarding completed
  - Session completed
  - Trial started / ended
  - Subscription started
  - Referral link shared / captured
- Ensure dSYMs are uploaded so crashes are symbolicated.
- Test that crashes appear correctly in Firebase console.

### 2. Referral Flow Completion
- Full end-to-end testing of referral:
  - Share from app → install on another device/simulator → code capture on first launch → subscription → benefit flag appears on referrer.
- Make the MVP stub obvious in code comments so it can be upgraded later.

### 3. Accessibility & Polish
- Full accessibility audit:
  - Proper labels, hints, and values on all interactive elements
  - Dynamic Type support across the app
  - Sufficient color contrast with the dark gothic palette
- Add subtle, high-quality haptic feedback on important actions (Mark as Done, session complete).
- Review all animations for smoothness and premium feel.

### 4. Privacy Policy & App Privacy Section
- Add a publicly accessible Privacy Policy URL in App Store Connect.
- Complete the App Privacy section accurately (Analytics, Crash Data, User ID, Subscriptions, Referrals).
- Ensure the in-app experience matches the declared data collection.

### 5. Final App Store Compliance Checks
- Export compliance questions answered correctly.
- Admin mode completely hidden/disabled in the release build.
- All analytics events firing correctly.
- Receipt validation and subscription handling tested in Sandbox.
- Prepare screenshots, description, and keywords.

### 6. Testing & Validation Discipline
- Full end-to-end testing of all major flows.
- Accessibility testing with VoiceOver.
- Test referral flow completely.
- Verify Admin tab is hidden in release configuration.
- Only proceed after successful tests.

### 7. Git Discipline
Example commits:
- `feat: Integrate Firebase Analytics and Crashlytics`
- `feat: Complete referral flow testing`
- `feat: Accessibility audit and Dynamic Type support`
- `feat: Add Privacy Policy and complete App Privacy section`
- `feat: Hide Admin mode and final compliance checks`

## Final Deliverables for Phase 8

- [ ] Firebase Analytics + Crashlytics integrated and tested
- [ ] Referral flow fully tested end-to-end
- [ ] Accessibility audit passed + Dynamic Type supported
- [ ] Privacy Policy URL added and App Privacy section completed
- [ ] Admin mode hidden in release build
- [ ] All compliance items ready for App Store submission
- [ ] Simulator + device tested successfully
- [ ] Git history is clean

## Cursor Instructions (Follow Exactly)

This phase turns the app from "working" into "shippable".

After completing this phase, respond with:

```
✅ Phase 8 Completed

Checklist:
- [ ] Firebase done
- [ ] Referral flow done
- [ ] Accessibility done
- [ ] Privacy + compliance done
- [ ] Admin hidden in release
- [ ] Simulator + device tested successfully

Missing items / decisions needed:
- 

Ready for Phase 9.
```

Do **not** move to Phase 9 until the above report is given.