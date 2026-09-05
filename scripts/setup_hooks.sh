#!/usr/bin/env bash
# Sets up local git hooks for any developer or external AI agent

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

chmod +x "$REPO_ROOT/.githooks/pre-commit"
chmod +x "$REPO_ROOT/scripts/invariant_guard.py"
chmod +x "$REPO_ROOT/scripts/run_calculations_test.sh"

git config core.hooksPath .githooks

echo "Git hooks configured successfully to use .githooks/"
