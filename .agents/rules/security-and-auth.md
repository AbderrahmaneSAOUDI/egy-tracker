# Antigravity Rule: Security, Authentication & Data Lifecycle

Applies to authentication and storage layers in `egy_tracker`.

---

## 1. Authentication & Whitelist Gating
- **Mechanism**: Google Sign-In (`google_sign_in` or Firebase Auth).
- **Access Control**:
  - After successful Google authentication, the user's verified email address must be compared against `allowed_emails`.
  - If the email is not found in `allowed_emails`, sign-out immediately, show an informative error message ("Access restricted to authorized trip members"), and deny access to all screens.
- **Allowed Emails Management**:
  - Located in Settings tab.
  - CRUD operations: List allowed emails, Add email, Edit email, Remove email.

---

## 2. Temporary Application Lifecycle & Data Wipe
- The app is designed for a temporary travel window.
- The Settings screen must include a destructive action: **Delete all data**.
- Execution requirements:
  - Require explicit double confirmation (modal dialog) before proceeding.
  - Atomically or sequentially purge:
    * All `expenses` records
    * All `exchanges` records
    * All `initial_balances` records
    * Reset active state
  - Return the app to the initial clean state.
- Note: Google Authentication identities are managed by Google and not deleted, but local and cloud trip records are wiped clean.
