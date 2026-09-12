# egy-tracker 🇪🇬

> A lightweight, private Flutter application designed for two travelers managing physical cash and shared expenses together while traveling in Egypt.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.3+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore%20%7C%20Auth-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Tests](https://img.shields.io/badge/Tests-81%20Passed-brightgreen)](https://github.com/AbderrahmaneSAOUDI/egy-tracker)
[![License](https://img.shields.io/badge/License-Private-grey.svg)](#)

---

## 📌 Project Overview

**egy-tracker** is built specifically for a trip in Egypt by two companions. It is intentionally simple, temporary, and focused on physical cash management and accurate expense tracking without unnecessary generic finance overhead.

### 🌟 Core Domain Invariants

1. **Strict Currency Independence (USD & EGP)**:
   - Exactly two currencies exist: **USD (`$`)** and **EGP (`EGP`)**.
   - **Zero Automatic Conversion**: Currencies are never converted automatically.
   - **Zero Global Exchange Rate**: Exchange rates are strictly historical and transaction-specific.
   - **Zero Combined Currency Totals**: The app never computes or displays combined totals (e.g., displaying an artificial `$141 total` when holding `$70` and `3,500 EGP` is strictly prohibited).
   - **One Expense, One Currency**: Every expense is recorded in either USD or EGP.
2. **Physical Cash Balance vs. Personal Consumption Share**:
   - **Cash Balance**: Dictated by `paid_by`. The payer's physical cash balance decreases by the full amount of the bill.
   - **Personal Consumption Share**: Dictated by split percentages (`me_percentage + friend_percentage == 100%`).
   - Supported split models:
     - **100% Personal**: Payer absorbs the entire cost.
     - **50% / 50% Split**: Half each.
     - **Custom Split**: Custom user-defined percentages strictly summing to 100%.
3. **Exchanges are Transfers, Not Expenses**:
   - Currency exchanges (USD ↔ EGP) transfer funds between a traveler's own currency balances. They reflect physical cash swaps and are never categorized as spending.
4. **Peer-to-Peer Borrowing / Lending**:
   - Direct cash loans between travelers in either USD or EGP to accurately adjust physical balances without polluting expense records.
5. **Initial Balances as Configuration**:
   - Starting cash is set in Settings on each user profile, never injected as dummy transaction rows.
6. **Temporary Trip Lifecycle**:
   - High-visibility "Delete all data" action in Settings to purge all records once the trip concludes.

---

## 🚀 Features & Current Progress

### 📱 1. Home Feed & Balances
- **Real-Time Balance Cards**: Independent USD and EGP balances for both travelers with fluid numerical roll-up animations via `AnimatedCurrencyCounter`.
- **Chronological Activity Feed**: Real-time unified timeline showing:
  - 💸 **Expenses** (title, amount, payer, split breakdown, timestamp).
  - 🔄 **Exchanges** (from currency/amount, to currency/amount, effective exchange rate).
  - 🤝 **Borrows / Loans** (borrower, lender, currency, amount).
- **Interactive Gestures**:
  - `SlideActionCard` supporting swipe-to-edit (left) and swipe-to-delete (right).
  - Pull-to-refresh activity stream.
- **Quick-Entry Action Sheet**: Instant bottom sheet to add Expenses, Exchanges, or Borrow records.

### 📊 2. My Tracker (Personal View)
- **Personal Balance Summary**: Quick snapshot of the logged-in user's physical cash balances (USD & EGP) and total personal spending share.
- **Itemized Expense Breakdown**:
  - **My Expenses**: 100% personal expenses absorbed by the user.
  - **Shared Expenses**: Group or split expenses with clear indicators of the user's exact share vs. total bill.

### ⚙️ 3. Settings & Trip Management
- **Initial Balances Configuration**: Easily set or update starting cash for both travelers in USD and EGP.
- **Allowed Emails Whitelist**: Complete CRUD interface to manage authorized Google Sign-In email addresses.
- **Theme Settings**: Light, Dark, and System mode preference persistence.
- **Data Purge (Danger Zone)**: Double-confirmation modal that executes a complete Firestore purge of all collections (expenses, exchanges, borrows, user profiles, and balances).

---

## 🏗️ Architecture & Project Structure

The project follows a modular, feature-first MVVM architecture in Flutter:

```
lib/
├── core/
│   ├── animations/     # Reusable transitions and animated counters (a_animated_counter.dart)
│   ├── components/     # Atomic reusable widgets (dialogs, cards, pills, buttons, tiles)
│   ├── config/         # App constants, route definitions, and configuration
│   ├── models/         # Immutable domain models (Expense, Exchange, Borrow, UserProfile, etc.)
│   ├── services/       # Firebase Auth, Cloud Firestore streaming & sync engines
│   ├── theme/          # Material 3 dark/light color schemes and typography
│   └── utils/          # Pure calculation functions (Calculations.calculateCashBalance, etc.)
├── features/
│   ├── auth/           # Google Sign-In & whitelist gating screen
│   ├── home/           # Home tab, traveler balance cards, activity feed, and ViewModels
│   ├── my_tracker/     # Personal tracker screen, spending summaries, and ViewModels
│   └── settings/       # Initial balances, whitelist CRUD, theme picker, trip purge
├── firebase_options.dart
└── main.dart
```

---

## 🧪 Testing & Verification

egy-tracker maintains a comprehensive test suite with **81 tests** covering unit calculations, widget interactions, dialog validations, and UI state flows:

```bash
# Run all unit and widget tests
flutter test

# Run static analysis
dart analyze
```

### Verified Test Suites:
- `test/utils_test.dart`: Calculation engine invariants, cash balance equations, split allocations, and formatters.
- `test/models_test.dart`: Serialization, deserialization, and immutability of data entities.
- `test/home_feed_test.dart`: Feed streaming, empty states, swipe actions, and balance cards.
- `test/my_tracker_test.dart`: Personal share calculations and segmented expense lists.
- `test/settings_screen_test.dart`: Initial balance updates, allowed email CRUD, and trip wipe logic.
- `test/dialogs_and_animations_test.dart`: Add Expense, Exchange, and Borrow dialog behaviors, input constraints, and confirmations.
- `test/animated_counter_test.dart`: Animated counter tweens, target values, and negative balance handling.

---

## 🛠️ Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.3.0`)
- Android Studio or VS Code with Flutter extension
- Firebase project configured with Authentication (Google Sign-In) and Cloud Firestore

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/AbderrahmaneSAOUDI/egy-tracker.git
   cd egy-tracker
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Ensure `google-services.json` is placed in `android/app/`
   - Run `flutterfire configure` if updating credentials

4. Run the app:
   ```bash
   flutter run
   ```

---

## 📋 Progress Summary

| Feature | Status | Notes |
| :--- | :---: | :--- |
| **Google Sign-In & Whitelist Auth** | ✅ Completed | Whitelist enforcement against Firestore |
| **Core Calculation Engine** | ✅ Completed | Strict currency isolation; Scenarios A-E verified |
| **Home Balances & Feed** | ✅ Completed | Real-time streams with `AnimatedCurrencyCounter` |
| **Activity Gestures (Swipe to Edit/Delete)** | ✅ Completed | `SlideActionCard` with confirmation dialogs |
| **Expense, Exchange & Borrow Dialogs** | ✅ Completed | Validation, cash limit guards, custom split sliders |
| **My Tracker (Personal View)** | ✅ Completed | 100% vs Shared expense categorization |
| **Settings & Allowed Email CRUD** | ✅ Completed | Profile balance configuration & user management |
| **Trip Data Purge** | ✅ Completed | Atomic end-of-trip data wipe |
| **Material 3 Theming** | ✅ Completed | Light, Dark, and System theme persistence |
| **Comprehensive Test Suite** | ✅ Completed | 81 tests passing with 0 analyzer warnings |
