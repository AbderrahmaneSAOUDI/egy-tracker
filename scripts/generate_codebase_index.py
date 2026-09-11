#!/usr/bin/env python3
"""
High-Speed Codebase Indexer & Symbol Map Generator for egy_tracker.
Optimized for Gemini 3.8 Flash High.

Generates:
1. .agents/cache/repo_map.json (Machine-readable symbol index with exact line numbers)
2. .agents/cache/codebase_index.md (Human & model-readable architectural symbol catalog)
3. .agents/cache/repo_map_summary.txt (Ultra-compact ~35-line context summary for hook injection)

Runs in < 50ms using efficient regex parsing.
"""

import os
import sys
import json
import re
import time

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))
CACHE_DIR = os.path.join(PROJECT_ROOT, ".agents", "cache")

CLASS_RE = re.compile(r"^(?:abstract\s+)?(?:class|enum|mixin|extension)\s+([A-Za-z0-9_]+)", re.MULTILINE)
METHOD_RE = re.compile(
    r"^\s{2,4}(?:@override\s+)?(?:static\s+)?(?:[A-Za-z0-9_<>,?\s]+\s+)?([A-Za-z0-9_]+)\s*\(([^)]*)\)\s*(?:async\s*)?[{;]",
    re.MULTILINE
)
FIELD_RE = re.compile(r"^\s{2,4}(?:final|const|late)?\s*([A-Za-z0-9_<>?,]+)\s+([A-Za-z0-9_]+)\s*[;=]", re.MULTILINE)
TOP_LEVEL_FUNC_RE = re.compile(r"^(?:[A-Za-z0-9_<>,?\s]+\s+)?([A-Za-z0-9_]+)\s*\(([^)]*)\)\s*(?:async\s*)?[{]", re.MULTILINE)

def parse_dart_file(rel_path, abs_path):
    try:
        with open(abs_path, "r", encoding="utf-8", errors="ignore") as f:
            lines = f.readlines()
    except Exception:
        return []

    symbols = []
    current_class = None

    for idx, line in enumerate(lines):
        line_num = idx + 1
        stripped = line.strip()

        # Check class / enum / mixin
        class_match = re.match(r"^(?:abstract\s+)?(class|enum|mixin|extension)\s+([A-Za-z0-9_]+)", stripped)
        if class_match:
            kind, name = class_match.groups()
            current_class = name
            symbols.append({
                "name": name,
                "kind": kind,
                "class": None,
                "file": rel_path,
                "line": line_num,
                "signature": stripped.split("{")[0].strip()
            })
            continue

        # Reset class if top-level closing brace at col 0
        if line.startswith("}"):
            current_class = None
            continue

        # Check top-level function if not in a class
        if not current_class:
            func_match = re.match(r"^(?:[A-Za-z0-9_<>,?]+\s+)?([A-Za-z0-9_]+)\s*\(([^)]*)\)\s*(?:async\s*)?[{]", stripped)
            if func_match and not stripped.startswith("typedef") and not stripped.startswith("return"):
                name, args = func_match.groups()
                if name not in ("if", "for", "while", "switch", "catch"):
                    symbols.append({
                        "name": name,
                        "kind": "function",
                        "class": None,
                        "file": rel_path,
                        "line": line_num,
                        "signature": f"{name}({args})"
                    })
            continue

        # Inside class: check important methods / constructors / key fields
        if current_class:
            # Constructor
            if re.match(rf"^(?:const\s+)?{current_class}(?:\.[a-zA-Z0-9_]+)?\s*\(", stripped):
                sig = stripped.split("{")[0].split(";")[0].strip()
                symbols.append({
                    "name": current_class if not "." in sig else sig.split("(")[0],
                    "kind": "constructor",
                    "class": current_class,
                    "file": rel_path,
                    "line": line_num,
                    "signature": sig
                })
                continue

            # Getter
            getter_match = re.match(r"^(?:@override\s+)?(?:static\s+)?(?:[A-Za-z0-9_<>,?\[\]]+\s+)?get\s+([A-Za-z0-9_]+)\s*(?:=>|[{])", stripped)
            if getter_match:
                gname = getter_match.group(1)
                symbols.append({
                    "name": gname,
                    "kind": "getter",
                    "class": current_class,
                    "file": rel_path,
                    "line": line_num,
                    "signature": f"get {gname}"
                })
                continue

            # Method or function (including named args or multi-line signatures)
            method_match = re.match(
                r"^(?:@override\s+)?(?:static\s+)?(?:[A-Za-z0-9_<>,?\[\]]+\s+)?([A-Za-z0-9_]+)\s*(\([^{;]*\)?|\{)",
                stripped
            )
            if method_match:
                name, args_part = method_match.groups()
                if name not in ("if", "for", "while", "switch", "catch", "toString", "return", "final", "const", "super"):
                    symbols.append({
                        "name": name,
                        "kind": "method",
                        "class": current_class,
                        "file": rel_path,
                        "line": line_num,
                        "signature": stripped.split("{")[0].split(";")[0].strip()
                    })
                    continue

            # Key property
            field_match = re.match(r"^(?:final|const)\s+([A-Za-z0-9_<>?,]+)\s+([A-Za-z0-9_]+)\s*[;=]", stripped)
            if field_match:
                ftype, fname = field_match.groups()
                symbols.append({
                    "name": fname,
                    "kind": "field",
                    "class": current_class,
                    "file": rel_path,
                    "line": line_num,
                    "signature": f"{ftype} {fname}"
                })

    return symbols

def categorize_file(rel_path):
    if "core/models" in rel_path:
        return "Core Models"
    elif "core/services" in rel_path:
        return "Core Services"
    elif "core/utils" in rel_path:
        return "Core Utilities & Math"
    elif "core/components" in rel_path:
        return "Core UI Components"
    elif "core/animations" in rel_path:
        return "Core Animations"
    elif "core/theme" in rel_path:
        return "Theme"
    elif "features/home" in rel_path:
        return "Feature: Home Tab"
    elif "features/my_tracker" in rel_path:
        return "Feature: My Tracker Tab"
    elif "features/settings" in rel_path:
        return "Feature: Settings Tab"
    elif "features/auth" in rel_path:
        return "Feature: Auth"
    elif rel_path.startswith("test/"):
        return "Tests"
    else:
        return "Root / Config"

def scan_codebase():
    start_time = time.time()
    os.makedirs(CACHE_DIR, exist_ok=True)

    all_symbols = []
    file_map = {}
    total_lines = 0

    scan_dirs = [os.path.join(PROJECT_ROOT, "lib"), os.path.join(PROJECT_ROOT, "test")]

    for scan_dir in scan_dirs:
        if not os.path.exists(scan_dir):
            continue
        for root, _, files in os.walk(scan_dir):
            for file in files:
                if file.endswith(".dart"):
                    abs_path = os.path.join(root, file)
                    rel_path = os.path.relpath(abs_path, PROJECT_ROOT)

                    with open(abs_path, "r", encoding="utf-8", errors="ignore") as f:
                        line_count = sum(1 for _ in f)
                    total_lines += line_count

                    syms = parse_dart_file(rel_path, abs_path)
                    all_symbols.extend(syms)
                    file_map[rel_path] = {
                        "category": categorize_file(rel_path),
                        "lineCount": line_count,
                        "symbols": syms
                    }

    # 1. Output repo_map.json
    repo_map_path = os.path.join(CACHE_DIR, "repo_map.json")
    symbol_dict = {}
    for s in all_symbols:
        key = s["name"] if not s["class"] else f"{s['class']}.{s['name']}"
        symbol_dict[key] = {
            "name": s["name"],
            "kind": s["kind"],
            "class": s["class"],
            "file": s["file"],
            "line": s["line"],
            "signature": s["signature"]
        }

    output_data = {
        "generatedAt": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "totalFiles": len(file_map),
        "totalLines": total_lines,
        "totalSymbols": len(symbol_dict),
        "files": file_map,
        "symbols": symbol_dict
    }

    with open(repo_map_path, "w", encoding="utf-8") as f:
        json.dump(output_data, f, indent=2)

    # 2. Output codebase_index.md
    index_md_path = os.path.join(CACHE_DIR, "codebase_index.md")
    categories = [
        "Core Models",
        "Core Services",
        "Core Utilities & Math",
        "Feature: Home Tab",
        "Feature: My Tracker Tab",
        "Feature: Settings Tab",
        "Feature: Auth",
        "Core UI Components",
        "Core Animations",
        "Theme",
        "Root / Config",
        "Tests"
    ]

    md_lines = [
        "# egy_tracker — High-Speed Codebase & Symbol Index",
        f"*Generated automatically in {round((time.time() - start_time)*1000, 1)}ms for Gemini 3.8 Flash High.*",
        "",
        "> [!TIP]",
        "> **Surgical Navigation**: Check this index or use `python3 scripts/find_symbol.py <symbol>` to pinpoint file and line numbers without reading entire files.",
        "",
        "## Summary Metrics",
        f"- **Total Dart Files**: {len(file_map)}",
        f"- **Total Dart Lines**: {total_lines}",
        f"- **Indexed Symbols**: {len(symbol_dict)}",
        "",
        "---",
        ""
    ]

    for cat in categories:
        cat_files = {p: info for p, info in file_map.items() if info["category"] == cat}
        if not cat_files:
            continue

        md_lines.append(f"## {cat}")
        md_lines.append("| File | Lines | Key Classes / Functions | Primary Purpose |")
        md_lines.append("| :--- | :---: | :--- | :--- |")

        for fpath, info in sorted(cat_files.items()):
            classes = [s["name"] for s in info["symbols"] if s["kind"] in ("class", "enum", "mixin")]
            funcs = [s["name"] for s in info["symbols"] if s["kind"] == "function"]
            key_names = ", ".join(classes + funcs[:3]) if (classes or funcs) else "-"
            md_lines.append(f"| [`{fpath}`]({fpath}) | {info['lineCount']} | {key_names} | {cat} |")

        md_lines.append("")

    with open(index_md_path, "w", encoding="utf-8") as f:
        f.write("\n".join(md_lines))

    # 3. Output repo_map_summary.txt (Ultra-compact context summary for PreInvocation hook)
    summary_path = os.path.join(CACHE_DIR, "repo_map_summary.txt")
    summary_lines = [
        "EGY_TRACKER ARCHITECTURE MAP (FAST REFERENCE):",
        "- Models (lib/core/models/): Expense(mod_expense.dart), Exchange(mod_exchange.dart), Borrow(mod_borrow.dart), UserProfile(mod_user_profile.dart), AllowedEmail(mod_allowed_email.dart), InitialBalance(mod_initial_balance.dart)",
        "- Services (lib/core/services/): AuthService(f_auth.dart), FirestoreService(f_firestore.dart)",
        "- Math & Utils (lib/core/utils/): calculateCurrentBalances, calculatePersonalShare (m_calculations.dart), Validators(m_validators.dart), Formatters(m_formatters.dart)",
        "- Home Tab (lib/features/home/): HomeScreen(s_home.dart), HomeTab(s_home_tab.dart), HomeFeedVM(vm_home_feed.dart)",
        "- My Tracker Tab (lib/features/my_tracker/): MyTrackerScreen(s_my_tracker.dart), MyTrackerVM(vm_my_tracker.dart)",
        "- Settings Tab (lib/features/settings/): SettingsScreen(s_settings.dart), SettingsVM(vm_settings.dart)",
        "- Auth (lib/features/auth/): LoginScreen(s_login.dart)",
        "- Navigation: 3 tabs (Home, My Tracker, Settings). Strict separation of USD ($) and EGP (EGP).",
        "- Quick Lookup: Run `python3 scripts/find_symbol.py <symbol>` or grep_search. Avoid reading full files."
    ]

    with open(summary_path, "w", encoding="utf-8") as f:
        f.write("\n".join(summary_lines) + "\n")

    return len(file_map), len(symbol_dict), round((time.time() - start_time) * 1000, 1)

def main():
    quiet = "--quiet" in sys.argv
    file_count, sym_count, elapsed = scan_codebase()

    if quiet:
        # Hook output: expected {} for PostToolUse
        sys.stdout.write("{}\n")
        sys.stdout.flush()
    else:
        sys.stdout.write(f"Index generated: {file_count} files, {sym_count} symbols in {elapsed}ms\n")
        sys.stdout.write(f"Cache location: {CACHE_DIR}\n")

if __name__ == "__main__":
    main()
