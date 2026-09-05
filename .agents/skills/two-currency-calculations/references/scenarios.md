# Scenario Verification Matrices (MVP Specification)

Use these test cases to verify the correctness of calculation logic:

---

### Scenario A — Personal Expense
- **Initial Setup**: Me USD: $150, Friend USD: $150.
- **Expense**: Taxi, $15.
- **Paid By**: Me.
- **Split**: 100% by default.
- **Expected Outcome**:
  - My USD Cash Balance: $150 - $15 = **$135** (delta: -$15)
  - Friend USD Cash Balance: **$150** (delta: $0)
  - My Personal Share: **$15**
  - Friend's Personal Share: **$0**

---

### Scenario B — Shared Expense (50/50)
- **Initial Setup**: Me EGP: 5,000, Friend EGP: 5,000.
- **Expense**: Dinner, 1,000 EGP.
- **Paid By**: Me.
- **Split**: 50/50.
- **Expected Outcome**:
  - My EGP Cash Balance: 5,000 - 1,000 = **4,000 EGP** (delta: -1,000 EGP)
  - Friend EGP Cash Balance: **5,000 EGP** (delta: 0 EGP)
  - My Personal Share: **500 EGP**
  - Friend's Personal Share: **500 EGP**

---

### Scenario C — Friend Pays for Me
- **Initial Setup**: Me USD: $100, Friend USD: $100.
- **Expense**: Taxi, $20.
- **Paid By**: Friend.
- **Split**: 100% Me (custom or explicit: Me 100%, Friend 0%).
- **Expected Outcome**:
  - My USD Cash Balance: **$100** (delta: $0)
  - Friend USD Cash Balance: $100 - $20 = **$80** (delta: -$20)
  - My Personal Share: **$20**
  - Friend's Personal Share: **$0**

---

### Scenario D — Custom Split
- **Initial Setup**: Me EGP: 10,000, Friend EGP: 10,000.
- **Expense**: Dinner, 2,000 EGP.
- **Paid By**: Friend.
- **Split**: Custom: Me 70%, Friend 30%.
- **Expected Outcome**:
  - My EGP Cash Balance: **10,000 EGP** (delta: 0 EGP)
  - Friend EGP Cash Balance: 10,000 - 2,000 = **8,000 EGP** (delta: -2,000 EGP)
  - My Personal Share: 2,000 * 0.70 = **1,400 EGP**
  - Friend's Personal Share: 2,000 * 0.30 = **600 EGP**

---

### Scenario E — Exchange (Transfer Between Own Balances)
- **Initial Setup**: Me USD: $150, Me EGP: 0 EGP.
- **Exchange Event**:
  - User: Me
  - From: USD, Amount: $100
  - To: EGP, Amount: 4,900 EGP
  - Recorded Rate: 49 EGP / USD
- **Expected Outcome**:
  - My USD Cash Balance: $150 - $100 = **$50**
  - My EGP Cash Balance: 0 + 4,900 = **4,900 EGP**
  - No expenses created.
  - No personal share recorded.
  - Friend's balances remain completely unaffected.
