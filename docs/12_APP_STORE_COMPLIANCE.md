# 12 APP STORE COMPLIANCE – FULL DETAILED END-TO-END SPEC

## 12.1 Required Items Before Submission

### 12.1.1 Privacy Policy
- Must have a publicly accessible Privacy Policy URL.
- The policy must clearly state what data is collected (analytics, crash reports, optional name, referral codes, subscription status).
- Must mention that Sign in with Apple is used and that Apple handles authentication.
- Must state that no data is sold or shared with third parties for advertising.
- Recommended: Use a simple, clear policy hosted on a personal site or GitHub Pages.

### 12.1.2 Support Email / Contact
- Provide a working support email in App Store Connect (e.g., imjohnnyplaid@gmail.com or a dedicated support address).
- This email must be monitored during the review process.

### 12.1.3 Export Compliance
- In App Store Connect, answer the export compliance questions honestly.
- Language Skull uses standard encryption (Sign in with Apple, HTTPS, StoreKit). Usually this qualifies for "No" on the encryption question or falls under the "mass market" exemption.
- If using Firebase or any other service, confirm their compliance status.

### 12.1.4 App Privacy Section (App Store Connect)
In App Store Connect → App Privacy, declare data collection accurately:

- **Analytics** (Firebase Analytics) – Yes, collected
- **Crash Data** (Firebase Crashlytics) – Yes, collected
- **User ID / Name** (optional first name, Apple User ID internally) – Limited use
- **Subscriptions / Purchases** – Yes (handled by Apple)
- **Referrals** – Internal tracking only

Be precise and conservative. Apple reviews these declarations.

## 12.2 In-App Purchase & Subscription Compliance

- Implement proper `restorePurchases()` functionality.
- Handle subscription status correctly (trial, active, expired, grace period).
- Do not hard-code prices or make misleading claims about billing.
- Show clear cancellation instructions in the Manage Plan screen.
- Test thoroughly in Sandbox environment.

## 12.3 Sign in with Apple Requirements

- If Sign in with Apple is offered, it must be presented as a prominent option (not hidden).
- Must provide a way for users to delete their account / data if requested (even if simple for MVP).
- Respect "Hide My Email" relay addresses.

## 12.4 Crash Reporting & dSYM Upload

- If using Firebase Crashlytics, ensure dSYMs are uploaded so crashes are symbolicated.
- Firebase usually handles this automatically when using Xcode Cloud or the upload script.
- Test that crashes appear correctly in the Firebase console during development.

## 12.5 Review Notes / Submission Notes

In App Store Connect submission notes, include:
- Test account credentials if needed (usually not required for this type of app)
- Clear description of the referral flow (local tracking in MVP)
- Mention that Admin mode is disabled in the release build
- Any special testing instructions for subscription flows

## 12.6 Cursor Implementation Requirements

- Add a clear `PrivacyPolicyURL` constant or configuration.
- Implement full `restorePurchases()` and test it.
- Make sure the Manage Plan screen explains cancellation clearly.
- Add proper export compliance answers in App Store Connect (do this manually, not in code).
- Keep the App Privacy declaration accurate and minimal.
- Document in code comments any compliance-related decisions (e.g., why certain data is collected).

Following these rules will significantly increase the chance of first-time App Store approval.