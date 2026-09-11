#!/usr/bin/env python3
"""
PreInvocation Context Injector for Gemini 3.8 Flash High.
Triggered by Antigravity PreInvocation hook in .agents/hooks.json.

Injects high-signal codebase map and efficiency directives into the agent prompt
as an ephemeral system message, eliminating cold-start file exploration.
"""

import sys
import os
import json

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))
SUMMARY_FILE = os.path.join(PROJECT_ROOT, ".agents", "cache", "repo_map_summary.txt")
INDEXER_SCRIPT = os.path.join(SCRIPT_DIR, "generate_codebase_index.py")

def ensure_summary():
    if not os.path.exists(SUMMARY_FILE):
        os.system(f"python3 {INDEXER_SCRIPT} --quiet")

def main():
    # Consume stdin payload if provided
    try:
        if not sys.stdin.isatty():
            _ = sys.stdin.read()
    except Exception:
        pass

    ensure_summary()

    summary_text = ""
    if os.path.exists(SUMMARY_FILE):
        try:
            with open(SUMMARY_FILE, "r", encoding="utf-8") as f:
                summary_text = f.read().strip()
        except Exception:
            pass

    ephemeral_msg = (
        "[GEMINI 3.8 FLASH HIGH SPEED DIRECTIVES & ARCHITECTURE MAP]\n"
        "⚡ SPEED INVARIANTS (Never read all files):\n"
        "1. Never call `view_file` without line range (`StartLine`, `EndLine`) on files > 50 lines.\n"
        "2. Locate symbols instantly: Run `python3 scripts/find_symbol.py <symbol>` or view `.agents/cache/codebase_index.md`.\n"
        "3. Search with precision: Use `grep_search` with `MatchPerLine: true` and `Includes` pattern.\n"
        "4. Surgical editing: Use `replace_file_content` targeting exact line slices; verify with `flutter analyze`.\n\n"
        f"{summary_text}"
    )

    output = {
        "injectSteps": [
            {
                "ephemeralMessage": ephemeral_msg
            }
        ]
    }

    sys.stdout.write(json.dumps(output))
    sys.stdout.flush()

if __name__ == "__main__":
    main()
