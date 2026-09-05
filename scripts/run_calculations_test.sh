#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== Running egy_tracker Calculation & Invariant Tests ==="
python3 "$REPO_ROOT/scripts/invariant_guard.py"
dart run "$REPO_ROOT/.agents/skills/egy-tracker-qa-verifier/scripts/verify_scenarios.dart"
echo "All calculation checks passed successfully!"
