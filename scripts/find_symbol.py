#!/usr/bin/env python3
"""
Instant Symbol & File Lookup Utility for egy_tracker.
Optimized for Gemini 3.8 Flash High.

Usage:
  python3 scripts/find_symbol.py <SymbolName>
  python3 scripts/find_symbol.py <Keyword> --files

Outputs exact file path, declaration line, signature, and recommended view_file slice.
"""

import sys
import os
import json

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))
CACHE_FILE = os.path.join(PROJECT_ROOT, ".agents", "cache", "repo_map.json")

def ensure_cache():
    if not os.path.exists(CACHE_FILE):
        os.system(f"python3 {os.path.join(SCRIPT_DIR, 'generate_codebase_index.py')} --quiet")

def search(query, files_only=False):
    ensure_cache()
    if not os.path.exists(CACHE_FILE):
        sys.stderr.write("Error: Could not generate codebase cache.\n")
        sys.exit(1)

    with open(CACHE_FILE, "r", encoding="utf-8") as f:
        data = json.load(f)

    query_lower = query.lower()
    matches = []

    # Search in symbols
    symbols = data.get("symbols", {})
    for key, sym in symbols.items():
        if query_lower == key.lower() or query_lower == sym["name"].lower() or query_lower in key.lower():
            matches.append(sym)

    # Search in files
    file_matches = []
    for fpath, finfo in data.get("files", {}).items():
        if query_lower in fpath.lower():
            file_matches.append((fpath, finfo))

    if files_only or not matches:
        if file_matches:
            print(f"=== Matching Files for '{query}' ===")
            for fpath, finfo in file_matches:
                print(f"- {fpath} ({finfo['lineCount']} lines, {finfo['category']})")
                classes = [s["name"] for s in finfo["symbols"] if s["kind"] in ("class", "enum", "mixin")]
                if classes:
                    print(f"  Classes: {', '.join(classes)}")
            return
        elif not matches:
            print(f"No exact symbol or file match found for '{query}'. Try grep_search.")
            return

    print(f"=== Symbol Matches for '{query}' (Found {len(matches)}) ===")
    for m in matches[:10]:
        cls_str = f" [{m['class']}]" if m.get("class") else ""
        print(f"\nSymbol: {m['name']}{cls_str} ({m['kind']})")
        print(f"File:   {m['file']}:{m['line']}")
        print(f"Sig:    {m['signature']}")
        start_line = max(1, m['line'] - 2)
        end_line = m['line'] + 25
        print(f"Slice:  view_file StartLine: {start_line} EndLine: {end_line}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 scripts/find_symbol.py <symbol_or_keyword> [--files]")
        sys.exit(1)
    
    q = sys.argv[1]
    files_flag = "--files" in sys.argv
    search(q, files_only=files_flag)
