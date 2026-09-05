# Antigravity Rule: Domain & Mathematical Invariants

Applies to all code, tests, and configurations in `egy_tracker`.

---

## 1. Currency Independence & Separation
- The application supports only two currencies: `USD` and `EGP`.
- `USD` and `EGP` must remain completely separate in data storage, business logic, and UI display.
- **Rule of Zero Equivalent Sums**: The UI or calculation layer must **never** sum or convert balances across currencies to produce an "aggregate total" (e.g. `$141 total` or `7,000 EGP total` is an invariant violation).
- **Rule of Zero Global Rates**: There is no global exchange rate, no scheduled rate synchronization, and no external exchange-rate API.
- **One Expense, One Currency**: An expense must have exactly one currency string: `'USD'` or `'EGP'`.

---

## 2. Payer vs. Personal Share Calculation
- **Physical Cash Effect**:
  When User A pays an expense of amount $X$ in currency $C$:
  $$\Delta \text{Balance}_{A, C} = -X$$
  $$\Delta \text{Balance}_{B, C} = 0$$
  The full amount is deducted from the payer's cash balance, regardless of split percentages.
- **Personal Share Calculation**:
  $$\text{Share}_{\text{Me}} = X \times \frac{\text{me\_percentage}}{100}$$
  $$\text{Share}_{\text{Friend}} = X \times \frac{\text{friend\_percentage}}{100}$$
- **Percentage Sum Rule**:
  $$\text{me\_percentage} + \text{friend\_percentage} == 100.0$$
- **Split Types**:
  - `default_100`: Payer has 100%, friend has 0%.
  - `fifty_fifty`: 50% Me, 50% Friend.
  - `custom`: Explicit user percentages summing strictly to 100%.

---

## 3. Exchanges
- An exchange moves money between a user's own balances:
  $$\Delta \text{Balance}_{\text{user}, \text{from\_currency}} = -\text{from\_amount}$$
  $$\Delta \text{Balance}_{\text{user}, \text{to\_currency}} = +\text{to\_amount}$$
- An exchange is **not** an expense and must not appear in expense totals.
- Every exchange records its own historical `exchange_rate`. Modifying later exchanges must never retroactively recalculate or alter past exchanges.

---

## 4. Initial Balances
- Initial balances represent starting cash before travel begins.
- They are stored on the user's settings profile.
- They must **never** be stored or calculated as dummy expense transactions.

---

## 5. Scope Boundary
- Immediate rejection of: DZD, categories, tags, budgeting, trip management, debt simplification graphs.
