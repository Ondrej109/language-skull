# 07 UI DESIGN SYSTEM & NAVIGATION – FULL DETAILED END-TO-END SPEC

## 7.1 Core UI Philosophy (Strict – Default iOS First + Premium Feel)

**Language Skull must feel like a modern, ultra-polished, buttery-smooth native Apple app.**

Every interaction should be a **joy to use**. The app should feel premium, sophisticated, and delightful.

**Key Quality Bar:**
- Interactions must be **world-class**, especially flashcards (super smooth animations, satisfying gestures, visually stunning, delightful micro-interactions, 60/120fps performance).
- Overall aesthetic: Sophisticated dark academia — **Old Oxford or Harvard of 100 years ago**. Polished, elegant, a little dark and mysterious. Refined and understated. **Not** parchment, wax, or overly ornate gothic.

We embrace default iOS components while elevating the feel through:
- Thoughtful use of liquid glass / material
- Subtle, high-quality animations
- Excellent gesture handling (especially in flashcards)
- Consistent, premium visual language

## 7.2 Exact Color Palette (Use These Values)

- Background (main view): #050505
- Surface / Card background: #111111 + material blur effect
- Accent color (buttons, progress rings, highlights, active tab): #4A1C1C (muted burgundy)
- Subtle parchment / secondary highlight (used sparingly): #D4C4A8
- Text Primary: #FFFFFF
- Text Secondary / captions: #E5E5E5

Apply colors via a `Theme` environment object or simple `Color` extension.

## 7.3 Header / Navigation Bar Rule (Non-Negotiable)

**No skull logo in the navigation bar.**

Right side of every navigation bar = circular User Avatar (use `person.circle.fill` SF Symbol or user photo if available).

Tapping the avatar must open a **native menu** containing exactly these items:
1. **Profile**
2. **Manage Plan**
3. **Refer a Friend**
4. **Sign Out**

## 7.4 Tab Bar

Bottom `TabView` with exactly 4 tabs:
- **Home**
- **Calendar**
- **Admin** (visible in MVP, easy to hide before submission)
- **Profile**

Use default iOS tab bar appearance. Selected tab uses our accent color.

## 7.5 Liquid Glass & Material + Interaction Polish

Apply `.background(.ultraThinMaterial)` or `.background(.regularMaterial)` generously.

**Flashcard interactions must be exceptional**:
- Smooth swipe gestures with natural physics
- Satisfying tap-to-flip with elegant animation
- Subtle visual feedback and micro-interactions
- High performance (buttery smooth)
- Visually stunning while remaining clean and sophisticated

## 7.6 When Custom Styling Is Allowed

**Only after a Figma file is provided.** Until then, stay extremely close to default iOS components and focus on **interaction quality and polish** rather than heavy visual customization.

## 7.7 Accessibility & Polish Requirements

- All interactive elements must have proper accessibility labels and hints.
- Support Dynamic Type.
- Maintain sufficient contrast.
- Add subtle, high-quality haptic feedback on important actions.
- Every screen must have a working SwiftUI Preview showing multiple states.

## 7.8 Cursor Implementation Rules

- Start every screen with default SwiftUI components.
- Prioritize **buttery smooth interactions** and delightful micro-interactions, especially in flashcards.
- Create a lightweight `Theme` for colors.
- Use SF Symbols exclusively for icons.
- Make the avatar menu using native components.
- Ensure the Admin tab can be hidden easily before submission.
- The overall feel must be modern, ultra-polished, and a genuine joy to use.

This approach guarantees we ship a premium-feeling, native iOS app with world-class interactions while staying true to the sophisticated dark academia aesthetic (Old Oxford / old Harvard vibe).