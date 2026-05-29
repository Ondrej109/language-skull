# 02 MONETIZATION, IAP & TRIAL – FULL DETAILED END-TO-END SPEC

## 2.1 Business Rules (Strict)

- App is **free to download** with no paywall on first launch.
- Every new user gets a **full 7-day Pro trial** (access to all languages, all features, admin mode, unlimited sessions).
- After the trial ends, the user must subscribe to continue accessing new content and new languages.
- Only **one** monthly auto-renewable subscription product in MVP.
- Referral benefit ("3 months free") is tracked locally in MVP and applied as a stub. Real StoreKit credit happens in Phase 2.

## 2.2 Technical Implementation – StoreKit 2 (Exact Requirements)

Use **StoreKit 2** only. No deprecated StoreKit 1 APIs.

Key components to implement:

1. `SubscriptionManager` actor or class (recommended as actor for thread safety).
2. Listen to `Transaction.updates` for real-time transaction changes.
3. On app launch and key actions, call `checkSubscriptionStatus()` which:
   - Verifies current entitlements
   - Updates `SubscriptionStatus` model in SwiftData
   - Handles trial end date
4. Implement `purchase()` using `Product.purchase()`
5. Implement `restorePurchases()` using `Transaction.currentEntitlements`

## 2.3 Trial Tracking Logic (Detailed)

- On first launch for a new `UserProfile`, set `trialEndDate = Date() + 7 days`.
- Store this date in `SubscriptionStatus.trialEndDate`.
- On every launch and before showing locked content, compare current date with `trialEndDate`.
- If `trialEndDate` has passed and user has no active subscription → mark as trial expired.
- Use `UserDefaults` as a lightweight fallback in case SwiftData is not yet available on very first launch.

## 2.4 Paywall Behavior (Contextual & Value-First)

Show the paywall in these situations:
- User tries to access a locked language after trial
- User tries to start a new day after trial ended
- Gentle prompt on launch if trial ended within last 3 days

Paywall content must include:
- Clear benefit list ("Unlimited languages", "Full study plans", "Progress sync", etc.)
- Price and billing period
- Prominent "Start Subscription" button
- "Restore Purchases" button
- Link to Privacy Policy and Terms

Use `SubscriptionStoreView` from StoreKit where possible, styled with our gothic theme.

## 2.5 Manage Plan Screen (Required Fields)

Accessible from avatar menu → "Manage Plan".

Must display:
- Current status (Trial Active / Trial Expired / Subscribed / Expired)
- If on trial: Days remaining + exact end date
- If subscribed: Plan name, price, next billing date, renewal status
- Buttons: Cancel Subscription, Upgrade, Restore Purchases
- Referral status (if user has referred someone)

This screen must feel native and trustworthy.

## 2.6 Receipt Validation & Grace Period

- On launch, validate the current receipt/entitlements.
- If validation fails temporarily, allow a short grace period (e.g. 3 days) before locking content.
- Store `lastReceiptValidationDate` in `SubscriptionStatus`.
- Clear messaging when subscription is in retry or grace period.

## 2.7 Edge Cases (Must Handle)

- Trial expires while app is in background → next launch shows paywall + clear message.
- User restores purchases on a new device → merge subscription state.
- Family Sharing → correctly detect shared subscription.
- User cancels subscription but still has time remaining → show correct status until end of period.
- Sandbox testing vs Production behavior differences (document in code comments).

## 2.8 Cursor Implementation Rules

- Create a dedicated `SubscriptionManager` (actor preferred).
- All subscription state must live in `SubscriptionStatus` SwiftData model and be the single source of truth.
- Never hard-code trial length in multiple places – use a constant.
- Make paywall presentation contextual (pass reason: `.trialEnded`, `.featureLocked`, etc.).
- Log clear events for analytics (`trial_expired`, `subscription_started`, `restore_success`, etc.).
- Test trial expiry by manually changing device date in Simulator during development.

This monetization layer must be reliable and App Review friendly from day one.