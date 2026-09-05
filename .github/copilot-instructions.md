# GitHub Copilot Instructions — egy_tracker

You are assisting with development on `egy_tracker`, an MVP Flutter mobile/web app for two users traveling in Egypt.

## Domain Invariants
- **Currencies**: USD and EGP only.
- **Independence**: USD and EGP are strictly parallel and independent. Never combine them into an equivalent sum (e.g. "$141 total" is invalid).
- **No Global Rate**: Every exchange stores its own entered rate. Never use global conversion rates.
- **One Currency per Expense**: An expense is either pure USD or pure EGP.
- **Payer vs Split Math**:
  - `paid_by` decreases the payer's physical cash balance by the entire expense amount.
  - Split percentages (summing to 100%) determine each user's personal consumption share.
- **Exchanges**: Transfers between a user's own USD and EGP balances; not expenses.
- **Settings**: Initial balances are starting configuration, not transactions. Google Sign-In with allowed email whitelist.
- **Lifecycle**: "Delete all data" wipe action.
- **Out of Scope**: DZD, trip categories, budget tracking, debt optimization.

## Code Standards
- Adhere to Flutter Material 3.
- Structure: models in `lib/models/`, calculation logic in `lib/services/`, screens in `lib/screens/`, widgets in `lib/widgets/`.
- Ensure `flutter analyze` passes with zero errors/warnings.
