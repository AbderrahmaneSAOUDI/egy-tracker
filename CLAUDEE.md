# egy_tracker — Comprehensive Codebase Audit

> **Audited**: 2026-09-10 by Antigravity (Claude Opus 4.6 & Gemini 3.8 Flash)  
> **Codebase**: 10,144 lines of Dart across 62 files  
> **MVP Spec**: `two_currency_expense_tracker_mvp.md` (26 sections)  
> **Scope**: Deeper forensic scan across Android release manifests, memory lifecycles, widget rendering pipelines, layout boundaries, stream churn, and domain invariants missed in the initial pass.  
> **Structure**: Sorted strictly by **Danger & Priority Level** (Tier 1: Critical → Tier 2: High → Tier 3: Medium → Tier 4: Low), followed by the Consolidated Master Action Matrix and File-by-File Index. Zero notes or code blocks omitted.

---

## Table of Contents

- [1. TIER 1: 🔴 CRITICAL / CATASTROPHIC DANGER](#1-tier-1-critical-catastrophic-danger)
  - [1.1 🔴 [CRITICAL RELEASE BUG] Release APK Crash: Missing `INTERNET` Permission in `main/AndroidManifest.xml`](#11-critical-release-bug-release-apk-crash-missing-internet-permission-in-mainandroidmanifestxml)
  - [1.2 🔴 [CRITICAL CALCULATION BUG] Balance Calculation Bug: Deducting Share Instead of Full Cash Paid](#12-critical-calculation-bug-balance-calculation-bug-deducting-share-instead-of-full-cash-paid)
  - [1.3 🔴 [CRITICAL DATA INVARIANT VIOLATION] "Both Shared" Hardcodes `paidBy = currentUserId`](#13-critical-data-invariant-violation-both-shared-hardcodes-paidby-currentuserid)
  - [1.4 🔴 [CRITICAL ARCHITECTURE TRAP] Egocentric Split Model (`me_percentage`) & Fragile `isPrimaryUser` Inversion](#14-critical-architecture-trap-egocentric-split-model-me_percentage-fragile-isprimaryuser-inversion)
  - [1.5 🔴 [CRITICAL SECURITY VULNERABILITIES] Security Holes Suite](#15-critical-security-vulnerabilities-security-holes-suite)
    - [1.5.1 Firestore Rules: COMPLETELY OPEN](#151-firestore-rules-completely-open)
    - [1.5.2 Hardcoded Admin Email](#152-hardcoded-admin-email)
    - [1.5.3 Dev Login Backdoor in Production](#153-dev-login-backdoor-in-production)
    - [1.5.4 OAuth Client ID Exposed](#154-oauth-client-id-exposed)
  - [1.6 🔴 [CRITICAL APP SIZE] App Size Bloat (300MB → <20MB) & Release Build Configuration](#16-critical-app-size-app-size-bloat-300mb-20mb-release-build-configuration)
- [2. TIER 2: 🟠 HIGH PRIORITY / MAJOR DANGER](#2-tier-2-high-priority-major-danger)
  - [2.1 🟠 [CRITICAL UX LOCKOUT] Hard-Blocked Over-Budget Validation Traps Users](#21-critical-ux-lockout-hard-blocked-over-budget-validation-traps-users)
  - [2.2 🟠 [MEMORY LEAK] Un-disposed `TextEditingController`s in Every Single Modal Dialog](#22-memory-leak-un-disposed-texteditingcontrollers-in-every-single-modal-dialog)
  - [2.3 🟠 [PERFORMANCE BOTTLENECK] 4.1 Six Concurrent Firestore Snapshot Listeners (MAIN BOTTLENECK)](#23-performance-bottleneck-41-six-concurrent-firestore-snapshot-listeners-main-bottleneck)
  - [2.4 🟠 [PERFORMANCE BOTTLENECK] 4.2 Duplicate Stream Subscriptions](#24-performance-bottleneck-42-duplicate-stream-subscriptions)
  - [2.5 🟠 [PERFORMANCE: STREAM CHURN] Settings Screen 3-Tier Nested StreamBuilders](#25-performance-stream-churn-settings-screen-3-tier-nested-streambuilders)
  - [2.6 🟠 [PERFORMANCE & UX BUG] `AnimatedSwitcher` Destroys Page State on Every Tab Switch](#26-performance-ux-bug-animatedswitcher-destroys-page-state-on-every-tab-switch)
  - [2.7 🟠 [PERFORMANCE KILLER] Three Concurrent Animation Controllers Per List Item](#27-performance-killer-three-concurrent-animation-controllers-per-list-item)
  - [2.8 🟠 [PERFORMANCE: COMPUTATION STORM] Uncached Multi-QuickSort on Every Widget Build](#28-performance-computation-storm-uncached-multi-quicksort-on-every-widget-build)
  - [2.9 🟠 [PERFORMANCE BOTTLENECK] 4.6 `BackdropFilter` on Navigation Bar](#29-performance-bottleneck-46-backdropfilter-on-navigation-bar)
  - [2.10 🟠 [PERFORMANCE BOTTLENECK] 4.7 3537×3537 Logo Image Decoded on Startup](#210-performance-bottleneck-47-35373537-logo-image-decoded-on-startup)
  - [2.11 🟠 [DOMAIN INVARIANT VIOLATION] 5.1 `Borrow` Model — OUT OF SCOPE](#211-domain-invariant-violation-51-borrow-model-out-of-scope)
  - [2.12 🟠 [DOMAIN INVARIANT VIOLATION] 8.4 `paidByMode` UI Model Conflates Split and Payer](#212-domain-invariant-violation-84-paidbymode-ui-model-conflates-split-and-payer)
  - [2.13 🟠 [DOMAIN INVARIANT VIOLATION] 5.3 No Validation That `fromCurrency != toCurrency` in Exchange](#213-domain-invariant-violation-53-no-validation-that-fromcurrency-tocurrency-in-exchange)
  - [2.14 🟠 [DOMAIN INVARIANT VIOLATION] 5.4 No Edit Functionality for Allowed Emails](#214-domain-invariant-violation-54-no-edit-functionality-for-allowed-emails)
  - [2.15 🟠 [PERFORMANCE CHURN] Typing in Dialog Rebuilds 657-Line Widget Tree on Every Keystroke](#215-performance-churn-typing-in-dialog-rebuilds-657-line-widget-tree-on-every-keystroke)
  - [2.16 🟠 [PERFORMANCE BOTTLENECK] 4.8 `refresh()` Does Nothing Useful](#216-performance-bottleneck-48-refresh-does-nothing-useful)
- [3. TIER 3: 🟡 MEDIUM PRIORITY / MODERATE DANGER](#3-tier-3-medium-priority-moderate-danger)
  - [3.1 🟡 [UI / OVERFLOW BUG] Hardcoded `height: 400` in Add Expense Dialog](#31-ui-overflow-bug-hardcoded-height-400-in-add-expense-dialog)
  - [3.2 🟡 [LAYOUT DEFECT] Home Tab Non-Scrollable Header Traps Viewport](#32-layout-defect-home-tab-non-scrollable-header-traps-viewport)
  - [3.3 🟡 [MATH & RUNTIME ERROR] Exchange Rate Division by Zero Produces `double.infinity`](#33-math-runtime-error-exchange-rate-division-by-zero-produces-doubleinfinity)
  - [3.4 🟡 [NETWORK SAFETY] Silent Firestore Stream Error Swallowing](#34-network-safety-silent-firestore-stream-error-swallowing)
  - [3.5 🟡 [DATA INTEGRITY] 7.1 No Server-Side Validation](#35-data-integrity-71-no-server-side-validation)
  - [3.6 🟡 [DATA INTEGRITY] 7.2 Delete All Data Can Fail Silently](#36-data-integrity-72-delete-all-data-can-fail-silently)
  - [3.7 🟡 [DATA INTEGRITY] 7.3 No Duplicate Expense Prevention](#37-data-integrity-73-no-duplicate-expense-prevention)
  - [3.8 🟡 [HIDDEN BUG] 6.1 `_authController` is Static and Never Closed](#38-hidden-bug-61-_authcontroller-is-static-and-never-closed)
  - [3.9 🟡 [HIDDEN BUG] 6.2 `saveUserProfile` Called on Every Auth Gate Build](#39-hidden-bug-62-saveuserprofile-called-on-every-auth-gate-build)
  - [3.10 🟡 [HIDDEN BUG] 6.3 `isEmailAllowed` Race Condition on First Launch](#310-hidden-bug-63-isemailallowed-race-condition-on-first-launch)
  - [3.11 🟡 [HIDDEN BUG] 6.4 Date Stored as ISO String, Not Firestore Timestamp](#311-hidden-bug-64-date-stored-as-iso-string-not-firestore-timestamp)
  - [3.12 🟡 [HIDDEN BUG] 6.6 `ExpenseTile` paidBy Display Uses UID, Not Name](#312-hidden-bug-66-expensetile-paidby-display-uses-uid-not-name)
  - [3.13 🟡 [DATA INTEGRITY] Borrow Dialog Saves Literal `'friend'` ID](#313-data-integrity-borrow-dialog-saves-literal-friend-id)
  - [3.14 🟡 [UX / AUTH STAGNATION] Access Denied Has No Retry or Real-Time Stream](#314-ux-auth-stagnation-access-denied-has-no-retry-or-real-time-stream)
  - [3.15 🟡 [HIDDEN BUG] 6.8 No Offline Support](#315-hidden-bug-68-no-offline-support)
  - [3.16 🟡 [HIDDEN BUG] 6.5 `formatDate` Has 12-Hour Midnight Bug](#316-hidden-bug-65-formatdate-has-12-hour-midnight-bug)
- [4. TIER 4: 🟢 LOW PRIORITY / MINOR DANGER & POLISH](#4-tier-4-low-priority-minor-danger-polish)
  - [4.1 🟢 [DEAD CODE BLOAT] Unused Core Animation Files](#41-dead-code-bloat-unused-core-animation-files)
  - [4.2 🟢 [UX FLAW] Friend's Starting Cash is Read-Only in Settings](#42-ux-flaw-friends-starting-cash-is-read-only-in-settings)
  - [4.3 🟢 [DESIGN & UX] 8.2 No Loading State for Initial Data](#43-design-ux-82-no-loading-state-for-initial-data)
  - [4.4 🟢 [DESIGN & UX] 8.3 No Error Handling UI for Failed Operations](#44-design-ux-83-no-error-handling-ui-for-failed-operations)
  - [4.5 🟢 [DESIGN & UX] 8.5 No Confirmation on Expense Edit Save](#45-design-ux-85-no-confirmation-on-expense-edit-save)
  - [4.6 🟢 [DESIGN & UX] 8.6 Theme Selector Not Persisted](#46-design-ux-86-theme-selector-not-persisted)
  - [4.7 🟢 [DESIGN & UX] 8.7 No Haptic Feedback on Critical Actions](#47-design-ux-87-no-haptic-feedback-on-critical-actions)
  - [4.8 🟢 [DESIGN & UX] 8.8 My Tracker Shows Only Expenses, Not Exchanges](#48-design-ux-88-my-tracker-shows-only-expenses-not-exchanges)
  - [4.9 🟢 [DESIGN & UX] 8.9 No Keyboard Shortcut or Quick Amount Entry](#49-design-ux-89-no-keyboard-shortcut-or-quick-amount-entry)
  - [4.10 🟢 [CODE QUALITY] 9.1 Fonts Bundled But Never Declared in pubspec.yaml](#410-code-quality-91-fonts-bundled-but-never-declared-in-pubspecyaml)
  - [4.11 🟢 [CODE QUALITY] 9.2 Unused `cupertino_icons` Dependency](#411-code-quality-92-unused-cupertino_icons-dependency)
  - [4.12 🟢 [CODE QUALITY] 9.3 `MyApp` Services Are Nullable For No Reason](#412-code-quality-93-myapp-services-are-nullable-for-no-reason)
  - [4.13 🟢 [CODE QUALITY] 9.4 `sdk: ^3.14.0-147.0.dev` — Pinned to Dev Channel](#413-code-quality-94-sdk-3140-1470dev-pinned-to-dev-channel)
  - [4.14 🟢 [CODE QUALITY] 9.5 No `const` Constructors on Many Widgets](#414-code-quality-95-no-const-constructors-on-many-widgets)
  - [4.15 🟢 [CODE QUALITY] 9.6 `DateTime.now()` in `fromMap` Fallbacks](#415-code-quality-96-datetimenow-in-frommap-fallbacks)
  - [4.16 🟢 [CODE QUALITY] 9.7 No Unit Tests for Calculation Logic](#416-code-quality-97-no-unit-tests-for-calculation-logic)
  - [4.17 🟢 [CODE QUALITY] 9.8 Re-export Barrel Files Are Unnecessary](#417-code-quality-98-re-export-barrel-files-are-unnecessary)
  - [4.18 🟢 [CODE QUALITY] 9.9 `applicationId` is `com.example.egy_tracker`](#418-code-quality-99-applicationid-is-comexampleegy_tracker)
- [5. Master Prioritized Action Matrix (Consolidated)](#5-master-prioritized-action-matrix-consolidated)
- [6. Appendix: Consolidated File-by-File Quick Reference](#6-appendix-consolidated-file-by-file-quick-reference)

---

# 1. TIER 1: 🔴 CRITICAL / CATASTROPHIC DANGER
> **Definition**: Immediate app crashes on release, fatal financial calculation engine corruption, direct data invariant violations, wide-open security vulnerabilities, or severe distribution-blocking binary bloat.

### 1.1 🔴 [CRITICAL RELEASE BUG] Release APK Crash: Missing `INTERNET` Permission in `main/AndroidManifest.xml`

**File**: `android/app/src/main/AndroidManifest.xml`  
**Severity**: **Catastrophic (Blocks Release Build)**

- `android/app/src/debug/AndroidManifest.xml` contains `<uses-permission android:name="android.permission.INTERNET"/>`.
- **`android/app/src/main/AndroidManifest.xml` DOES NOT.**
- When running debug builds (`flutter run`), Gradle merges the debug manifest, so network calls work.
- When you execute the command recommended in Section 1 to fix the 300MB app size (`flutter build apk --release`), Gradle **excludes `src/debug` entirely**.
- **Result**: The release APK has **zero internet permission**. On first launch, Firebase Auth and Firestore fail immediately with `SocketException: Permission denied` or network unreachable errors, rendering the app 100% dead on release!

**Fix**: Add the permission directly into `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <application ...>
```

---

### 1.2 🔴 [CRITICAL CALCULATION BUG] Balance Calculation Bug: Deducting Share Instead of Full Cash Paid

### Bug Location: `lib/core/utils/m_calculations.dart` lines 63-86

The `calculateCashBalance()` function has a **fundamental domain violation**: it mixes physical cash balance (who paid) with personal consumption share (split percentages).

**Current code (WRONG):**

```dart
// 3. Expenses: Physical cash subtracted strictly according to split percentage or single payer
for (final expense in expenses) {
  if (expense.currency.toUpperCase().trim() != normCurrency) continue;

  final isSplit = (expense.splitType == 'fifty_fifty') ||
      (expense.splitType == 'custom' &&
          expense.mePercentage > 0 &&
          expense.friendPercentage > 0);

  if (isSplit) {
    if (expense.splitType == 'fifty_fifty') {
      balance -= expense.amount * 0.5;  // ← WRONG: deducts share, not cash paid
    } else {
      final pct = isPrimaryUser
          ? expense.mePercentage
          : expense.friendPercentage;
      balance -= expense.amount * (pct / 100.0);  // ← WRONG: deducts share
    }
  } else {
    if (matchesUser(expense.paidBy)) {
      balance -= expense.amount;  // ← CORRECT for non-split
    }
  }
}
```

**What the MVP spec says (Section 15):**

> `paid_by` determines whose **physical balance** decreases.
> Split percentages determine personal **consumption share**.
>
> Example: $100 expense, paid by Me, 50/50 split:
> - My USD balance: **-$100** (full amount)
> - Friend USD balance: **$0**

**The bug**: For 50/50 and custom splits, the code deducts only the user's *share* (50%) from their *cash balance*, instead of the full amount from the *payer's* balance. This produces wrong balances in every shared expense scenario.

**Correct implementation should be:**

```dart
for (final expense in expenses) {
  if (expense.currency.toUpperCase().trim() != normCurrency) continue;
  
  // Physical cash: ONLY the payer's balance decreases, by the FULL amount
  if (matchesUser(expense.paidBy)) {
    balance -= expense.amount;
  }
}
```

**Impact**: Every shared expense (50/50 or custom split) produces incorrect cash balances for both users. This is the core calculation engine, so it cascades to Home balances, My Tracker balances, and all over-budget warnings in the expense dialog.

### Secondary Calculation Issue: Balance Sufficiency Check in Expense Dialog

In `c_add_expense_dialog.dart` lines 82-100, the "effective available balance" restoration logic for edit mode is extraordinarily complex and couples share-percentage logic with cash-balance logic. Given the primary bug above, this compound logic will also produce wrong results during edits.

---

### 1.3 🔴 [CRITICAL DATA INVARIANT VIOLATION] "Both Shared" Hardcodes `paidBy = currentUserId`

**File**: `lib/core/components/c_add_expense_dialog.dart` (Line 75)  
**Severity**: **Data Corruption / Domain Violation**

In the expense dialog:
```dart
// Line 75:
final actualPayerId = paidByMode == 'friend' ? friendId : currentUserId;
```
- If the user selects **"Both"** (shared 50/50 or custom split), `paidByMode` is `'both'`.
- Because `paidByMode != 'friend'`, `actualPayerId` is evaluated as **`currentUserId` ALWAYS**.
- **Real-world failure scenario**:
  1. Friend hands 1,000 EGP cash to a tour guide at the Pyramids.
  2. You open the app and tap "Add Expense" -> select "Shared 50/50".
  3. The app records `paidBy = currentUserId` (YOU)!
  4. **Result**: 1,000 EGP is deducted from **YOUR** physical cash balance instead of your friend's!
- **Violation**: Violates Domain Invariant 1.2: *"Cash Balance Impact: Dictated solely by `paid_by`. If User A pays for an expense, only User A's physical cash balance in that currency decreases by the full amount."*
- **Fix**: The dialog **must** have an independent, explicit picker for **Who paid the cash** (You vs. Friend), completely orthogonal to how the consumption is split.

---

### 1.4 🔴 [CRITICAL ARCHITECTURE TRAP] Egocentric Split Model (`me_percentage`) & Fragile `isPrimaryUser` Inversion

**Files**: `lib/core/models/mod_expense.dart`, `lib/core/utils/m_calculations.dart`, `lib/features/home/vm_home_feed.dart`  
**Severity**: **Database Corruption on Multi-Device Sync**

The `Expense` model stores:
```dart
final double mePercentage;
final double friendPercentage;
```
Whose "me" is this? In Firestore, there is no "me".
To resolve this, the viewmodels use:
```dart
bool get isPrimaryUser {
  final myEmail = user.email?.toLowerCase().trim() ?? '';
  if (myEmail == 'abderrahmane.saoudi.26@gmail.com') return true;
  if (_allowedEmails.isEmpty) return true;
  return myEmail == _allowedEmails.first.email.toLowerCase().trim();
}
```
And then in calculations:
```dart
final pct = isPrimaryUser ? expense.mePercentage : expense.friendPercentage;
```
- If the app is deployed for any other two users (not hardcoded `abderrahmane.saoudi.26@gmail.com`), `isPrimaryUser` relies on `_allowedEmails.first.email`.
- If the whitelist order changes (or during initial Firestore streaming before `sort()` finishes), `isPrimaryUser` **flips from `true` to `false`**.
- **Result**: Every historical split percentage across the entire trip is instantly inverted! User A's 80/20 share becomes 20/80!
- **Fix**: Store splits mapped to actual user IDs: `Map<String, double> splitPercentages` (e.g. `{'uid_123': 70.0, 'uid_456': 30.0}`), or store `payerPercentage` and `nonPayerPercentage`.

#### Corroborating Finding from Initial Audit:

### 5.2 `me_percentage` / `friend_percentage` Are Perspective-Dependent

The expense model stores `mePercentage` and `friendPercentage`, but "me" and "friend" depend on WHO created the expense. If User A creates a 70/30 expense, `mePercentage=70` means User A gets 70%. But if User B views it, the code uses `isPrimaryUser` to flip the perspective.

**Problem**: The `isPrimaryUser` flag is determined by checking if the user's email matches the first allowed email or the hardcoded admin. This is fragile — if the allowed_emails order changes, all existing expense splits become inverted.

**Fix**: Store `user_a_percentage` and `user_b_percentage` with explicit user IDs, not relative "me"/"friend" labels. Or store `payer_percentage` and `other_percentage` with the payer's ID.

---

### 1.5 🔴 [CRITICAL SECURITY VULNERABILITIES] Security Holes Suite

#### 1.5.1 Firestore Rules: COMPLETELY OPEN

```javascript
// firestore.rules — EVERY collection is:
allow read, write: if true;
```

**Impact**: Any person on the internet who discovers the Firebase project ID can:
- Read all expenses, exchanges, user profiles, and emails
- Write/modify/delete any data
- Impersonate users
- Wipe the entire database

**Fix**: Restrict rules to authenticated users whose email is in `allowed_emails`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isAllowedUser() {
      return isAuthenticated() && 
             exists(/databases/$(database)/documents/allowed_emails/$(request.auth.token.email));
    }

    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated() && request.auth.uid == userId;
    }
    
    match /allowed_emails/{emailId} {
      allow read: if isAuthenticated();
      allow write: if isAllowedUser();
    }
    
    match /initial_balances/{balanceId} {
      allow read, write: if isAllowedUser();
    }
    
    match /expenses/{expenseId} {
      allow read, write: if isAllowedUser();
    }
    
    match /exchanges/{exchangeId} {
      allow read, write: if isAllowedUser();
    }
    
    match /borrows/{borrowId} {
      allow read, write: if isAllowedUser();
    }
  }
}
```

#### 1.5.2 Hardcoded Admin Email

The email `abderrahmane.saoudi.26@gmail.com` is hardcoded in **6 different files** as a privileged bypass:
- `f_auth.dart` line 28 (DevUser default)
- `f_auth.dart` line 101 (signInAsDevUser default)
- `f_firestore.dart` lines 55-57 (sort priority)
- `f_firestore.dart` line 68 (whitelist bypass)
- `f_firestore.dart` line 244 (delete protection)
- `s_auth_gate.dart` line 83 (whitelist bypass)
- `vm_home_feed.dart` line 175 (isPrimaryUser)
- `vm_my_tracker.dart` line 161 (isPrimaryUser)

**Fix**: Extract to a single `const` in a config file. Better yet, use the first entry in `allowed_emails` as the admin, which is already the intended behavior.

#### 1.5.3 Dev Login Backdoor in Production

`signInAsDevUser()` and `DevUser` class allow bypassing Google Sign-In entirely. The login screen's logo tap calls `handleAutoLogin()` which calls `signInAsDevUser()`. This is a **production backdoor** — anyone tapping the logo bypasses authentication.

**Fix**: Guard behind `kDebugMode`:

```dart
if (!kDebugMode) return; // Disable dev login in release builds
```

#### 1.5.4 OAuth Client ID Exposed

`serverClientId` is hardcoded in `f_auth.dart` line 58-59. While not as critical as a server secret, it should ideally come from `firebase_options.dart` or environment config.

---

### 1.6 🔴 [CRITICAL APP SIZE] App Size Bloat (300MB → <20MB) & Release Build Configuration

### Root Cause Analysis

The installed APK on the device is ~300MB. The **debug APK** alone is **106MB**. Here's where the bloat lives:

| Source | Size | Fix |
|---|---|---|
| `assets/images/logo.png` | **2.4 MB** (3537×3537 RGBA PNG) | Resize to 512×512, convert to WebP (~30KB) |
| `assets/fonts/` (3× Google Sans woff2) | **174 KB** | Remove entirely — use Material 3 system fonts (`Roboto`/system default) which are already bundled. Google Sans woff2 files are for web, not mobile. |
| **Debug build mode** | **~106 MB APK** | This is the #1 reason. Debug builds include the Dart VM, JIT compiler, observatory, and debug symbols. A **release build** (`flutter build apk --release`) will be ~15-25MB. |
| `build/` directory | **1.3 GB** | Add `build/` to `.gitignore` (already there, but clean it). Not shipped, but clutters workspace. |
| `flutter_svg` dependency | ~1.5MB in binary | Only used for `logo_google.svg` on login. Replace with a `const Icon` or inline the SVG as a `CustomPainter`. |

### Fix Priority (achieves <20MB):

```text
1. flutter build apk --release --split-per-abi   → ~15MB per ABI
2. flutter build appbundle                         → ~12MB AAB for Play Store
3. Compress logo.png: 3537×3537 → 512×512 WebP    → saves ~2.3MB from assets
4. Remove Google Sans fonts (use system fonts)     → saves ~174KB
5. Consider removing flutter_svg if only used once → saves ~1.5MB
6. Enable R8/ProGuard shrinking (already implicit in release)
7. Add to android/app/build.gradle.kts:
     buildTypes {
       release {
         isMinifyEnabled = true
         isShrinkResources = true
       }
     }
```

### Why the app shows as 300MB on device:

Debug APK (106MB) + Android runtime expansion + Dart VM + debug symbols + cached data = ~300MB installed footprint. This is **completely normal for Flutter debug builds** and **will vanish with a release build**.

---

# 2. TIER 2: 🟠 HIGH PRIORITY / MAJOR DANGER
> **Definition**: Core user workflows hard-blocked, cumulative memory leaks, intense real-time stream churn and reconnect loops, page state destruction on navigation, massive animation ticker bloat, multi-quicksort computational storms, and prohibited domain scope creep.

### 2.1 🟠 [CRITICAL UX LOCKOUT] Hard-Blocked Over-Budget Validation Traps Users

**Files**: `lib/core/components/c_add_exchange_dialog.dart` (Lines 53, 183), `lib/core/components/c_add_expense_dialog.dart` (Line 138)  
**Severity**: **App Blocks Core Functionality**

In `c_add_exchange_dialog.dart`:
```dart
final isOverBudget = currentFromAmt > effectiveAvailable;
final canSubmit = currentFromAmt > 0 && currentToAmt > 0 && !isOverBudget && !isSubmitting;
...
if (amt > effectiveAvailable) {
  return 'Exceeds owned money (${Formatters.formatCurrency(effectiveAvailable, fromCurrency)})';
}
```
And in `c_add_expense_dialog.dart`:
```dart
final canSubmit = hasTitle && enteredAmount > 0 && !isOverBudget && ...
```
- If you arrive at Cairo Airport, exchange $300 at the currency counter for 14,800 EGP, and open the app to record it:
  - If you haven't opened Settings yet to set your initial balance (or balance is $0):
  - **`effectiveAvailable` is $0.00!**
  - **`isOverBudget` is TRUE!**
  - **The "Save" button is DISABLED.** The form validation throws an error!
- You literally **cannot record the exchange** because the app refuses to let you spend money you haven't logged having!
- The same happens if you pay a taxi driver 200 EGP before logging your currency exchange.
- **Rule**: Expense and exchange tracking apps record **physical reality after the fact**. They must warn, but **never hard-block** submitting negative balance or out-of-order transactions.

---

### 2.2 🟠 [MEMORY LEAK] Un-disposed `TextEditingController`s in Every Single Modal Dialog

**Files**:
- `lib/core/components/c_add_expense_dialog.dart` (`titleController`, `amountController`)
- `lib/core/components/c_add_exchange_dialog.dart` (`fromAmountController`, `toAmountController`)
- `lib/core/components/c_borrow_dialog.dart` (`usdController`, `egpController`)
- `lib/features/settings/components/c_edit_initial_balances_dialog.dart` (`usdController`, `egpController`)
- `lib/features/settings/components/c_add_email_dialog.dart` (`controller`)  
**Severity**: **High (Memory Leak & GC Pressure)**

Every modal dialog helper function creates `TextEditingController`s in the function scope and passes them to `StatefulBuilder`:
```dart
Future<void> showAddExchangeDialog(...) {
  final fromAmountController = TextEditingController(...);
  final toAmountController = TextEditingController(...);
  // ... showAnimatedDialog ...
  // NEVER CALLS fromAmountController.dispose() or toAmountController.dispose()!
}
```
- In Flutter, `TextEditingController` registers listeners with the platform text input service and `ChangeNotifier`.
- Because these controllers are never disposed, **every dialog opened permanently leaks controller instances and platform channels in memory**.
- Over a 10-day trip with 100+ transactions logged, this bloats memory and degrades performance.
- **Fix**: Convert dialogs to proper `StatefulWidget`s and call `dispose()` in `State.dispose()`, or attach a `.whenComplete(() { controller.dispose(); })` to the dialog future.

---

### 2.3 🟠 [PERFORMANCE BOTTLENECK] 4.1 Six Concurrent Firestore Snapshot Listeners (MAIN BOTTLENECK)

`HomeFeedViewModel` opens **6 simultaneous real-time listeners** in its constructor:
1. `expenses` stream
2. `exchanges` stream
3. `borrows` stream
4. `initial_balances` stream
5. `users` stream
6. `allowed_emails` stream

Each listener fires `notifyListeners()` independently. On initial load, this triggers **6 rapid sequential rebuilds** of the entire widget tree. Every Firestore snapshot change (even a metadata update) triggers a full recalculation of all balances.

**Fix**:
- Debounce `notifyListeners()` — batch the 6 callbacks into one rebuild:
  ```dart
  Timer? _debounce;
  void _scheduleNotify() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 50), () {
      notifyListeners();
    });
  }
  ```
- Use `Future.wait()` for initial load, then switch to streams
- Consider combining into a single Firestore query using sub-collections or a compound approach

---

### 2.4 🟠 [PERFORMANCE BOTTLENECK] 4.2 Duplicate Stream Subscriptions

When `MyTrackerViewModel` is created **without** a `feedViewModel`, it opens **6 more** identical Firestore streams (lines 68-93 of `vm_my_tracker.dart`). When it *has* a `feedViewModel`, it listens to that and proxies. But the standalone path creates 12 total concurrent Firestore listeners.

---

### 2.5 🟠 [PERFORMANCE: STREAM CHURN] Settings Screen 3-Tier Nested StreamBuilders

**File**: `lib/features/settings/components/c_initial_balances_card.dart` (Lines 36-44)  
**Severity**: **High (Massive Unnecessary Network Reads & Frame Drops)**

Look at how `InitialBalancesCard` is constructed:
```dart
StreamBuilder<List<InitialBalance>>(
  stream: viewModel.initialBalancesStream, // Getter returns new Stream!
  builder: (context, balancesSnap) {
    return StreamBuilder<List<AllowedEmail>>(
      stream: viewModel.allowedEmailsStream, // Getter returns new Stream!
      builder: (context, emailsSnap) {
        return StreamBuilder<List<UserProfile>>(
          stream: viewModel.usersStream, // Getter returns new Stream!
```
And in `vm_settings.dart`:
```dart
Stream<List<UserProfile>> get usersStream => firestoreService.getUsersStream();
Stream<List<AllowedEmail>> get allowedEmailsStream => firestoreService.getAllowedEmailsStream();
Stream<List<InitialBalance>> get initialBalancesStream => firestoreService.getInitialBalancesStream();
```
- In Dart, a getter that returns `firestoreService.get...Stream()` creates a **BRAND NEW `Stream` instance every time it is evaluated**.
- When `InitialBalancesCard.build()` runs, it passes 3 new streams.
- `StreamBuilder` detects a new stream instance, **cancels the old listener, and opens a new Firestore subscription**.
- When the outer stream emits, it rebuilds the middle `StreamBuilder`, which cancels and re-subscribes the inner one!
- **Result**: Endless subscription cancellation and reconnection loop, burning through Firestore read quotas and causing constant UI stuttering on the Settings screen.
- **Fix**: Store persistent stream subscriptions inside `SettingsViewModel` and notify via `ChangeNotifier`, or cache the `Stream` instances as `late final` variables.

---

### 2.6 🟠 [PERFORMANCE & UX BUG] `AnimatedSwitcher` Destroys Page State on Every Tab Switch

**File**: `lib/features/home/s_home.dart` (Lines 108-127)  
**Severity**: **High (Laggy Tab Switching, Loss of Scroll Position)**

```dart
child: AnimatedSwitcher(
  duration: const Duration(milliseconds: 320),
  child: selectedIndex == 0
      ? HomeTabScreen(...)
      : selectedIndex == 1
          ? MyTrackerScreen(...)
          : SettingsScreen(...),
)
```
- `AnimatedSwitcher` with conditional child completely **unmounts and disposes** the inactive screens.
- When switching from `Home` -> `My Tracker` -> `Home`:
  - The entire `HomeTabScreen` is destroyed and garbage-collected.
  - **Scroll offset is completely wiped out** (resets to top).
  - Feed viewmodel stream listeners and animations re-run from scratch.
  - Staggered animations replay every single time you tap a tab.
- **Fix**: Use an `IndexedStack` or `PageView(physics: const NeverScrollableScrollPhysics())` to keep all 3 tabs alive in memory with zero re-rendering overhead and preserved scroll positions.

---

### 2.7 🟠 [PERFORMANCE KILLER] Three Concurrent Animation Controllers Per List Item

**Files**: `c_activity_tile.dart`, `a_staggered_item.dart`, `c_slide_action_card.dart`  
**Severity**: **High (Scrolling Jitter & CPU Drain)**

In `HomeTabScreen` and `MyTrackerScreen`:
For **every single item** in the `ListView.builder`:
1. `StaggeredItem` instantiates an `AnimationController` (`Duration(milliseconds: 380)`).
2. Inside it, `ActivityTile` instantiates its own `AnimationController` (`Duration(milliseconds: 320)`).
3. Inside that, `SlideActionCard` instantiates a third `AnimationController` (`Duration(milliseconds: 260)`).
- If the feed contains 40 transactions, there are **120 active `AnimationController` instances and tickers** registered with the Flutter engine!
- This causes stuttering and dropped frames during fast scrolling.
- **Fix**:
  - Remove `ActivityTile`'s redundant entrance controller (handled by `StaggeredItem`).
  - Replace custom `SlideActionCard` with Flutter's built-in `Dismissible` widget (zero animation controllers until touch gesture begins).

#### Origin Finding from Initial Audit:

### 4.5 StaggeredItem Creates AnimationController Per List Item

Every `ActivityTile` is wrapped in a `StaggeredItem` that creates its own `AnimationController` + `Timer` + `CurvedAnimation`. Plus, `ActivityTile` itself creates another `AnimationController` for entrance animation. That's **2 AnimationControllers per list item** — for 50 items, that's 100 concurrent animation controllers.

**Fix**: 
- Remove the double-animation (keep either StaggeredItem or ActivityTile entrance, not both)
- Only animate the first ~10 items, skip for scrolled-in items
- Consider using `AnimatedList` instead

---

### 2.8 🟠 [PERFORMANCE: COMPUTATION STORM] Uncached Multi-QuickSort on Every Widget Build

**Files**: `lib/features/home/s_home_tab.dart`, `lib/features/home/vm_home_feed.dart`  
**Severity**: **High (CPU Spikes)**

In `s_home_tab.dart`:
```dart
SegmentedPillItem(value: HomeFeedFilter.all, count: viewModel.allActivities.length),
SegmentedPillItem(value: HomeFeedFilter.mine, count: viewModel.mineActivities.length),
SegmentedPillItem(value: HomeFeedFilter.shared, count: viewModel.sharedActivities.length),
...
itemCount: viewModel.filteredActivities.length,
```
In `vm_home_feed.dart`:
- `allActivities` calls `activities` getter -> merges 3 lists and runs `List.sort(...)`.
- `mineActivities` calls `activities` getter AGAIN -> merges 3 lists and runs `List.sort(...)` AGAIN, then `.where(...).toList()`.
- `sharedActivities` calls `activities` getter a THIRD time -> merges 3 lists and runs `List.sort(...)` a THIRD time, then `.where(...).toList()`.
- `filteredActivities` calls `activities` getter a FOURTH time -> merges 3 lists and runs `List.sort(...)` a FOURTH time!
- In a **single frame render**, the transaction list is concatenated and quicksorted **4 distinct times**, plus 8 linear scans for balance computations.
- **Fix**: Calculate and cache `_allActivities`, `_mineActivities`, `_sharedActivities` **once** inside the stream subscription handler whenever Firestore data changes, rather than recomputing inside getters.

#### Compounding Factor from Initial Audit:

### 4.3 O(n²) Balance Computation on Every Rebuild

Every call to `myUsdBalance`, `myEgpBalance`, `friendUsdBalance`, `friendEgpBalance` iterates through ALL expenses, ALL exchanges, and ALL borrows. These getters are called multiple times per build (Home balances, activity filter counts, over-budget checks). With 6 streams each calling `notifyListeners()`, this means:

```
6 stream events × 4 balance getters × (n_expenses + n_exchanges + n_borrows) iterations = catastrophic
```

**Fix**: Cache computed balances in fields, only recalculate on actual data changes.

#### List Allocation Bottleneck from Initial Audit:

### 4.4 `activities` Getter Allocates New Lists Every Call

```dart
List<ActivityItem> get activities {
  final list = <ActivityItem>[
    ..._expenses.map((e) => ActivityItem.expense(e)),
    ..._exchanges.map((e) => ActivityItem.exchange(e)),
    ..._borrows.map((b) => ActivityItem.borrow(b)),
  ];
  list.sort(/* ... */);
  return list;
}
```

Called from `allActivities`, `mineActivities`, `sharedActivities`, and `filteredActivities` — **4 sorts per rebuild**, each creating new list + new ActivityItem wrappers.

**Fix**: Cache `_activities` list, invalidate only when data changes.

---

### 2.9 🟠 [PERFORMANCE BOTTLENECK] 4.6 `BackdropFilter` on Navigation Bar

The `FloatingPillNavBar` uses `BackdropFilter` with `ImageFilter.blur(sigmaX: 16, sigmaY: 16)`. This is expensive on every frame, especially on low-end devices. Combined with the `AnimatedContainer` transitions and `ClipRRect`, this makes tab switching janky.

**Fix**: Consider using a solid/semi-transparent background instead of blur, or cache the blur layer.

---

### 2.10 🟠 [PERFORMANCE BOTTLENECK] 4.7 3537×3537 Logo Image Decoded on Startup

The 2.4MB logo PNG is 3537×3537 pixels. Even if displayed at 100×100, Flutter decodes the full resolution into memory (~47MB of pixel data). This happens on the login screen.

**Fix**: Resize to 256×256 or 512×512, convert to WebP.

---

### 2.11 🟠 [DOMAIN INVARIANT VIOLATION] 5.1 `Borrow` Model — OUT OF SCOPE

The `Borrow` model, `borrows` Firestore collection, and `BorrowDialog` are **not in the MVP spec**. The spec explicitly states (Section 3):

> ❌ Debt settlement or debt-optimization graphs

And `AGENTS.md` Section 1.5:

> ❌ Debt settlement or debt-optimization graphs

While lending/borrowing cash is arguably different from debt settlement, the MVP spec makes no mention of a "Borrow" concept anywhere in its 26 sections. This adds:
- Extra model (`mod_borrow.dart`)
- Extra Firestore collection
- Extra stream listener
- Extra dialog (~474 lines)
- Extra complexity in balance calculations
- UI space in the add-action sheet

**Recommendation**: Consider removing or hiding behind a feature flag. It adds scope creep and calculation complexity.

---

### 2.12 🟠 [DOMAIN INVARIANT VIOLATION] 8.4 `paidByMode` UI Model Conflates Split and Payer

The expense dialog uses `paidByMode` with values `'you'`, `'both'`, `'friend'`. But `'both'` doesn't mean both people paid — it means the expense is *split* between both. This conflates "who paid" (physical cash) with "who consumed" (split). The MVP spec clearly separates these:

- **Paid By**: Me or Friend (physical cash)
- **Split**: 100% default, 50/50, Custom (consumption share)

The current UI merges these into one selector, making it impossible to express "Friend paid, but it's split 50/50" — a valid and common scenario (e.g., friend pays for a restaurant dinner that should be split).

**Fix**: Separate "Paid By" selector (Me/Friend) from "Split" selector (100%/50-50/Custom), matching the MVP spec's form design (Sections 9.4 and 9.5).

---

### 2.13 🟠 [DOMAIN INVARIANT VIOLATION] 5.3 No Validation That `fromCurrency != toCurrency` in Exchange

The exchange dialog allows selecting the same currency for both `from` and `to`, which would create a nonsensical exchange (e.g., USD → USD). The exchange model doesn't validate this constraint.

---

### 2.14 🟠 [DOMAIN INVARIANT VIOLATION] 5.4 No Edit Functionality for Allowed Emails

The MVP spec (Section 8.1) requires:
> Operations: Add, **Edit**, Delete, View

The settings only support Add, Delete, and View. Edit is missing.

---

### 2.15 🟠 [PERFORMANCE CHURN] Typing in Dialog Rebuilds 657-Line Widget Tree on Every Keystroke

**File**: `lib/core/components/c_add_expense_dialog.dart` (Lines 233, 260)  
**Severity**: **Medium-High (Typing Latency & Frame Drops)**

```dart
TextFormField(
  controller: titleController,
  onChanged: (_) => setDialogState(() {}), // REBUILDS ENTIRE DIALOG!
...
TextFormField(
  controller: amountController,
  onChanged: (_) => setDialogState(() {}), // REBUILDS ENTIRE DIALOG!
```
- Every single character typed in the "Title" or "Amount" fields calls `setDialogState(() {})`.
- This forces Flutter to rebuild the entire 657-line dialog widget tree, re-parsing amounts, re-evaluating regexes, and recalculating budget limits on every keystroke.
- On mid-range phones, this creates noticeable input lag while typing numbers.
- **Fix**: Only rebuild the submit button state or summary text via `ValueListenableBuilder(valueListenable: amountController)` instead of calling `setDialogState` across the entire modal.

---

### 2.16 🟠 [PERFORMANCE BOTTLENECK] 4.8 `refresh()` Does Nothing Useful

```dart
Future<void> refresh() async {
  notifyListeners();
}
```

Pull-to-refresh just triggers a rebuild without actually refreshing data. Firestore streams are already real-time. Either remove pull-to-refresh or implement a proper refresh (cancel and re-subscribe to streams).

---

# 3. TIER 3: 🟡 MEDIUM PRIORITY / MODERATE DANGER
> **Definition**: UI overflows and layout breakage on mobile viewports, unhandled mathematical crashes on edge cases, silent asynchronous stream failures, database data integrity vulnerabilities, and multi-user race conditions.

### 3.1 🟡 [UI / OVERFLOW BUG] Hardcoded `height: 400` in Add Expense Dialog

**File**: `lib/core/components/c_add_expense_dialog.dart` (Line 222)  
**Severity**: **Medium (Keyboard Overflow on Small Screens)**

```dart
content: Form(
  key: formKey,
  child: SizedBox(
    width: double.maxFinite,
    height: 400, // HARDCODED FIXED HEIGHT!
    child: SingleChildScrollView(
```
- On devices with lower screen height (e.g. iPhone SE, compact Android devices) or in landscape orientation:
  - Screen height is ~640px.
  - Virtual keyboard takes ~300px.
  - Available height is ~340px.
- A fixed `height: 400` causes an immediate yellow-and-black `RenderFlex overflowed by 60+ pixels` error, pushing the "Cancel" and "Save" action buttons completely off-screen!
- **Fix**: Remove `height: 400` and use `ConstrainedBox(constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.65))`.

#### Corroborating Finding from Initial Audit:

### 8.1 Expense Dialog Fixed Height of 400px

```dart
SizedBox(
  width: double.maxFinite,
  height: 400,  // ← Fixed height regardless of content
  child: SingleChildScrollView(...)
)
```

On small phones, this may overflow. On tablets, it wastes space. Use `ConstrainedBox` with `maxHeight` instead:

```dart
ConstrainedBox(
  constraints: BoxConstraints(
    maxHeight: MediaQuery.of(context).size.height * 0.6,
  ),
  child: SingleChildScrollView(...)
)
```

---

### 3.2 🟡 [LAYOUT DEFECT] Home Tab Non-Scrollable Header Traps Viewport

**File**: `lib/features/home/s_home_tab.dart` (Lines 44-48, 94)  
**Severity**: **Medium (Poor UX on Small Devices)**

```dart
RefreshIndicator(
  onRefresh: viewModel.refresh,
  child: Column(
    children: [
      Padding(
        child: Column(
          children: [
            HomeBalancesCard(...), // ~220px
            SegmentedPillBar(...), // ~50px
          ],
        ),
      ),
      Expanded(
        child: ListView.builder(...),
      ),
    ],
  ),
)
```
- The `HomeBalancesCard` and `SegmentedPillBar` sit in a fixed non-scrollable `Column` above `Expanded(ListView)`.
- On compact phones, the balance cards consume >50% of the screen height and **cannot be scrolled away**. The user can only see 1 or 2 activity items in the tiny remaining viewport!
- Furthermore, `RefreshIndicator` only triggers when pulling from within the inner `ListView`. Pulling down on the balance card does nothing!
- **Fix**: Convert `HomeTabScreen` to a `CustomScrollView` with `SliverToBoxAdapter` for the balances and filter bar, and `SliverList` for the activities. The balances will smoothly scroll off-screen, giving full height to the transaction history.

---

### 3.3 🟡 [MATH & RUNTIME ERROR] Exchange Rate Division by Zero Produces `double.infinity`

**Files**: `lib/core/components/c_add_exchange_dialog.dart` (Line 70), `lib/core/components/c_activity_tile.dart` (Line 336)  
**Severity**: **Medium (Crash on Invalid/Zero Input)**

In `c_add_exchange_dialog.dart`:
```dart
final rate = fromAmt > 0
    ? (fromCurrency == 'USD'
        ? (toAmt / fromAmt)
        : (fromAmt / toAmt))
    : 1.0;
```
- If `fromCurrency == 'EGP'` and `toAmt == 0.0`:
- `(fromAmt / toAmt)` evaluates to `double.infinity`.
- In `c_activity_tile.dart`:
```dart
Text('$userLabel · Rate: ${exchange.exchangeRate.toStringAsFixed(2)}')
```
- In Dart, calling `.toStringAsFixed(2)` on `double.infinity` or `double.nan` throws `UnsupportedError: Cannot convert to a double`.
- **Result**: The activity tile crashes with a red error screen!
- **Fix**: Guard division: `(toAmt > 0 ? fromAmt / toAmt : 1.0)`, and format safely with `exchange.exchangeRate.isFinite ? exchange.exchangeRate.toStringAsFixed(2) : '-'`.

#### Corroborating Analysis from Initial Audit:

### 6.7 Exchange Rate Calculation Can Be Asymmetric

In `c_add_exchange_dialog.dart` lines 70-73:

```dart
final rate = fromAmt > 0
    ? (fromCurrency == 'USD'
        ? (toAmt / fromAmt)       // USD→EGP: rate = EGP/USD
        : (fromAmt / toAmt))      // EGP→USD: rate = EGP/USD
    : 1.0;
```

This always computes the rate as "EGP per USD" regardless of direction. This is *consistent* but may confuse users — the displayed rate is always the same unit even when exchanging EGP→USD. The exchange model's `exchangeRate` field meaning is ambiguous.

---

### 3.4 🟡 [NETWORK SAFETY] Silent Firestore Stream Error Swallowing

**File**: `lib/core/services/f_firestore.dart` (Lines 133-144, 170-181)  
**Severity**: **Medium (Silent Data Freezes)**

```dart
Stream<List<Expense>> getExpensesStream() {
  try {
    return _expensesCollection.snapshots().map((snapshot) { ... });
  } catch (_) {
    return const Stream.empty();
  }
}
```
- In Dart, synchronous `try/catch` around `_expensesCollection.snapshots()` **only catches errors thrown during stream creation**.
- Any runtime stream errors (such as Firestore Permission Denied, offline network timeouts, or index creation errors) occur **asynchronously** inside the stream pipeline.
- Because there is no `.handleError(...)`, asynchronous errors bypass this `try/catch` completely, causing unhandled stream exceptions in `StreamSubscription` or freezing the stream indefinitely without error UI.
- **Fix**: Attach `.handleError((error) { debugPrint('Firestore stream error: $error'); yield []; })`.

---

### 3.5 🟡 [DATA INTEGRITY] 7.1 No Server-Side Validation

With Firestore rules set to `allow read, write: if true`, there's zero server-side validation. Any client can write:
- Negative amounts
- Percentages that don't sum to 100
- Invalid currency values (anything other than 'USD'/'EGP')
- Invalid split types
- Expenses with empty titles

**Fix**: Add Firestore rules with data validation:

```javascript
match /expenses/{expenseId} {
  allow write: if isAllowedUser()
    && request.resource.data.amount > 0
    && request.resource.data.currency in ['USD', 'EGP']
    && request.resource.data.split_type in ['default_100', 'fifty_fifty', 'custom']
    && request.resource.data.me_percentage + request.resource.data.friend_percentage == 100;
}
```

---

### 3.6 🟡 [DATA INTEGRITY] 7.2 Delete All Data Can Fail Silently

The `deleteAllTripData()` method uses a batch with a 400-operation limit. If the batch commit fails partway through, partial data remains. There's no transaction or rollback mechanism. With the `async safeDelete()` pattern, if one commit fails, subsequent deletes may succeed, leaving the database in an inconsistent state.

---

### 3.7 🟡 [DATA INTEGRITY] 7.3 No Duplicate Expense Prevention

There's no idempotency check. If the save button is tapped quickly or there's a network retry, the same expense could be saved twice. While `isSubmitting` prevents UI double-taps, network retries could still create duplicates.

---

### 3.8 🟡 [HIDDEN BUG] 6.1 `_authController` is Static and Never Closed

In `f_auth.dart` line 55-56:

```dart
static final StreamController<User?> _authController =
    StreamController<User?>.broadcast();
```

This is a static `StreamController` that is **never disposed**. Since it's broadcast and static, it persists for the lifetime of the app. Not a memory leak per se, but:
- Multiple `AuthService` instances share the same controller
- `authStateChanges` `async*` yields the current user then the stream — if the stream has stale events, they'll be replayed

---

### 3.9 🟡 [HIDDEN BUG] 6.2 `saveUserProfile` Called on Every Auth Gate Build

In `s_auth_gate.dart` lines 119-129, `saveUserProfile()` is called every time the `AuthGate` rebuilds with an allowed user. Since `StreamBuilder` rebuilds on every auth event, and the whitelist `FutureBuilder` also rebuilds, the profile is saved to Firestore repeatedly (with `createdAt: DateTime.now()` — overwriting the original creation timestamp each time).

**Fix**: Only save profile on first login or when data changes.

---

### 3.10 🟡 [HIDDEN BUG] 6.3 `isEmailAllowed` Race Condition on First Launch

In `f_firestore.dart` lines 66-83:

```dart
Future<bool> isEmailAllowed(String email) async {
  // ...
  if (snapshot.docs.isEmpty) {
    await addAllowedEmail(normalized);  // ← Auto-seeds on empty whitelist
    return true;
  }
  // ...
}
```

If two users simultaneously first-launch the app, both could find an empty whitelist and both get auto-added. This bypasses the intended two-user restriction.

---

### 3.11 🟡 [HIDDEN BUG] 6.4 Date Stored as ISO String, Not Firestore Timestamp

All dates are stored as ISO 8601 strings (`date.toIso8601String()`). This means:
- No server-side date ordering via Firestore queries (string sort ≠ date sort)
- No timezone awareness — `DateTime.now()` uses local time, different users may be in different timezones during the trip
- Cannot use Firestore's `orderBy` on date fields efficiently

**Fix**: Use `Timestamp.fromDate(date)` for Firestore storage and `(map['date'] as Timestamp).toDate()` for retrieval.

---

### 3.12 🟡 [HIDDEN BUG] 6.6 `ExpenseTile` paidBy Display Uses UID, Not Name

In `c_activity_tile.dart`, when displaying "Paid by" for expenses, the code compares `expense.paidBy` (which is a Firebase UID) against `currentUserId`. If it matches, it shows "You"; otherwise it shows `friendName`. But `friendName` can be `null` if the friend hasn't logged in yet, showing a raw email or nothing.

---

### 3.13 🟡 [DATA INTEGRITY] Borrow Dialog Saves Literal `'friend'` ID

**File**: `lib/core/components/c_borrow_dialog.dart` (Line 39)  
**Severity**: **Low-Medium (Orphaned Balance Record)**

```dart
final friendId = friendUserId ?? 'friend';
```
- If the primary traveler enters a borrow before the partner logs in for the first time, `friendUserId` is null.
- The borrow record is saved in Firestore with `borrowerId: 'friend'`.
- When the partner later logs in with their real Firebase UID (e.g. `auth_uid_xyz`), `Calculations.matchesUser` matches against `user.uid` and `user.email`.
- It will **never match `'friend'`**.
- **Result**: The borrowed amount is forever invisible in the partner's calculations!
- **Fix**: Use `friendEmailDoc?.email` as the stable identity before UID is known.

---

### 3.14 🟡 [UX / AUTH STAGNATION] Access Denied Has No Retry or Real-Time Stream

**File**: `lib/features/auth/s_auth_gate.dart` (Lines 44-55, 144-202)  
**Severity**: **Medium (User Friction)**

- When an unwhitelisted user signs in, `AuthGate` checks `isEmailAllowed` via a cached `Future`:
```dart
_whitelistFuture = widget.firestoreService.isEmailAllowed(email);
```
- If the friend is denied access, the screen displays "Unauthorized Account" with only a "Sign Out" button.
- If the primary organizer adds the friend's email to the whitelist in Settings 10 seconds later:
  - **The friend's screen never updates.**
  - There is **no "Retry" or "Check Again" button**.
  - The friend is forced to manually sign out and go through Google login again!
- **Fix**: Either provide a "Check Again" button that resets `_whitelistFuture`, or connect `AuthGate` to `firestoreService.getAllowedEmailsStream()` for instant, real-time access granting.

---

### 3.15 🟡 [HIDDEN BUG] 6.8 No Offline Support

All data operations go directly to Firestore with no local caching or offline persistence enabled. If the user loses internet (common while traveling in Egypt), the app shows empty state or errors. Firestore's offline persistence is available but not explicitly enabled.

**Fix**: Firestore offline persistence is on by default for mobile, but you should verify it and add optimistic UI updates.

---

### 3.16 🟡 [HIDDEN BUG] 6.5 `formatDate` Has 12-Hour Midnight Bug

In `m_formatters.dart` line 53:

```dart
final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
```

When `dt.hour == 12` (noon), this returns `12` and `period = 'PM'` ✓.
When `dt.hour == 0` (midnight), this returns `12` and `period = 'AM'` ✓.
When `dt.hour == 24` — impossible, but if it were, it would break.

Actually this is correct for 12-hour format. No bug here.

---

# 4. TIER 4: 🟢 LOW PRIORITY / MINOR DANGER & POLISH
> **Definition**: UI/UX micro-interactions and tactile feedback, dead code and unused assets, dependency hygiene, test suite scaffolding, and build configuration cleanup.

### 4.1 🟢 [DEAD CODE BLOAT] Unused Core Animation Files

**Files**:
- `lib/core/animations/a_shimmer.dart` (87 lines, active `AnimationController`)
- `lib/core/animations/a_expandable.dart` (76 lines)
- `lib/core/animations/a_animated_amount.dart` (74 lines)  
**Severity**: **Low (Dead Code)**

- None of these 3 files are imported or used anywhere in the entire codebase.
- `a_shimmer.dart` defines an animated shader mask that was never integrated into skeleton loaders.
- These should be removed to keep the codebase clean and trim compilation units.

---

### 4.2 🟢 [UX FLAW] Friend's Starting Cash is Read-Only in Settings

**File**: `lib/features/settings/components/c_initial_balances_card.dart` (Line 140)  
**Severity**: **Low (Trip Setup Inconvenience)**

```dart
// Friend Starting Balance Item (read-only for current user)
BalanceUserCard(
  isCurrentUser: false,
  ...
  onEdit: null, // Hardcoded null!
)
```
- In real life, travel companions often pool money or one person holds the cash envelope and configures the trip starting parameters.
- Locking the friend's starting balance to `onEdit: null` forces the trip organizer to wait until the friend downloads the app, logs in, and enters their own numbers.
- **Fix**: Allow the organizer to configure starting cash for both travelers.

---

### 4.3 🟢 [DESIGN & UX] 8.2 No Loading State for Initial Data

When the app first opens, all 6 streams start empty and populate asynchronously. There's no skeleton/shimmer loading state for the balance cards or activity feed — they show "No activity yet" briefly before data arrives.

**Fix**: Show shimmer placeholders until the first data event arrives for each stream.

---

### 4.4 🟢 [DESIGN & UX] 8.3 No Error Handling UI for Failed Operations

When `addExpense`, `deleteExpense`, etc. fail, `_errorMessage` is set in the ViewModel but never displayed to the user in the main screens. The only error feedback is a SnackBar in the dialog, but the dialog may already be closed.

---

### 4.5 🟢 [DESIGN & UX] 8.5 No Confirmation on Expense Edit Save

When editing an expense, there's no diff showing what changed. The user might accidentally modify values without realizing.

---

### 4.6 🟢 [DESIGN & UX] 8.6 Theme Selector Not Persisted

`AppTheme.themeModeNotifier` uses a `ValueNotifier<ThemeMode>` that resets to `ThemeMode.system` on app restart. The user's theme preference is lost.

**Fix**: Persist to `SharedPreferences` and restore on startup.

---

### 4.7 🟢 [DESIGN & UX] 8.7 No Haptic Feedback on Critical Actions

No `HapticFeedback.lightImpact()` or similar on expense/exchange save, delete, or tab switch.

---

### 4.8 🟢 [DESIGN & UX] 8.8 My Tracker Shows Only Expenses, Not Exchanges

The MVP spec (Section 7) says My Tracker shows personal balances, "My Expenses" (100% share), and "Shared Expenses." But it does NOT show the user's exchanges. Since exchanges affect balances, the user can't understand why their balance changed from the My Tracker tab alone.

---

### 4.9 🟢 [DESIGN & UX] 8.9 No Keyboard Shortcut or Quick Amount Entry

The MVP spec emphasizes "Very fast expense entry" (Section 2, #1 priority). Current flow requires:
1. Tap + button
2. Tap "Add Expense" from action sheet
3. Type title
4. Type amount
5. Toggle currency
6. Select payer
7. Select split
8. Tap Save

That's 8 steps. Consider:
- Auto-focus the amount field
- Allow entering amount first, title second
- Quick-add presets for common expenses
- Pre-select EGP as default (already done ✓)

---

### 4.10 🟢 [CODE QUALITY] 9.1 Fonts Bundled But Never Declared in pubspec.yaml

Three Google Sans woff2 font files exist in `assets/fonts/` but are declared only as asset directories, not as `fonts:` entries:

```yaml
flutter:
  assets:
    - assets/
    - assets/images/
    - assets/fonts/       # ← These are assets, not declared fonts
```

The fonts are loaded as raw assets but never used as text fonts (no `fontFamily: 'GoogleSans'` anywhere in the theme). They just waste binary space.

**Fix**: Either declare them properly under `flutter.fonts` or delete them entirely and use Material 3 system fonts.

---

### 4.11 🟢 [CODE QUALITY] 9.2 Unused `cupertino_icons` Dependency

`cupertino_icons: ^1.0.8` is in `pubspec.yaml` but no Cupertino icons are used anywhere in the codebase (only Material icons).

---

### 4.12 🟢 [CODE QUALITY] 9.3 `MyApp` Services Are Nullable For No Reason

```dart
class MyApp extends StatelessWidget {
  final AuthService? authService;      // ← nullable
  final FirestoreService? firestoreService;  // ← nullable
```

These are always provided from `main()`. The nullable check in `build()` creates a dead-code fallback scaffold that's never displayed.

---

### 4.13 🟢 [CODE QUALITY] 9.4 `sdk: ^3.14.0-147.0.dev` — Pinned to Dev Channel

```yaml
environment:
  sdk: ^3.14.0-147.0.dev
```

This pins to a **dev channel** SDK. This means:
- The app can't be built on stable Flutter
- Other developers can't easily contribute
- CI/CD pipelines will fail without the exact dev SDK

**Fix**: Use the stable SDK constraint: `sdk: ^3.5.0` or whatever stable version you're targeting.

---

### 4.14 🟢 [CODE QUALITY] 9.5 No `const` Constructors on Many Widgets

Many widgets that could be `const` aren't, leading to unnecessary rebuilds. For example, `EmptyState`, `HomeBalancesCard` instances, and others.

---

### 4.15 🟢 [CODE QUALITY] 9.6 `DateTime.now()` in `fromMap` Fallbacks

Every model's `fromMap` factory falls back to `DateTime.now()` when parsing fails:

```dart
date: map['date'] != null
    ? DateTime.tryParse(map['date'] as String) ?? DateTime.now()
    : DateTime.now(),
```

This silently masks data corruption by replacing bad dates with the current time.

---

### 4.16 🟢 [CODE QUALITY] 9.7 No Unit Tests for Calculation Logic

The `test/` directory exists but has no tests for the critical `Calculations` class. Given the balance calculation bug (#2), this is especially dangerous.

---

### 4.17 🟢 [CODE QUALITY] 9.8 Re-export Barrel Files Are Unnecessary

7 barrel files in `lib/features/home/components/` just re-export from `core/components/`:
```dart
export '../../../core/components/c_activity_tile.dart';
```

These add file count without value. Import directly from core instead.

---

### 4.18 🟢 [CODE QUALITY] 9.9 `applicationId` is `com.example.egy_tracker`

The Android `applicationId` in `build.gradle.kts` is still the Flutter default `com.example.egy_tracker`. If publishing to Play Store, this needs a proper reverse-domain package name.

---

# 5. Master Prioritized Action Matrix (Consolidated)

This table merges all findings from Claude (Sections 1–10) and Antigravity/Gemini (Section 11) into a single unified execution roadmap, strictly ordered by Priority and Danger Level.

| # | Priority | Issue | Location | Effort | Impact |
|---|---|---|---|---|---|
| 1 | 🔴 CRITICAL | Add `INTERNET` permission to `main/AndroidManifest.xml` | `AndroidManifest.xml` | 2 min | **Prevents release APK crash on startup** |
| 2 | 🔴 CRITICAL | Fix cash balance formula (`paid_by` = full amount, not share) | `m_calculations.dart` | 30 min | **Fixes incorrect balances across all shared expenses** |
| 3 | 🔴 CRITICAL | Separate "Who Paid" from "Split Type" (fix "Both" setting `paidBy=me`) | `c_add_expense_dialog.dart` | 45 min | **Prevents balance corruption when partner pays cash** |
| 4 | 🔴 CRITICAL | Store split percentages mapped to explicit UIDs (fix `isPrimaryUser` inversion) | `mod_expense.dart`, ViewModels | 1 hr | **Prevents trip split inversion on multi-device sync** |
| 5 | 🔴 CRITICAL | Lock down wide-open Firestore security rules (`allow read, write: if true;`) | `firestore.rules` | 30 min | **Secures private financial data against unauthorized access/wipe** |
| 6 | 🔴 CRITICAL | Remove hardcoded dev login backdoor in release (`if (!kDebugMode) return;`) | `f_auth.dart`, `s_login.dart` | 5 min | **Closes auth bypass in production builds** |
| 7 | 🔴 CRITICAL | Remove hardcoded admin email privileged bypass across 8 files | Core & ViewModels | 20 min | **Eliminates privilege escalations and rigid coupling** |
| 8 | 🔴 CRITICAL | Move hardcoded OAuth client ID to environment/Firebase config | `f_auth.dart` | 10 min | **Secures client authentication credentials** |
| 9 | 🔴 CRITICAL | Build release APK (`flutter build apk --release --split-per-abi`) + R8 shrink | Gradle / CLI | 5 min | **Shrinks installed app footprint from 300MB → <20MB** |
| 10 | 🟠 HIGH | Remove hard-blocking over-budget checks in expense & exchange dialogs | Dialog components | 20 min | **Allows logging reality after the fact (e.g. Cairo airport exchange)** |
| 11 | 🟠 HIGH | Dispose `TextEditingController`s in all 5 modal dialogs | `core/components/` | 30 min | **Fixes permanent memory leaks and GC degradation over the trip** |
| 12 | 🟠 HIGH | Debounce 6 real-time Firestore listeners on `HomeFeedViewModel` | `vm_home_feed.dart` | 25 min | **Fixes slow startup and stops 6 rapid sequential rebuilds** |
| 13 | 🟠 HIGH | Eliminate duplicate stream subscriptions in standalone `MyTrackerViewModel` | `vm_my_tracker.dart` | 20 min | **Prevents spawning 12 concurrent real-time Firestore listeners** |
| 14 | 🟠 HIGH | Fix Settings 3-tier nested `StreamBuilder`s creating new stream instances | `c_initial_balances_card.dart` | 30 min | **Stops massive Firestore churn, quota burn, and frame drops** |
| 15 | 🟠 HIGH | Replace `AnimatedSwitcher` with `IndexedStack` for 3-tab root navigation | `s_home.dart` | 20 min | **Preserves scroll position & state; eliminates tab switching lag** |
| 16 | 🟠 HIGH | Remove 3x animation controllers per list item; use `Dismissible` | `c_activity_tile.dart` | 30 min | **Saves 80+ active controllers on feed; fixes scrolling jitter** |
| 17 | 🟠 HIGH | Replace multi-getter quicksort storm with single cached list & cached balances | `vm_home_feed.dart` | 30 min | **Eliminates 4 quicksorts and O(n²) scans per frame render** |
| 18 | 🟠 HIGH | Replace `BackdropFilter` blur on nav bar with solid translucent layer | `c_floating_pill_nav_bar.dart` | 15 min | **Fixes 60fps frame drops on lower-end devices** |
| 19 | 🟠 HIGH | Resize & convert `logo.png` from 2.4MB RGBA (3537px) to 30KB WebP | `assets/images/` | 10 min | **Saves 2.3MB asset weight and 47MB decoded startup RAM** |
| 20 | 🟠 HIGH | Review Borrow feature scope: remove or hide behind feature flag | Models & Dialogs | 45 min | **Complies strictly with MVP specification and AGENTS.md** |
| 21 | 🟠 HIGH | Add validation preventing `fromCurrency == toCurrency` in exchange | `c_add_exchange_dialog.dart` | 10 min | **Prevents invalid USD→USD or EGP→EGP transactions** |
| 22 | 🟠 HIGH | Implement Edit functionality for allowed emails in Settings | Settings components | 30 min | **Fulfills MVP spec Section 8.1 whitelist CRUD** |
| 23 | 🟠 HIGH | Scope text field updates to `ValueListenableBuilder` (avoid full dialog rebuild) | `c_add_expense_dialog.dart` | 20 min | **Eliminates typing latency in expense modal** |
| 24 | 🟠 HIGH | Fix no-op `refresh()` method in Home viewmodel | `vm_home_feed.dart` | 10 min | **Implements actual stream refresh or removes dummy UI** |
| 25 | 🟡 MEDIUM | Fix hardcoded `height: 400` in Add Expense dialog | `c_add_expense_dialog.dart` | 15 min | **Prevents yellow RenderFlex overflow on small screens** |
| 26 | 🟡 MEDIUM | Convert Home tab fixed header to `CustomScrollView` + Slivers | `s_home_tab.dart` | 45 min | **Improves small screen layout; prevents header trapping viewport** |
| 27 | 🟡 MEDIUM | Guard exchange rate division by zero against `double.infinity` crash | Exchange dialog & tile | 15 min | **Prevents crash on bad input during currency exchange entry** |
| 28 | 🟡 MEDIUM | Attach `.handleError()` to Firestore stream pipelines | `f_firestore.dart` | 15 min | **Prevents silent unhandled stream freezes on network drop** |
| 29 | 🟡 MEDIUM | Add Firestore data validation rules to security config | `firestore.rules` | 30 min | **Prevents writing negative amounts, invalid currencies, or bad splits** |
| 30 | 🟡 MEDIUM | Implement batch chunking & rollback for "Delete All Data" | `f_firestore.dart` | 30 min | **Guarantees complete trip wipe without partial failure** |
| 31 | 🟡 MEDIUM | Add idempotency check to prevent duplicate expenses on retry | Expense submission | 20 min | **Prevents double-charging expenses on network retry** |
| 32 | 🟡 MEDIUM | Dispose or properly manage static `_authController` in `AuthService` | `f_auth.dart` | 15 min | **Prevents cross-instance event leaks & stale replays** |
| 33 | 🟡 MEDIUM | Fix `saveUserProfile` calling every build on `AuthGate` | `s_auth_gate.dart` | 15 min | **Reduces redundant Firestore writes & timestamp churn** |
| 34 | 🟡 MEDIUM | Fix first-launch whitelist auto-seed race condition | `f_firestore.dart` | 20 min | **Guarantees two-user limit during simultaneous first opens** |
| 35 | 🟡 MEDIUM | Store dates as Firestore `Timestamp` instead of ISO string | All models | 40 min | **Enables native server-side chronological sorting** |
| 36 | 🟡 MEDIUM | Resolve payer display name from whitelist email when UID is unknown | `c_activity_tile.dart` | 15 min | **Displays friendly name/email instead of raw Firebase UID** |
| 37 | 🟡 MEDIUM | Avoid saving literal `'friend'` placeholder in Borrow records | `c_borrow_dialog.dart` | 15 min | **Prevents permanent record disconnection for partner** |
| 38 | 🟡 MEDIUM | Add real-time stream or "Check Again" button on Access Denied | `s_auth_gate.dart` | 20 min | **Seamless friend onboarding without sign-out loop** |
| 39 | 🟡 MEDIUM | Explicitly configure Firestore offline cache and optimistic UI | `f_firestore.dart` | 30 min | **Ensures smooth offline expense logging during Egypt travel** |
| 40 | 🟡 MEDIUM | Verified `formatDate` 12-hour midnight formatting logic | `m_formatters.dart` | 5 min | **Verified accurate (12 AM / 12 PM); documented for safety** |
| 41 | 🟢 LOW | Delete dead animation files (`a_shimmer`, `a_expandable`, etc.) | `core/animations/` | 5 min | **Removes 237 lines of unused dead code** |
| 42 | 🟢 LOW | Allow trip organizer to configure friend's starting cash in Settings | `c_initial_balances_card.dart` | 20 min | **Improves initial trip onboarding from single device** |
| 43 | 🟢 LOW | Add shimmer skeleton placeholders while initial streams load | Screen components | 30 min | **Eliminates momentary "No activity yet" flash on startup** |
| 44 | 🟢 LOW | Surface ViewModel background error messages in UI SnackBars | Screen components | 20 min | **Informs user when background Firestore operations fail** |
| 45 | 🟢 LOW | Add visual confirmation diff before saving edited expenses | `c_add_expense_dialog.dart` | 25 min | **Prevents accidental expense modifications** |
| 46 | 🟢 LOW | Persist theme mode preference in `SharedPreferences` | `t_app_theme.dart` | 15 min | **Retains user dark/light mode preference across restarts** |
| 47 | 🟢 LOW | Add haptic feedback (`HapticFeedback.lightImpact()`) on critical actions | Buttons & Nav Bar | 15 min | **Provides tactile confirmation on expense entry and tabs** |
| 48 | 🟢 LOW | Display currency exchanges in My Tracker history | `s_my_tracker.dart` | 30 min | **Explains personal balance changes from tracker tab** |
| 49 | 🟢 LOW | Auto-focus amount field and streamline entry flow to 3 steps | Expense dialog | 30 min | **Aligns with MVP #1 priority: ultra-fast expense entry** |
| 50 | 🟢 LOW | Properly declare or delete bundled Google Sans font files | `pubspec.yaml`, assets | 10 min | **Eliminates 174KB of undeclared binary asset bloat** |
| 51 | 🟢 LOW | Remove unused `cupertino_icons` dependency | `pubspec.yaml` | 2 min | **Cleans package dependency tree** |
| 52 | 🟢 LOW | Make `MyApp` services non-nullable and remove dead fallback scaffold | `main.dart` | 5 min | **Eliminates unreachable fallback code** |
| 53 | 🟢 LOW | Pin Dart SDK constraint to stable Flutter (`sdk: ^3.5.0`) | `pubspec.yaml` | 2 min | **Ensures project builds on standard Flutter stable channel** |
| 54 | 🟢 LOW | Add `const` constructors across immutable widgets | Various components | 20 min | **Prevents unnecessary widget repainting** |
| 55 | 🟢 LOW | Flag or log `DateTime.now()` fallback in model JSON parsing | Models | 15 min | **Avoids masking corrupted timestamp data** |
| 56 | 🟢 LOW | Add unit test suite for `Calculations` (Scenarios A through E) | `test/` | 1.5 hr | **Guarantees multi-currency invariants and prevents regressions** |
| 57 | 🟢 LOW | Delete 7 redundant barrel re-export files in feature directory | `features/home/components/` | 5 min | **Simplifies project directory structure** |
| 58 | 🟢 LOW | Fix Android `applicationId` package name | `build.gradle.kts` | 5 min | **Prepares app for Play Store submission** |

---

# 6. Appendix: Consolidated File-by-File Quick Reference

This reference maps every modified file across the entire repository to all issues, optimizations, and invariants identified during both audit passes.

| File | Lines | Issues Found |
|---|---|---|
| `m_calculations.dart` | 144 | **Balance bug** (cash vs share confusion) |
| `f_firestore.dart` | 311 | Open security rules, email race condition |
| `f_auth.dart` | 230 | Static stream controller, dev backdoor, hardcoded email |
| `vm_home_feed.dart` | 392 | 6 concurrent listeners, uncached getters, O(n²) |
| `vm_my_tracker.dart` | 344 | Duplicate listeners, uncached balances |
| `c_add_expense_dialog.dart` | 657 | Merged payer/split UI, fixed height, complex restore logic |
| `c_activity_tile.dart` | 488 | Double animation controller |
| `c_floating_pill_nav_bar.dart` | 445 | Expensive BackdropFilter blur |
| `c_borrow_dialog.dart` | 474 | Out-of-scope feature |
| `s_auth_gate.dart` | 204 | saveUserProfile on every build, hardcoded email |
| `t_app_theme.dart` | 391 | No persisted theme mode |
| `pubspec.yaml` | 32 | Dev SDK, unused deps, undeclared fonts |
| `firestore.rules` | 30 | **All rules wide open** |
| `build.gradle.kts` | 41 | No minify/shrink, example applicationId |
| `logo.png` | — | **2.4MB, 3537×3537** (should be ~30KB) |
| `android/app/src/main/AndroidManifest.xml` | ~30 | **Missing `INTERNET` permission** (crashes release APK on startup) |
| `mod_expense.dart` | ~120 | Egocentric `me_percentage`/`friend_percentage`; dates stored as ISO strings; `DateTime.now()` fallback |
| `mod_exchange.dart` | ~90 | Missing validation (`from != to`); asymmetric rate calculation; ISO string dates |
| `s_home.dart` | 150 | `AnimatedSwitcher` destroys page state, scroll offset, and replays animations on every tab switch |
| `s_home_tab.dart` | 180 | Non-scrollable header traps viewport; pull-to-refresh only triggers inside list |
| `s_my_tracker.dart` | 200 | Missing initial loading shimmer; omits exchange history; lack of background error SnackBar |
| `s_settings.dart` | 250 | Missing Edit operation for allowed emails (Add, Delete only); delete all data safety |
| `vm_settings.dart` | 180 | Stream getters return new instances on every call, causing infinite reconnect loop |
| `c_initial_balances_card.dart` | ~160 | 3-tier nested `StreamBuilder`s re-subscribing endlessly; friend's starting cash read-only |
| `c_add_exchange_dialog.dart` | ~250 | Hard-blocked overbudget disables Save; division by zero produces `double.infinity`; un-disposed controllers |
| `a_shimmer.dart` | 87 | Dead code; unused animation file |
| `a_expandable.dart` | 76 | Dead code; unused animation file |
| `a_animated_amount.dart` | 74 | Dead code; unused animation file |
| `m_formatters.dart` | 95 | 12-hour midnight logic verified; division-by-zero protection needed |
| `test/` | — | Missing unit tests for calculation logic and Scenarios A through E |
