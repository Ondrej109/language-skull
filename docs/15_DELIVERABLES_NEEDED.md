# 15 DELIVERABLES NEEDED – FULL DETAILED END-TO-END SPEC

## 15.1 Before Starting the Build (High Priority)

### 15.1.1 Apple Developer Account
- Active Apple Developer Program membership ($99/year).
- Must be able to create App IDs, Provisioning Profiles, and submit to App Store Connect.

### 15.1.2 App Store Connect App Record
- Create the app record in App Store Connect with the correct Bundle ID.
- Set up the app icon, screenshots (later), description, and keywords.

### 15.1.3 Monthly Subscription IAP Product
- Create one auto-renewable monthly subscription product in App Store Connect.
- Note the Product ID (e.g., `com.languageskull.pro.monthly`).
- Configure pricing, subscription group, and introductory offers if desired.

### 15.1.4 Privacy Policy URL
- Host a clear Privacy Policy (can be simple and hosted on GitHub Pages, Carrd, or a personal site).
- Must cover data collection for analytics, crash reporting, optional name, referral tracking, and subscription status.

### 15.1.5 Support Email
- A working email address that will be listed in App Store Connect and the app (e.g., support@yourdomain.com or imjohnnyplaid@gmail.com).

## 15.2 During the Build (Medium Priority)

### 15.2.1 Firebase Project (Recommended)
- Create a Firebase project for Analytics + Crashlytics.
- Add the iOS app and download `GoogleService-Info.plist`.
- Do **not** commit the plist to git (add to .gitignore).

### 15.2.2 Test Devices / Simulators
- Physical iOS device recommended for testing Sign in with Apple and push notifications.
- Multiple Simulators useful for testing referral link handling.

### 15.2.3 Sandbox Testing for Subscriptions
- Use Sandbox Apple ID for testing trial and subscription flows.
- Document the Sandbox Apple ID used for testing.

## 15.3 Before App Store Submission (Critical)

- Final Privacy Policy URL added to App Store Connect.
- Accurate App Privacy section completed in App Store Connect.
- Export compliance questions answered.
- Admin mode completely hidden/disabled in the release build.
- dSYMs uploaded or automatic upload configured for Crashlytics.
- All analytics events tested and firing correctly.
- Referral flow tested end-to-end (share → install → code capture → subscription flag).
- Screenshots and app description prepared.

## 15.4 Nice-to-Have / Future

- Custom domain for Privacy Policy and future marketing site.
- Professional app icon and launch screen assets (beyond SF Symbols).
- Figma design file for final UI polish pass.
- Server-side referral validation and StoreKit promo offers (Phase 2).

## 15.5 Cursor Instructions

After each phase (or when relevant), explicitly list any missing deliverables from this document that are still needed.
For example:
- "Still need: Firebase project + GoogleService-Info.plist"
- "Still need: Monthly subscription Product ID from App Store Connect"
- "Still need: Final Privacy Policy URL"

This list keeps the project moving smoothly toward a successful App Store submission.