---
name: flutter-feature-scaffold
description: >-
  Use this skill when implementing, extending, or refactoring Flutter screens,
  navigation, forms, or widgets in egy_tracker. Enforces the 3-tab layout
  (Home, My Tracker, Settings), fast expense/exchange entry, and strict UI invariants.
---

# Flutter Feature Scaffold Skill

Guides the layout, widget tree, and form interactions for `egy_tracker`.

## Core Navigation & Screens

1. **Root Screen**: A `Scaffold` containing a `NavigationBar` (Material 3) with 3 destinations:
   - **Index 0: Home**: Shared trip view and primary activity log.
   - **Index 1: My Tracker**: Personalized view answering: *What money do I have, what did I spend, and what is my share of shared expenses?*
   - **Index 2: Settings**: Whitelist, initial balances, and data management.

2. **Floating Action Button (`+`)**:
   - Prominent on both Home and My Tracker.
   - Triggers an action sheet or split menu:
     * **Add Expense**: Opens Expense modal/screen.
     * **Add Exchange**: Opens Exchange modal/screen.

3. **Form Specifications**:
   - **Add Expense Form**:
     * Title (Text, e.g. "Restaurant dinner")
     * Amount (Numeric keyboard)
     * Currency (SegmentedButton: `USD` vs `EGP`)
     * Paid By (SegmentedButton: `Me` vs `Friend`)
     * Split Type (Choice: `100% by default`, `50/50`, `Custom`)
     * If Custom: Two percentage fields (`Me %`, `Friend %`). Form is disabled if sum != 100.
     * Date/Time picker (defaults to `DateTime.now()`).
   - **Add Exchange Form**:
     * From Currency (`USD` or `EGP`)
     * Amount Given
     * To Currency (automatically toggles to the opposite currency)
     * Amount Received
     * Exchange Rate (explicit entered rate)
     * Date/Time picker.

Read [references/layouts.md](references/layouts.md) for detailed layout ASCII mocks and UI component specifications.
