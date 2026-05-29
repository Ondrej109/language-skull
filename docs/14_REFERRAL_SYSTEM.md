# 14 REFERRAL SYSTEM – FULL DETAILED END-TO-END SPEC (MVP Stub + Phase 2 Path)

## 14.1 Overview

**MVP Goal**: Allow users to easily refer friends with a working share flow and local tracking. The benefit ("3 months free") is recorded locally as a flag. Full automatic application via StoreKit happens in Phase 2.

**Messaging**: "You and your friend both get 3 months free."

## 14.2 MVP Implementation (Detailed)

### 14.2.1 Referral Code Generation & Storage
- When the user first opens the Refer a Friend screen, generate a unique referral code if one does not already exist.
- Store the code in `UserProfile.referralCode` (or a dedicated `Referral` model).
- The code should be short, URL-safe, and unique per user (e.g., 8-character alphanumeric).

### 14.2.2 Share Sheet
- User taps "Refer a Friend" in the avatar menu.
- Present a native `ShareLink` or `UIActivityViewController` with:
  - Pre-filled message: "Join me on Language Skull and we both get 3 months free!"
  - Custom URL containing the referral code (e.g., `languageskull://refer?code=ABC123XY`)
- Support for Messages, Mail, AirDrop, etc.

### 14.2.3 Link Capture on First Launch
- Use `onOpenURL` in the main App struct (or `UIApplicationDelegate`).
- When the app is opened via the referral link:
  - Parse the `code` parameter.
  - If this is the very first launch for this user (new `UserProfile`), store the code in `UserProfile.referredBy`.
  - Show a friendly toast or banner: "Welcome! You were referred by a friend."
- Ignore the link if the user already has a profile (prevent abuse).

### 14.2.4 Local Tracking & Benefit Flag (MVP Stub)
- When a referred user successfully subscribes, set a local flag on the **referrer’s** profile: `hasPendingReferralBenefit = true`.
- On the referrer’s Manage Plan screen, show a note: "You have a pending 3-month referral credit."
- Do **not** automatically apply the credit in MVP (this requires StoreKit promo offers or server-side logic in Phase 2).

## 14.3 Phase 2 Improvements (Future)

- Use StoreKit Promo Offers or server-side subscription management to automatically apply 3 months free to the referrer.
- Add proper fraud prevention (one referral per user, cooldowns, etc.).
- Track referral success in analytics.
- Show referral stats in Profile (number of successful referrals, credits earned).

## 14.4 Edge Cases

- User shares link but recipient already has the app installed → link is ignored or shows "Thanks for sharing!"
- Multiple referrals for the same new user → only the first valid code is recorded.
- User reinstalls the app → referral code is not re-applied.
- Referral code is invalid or expired → silently ignore.

## 14.5 Cursor Implementation Requirements

- Create a simple `ReferralManager` or extend `UserProfile` with referral-related properties.
- Implement `ShareLink` with a properly formatted URL.
- Handle `onOpenURL` early in the app lifecycle.
- Store referral relationships cleanly in SwiftData.
- Make the MVP stub obvious in code comments so it can be upgraded later without confusion.
- Test the full flow: share → install on another device/simulator → code capture → subscription → benefit flag appears on referrer.

This gives a working, user-facing referral experience in MVP while keeping the architecture ready for a more powerful Phase 2 implementation.