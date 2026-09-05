#!/usr/bin/env python3
"""
Continuous Invariant Watcher Sidecar for egy_tracker
Runs autonomously in background, monitoring the codebase for domain invariant violations.
"""

import time
import os
import sys
import datetime

# Add scripts directory to path to reuse check logic
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(CURRENT_DIR, "../../../"))
SCRIPTS_DIR = os.path.join(PROJECT_ROOT, "scripts")
sys.path.insert(0, SCRIPTS_DIR)

try:
    from invariant_guard import scan_files
except ImportError:
    def scan_files(directory):
        return []

LOG_FILE = os.path.join(CURRENT_DIR, "status.log")
POLL_INTERVAL = int(os.environ.get("POLL_INTERVAL", "5"))

def log(message):
    timestamp = datetime.datetime.now().isoformat()
    entry = f"[{timestamp}] {message}\n"
    sys.stdout.write(entry)
    sys.stdout.flush()
    try:
        with open(LOG_FILE, "a") as f:
            f.write(entry)
    except Exception:
        pass

def main():
    log("Currency Invariant Watcher sidecar started.")
    lib_dir = os.path.join(PROJECT_ROOT, "lib")
    test_dir = os.path.join(PROJECT_ROOT, "test")

    last_violation_count = -1

    while True:
        try:
            violations = []
            violations.extend(scan_files(lib_dir))
            violations.extend(scan_files(test_dir))

            if len(violations) != last_violation_count:
                last_violation_count = len(violations)
                if violations:
                    log(f"ALERT: {len(violations)} domain invariant violation(s) detected!")
                    for v in violations:
                        log(f"  - {v}")
                else:
                    log("OK: Zero domain invariant violations. All currencies and models compliant.")
        except Exception as e:
            log(f"Error during scan: {e}")

        time.sleep(POLL_INTERVAL)

if __name__ == "__main__":
    main()
