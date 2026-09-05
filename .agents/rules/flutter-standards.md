# Antigravity Rule: Flutter & Dart Architectural Standards

Applies to all Dart code within `egy_tracker`.

---

## 1. Directory Structure Conventions
```text
lib/
├── main.dart
├── models/
│   ├── expense.dart
│   ├── exchange.dart
│   ├── initial_balance.dart
│   ├── user_profile.dart
│   └── split_type.dart
├── services/
│   ├── auth_service.dart
│   ├── calculation_service.dart
│   └── storage_service.dart
├── screens/
│   ├── home_screen.dart
│   ├── my_tracker_screen.dart
│   ├── settings_screen.dart
│   ├── add_expense_modal.dart
│   └── add_exchange_modal.dart
└── widgets/
    ├── balance_card.dart
    ├── activity_tile.dart
    ├── currency_badge.dart
    └── split_selector.dart
```

---

## 2. Coding Patterns
- **Immutability**: All model classes must be immutable with `final` fields, `const` constructors where applicable, and `copyWith` methods.
- **Null Safety**: Strict non-nullable typing. Avoid force unwrap `!` unless null-check was performed immediately prior.
- **Async Handling**: Handle loading and error states explicitly in UI widgets.
- **Formatting & Analysis**:
  - Run `flutter analyze` and resolve all warnings.
  - Follow the rules defined in `analysis_options.yaml`.
  - Always use `const` widgets where possible to optimize rebuild performance.

---

## 3. UI/UX Invariants
- **Fast Entry**: Minimum form fields on Add Expense and Add Exchange.
- **Clear Separation**: Always display USD with `$` and EGP with `EGP` symbol/label. Never hide the currency unit.
- **Dual FAB / Action**: The `+` action must clearly offer separate paths for "Expense" and "Exchange".
- **Real-time Validation**: On Custom Split, show dynamic error if Me % + Friend % != 100.
