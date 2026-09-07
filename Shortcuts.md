# egy_tracker — File Naming Shortcuts & Architecture

Quick reference for file prefixes and MVVM architectural roles across the codebase.

## File Naming System

| Prefix | Category | Purpose & Description | Examples |
| :--- | :--- | :--- | :--- |
| `main.dart` | **Entry Point** | App bootstrap, Firebase init, theme wrapper *(kept untouched)* | `lib/main.dart` |
| `s_*.dart` | **Screens (Views)** | Top-level screen views and page layouts | `s_home.dart`, `s_settings.dart`, `s_login.dart` |
| `c_*.dart` | **Components** | Reusable UI widgets, cards, buttons, badges, tiles, dialogs | `c_section_card.dart`, `c_app_dialog.dart`, `c_badge.dart` |
| `a_*.dart` | **Animations** | Animation builders, transitions, and motion helpers | `a_fade_slide_transition.dart` |
| `vm_*.dart` | **ViewModels** | State management, UI logic, business workflows (`ChangeNotifier`) | `vm_home.dart`, `vm_settings.dart`, `vm_auth.dart` |
| `mod_*.dart` | **Models** | Immutable domain entities and data classes | `mod_expense.dart`, `mod_exchange.dart`, `mod_user_profile.dart` |
| `m_*.dart` | **Methods / Functions** | Pure Dart helper functions (calculations, formatters, validators) | `m_calculations.dart`, `m_formatters.dart`, `m_validators.dart` |
| `f_*.dart` | **Firebase Services** | Firebase Auth and Cloud Firestore service adapters | `f_auth.dart`, `f_firestore.dart` |
| `db_*.dart` | **Database** | Database storage management, cache, or SQLite/Hive handlers | `db_storage.dart` |
| `t_*.dart` | **Theme & Tokens** | Material 3 themes, color palettes, spacing tokens, typography | `t_app_theme.dart` |

---

## Directory Structure

```text
lib/
├── core/
│   ├── animations/       # a_*.dart (motion & transitions)
│   ├── components/       # c_*.dart (shared atomic widgets, cards, dialogs)
│   ├── models/           # mod_*.dart (domain data models)
│   ├── services/         # f_*.dart / db_*.dart (Firebase & data services)
│   ├── theme/            # t_*.dart (theme tokens & styles)
│   └── utils/            # m_*.dart (pure calculations & helpers)
├── features/
│   ├── auth/             # s_auth_gate.dart, s_login.dart, vm_auth.dart, components/
│   ├── home/             # s_home.dart, vm_home.dart
│   └── settings/         # s_settings.dart, vm_settings.dart, components/
└── main.dart             # Untouched entrypoint
```

---

## Core Invariants
1. **Currency Independence**: USD and EGP are strictly separate. Never sum or convert automatically.
2. **One Expense, One Currency**: Every expense is strictly USD or strictly EGP.
3. **Keep Files Short**: Break complex layouts into atomic `c_*.dart` components and `a_*.dart` animations.
