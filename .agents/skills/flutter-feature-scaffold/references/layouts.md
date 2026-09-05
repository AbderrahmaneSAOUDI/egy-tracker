# UI Layout Specifications & ASCII Mocks

### 1. Home Layout
```text
+------------------------------------------+
| HOME                                     |
+------------------------------------------+
| MONEY                                    |
|   USD:                                   |
|     You:     $70                         |
|     Friend:  $80                         |
|                                          |
|   EGP:                                   |
|     You:     3,500 EGP                   |
|     Friend:  5,000 EGP                   |
|                                          |
| RECENT ACTIVITY                          |
|   [Card] Restaurant                      |
|          1,200 EGP                       |
|          Paid by You · 50/50             |
|                                          |
|   [Card] Exchange                        |
|          $100 -> 4,900 EGP               |
|          By You                          |
|                                          |
|   [Card] Taxi                            |
|          $15                             |
|          Paid by Friend · 100% You       |
|                                          |
|                                    [ + ] |
+------------------------------------------+
| [Home]       [My Tracker]     [Settings] |
+------------------------------------------+
```

### 2. My Tracker Layout
```text
+------------------------------------------+
| MY TRACKER                               |
+------------------------------------------+
| MY MONEY                                 |
|   USD: $70                               |
|   EGP: 3,500 EGP                         |
|                                          |
| MY EXPENSES (100% my share)              |
|   [Card] Taxi                            |
|          $15                             |
|          My share: $15                   |
|                                          |
| SHARED EXPENSES (Partial share)          |
|   [Card] Dinner                          |
|          Total: 1,000 EGP                |
|          My share: 500 EGP               |
|                                          |
|   [Card] Groceries                       |
|          Total: 2,000 EGP                |
|          My share: 1,400 EGP             |
|                                          |
|                                    [ + ] |
+------------------------------------------+
| [Home]       [My Tracker]     [Settings] |
+------------------------------------------+
```

### 3. Settings Layout
```text
+------------------------------------------+
| SETTINGS                                 |
+------------------------------------------+
| INITIAL BALANCES                         |
|   You:                                   |
|     USD: $150      EGP: 0 EGP            |
|   Friend:                                |
|     USD: $150      EGP: 0 EGP            |
|   [ Edit Initial Balances ]              |
|                                          |
| ALLOWED EMAILS                           |
|   • you@example.com                      |
|   • friend@example.com                   |
|   [ + Add Allowed Email ]                |
|                                          |
| ACCOUNT                                  |
|   Signed in as: you@example.com          |
|   [ Sign Out ]                           |
|                                          |
| DATA MANAGEMENT                          |
|   [ Delete All Trip Data ]  (Red/Alert)  |
+------------------------------------------+
| [Home]       [My Tracker]     [Settings] |
+------------------------------------------+
```
