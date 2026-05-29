# Phase 6: Monetization & Trial (Production-Grade)

**Goal**  
Implement a reliable 7-day trial + subscription system using StoreKit 2 that feels trustworthy and App Review friendly.

## Strict Requirements (Do Not Skip)

### 1. SubscriptionManager
- Implement as an `actor` for thread safety.
- Listen to `Transaction.updates` for real-time changes.
- On launch and key actions, call `checkSubscriptionStatus()` which:
  - Verifies current entitlements
  - Updates `SubscriptionStatus` model in SwiftData
  - Handles trial end date

### 2. Trial Tracking
- On first launch for a new `UserProfile`, set `trialEndDate = Date() + 7 days`.
- Store this in `SubscriptionStatus.trialEndDate`.
- On every launch and before showing locked content, compare current date with `trialEndDate`.
- If trial has ended and no active subscription → mark as trial expired.
- Use `UserDefaults` as lightweight fallback if SwiftData is not ready.

### 3. Paywall Behavior
Show the paywall contextually:
- User tries to access a locked language after trial
- User tries to start a new day after trial ended
- Gentle prompt on launch if trial ended recently

Paywall must include:
- Clear benefit list
- Price and billing period
- Prominent “Start Subscription” button
- “Restore Purchases” button
- Links to Privacy Policy and Terms

Use `SubscriptionStoreView` styled with the gothic theme where possible.

### 4. Manage Plan Screen
Accessible from Avatar Menu → “Manage Plan”.
Must display:
- Current status (Trial Active / Trial Expired / Subscribed / Expired)
- If on trial: Days remaining + exact end date
- If subscribed: Plan name, price, next billing date, renewal status
- Buttons: Cancel Subscription, Upgrade, Restore Purchases
- Referral status (if applicable)

This screen must feel native and trustworthy.

### 5. Restore Purchases & Receipt Validation
- Implement `restorePurchases()` using `Transaction.currentEntitlements`.
- On launch, validate current entitlements.
- If validation fails temporarily, allow a short grace period (e.g. 3 days).
- Store `lastReceiptValidationDate` in `SubscriptionStatus`.

### 6. Testing & Validation Discipline (Sandbox)
- Test extensively in Sandbox environment.
- Test trial expiry by manually changing device date in Simulator.
- Test restore purchases on a second device/simulator.
- Test paywall appearance after trial ends.
- Document any Sandbox vs Production differences in code comments.

### 7. Git Discipline
Example commits:
- `feat: Implement SubscriptionManager as actor with StoreKit 2`
- `feat: Add trial tracking and expiry logic`
- `feat: Build contextual paywall`
- `feat: Create Manage Plan screen with full billing info`
- `feat: Add Restore Purchases and receipt validation`

## Final Deliverables for Phase 6

- [ ] SubscriptionManager works with StoreKit 2
- [ ] 7-day trial tracking works correctly
- [ ] Contextual paywall appears when expected
- [ ] Manage Plan screen shows correct status and options
- [ ] Restore Purchases works in Sandbox
- [ ] Receipt validation on launch works
- [ ] All flows tested successfully in Sandbox/Simulator
- [ ] Git history is clean

## Cursor Instructions (Follow Exactly)

This system must be reliable and App Review friendly from day one.

After completing this phase, respond with:

```
✅ Phase 6 Completed

Checklist:
- [ ] SubscriptionManager done
- [ ] Trial tracking done
- [ ] Paywall done
- [ ] Manage Plan screen done
- [ ] Restore + validation done
- [ ] Sandbox tested successfully

Missing items / decisions needed:
- 

Ready for Phase 7.
```

Do **not** move to Phase 7 until the above report is given.