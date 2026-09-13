# Git Workflow: Verification & Version-Prefixed Commits

## 1. Mandatory Pre-Commit Sequence
Before creating any commit in `egy_tracker`, execute the standard validation pipeline:

### Step 1: Pre-Commit Validations
```bash
python3 scripts/invariant_guard.py
dart run .agents/skills/egy-tracker-qa-verifier/scripts/verify_scenarios.dart
flutter analyze
```
All static analysis checks and domain scenario validations must pass without errors.

### Step 2: Version Calculation (`pubspec.yaml` / Commit Prefix)
- **Start Date**: `2026-09-05`
- **Major Version**: `1`
- **Minor Version**: `floor((Current Date - 2026-09-05) in days)`
- **Patch / Sequence Number**: Incrementing sequential commit index across the repository.
- Formatted version: `1.<minor>.<patch>` (e.g. `1.8.22`).

### Step 3: Commit Format
Every commit message must strictly follow the pattern:
```
<version> <type>: <description>
```
*Examples*:
- `1.8.22 feat: implement shared expense breakdown modal`
- `1.8.23 fix: guard against null balance item in stream builder`
- `1.8.24 chore: update flutter dependencies`

## 2. Commit Type Taxonomy
- `feat`: New user-facing feature or screen.
- `fix`: Bug fix or layout issue correction.
- `refactor`: Code restructuring without changing external behavior.
- `style`: UI styling, theme, typography, or spacing alignment.
- `perf`: Performance optimization.
- `chore`: Tooling, scripts, dependencies, or agent infrastructure changes.
- `docs`: Documentation updates.
