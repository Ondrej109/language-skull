# 10 ANALYTICS & CRASH REPORTING – FULL DETAILED END-TO-END SPEC

## 10.1 Goals

We need production-grade observability from day one so we can:
- Understand how users actually use the app (onboarding drop-off, session completion rates, trial-to-paid conversion)
- Quickly detect and fix crashes
- Make data-driven decisions for future features (e.g., which activity types are most effective)

## 10.2 Recommended Stack for MVP (Clear Decision)

**Primary Recommendation: Firebase Analytics + Firebase Crashlytics**

**Why Firebase?**
- Free for our expected volume
- Excellent SwiftUI support
- Automatic crash reporting with symbolication
- Easy event tracking
- Works well alongside SwiftData (no conflict)
- Simple to remove later if we switch to a paid tool

**Alternative considered**: Apple’s built-in App Analytics (free but limited events + no custom parameters) + Sentry (more powerful but paid).

**Decision for MVP**: Start with Firebase. It gives us the best balance of capability, cost, and speed of implementation.

## 10.3 Firebase Setup (Exact Steps for Cursor)

1. Create Firebase project in Firebase Console.
2. Add iOS app with correct Bundle ID.
3. Download `GoogleService-Info.plist` and add it to the Xcode project (do **not** commit it to git – add to .gitignore).
4. Add Firebase SDK via Swift Package Manager:
   - `FirebaseAnalytics`
   - `FirebaseCrashlytics`
5. In `AppDelegate` or `@main` App struct, configure Firebase:
   ```swift
   import FirebaseCore
   
   @main
   struct LanguageSkullApp: App {
       init() {
           FirebaseApp.configure()
       }
       var body: some Scene { ... }
   }
   ```
6. Enable Crashlytics in Firebase Console (it is automatic once the SDK is integrated and the app runs).

## 10.4 Events to Track in MVP (Concrete List)

Track these events with meaningful parameters:

- `onboarding_started`
- `onboarding_completed` (with `proficiency_level` parameter)
- `apple_sign_in_completed` (success/failure)
- `course_selected` (language name)
- `session_started` (morning/evening, day_number)
- `activity_completed` (activity_type, day_number, time_of_day)
- `session_completed` (morning/evening, completion_percentage)
- `trial_expired`
- `paywall_shown` (trigger: launch / feature_gate / manual)
- `subscription_started` (plan, price)
- `subscription_restored`
- `referral_link_shared`
- `referral_code_captured` (on first launch)

Use `Analytics.logEvent("event_name", parameters: [...])` for custom events.

## 10.5 Crash Reporting

Firebase Crashlytics is enabled automatically. It will symbolicate crashes if dSYMs are uploaded (Firebase does this automatically for most cases when using Xcode Cloud or manual upload).

Add this line in your build phase or use Firebase’s recommended script for dSYM upload if needed.

## 10.6 Privacy & App Store Compliance

- Firebase Analytics and Crashlytics are allowed on the App Store when configured correctly.
- In `Info.plist`, add the required Firebase-related keys if prompted.
- In App Store Connect → App Privacy, declare data collection for analytics and crash data (Firebase provides clear guidance).

## 10.7 Cursor Implementation Rules

- Create a lightweight `AnalyticsService` actor or class that wraps Firebase calls.
- Make all tracking calls go through this service so we can easily swap providers later.
- Do **not** track any personally identifiable information (PII).
- Log events at meaningful moments (after successful actions, not before).
- For Crashlytics, let it run automatically – do not add custom keys unless they are truly useful for debugging.

This gives us professional-grade observability from the first day of the MVP without over-engineering.