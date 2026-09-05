---
name: egy-tracker-qa-verifier
description: >-
  Use this skill to audit, test, and verify the integrity of egy_tracker code.
  Runs static analysis, checks for domain invariant violations, and executes
  the MVP calculation scenarios (Scenarios A through E).
---

# QA Verifier Skill for egy_tracker

This skill provides quality assurance and verification workflows.

## Verification Checklist

1. **Domain Invariant Audit**:
   Execute the invariant guard script to ensure zero forbidden constructs (e.g. `DZD`, automatic conversions, combined totals):
   ```bash
   python3 scripts/invariant_guard.py
   ```

2. **Scenario Calculation Verification**:
   Execute the automated Dart test asserting all 5 scenarios from the MVP specification:
   ```bash
   dart run .agents/skills/egy-tracker-qa-verifier/scripts/verify_scenarios.dart
   ```

3. **Flutter Static Analysis**:
   Ensure zero errors and zero warnings:
   ```bash
   flutter analyze
   ```

4. **Flutter Unit & Widget Tests**:
   Run the test suite:
   ```bash
   flutter test
   ```
