---
name: two-currency-calculations
description: >-
  Use this skill whenever implementing, modifying, or testing balance calculations,
  expense splits, currency exchanges, or personal share logic in egy_tracker.
  Ensures strict currency independence and zero cross-currency aggregation.
---

# Two-Currency Calculations Skill

This skill guides the implementation and verification of all monetary mathematics in `egy_tracker`.

## Core Mathematical Principles

1. **Strict Currency Independence**:
   - Every user has two independent balance accounts: $B_{\text{user}, \text{USD}}$ and $B_{\text{user}, \text{EGP}}$.
   - Balances are NEVER aggregated or converted into a single combined sum.

2. **Cash Balance Formula**:
   For any user $u$ and currency $c \in \{\text{USD}, \text{EGP}\}$:
   $$B_{u, c} = I_{u, c} + \sum \text{ExchangesIn}_{u, c} - \sum \text{ExchangesOut}_{u, c} - \sum \text{ExpensesPaid}_{u, c}$$
   Where:
   - $I_{u, c}$ is the user's initial balance for currency $c$.
   - $\text{ExchangesIn}_{u, c}$ are exchanges where user == $u$ and $\text{to\_currency} == c$ (amount added is $\text{to\_amount}$).
   - $\text{ExchangesOut}_{u, c}$ are exchanges where user == $u$ and $\text{from\_currency} == c$ (amount subtracted is $\text{from\_amount}$).
   - $\text{ExpensesPaid}_{u, c}$ are expenses where $\text{paid\_by} == u$ and $\text{currency} == c$ (amount subtracted is the full expense $\text{amount}$).

3. **Personal Consumption Share Formula**:
   For any expense $e$ in currency $c$ with total amount $A$:
   - If user is "Me": $\text{Share}_{\text{Me}} = A \times \frac{\text{me\_percentage}}{100}$
   - If user is "Friend": $\text{Share}_{\text{Friend}} = A \times \frac{\text{friend\_percentage}}{100}$
   - Constraint: $\text{me\_percentage} + \text{friend\_percentage} == 100$

4. **Split Types**:
   - `default_100`:
     - If $\text{paid\_by} == \text{Me} \implies \text{Me} = 100\%, \text{Friend} = 0\%$
     - If $\text{paid\_by} == \text{Friend} \implies \text{Me} = 0\%, \text{Friend} = 100\%$
   - `fifty_fifty`:
     - $\text{Me} = 50\%, \text{Friend} = 50\%$
   - `custom`:
     - Explicit percentages strictly validated to sum to 100.

## Detailed Verification Reference
Read [references/scenarios.md](references/scenarios.md) for step-by-step test cases (Scenarios A through E) to validate your implementation.
