---
name: fast-codebase-navigator
description: >-
  Use this skill to navigate, locate symbols, inspect classes, and understand
  project architecture in egy_tracker without reading all files. Provides instant
  symbol and file resolution for Gemini 3.8 Flash High.
---

# Fast Codebase Navigator Skill for egy_tracker

This skill provides an ultra-fast, token-efficient procedure for locating any class, method, function, or file in `egy_tracker` without scanning or dumping entire files.

---

## 1. Instant Symbol Lookup

Before calling `view_file` or searching directories, look up the symbol using the pre-computed index:

```bash
python3 scripts/find_symbol.py <SymbolName>
```

**Example output:**
```text
Symbol: Expense (class)
File:   lib/core/models/mod_expense.dart:1
Sig:    class Expense
Slice:  view_file StartLine: 1 EndLine: 26
```

If searching for a specific file or feature area:
```bash
python3 scripts/find_symbol.py <Keyword> --files
```

---

## 2. Pre-Computed Index Reference

The entire codebase is indexed into a structured Markdown catalog:
- View the catalog: [.agents/cache/codebase_index.md](file:///.agents/cache/codebase_index.md)
- Machine mapping: [.agents/cache/repo_map.json](file:///.agents/cache/repo_map.json)

---

## 3. Targeted Line-Sliced Inspection

Once the file and line number are known:
1. Open only the 20–40 line slice around the target:
   ```json
   {
     "AbsolutePath": ".../lib/core/models/mod_expense.dart",
     "StartLine": 1,
     "EndLine": 30
   }
   ```
2. **Never** omit `StartLine` and `EndLine` on files over 50 lines.

---

## 4. Targeted Grep Pattern

If looking for a specific string literal or error message:
- Use `grep_search` with:
  - `MatchPerLine: true`
  - `Includes: ["lib/**/*.dart"]`
- Do not run recursive directory listings.
