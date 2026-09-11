---
name: flash-surgical-editor
description: >-
  Use this skill when making modifications, bug fixes, or feature additions in
  egy_tracker at maximum speed. Enforces single-pass surgical edits and targeted
  test verification without scanning multiple files.
---

# Flash Surgical Editor Skill for egy_tracker

This skill defines the high-velocity, token-conserving editing workflow for Gemini 3.8 Flash High.

---

## 4-Step Surgical Edit Cycle

```
[1. Locate Symbol] ➔ [2. Slice View] ➔ [3. Exact Replace] ➔ [4. Analyze / Test]
 (find_symbol.py)     (view_file slice)    (replace_file)      (flutter analyze)
```

---

### Step 1: Pinpoint Target Line Range
Do not search file by file. Look up the declaration immediately:
```bash
python3 scripts/find_symbol.py <TargetSymbol>
```
Note the file path and line number.

### Step 2: Read Only the Enclosing Slice
Call `view_file` specifying `StartLine` and `EndLine`:
- `StartLine = max(1, line - 5)`
- `EndLine = line + 35`
Confirm the exact character sequence for the replacement.

### Step 3: Single-Pass Surgical Modification
Use `replace_file_content` with:
- Tight `StartLine` and `EndLine`
- Exact `TargetContent`
- Correct `ReplacementContent`

*Note: The `cache-auto-updater` lifecycle hook will automatically re-index `.agents/cache/` after the file edit finishes.*

### Step 4: Verify Without Scanning Dependent Files
Do not view surrounding files to see if they broke. Use automated verification tools:
```bash
flutter analyze
```
And verify domain invariants:
```bash
python3 scripts/invariant_guard.py
```
If verification passes cleanly, the task is complete.
