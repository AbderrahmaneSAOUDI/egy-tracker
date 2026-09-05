#!/usr/bin/env bash
# Background scenario verification daemon for egy_tracker

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$CURRENT_DIR/../../.." && pwd)"
LOG_FILE="$CURRENT_DIR/test_daemon.log"

echo "[$(date -Iseconds)] Flutter test daemon sidecar initialized." >> "$LOG_FILE"

while true; do
  OUTPUT=$(dart run "$PROJECT_ROOT/.agents/skills/egy-tracker-qa-verifier/scripts/verify_scenarios.dart" 2>&1)
  STATUS=$?
  if [ $STATUS -eq 0 ]; then
    echo "[$(date -Iseconds)] Scenario verification OK: All 5 scenarios passed." >> "$LOG_FILE"
  else
    echo "[$(date -Iseconds)] Scenario verification FAILED: $OUTPUT" >> "$LOG_FILE"
  fi
  sleep 15
done
