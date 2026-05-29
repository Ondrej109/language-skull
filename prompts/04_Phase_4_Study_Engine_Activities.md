# Phase 4: Sessions & Activities UI (Production-Grade)

**Goal**  
Build beautiful, buttery-smooth, world-class activity screens that feel premium and delightful to use. Flashcards in particular must be exceptional.

## Strict Requirements (Do Not Skip)

### 1. Two-Column List View
- Clean, elegant two-column layout (English | Foreign).
- Large, highly readable typography.
- Subtle material/glass card background.
- Scrollable with smooth performance.
- Passive activity — user reads and taps “Mark as Done” when ready.

### 2. Flashcard View (World-Class Standard)
This is the **hero interaction** of the app. It must feel exceptional:

- Beautiful card design with subtle depth, material quality, and refined shadow.
- **Tap to flip**: Elegant, smooth animation (refined rotation or scale, not flashy).
- **Swipe gestures**: Natural physics with subtle resistance and satisfying snap.
- High performance (buttery 60/120fps).
- Clean, premium typography on both sides.
- Subtle micro-interactions on swipe completion or correct/incorrect marking.
- Progress indicator that feels calm and premium.
- Overall feeling: “This is the best flashcard experience I’ve ever used.”

For D-3 revisions: Present the combined set as one continuous, smooth session in original order.

### 3. Grammar Paragraph View
- Clean, readable layout for grammar content.
- Sequential section number displayed.
- Scrollable content with excellent typography.
- “Mark as Done” when user has finished reading.

### 4. Mark as Done + Persistence
- Prominent but elegant “Mark as Done” button on every activity.
- Instant visual feedback + subtle haptic (if appropriate).
- Create/update `UserActivityCompletion` record with timestamp.
- Smooth animation when marking complete.
- Completed activities show clear visual state (checkmark, dimmed, etc.).

### 5. Session Completion Celebration
- After the last activity in a Morning or Evening session:
  - Nice success animation (subtle, not over-the-top).
  - Clear message: “Great work! Evening session recommended.” or similar.
  - Update Home progress rings immediately.

### 6. Testing & Validation Discipline
After implementing each major screen:
1. Build + run in Simulator.
2. Test the full flow for that activity type (including D-3).
3. Test swipe + tap-to-flip on flashcards extensively.
4. Test marking done + persistence across app restarts.
5. Test session completion celebration.
6. Only proceed after successful tests.

### 7. Git Discipline
Example commits:
- `feat: Add elegant two-column list view`
- `feat: Build world-class flashcard view with smooth swipe and flip`
- `feat: Implement grammar paragraph view`
- `feat: Add Mark as Done + session completion celebration`

## Final Deliverables for Phase 4

- [ ] Two-column list view is clean and premium
- [ ] Flashcard view is world-class (smooth swipe + elegant flip)
- [ ] Grammar paragraph view works
- [ ] Mark as Done works with persistence and animation
- [ ] Session completion celebration feels good
- [ ] All flows tested successfully in Simulator
- [ ] Git history is clean

## Cursor Instructions (Follow Exactly)

Flashcards are the standout feature. Make them genuinely delightful and buttery smooth.

After completing this phase, respond with:

```
✅ Phase 4 Completed

Checklist:
- [ ] Two-column list view done
- [ ] World-class flashcard view done
- [ ] Grammar view done
- [ ] Mark as Done + celebration done
- [ ] Simulator tested successfully

Missing items / decisions needed:
- 

Ready for Phase 5.
```

Do **not** move to Phase 5 until the above report is given.