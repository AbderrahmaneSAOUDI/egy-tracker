---
trigger: always_on
---

# Antigravity Rule: Gemini 3.8 Flash High Speed & Indexing Invariants

Applies to all interactions, tool calls, and coding tasks within `egy_tracker`.

---

## 1. High-Speed Operating Philosophy
Gemini 3.8 Flash High is optimized for ultra-low latency, fast reasoning, and surgical code modifications. To prevent unnecessary token overhead and tool latency, **never read entire files or perform blind repository scans**.

---

## 2. Invariants & Rules for File Access

### Rule 1: Single-Turn Parallel Reading & Batching
- Read files in full with a single `view_file` call. When multiple files are needed to understand a feature or fix a bug, emit multiple `view_file` or `grep_search` calls in the SAME turn to parallelize lookups.
- Never fragment file reads into tiny line slices unless the file exceeds 500 lines.

### Rule 2: Precision Search
- Use `grep_search` with `MatchPerLine: true` and `Includes: ["lib/**/*.dart"]` to pinpoint symbols, strings, or widget usages across the project.

### Rule 3: Single-Pass Surgical Edits
- Inspect code, determine the exact replacement, and apply changes in clean, focused `replace_file_content` calls.

### Rule 4: Hyper-Fast Targeted Verification
- **Selective Testing**: NEVER run the full test suite (`flutter test`, ~25s) for localized changes. Run only the specific test file impacted: e.g. `flutter test test/dialogs_and_animations_test.dart` (~2s).
- **Targeted Lint**: Run `dart analyze lib/path/to/modified_file.dart` for fast verification instead of full repo analysis when possible.

### Rule 5: State & Architecture Invariants
- State and business logic belong in ViewModels (`vm_*.dart`), not embedded inside UI widgets.
- Reusable UI elements belong in `lib/core/components/` (`c_*.dart`).
- Pure calculations and formatters belong in `m_calculations.dart` and `m_formatters.dart`.

---

## 3. Canonical Architecture Quick-Reference

Use this mapping directly without querying the filesystem:

| Layer | Directory | Key Files |
| :--- | :--- | :--- |
| **Models** | `lib/core/models/` | `mod_expense.dart`, `mod_exchange.dart`, `mod_borrow.dart`, `mod_user_profile.dart`, `mod_allowed_email.dart`, `mod_initial_balance.dart` |
| **Services** | `lib/core/services/` | `f_auth.dart` (`AuthService`), `f_firestore.dart` (`FirestoreService`) |
| **Calculations** | `lib/core/utils/` | `m_calculations.dart` (`Calculations.calculateCashBalance`, `Calculations.calculatePersonalShare`) |
| **Validators & Formatters**| `lib/core/utils/` | `m_validators.dart`, `m_formatters.dart` |
| **Home Feature** | `lib/features/home/` | `s_home.dart`, `s_home_tab.dart`, `vm_home_feed.dart`, `components/` |
| **My Tracker Feature** | `lib/features/my_tracker/` | `s_my_tracker.dart`, `vm_my_tracker.dart`, `components/` |
| **Settings Feature** | `lib/features/settings/` | `s_settings.dart`, `vm_settings.dart`, `components/` |
| **Auth Feature** | `lib/features/auth/` | `s_login.dart` |
| **Components** | `lib/core/components/` | Reusable atomic widgets (`c_*.dart`) |
| **Animations** | `lib/core/animations/` | Reusable transitions (`a_*.dart`) |
