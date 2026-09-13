# UX Audit — egy_tracker

Comprehensive review of all screens, dialogs, navigation, and interaction flows.

---

## 🔴 Critical Issues (All Resolved ✅)

### 1. Slide-to-Edit/Delete Is Completely Undiscoverable — ✅ RESOLVED
- **Status:** **Resolved**.
- **Implementation:** Added a subtle right-chevron (`Icons.chevron_right_rounded`) indicator on the first tile (`tileIndex == 0`) with tooltip `"Swipe right to edit"`, and a subtle left-chevron (`Icons.chevron_left_rounded`) indicator on the second tile (`tileIndex == 1`) with tooltip `"Swipe left to delete"`. Subsequent tiles remain clean.

---

### 2. My Tracker Has No Filter/Segmentation UI — ✅ RESOLVED
- **Status:** **Resolved**.
- **Implementation:** Added `SegmentedPillBar<MyTrackerFilter>` with `[All / Expenses / Exchanges / Splits]` below the balance card in My Tracker. Filter reactive getters in `MyTrackerGettersMixin` and empty states in `MyTrackerExpenseList` updated to handle all 4 filter cases.

---

### 3. Pull-to-Refresh Redundancy — ✅ RESOLVED
- **Status:** **Resolved**.
- **Implementation:** Removed `RefreshIndicator` from `s_home_tab.dart` (and omitted from My Tracker) because all Firestore data is subscribed via real-time streams with zero need for manual pull-to-refresh.

---

## 🟠 Moderate Issues (All Resolved ✅)

### 4. Exchange Tiles in My Tracker Cannot Be Edited or Deleted — ✅ RESOLVED
- **Status:** **Resolved**.
- **Implementation:** Added `openEditExchangeDialog` and `openDeleteExchangeDialog` in `c_my_tracker_actions.dart` and wired them to `onEdit` and `onDelete` on exchange `ActivityTile`s in `c_my_tracker_list.dart`.

---

### 5. Action Sheet Bypassed When Borrow Is Disabled — ✅ RESOLVED (Closed by Design)
- **Status:** **Closed by Design**.
- **Design Decision:** Retained direct "Add Expense" trigger from the `+` button without presenting an action sheet when borrow is disabled. Exchanges are accessed via the dedicated Exchange navigation button, keeping expense entry a single tap.

---

### 6. Custom Split Slider Has Low Precision — ✅ RESOLVED (Closed by Design)
- **Status:** **Closed by Design**.
- **Design Decision:** Kept `Slider` divisions at `20` (5% steps) in `c_expense_dialog_custom_slider.dart` for fast, coarse adjustments without slider friction.

---

### 7. Initial Balance Input Accepts Negative Signs and Multiple Decimals — ✅ RESOLVED
- **Status:** **Resolved**.
- **Implementation:** Updated `c_initial_balance_input_field.dart` with strict formatting: allows only `[0-9.]` (stripping negative signs) combined with a `TextInputFormatter` rejecting multiple decimal points.

---

### 8. Email Form Hint Text Is Confusing — ✅ RESOLVED
- **Status:** **Resolved**.
- **Implementation:** Changed hint text from `'partner or partner@gmail.com'` to concrete realistic example `'e.g. alex or alex@gmail.com'` in `c_add_email_form.dart`.

---

## 🟡 Minor Issues (All Resolved ✅)

### 9. Settings Sections Default to Collapsed — ✅ RESOLVED
- **Status:** **Resolved**.
- **Implementation:** Set `initiallyExpanded: true` and `isCollapsible: true` across all settings `SectionCard` components: Theme Selector (`c_theme_selector_card.dart`), Initial Balances (`c_initial_balances_card.dart`), Allowed Emails (`c_allowed_emails_card.dart`), and Delete Trip Data (`c_delete_data_card.dart`). All sections are now fully open by default for immediate discoverability, while preserving the user's ability to collapse/expand each section.

---

### 10. No Success Feedback After Save Operations — ✅ RESOLVED
- **Status:** **Resolved**.
- **Implementation:** Created `c_app_snack_bar.dart` providing a modern floating card with `ScaleTransition` + elastic bounce entrance, clear iconography, haptic feedback, and contextual styling (`AppSnackBarType.success`, `error`, `info`). Integrated into:
  - Add/Edit Expense (`c_expense_dialog_submit.dart`)
  - Add/Edit Exchange (`c_exchange_submit_handler.dart`)
  - Add/Edit Borrow (`c_borrow_submit_handler.dart`)
  - Initial Balances configuration (`c_edit_initial_balances_dialog.dart`)
  - Add Allowed Email (`c_add_email_dialog.dart`)
  - Delete Allowed Email (`c_confirm_delete_email_dialog.dart`)
  - Activity tile deletion confirmation (`c_delete_activity_dialog.dart`)
  - Delete All Trip Data (`c_delete_data_action_runner.dart` & `c_delete_data_dialog.dart`)

---

### 11. Delete Confirmation for Exchanges Uses Generic Name "this exchange" — ✅ RESOLVED
- **Status:** **Resolved**.
- **Implementation:** Updated `c_delete_activity_dialog.dart` to compute specific descriptions:
  - Exchanges display formatted amount and currencies: `Are you sure you want to delete "$50.00 → 2,500.00 EGP"?`
  - Borrow records display formatted currency totals: `Are you sure you want to delete "$30.00 & 500.00 EGP"?`

---

### 12. No Keyboard "Done" Button to Dismiss or Submit in Dialogs — ✅ RESOLVED
- **Status:** **Resolved**.
- **Implementation:** Configured keyboard actions and submit callbacks:
  - **Expense Dialog:** Title has `TextInputAction.next`; amount field has `TextInputAction.done` with `onFieldSubmitted: onSubmit`.
  - **Exchange Dialog:** `fromAmount` has `TextInputAction.next`; `toAmount` has `TextInputAction.done` with `onFieldSubmitted: onSubmit`.
  - **Borrow Dialog:** `usdAmount` has `TextInputAction.next`; `egpAmount` has `TextInputAction.done` with `onFieldSubmitted: onSubmit`.
  - **Initial Balances Dialog:** USD field has `TextInputAction.next`; EGP field has `TextInputAction.done` with `onFieldSubmitted: onSubmit`.
  - **Add Email Dialog:** Email field has `TextInputAction.done` with `onFieldSubmitted: onSubmit`.

---

## Summary

| # | Severity | Issue | Effort | Status |
|---|----------|-------|--------|--------|
| 1 | 🔴 Critical | Swipe actions undiscoverable | Medium | ✅ RESOLVED |
| 2 | 🔴 Critical | My Tracker missing filter bar | Low | ✅ RESOLVED |
| 3 | 🔴 Critical | My Tracker no pull-to-refresh | Low | ✅ RESOLVED |
| 4 | 🟠 Moderate | Exchange tiles non-interactive in My Tracker | Low | ✅ RESOLVED |
| 5 | 🟠 Moderate | Exchange button not obvious from `+` | Low | ✅ RESOLVED |
| 6 | 🟠 Moderate | Custom split slider 5% steps only | Low | ✅ RESOLVED |
| 7 | 🟠 Moderate | Balance input accepts garbage characters | Low | ✅ RESOLVED |
| 8 | 🟠 Moderate | Email hint text confusing | Trivial | ✅ RESOLVED |
| 9 | 🟡 Minor | Settings sections collapsed by default | Low | ✅ RESOLVED |
| 10 | 🟡 Minor | No success snackbar after save | Low | ✅ RESOLVED |
| 11 | 🟡 Minor | Exchange delete uses generic name | Trivial | ✅ RESOLVED |
| 12 | 🟡 Minor | No keyboard Done/submit in dialogs | Low | ✅ RESOLVED |

