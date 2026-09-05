# CLAUDE.md — Anthropic Claude Directives for egy_tracker

Project context and execution guidelines for Claude Code and Anthropic models operating in `egy_tracker`.

---

## Commands

- **Build / Run Web**: `flutter run -d chrome`
- **Build / Run Android**: `flutter run -d android`
- **Run Static Analysis**: `flutter analyze`
- **Run All Unit & Widget Tests**: `flutter test`
- **Run Calculation Scenarios Check**: `dart run .agents/skills/egy-tracker-qa-verifier/scripts/verify_scenarios.dart`
- **Install / Update Dependencies**: `flutter pub get`
- **Run Invariant Guard**: `python3 scripts/invariant_guard.py`

---

## Architecture & Code Style

- **State Management & Clean Separation**:
  - Model definitions in `lib/models/` (immutable data classes with `copyWith`, `toJson`, `fromJson`).
  - Business & calculation logic in `lib/services/` (pure, testable calculation functions).
  - Presentation components in `lib/screens/` and `lib/widgets/`.
- **UI Structure**: Material 3, three bottom navigation tabs:
  1. `HomeScreen`: USD and EGP balances for both users (independent display), recent activity stream, dual-action `+` FAB (Expense vs Exchange).
  2. `MyTrackerScreen`: Logged-in user's personal USD/EGP balances, "My Expenses" (100% share), "Shared Expenses" with exact personal share.
  3. `SettingsScreen`: Initial Balances editor, Allowed Emails whitelist CRUD, and "Delete all data" action.

---

## Critical Invariants & Rules

1. **Currency Independence**:
   - Currencies are strictly **USD** and **EGP**.
   - NEVER automatically convert currencies.
   - NEVER use a global exchange rate.
   - NEVER combine USD and EGP into a single sum (e.g. "$141 total" is forbidden).
   - Every expense has exactly ONE currency.
2. **Payer vs Split Math**:
   - `paid_by` decreases the payer's physical cash balance by 100% of the amount.
   - Split percentages (`me_percentage + friend_percentage == 100`) allocate personal consumption share.
   - Expenses are stored once; personal share is computed as `amount * percentage / 100`.
3. **Exchanges**:
   - Move funds between a user's own balances (USD ↔ EGP). Not an expense.
   - Stores historical actual exchange rate entered at transaction time.
4. **Initial Balances**:
   - Stored on user profile in Settings. Not fake transactions.
5. **Forbidden Scope**:
   - No DZD, no trip naming, no categories, no budget optimization, no settlement debt minimization.
