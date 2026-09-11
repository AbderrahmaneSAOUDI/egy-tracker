#!/usr/bin/env python3
"""
Continuous Background Codebase Index Daemon for egy_tracker.
Maintains .agents/cache/ fresh in real time for Gemini 3.8 Flash High.
"""

import os
import sys
import time
import datetime

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(CURRENT_DIR, "../../.."))
SCRIPTS_DIR = os.path.join(PROJECT_ROOT, "scripts")
LOG_FILE = os.path.join(CURRENT_DIR, "indexer_daemon.log")
POLL_INTERVAL = int(os.environ.get("POLL_INTERVAL", "3"))

sys.path.insert(0, SCRIPTS_DIR)
try:
    from generate_codebase_index import scan_codebase
except ImportError:
    scan_codebase = None

def log(msg):
    timestamp = datetime.datetime.now().isoformat()
    entry = f"[{timestamp}] {msg}\n"
    sys.stdout.write(entry)
    sys.stdout.flush()
    try:
        with open(LOG_FILE, "a", encoding="utf-8") as f:
            f.write(entry)
    except Exception:
        pass

def get_latest_mtime(directories):
    latest = 0.0
    for d in directories:
        if not os.path.exists(d):
            continue
        for root, _, files in os.walk(d):
            for file in files:
                if file.endswith(".dart"):
                    try:
                        mtime = os.path.getmtime(os.path.join(root, file))
                        if mtime > latest:
                            latest = mtime
                    except Exception:
                        pass
    return latest

def main():
    once = "--once" in sys.argv
    log("Codebase Index Daemon initialized.")

    if not scan_codebase:
        log("Error: could not import scan_codebase from scripts/generate_codebase_index.py")
        sys.exit(1)

    watch_dirs = [
        os.path.join(PROJECT_ROOT, "lib"),
        os.path.join(PROJECT_ROOT, "test")
    ]

    last_indexed_mtime = -1.0

    while True:
        try:
            latest_mtime = get_latest_mtime(watch_dirs)
            if latest_mtime > last_indexed_mtime:
                file_count, sym_count, elapsed = scan_codebase()
                last_indexed_mtime = latest_mtime
                log(f"Index updated: {file_count} files, {sym_count} symbols in {elapsed}ms")

            if once:
                break
        except Exception as e:
            log(f"Error during index update: {e}")

        time.sleep(POLL_INTERVAL)

if __name__ == "__main__":
    main()
