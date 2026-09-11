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

### Rule 1: Zero Full-File Dumps
- **PROHIBITED**: Calling `view_file` without line range constraints on files longer than 50 lines.
- **MANDATORY**: Always specify `StartLine` and `EndLine` to inspect only the targeted 20–50 line window containing the relevant function, widget, or property.

### Rule 2: Index-First Symbol Resolution
- Before inspecting files to locate a class, function, or model, consult the pre-computed index:
  1. Quick CLI: Run `python3 scripts/find_symbol.py <symbol>` to get the exact file and line slice.
  2. Index Catalog: View [.agents/cache/codebase_index.md](file:///.agents/cache/codebase_index.md).
  3. Machine Map: Read specific keys from [.agents/cache/repo_map.json](file:///.agents/cache/repo_map.json).

### Rule 3: Surgical Search Over Directory Crawling
- **PROHIBITED**: Recursive `list_dir` exploration or inspecting folders to "find where things are".
- **MANDATORY**: Use `grep_search` with:
  - `MatchPerLine: true`
  - Exact regex or query string
  - `Includes` pattern (e.g. `["lib/**/*.dart"]`)

### Rule 4: Single-Pass Surgical Edits
- Locate the exact line range using `find_symbol.py` or `grep_search`.
- Inspect the targeted 20–40 line slice using `view_file`.
- Apply targeted modifications with `replace_file_content`.
- Never rewrite entire files unless creating a new file from scratch.

### Rule 5: Fast Verification over File Re-Scanning
- After editing code, **do not re-read all dependent files**.
- Run `flutter analyze` or execute targeted unit/scenario tests to verify compilation and correctness.
- The `PostToolUse` hook automatically synchronizes the index cache upon file edits.

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
