# Gemini & Antigravity IDE Engineering Directives — egy_tracker

This document governs the Antigravity Agent and Gemini CLI within `/home/saoudi26/Documents/GitHub/PERSONAL/egy_tracker`.

---

## 1. Primary Directives & Invariants

You are working on a private two-user expense tracker for a trip in Egypt. The single source of truth is [two_currency_expense_tracker_mvp.md](file:///home/saoudi26/Documents/GitHub/PERSONAL/egy_tracker/two_currency_expense_tracker_mvp.md).

### Non-Negotiable Invariants:
1. **USD and EGP are strictly separate**: Never sum USD and EGP together into an equivalent value. Never apply a global or dynamic exchange rate.
2. **One Expense, One Currency**: Every expense is either USD or EGP.
3. **Exchanges Are Transfers**: Exchanges only move money between a user's own USD and EGP balances; they are not expenses.
4. **Physical Cash vs. Consumption**: `paid_by` subtracts the full cash amount from the payer's balance. Split percentages (`me_percentage + friend_percentage == 100`) allocate personal consumption share.
5. **Initial Balances in Settings**: Starting money is set in Settings, never generated as fake transactions.
6. **Strict Out-of-Scope**: Do NOT introduce DZD, categories, trip naming, budget goals, or settlement debt optimization.

---

## 2. Flutter / Dart Tooling Rules

When modifying Dart/Flutter files:
1. Connect proactively to the running app using `dtd` if available.
2. Trigger a hot reload using `hot_reload` when Dart code is updated.
3. If no app is running, continue without disruption.
4. Always verify code with `flutter analyze` or `dart analyze`.
5. Keep UI, state, and calculation logic separated:
   - Math functions in `lib/core/utils/m_calculations.dart` (`Calculations`)
   - Data models in `lib/core/models/` (`mod_*.dart`)
   - Services in `lib/core/services/` (`f_auth.dart`, `f_firestore.dart`)
   - Screens adhering to the 3-tab layout in `lib/features/` (`home/`, `my_tracker/`, `settings/`).

---

## 3. Gemini 3.8 Flash High Speed & Indexing Directives

To maximize velocity and avoid reading all files each turn:
1. **Never read entire files**: Prohibit `view_file` on files > 50 lines without `StartLine` and `EndLine`. Always read 20-50 line slices.
2. **Instant Symbol Lookup**: Run `python3 scripts/find_symbol.py <symbol>` or check `.agents/cache/codebase_index.md` before inspecting files.
3. **Targeted Search**: Use `grep_search` with `MatchPerLine: true` and `Includes` globs instead of directory browsing.
4. **Surgical Modifications**: Apply targeted edits with `replace_file_content`. Run `flutter analyze` or unit tests to verify instead of re-reading code.
5. **Background Indexing**: The `codebase-index-daemon` sidecar and `cache-auto-updater` hook maintain `.agents/cache/` continuously.

---

## 4. Reference Files & Customizations
- Multi-agent specifications: [AGENTS.md](file:///home/saoudi26/Documents/GitHub/PERSONAL/egy_tracker/AGENTS.md)
- Claude specifications: [CLAUDE.md](file:///home/saoudi26/Documents/GitHub/PERSONAL/egy_tracker/CLAUDE.md)
- Codebase Index Catalog: [.agents/cache/codebase_index.md](file:///.agents/cache/codebase_index.md)
- Antigravity Rules: `.agents/rules/`
- Antigravity Skills: `.agents/skills/`
- Antigravity Lifecycle Hooks: `.agents/hooks.json`
- Antigravity Sidecars: `.agents/sidecars/`
