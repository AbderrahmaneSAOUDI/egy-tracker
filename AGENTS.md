# Two-Currency Expense Tracker (egy_tracker) — Multi-Agent Engineering Rules

This repository contains **egy_tracker**, a private, lightweight Flutter mobile/web application designed for two users managing money while traveling in Egypt.

All AI agents (OpenAI Codex, Claude, Gemini/Antigravity, Cursor, Copilot, Windsurf, Cline, Aider, etc.) operating in this repository **must** strictly enforce the invariants, architectural patterns, and business logic defined herein.

---

## 1. Absolute Domain Invariants (NEVER VIOLATE)

### 1.1 Strict Currency Independence
- **Currencies**: Exactly two currencies exist: **USD** (`$`) and **EGP** (`EGP`).
- **Zero Automatic Conversion**: The application must **never** automatically convert one currency into the other.
- **Zero Global Exchange Rate**: There is **no** application-wide, daily, or API-fetched exchange rate. Exchange rates are strictly historical and transaction-specific.
- **Zero Combined Currency Totals**: Never display or compute an equivalent combined total (e.g. displaying `$141 total` or `7,000 EGP total` when a user has `$70` and `3,500 EGP` is strictly prohibited).
- **One Expense, One Currency**: Every expense has exactly one currency. Never allow split currencies within a single expense.

### 1.2 Separation of Cash Balance vs. Personal Consumption Share
- **Cash Balance Impact**: Dictated solely by `paid_by`. If User A pays for an expense, only User A's physical cash balance in that currency decreases by the full amount.
- **Personal Consumption Share**: Dictated solely by the split percentages. Calculated as:
  $$\text{Personal Share} = \text{Expense Amount} \times \text{Personal Percentage}$$
- **Single Record Storage**: An expense is stored exactly once in the database. Personal shares are dynamically computed; never create duplicate split records.
- **Percentage Sum Invariant**: For every expense:
  $$\text{me\_percentage} + \text{friend\_percentage} = 100$$
  Supported split types: `default_100` (100% payer), `fifty_fifty` (50% / 50%), `custom` (user specified, strictly summing to 100%).

### 1.3 Exchanges Are Balance Transfers, Not Expenses
- An exchange (USD → EGP or EGP → USD) transfers funds between a single user's own currency balances.
- It is **not** an expense and must never be recorded or counted as spending.
- Must store: `user_id`, `from_currency`, `from_amount`, `to_currency`, `to_amount`, `exchange_rate` (entered actual rate), `date`.

### 1.4 Initial Balances Are Configuration, Not Transactions
- Configured exclusively in **Settings**.
- Stored directly on each user's profile (`initial_balances`: `usd_amount`, `egp_amount`).
- Must **never** be generated as fake transaction or dummy expense rows.

### 1.5 Strict Out-of-Scope Blacklist
Do **NOT** implement, suggest, or scaffold any of the following features:
- ❌ DZD (Algerian Dinar) or any other third currency
- ❌ Automatic currency conversion or external exchange rate APIs
- ❌ Multiple trips, trip switching, or trip naming
- ❌ Expense categories (e.g. food, transport tags)
- ❌ Expense "For" fields
- ❌ Budgeting, spending goals, or charts
- ❌ Debt settlement or debt-optimization graphs
- ❌ Recurring expenses or subscriptions
- ❌ Bank or payment gateway integrations (Stripe, PayPal, etc.)
- ❌ Social feeds, comments, or reaction emojis

---

## 2. Calculation Formulas

### 2.1 Cash Balance Calculation
For each user and each currency independently:
```
Current Balance = Initial Balance
                + Exchanges In (as to_currency)
                - Exchanges Out (as from_currency)
                - Expenses Paid (where paid_by == user)
```

### 2.2 Personal Share Calculation
For the logged-in user:
```
Personal Share = Expense Amount * (Personal Percentage / 100)
```
- In **My Tracker**:
  - **My Expenses**: Expenses where the user's share is 100%.
  - **Shared Expenses**: Expenses where the user's share is $> 0\%$ and $< 100\%$.

---

## 3. Architecture & Tech Stack (Flutter / Dart)

- **Framework**: Flutter 3.x+ (Dart SDK `^3.x`)
- **Design System**: Material 3, clean high-contrast layouts, fast numeric entry.
- **Three-Tab Navigation**:
  1. **Home**: Current balances for both users (USD & EGP separate), chronological recent activity feed (expenses & exchanges), prominent `+` button with separate "Add Expense" and "Add Exchange" actions.
  2. **My Tracker**: Logged-in user's personal USD/EGP balances, "My Expenses" (100% share), and "Shared Expenses" with exact personal share.
  3. **Settings**: Initial Balances editor, Allowed Emails whitelist CRUD, Account details, and a high-visibility "Delete all data" button.
- **Authentication**: Google Sign-In with email whitelist gating against `allowed_emails`.
- **Data Lifecycle**: Temporary trip app. The "Delete all data" action in Settings must purge all expenses, exchanges, initial balances, and user records.

---

## 4. Code Style & Verification

- Run static analysis before submitting changes: `flutter analyze`.
- Run tests: `flutter test`.
- Verify the 5 standard verification scenarios documented in [two_currency_expense_tracker_mvp.md](file:///home/saoudi26/Documents/GitHub/PERSONAL/egy_tracker/two_currency_expense_tracker_mvp.md#16-example-scenarios).
- Maintain all code cleanly decoupled:
  - `lib/models/` for immutable domain entities (`Expense`, `Exchange`, `UserBalance`, etc.)
  - `lib/services/` for calculation engines, authentication, and persistence
  - `lib/screens/` and `lib/widgets/` for UI
