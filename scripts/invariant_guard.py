#!/usr/bin/env python3
"""
Invariant Guard for egy_tracker
Enforces domain invariants from two_currency_expense_tracker_mvp.md across:
- Antigravity PreToolUse / PostToolUse hook payloads (via stdin)
- Git pre-commit hooks (scans git diff or staged files)
- Standalone CLI scans (scans lib/ and test/)
"""

import sys
import os
import json
import re

FORBIDDEN_PATTERNS = [
    (r"\b(DZD|algerian[_\s]*dinar)\b", "Currency 'DZD' is strictly out of scope."),
    (r"\b(convert_?to_?(usd|egp)|auto_?convert)\b", "Automatic currency conversion is forbidden."),
    (r"\b(global_?exchange_?rate|fetch_?exchange_?rate|exchange_?rate_?api)\b", "Global or fetched exchange rates are forbidden."),
    (r"\b(combined_?total|total_?equivalent|usd_?equivalent|egp_?equivalent)\b", "Combining USD and EGP into a single sum is forbidden."),
    (r"\b(trip_?name|trip_?manager|create_?trip|switch_?trip)\b", "Multiple trips or trip naming is out of scope."),
    (r"\b(expense_?category|category_?picker|categories_?list)\b", "Expense categories are out of scope."),
    (r"\b(optimize_?settlement|debt_?graph|settle_?debts)\b", "Settlement and debt optimization are out of scope."),
]

def check_text(text, source_name="code"):
    violations = []
    for pattern, description in FORBIDDEN_PATTERNS:
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            violations.append(f"[{source_name}] Match '{match.group(0)}': {description}")
    return violations

def scan_files(directory):
    violations = []
    if not os.path.exists(directory):
        return violations
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".dart"):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
                        content = f.read()
                        violations.extend(check_text(content, source_name=file_path))
                except Exception as e:
                    violations.append(f"Error reading {file_path}: {e}")
    return violations

def handle_hook_input(payload):
    # Check if toolCall arguments contain content to be written
    tool_call = payload.get("toolCall", {})
    args = tool_call.get("args", {})
    code_to_check = ""

    if "CodeContent" in args:
        code_to_check += args["CodeContent"] + "\n"
    if "ReplacementContent" in args:
        code_to_check += args["ReplacementContent"] + "\n"
    if "ReplacementChunks" in args and isinstance(args["ReplacementChunks"], list):
        for chunk in args["ReplacementChunks"]:
            if isinstance(chunk, dict) and "ReplacementContent" in chunk:
                code_to_check += chunk["ReplacementContent"] + "\n"
    if "CommandLine" in args:
        code_to_check += args["CommandLine"] + "\n"

    violations = check_text(code_to_check, source_name="ToolCall Payload")
    if violations:
        output = {
            "decision": "deny",
            "reason": "Domain invariant violation:\n" + "\n".join(violations)
        }
    else:
        output = {
            "decision": "allow"
        }
    sys.stdout.write(json.dumps(output))
    sys.stdout.flush()

def main():
    # If standard input contains JSON from Antigravity Hook
    if not sys.stdin.isatty():
        try:
            stdin_content = sys.stdin.read().strip()
            if stdin_content.startswith("{") and stdin_content.endswith("}"):
                data = json.loads(stdin_content)
                if "toolCall" in data or "stepIdx" in data:
                    handle_hook_input(data)
                    return
        except Exception:
            pass

    # CLI scan mode
    repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    lib_dir = os.path.join(repo_root, "lib")
    test_dir = os.path.join(repo_root, "test")

    violations = []
    violations.extend(scan_files(lib_dir))
    violations.extend(scan_files(test_dir))

    if violations:
        sys.stderr.write("=== Invariant Guard Violations Detected ===\n")
        for v in violations:
            sys.stderr.write(f"- {v}\n")
        sys.exit(1)
    else:
        sys.stdout.write("Invariant Guard: All domain invariants passed cleanly.\n")
        sys.exit(0)

if __name__ == "__main__":
    main()
