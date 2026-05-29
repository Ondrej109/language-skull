# Phase 7: Admin Mode & Profile (Production-Grade)

**Goal**  
Build a genuinely useful Admin mode for content and plan management during development, while making it easy to completely disable before App Store submission. Also deliver a solid Profile screen.

## Strict Requirements (Do Not Skip)

### 1. Admin Visibility & Toggle
- Admin tab is visible by default during development.
- Provide a clear, obvious toggle (in Settings or via long-press on Admin tab icon) that **completely hides** the Admin tab.
- This toggle must be easy to use before submission, with a confirmation dialog.
- Add clear code comments explaining how to remove/hide admin code for the final build.

### 2. Content Management (Admin Tab)
- **Import / Update Content** button
  - Option to import entire language folder
  - Option to import individual files
  - Validation step with clear success/error messages
  - Choice between **Replace** (overwrite) and **Merge** (add/update)
  - Progress indicator during import
  - Warning that user progress is never deleted
- List of currently loaded courses with basic stats (number of words, phrases, grammar sections).

### 3. Study Plan Editor (Form-Based for MVP)
Simple but functional editor:
- Select Course
- Select Day (1–7 or specific week/day)
- Select Morning or Evening
- List of current activities with drag-to-reorder or up/down buttons
- Add Activity button → shows list of `ActivityType`s + metadata fields
- Edit / Delete existing activities
- Save button that updates the `StudyPlan` in SwiftData

### 4. Preview as Learner
- Prominent button: “Preview as Learner”
- When tapped, temporarily switches the view to use the selected course and plan as if the admin were a normal user.
- Clear banner or indicator that the user is in Preview mode.
- Easy way to exit preview and return to Admin mode.

### 5. Profile Screen
- Show user info, current streak, words/phrases learned, current plan name.
- Referral status (number of successful referrals, pending credits).
- Clean, elegant layout matching the premium aesthetic.

### 6. Referral Share Sheet (MVP Stub)
- From Avatar Menu → “Refer a Friend”
- Native share sheet with pre-filled message: “Join me on Language Skull and we both get 3 months free!” + referral link.
- Generate and store unique referral code per user.
- On first launch via referral link, capture the code and store it.
- On successful subscription, set local flag marking the referrer as eligible for benefit (stub for MVP).

### 7. Testing & Validation Discipline
- Test full Admin import flow (Replace and Merge).
- Test Study Plan Editor (add, reorder, delete activities).
- Test Preview as Learner mode.
- Test referral share sheet and link capture.
- Test hiding Admin tab completely.
- Only proceed after successful tests.

### 8. Git Discipline
Example commits:
- `feat: Add Admin tab with visibility toggle`
- `feat: Implement Content Import with Replace/Merge`
- `feat: Build form-based Study Plan Editor`
- `feat: Add Preview as Learner mode`
- `feat: Create Profile screen + Referral share sheet`

## Final Deliverables for Phase 7

- [ ] Admin tab with easy hide toggle works
- [ ] Content Import flow works (folder + files, Replace + Merge)
- [ ] Study Plan Editor is functional
- [ ] Preview as Learner mode works
- [ ] Profile screen is clean and useful
- [ ] Referral share sheet + local tracking stub works
- [ ] Simulator tested successfully
- [ ] Git history is clean

## Cursor Instructions (Follow Exactly)

Admin mode must be powerful for development but easy to completely disable before release.

After completing this phase, respond with:

```
✅ Phase 7 Completed

Checklist:
- [ ] Admin visibility toggle done
- [ ] Content Import done
- [ ] Study Plan Editor done
- [ ] Preview as Learner done
- [ ] Profile + Referral done
- [ ] Simulator tested successfully

Missing items / decisions needed:
- 

Ready for Phase 8.
```

Do **not** move to Phase 8 until the above report is given.