# Simple Two-Currency Expense Tracker

## 1. Product Overview

A lightweight private web/mobile app for two users who are managing money together while in Egypt.

The app tracks:

- Personal money balances
- Expenses
- Shared expense splits
- USD ↔ EGP exchanges
- Each user's personal share of expenses

The app is intentionally temporary and simple. There is only one active use case, two currencies, and a small number of users. The data can be deleted after returning from Egypt.

### Core principle

**USD and EGP are completely independent currencies.**

The app must never automatically convert one currency into the other, combine their values, or maintain a global exchange rate.

Every expense has exactly one currency.

Every exchange explicitly records the source amount, destination amount, and rate actually used.

---

# 2. Scope and Design Principles

The application should prioritize:

1. Very fast expense entry
2. Clear separation between USD and EGP
3. Accurate personal/shared expense calculation
4. Simple money-balance tracking
5. Minimal database complexity
6. Easy deletion when the app is no longer needed

The app should avoid unnecessary features and should not become a general-purpose finance application.

---

# 3. Explicitly Out of Scope

The MVP does **not** include:

- DZD
- DZD → USD conversion
- USD → DZD conversion
- Automatic currency conversion
- A global exchange rate
- Combined USD + EGP totals
- Multiple trips
- Trip creation
- Trip names
- Categories
- Expense "For" fields
- Complex budgeting
- Debt optimization
- Settlement optimization
- Notifications
- Social features
- Recurring expenses
- Bank integrations
- Payment integrations
- Multi-trip history
- Automatic exchange-rate APIs

The application only needs USD and EGP.

---

# 4. Authentication

## Google Sign-In

Authentication uses Google Sign-In.

After authentication, the user's Google email is checked against the application's allowed-email list.

Only allowed emails can access the application.

### Allowed email management

Settings contains a simple CRUD interface:

- View allowed emails
- Add an email
- Edit an email
- Delete an email

There are expected to be only two actual users.

The system can technically support more than two allowed accounts, but the UI and calculation model are optimized for two users.

---

# 5. Application Navigation

The application has three bottom-navigation tabs:

1. **Home**
2. **My Tracker**
3. **Settings**

---

# 6. Home Screen

Home is the shared view and the main source of truth for activity.

## 6.1 Current Money

Show the current balances of both users separately for each currency.

### USD

```text
You:     $70
Friend:  $80
```

### EGP

```text
You:     3,500 EGP
Friend:  5,000 EGP
```

Do not combine these into an equivalent USD or EGP total.

For example, do **not** display:

```text
$141 total
```

because USD and EGP are independent.

## 6.2 Recent Activity

Display expenses and exchanges in chronological order.

Examples:

```text
Restaurant
1,200 EGP
Paid by You · 50/50
```

```text
Taxi
$15
Paid by Friend · 100% You
```

```text
Exchange
$100 → 4,900 EGP
By You
```

Each item should clearly show:

- Title or activity type
- Amount
- Currency
- Person involved
- Split information for expenses
- Date/time

## 6.3 Add Button

A prominent `+` action should allow the user to add:

- Expense
- Exchange

These should be separate actions.

---

# 7. My Tracker Screen

My Tracker is personalized to the currently logged-in user.

Its purpose is to answer:

> What money do I currently have, what did I personally spend, and what is my share of shared expenses?

## 7.1 Current Personal Balances

Show separate balances:

### USD

```text
$70
```

### EGP

```text
3,500 EGP
```

Never combine them.

## 7.2 My Expenses

Show expenses where the user's calculated share is 100%.

Example:

```text
Taxi
$15
My share: $15
```

## 7.3 Shared Expenses

Show expenses where the user has less than 100% of the expense.

Example:

```text
Dinner
1,000 EGP
Total: 1,000 EGP
My share: 500 EGP
```

For a custom split:

```text
Dinner
1,000 EGP
Total: 1,000 EGP
My share: 700 EGP
Friend's share: 300 EGP
```

The same original expense remains stored only once in the database.

The personal tracker calculates the user's share from the stored percentages.

---

# 8. Settings Screen

Settings should remain minimal.

## 8.1 Allowed Emails

Manage the list of accounts that are allowed to log in.

Operations:

- Add
- Edit
- Delete
- View

## 8.2 Initial Balances

Initial balances are configured here and are completely separate from expenses and exchanges.

Each user has a starting balance for each currency.

Example:

```text
You
USD: $150
EGP: 0 EGP

Friend
USD: $150
EGP: 0 EGP
```

Initial balances are not expenses and are not exchanges.

They represent the starting state of each user's money before activity begins.

Each user's initial balances can be edited in Settings if an entry was incorrect.

### Important

There is no need to represent an initial balance as a fake transaction.

Store it directly as part of the user's starting balance data.

---

# 9. Adding an Expense

The `+` button opens the Add Expense form.

## Fields

### 9.1 Expense Title

A short description of the expense.

Examples:

```text
Restaurant dinner
Taxi to the airport
Groceries
Museum tickets
```

The title is useful because expenses should be understandable later without opening every detail.

### 9.2 Amount

Example:

```text
1,250
```

### 9.3 Currency

Choose exactly one:

```text
USD
EGP
```

The expense remains in that currency permanently.

### 9.4 Paid By

Choose:

```text
Me
Friend
```

### 9.5 Split Type

The split controls each person's share of the expense.

Available options:

```text
100% by default
50/50
Custom
```

#### 100% by default

This is the default option.

The expense belongs entirely to the person who paid it.

If `Paid By = Me`:

```text
Me: 100%
Friend: 0%
```

If `Paid By = Friend`:

```text
Me: 0%
Friend: 100%
```

#### 50/50

Example:

```text
Expense: $100

Me:     50%
Friend: 50%
```

Each person's share is:

```text
Me:     $50
Friend: $50
```

#### Custom

The user manually specifies the percentage for each person.

Example:

```text
Me:     70%
Friend: 30%
```

For a $100 expense:

```text
Me:     $70
Friend: $30
```

Validation requirement:

```text
Me percentage + Friend percentage = 100%
```

No other total should be accepted.

### 9.6 Date and Time

Default to the current date/time.

Allow the user to change it.

### 9.7 Save

After saving:

- The expense appears on Home.
- The expense contributes to the payer's money balance.
- Each user's personal share is calculated in My Tracker.

---

# 10. Adding an Exchange

An exchange is completely separate from an expense.

Example:

```text
$100 → 4,900 EGP
```

This is not spending money.

It means that a user moved money from one currency balance into another currency balance.

## Exchange Form

### From Currency

```text
USD
```

or:

```text
EGP
```

### Amount Given

Example:

```text
100
```

### To Currency

The opposite currency.

Example:

```text
EGP
```

### Amount Received

Example:

```text
4,900
```

### Exchange Rate

The user enters the actual rate used.

Example:

```text
1 USD = 49 EGP
```

The app should store the rate for this specific exchange.

### Date and Time

Default to current date/time.

### Save

After saving, the exchange affects the user's currency balances:

```text
USD decreases by the source amount
EGP increases by the destination amount
```

or the reverse if exchanging EGP → USD.

---

# 11. Exchange Rate Rules

Exchange rates are **transaction-specific**.

There is no global exchange-rate setting.

For example:

```text
Exchange 1
$100 → 4,900 EGP
Rate: 49 EGP / USD
```

Later:

```text
Exchange 2
$100 → 5,000 EGP
Rate: 50 EGP / USD
```

Both transactions keep their own rates.

Changing a later exchange must never modify an earlier transaction.

The app does not automatically fetch or recalculate exchange rates.

---

# 12. Currency Model

USD and EGP are separate parallel balances.

Example:

```text
You
USD: $70
EGP: 3,500 EGP
```

This is not one combined balance.

The same principle applies to the friend.

A user can have more EGP while the other user has more USD.

Example:

```text
You
USD: $100
EGP: 8,000 EGP

Friend
USD: $80
EGP: 5,000 EGP
```

This is completely valid.

The app does not attempt to equalize or convert these balances.

---

# 13. Balance Calculation

Each user's balance is calculated independently for each currency.

## USD Balance

Conceptually:

```text
Current USD
=
Initial USD
+ USD received
- USD exchanged out
+ USD exchanged in
- Personal USD expense share
```

## EGP Balance

```text
Current EGP
=
Initial EGP
+ EGP received
- EGP exchanged out
+ EGP exchanged in
- Personal EGP expense share
```

There is no cross-currency operation except an explicit Exchange record.

For example:

```text
USD → EGP
```

changes both balances only because the user explicitly recorded an exchange.

---

# 14. Expense Split Logic

Every expense is stored exactly once.

The expense stores:

- Total amount
- Currency
- Payer
- Split type
- Me percentage
- Friend percentage

The user's personal share is calculated as:

```text
Personal Share = Expense Amount × Personal Percentage
```

Example:

```text
Expense = 1,000 EGP
Me = 70%
Friend = 30%
```

Then:

```text
Me share = 1,000 × 0.70 = 700 EGP
Friend share = 1,000 × 0.30 = 300 EGP
```

The app should not create duplicate expense records for each user.

---

# 15. How an Expense Affects Money

The key distinction is:

- **Paid by** determines whose physical balance decreases.
- **Split percentages** determine how much of the expense belongs to each person personally.

Example:

```text
Expense:
$100

Paid by:
Me

Split:
50/50
```

Money effect:

```text
My USD balance: -$100
Friend USD balance: $0
```

Personal consumption:

```text
My share:     $50
Friend share: $50
```

The app therefore knows that I physically paid the full $100, but only $50 belongs to me as personal consumption.

This distinction is important for understanding shared spending.

---

# 16. Example Scenarios

## Scenario A — Personal expense

```text
Expense:
Taxi

Amount:
$15

Paid by:
Me

Split:
100%
```

Result:

```text
My USD balance: -$15
My share:       $15
Friend's share: $0
```

## Scenario B — Shared expense

```text
Expense:
Dinner

Amount:
1,000 EGP

Paid by:
Me

Split:
50/50
```

Result:

```text
My EGP balance: -1,000 EGP
My share:       500 EGP
Friend's share: 500 EGP
```

## Scenario C — Friend pays for me

```text
Expense:
Taxi

Amount:
$20

Paid by:
Friend

Split:
100% Me
```

Result:

```text
Friend USD balance: -$20
My share:             $20
Friend's share:        $0
```

The app records that the friend physically paid the money while the expense belongs entirely to me.

## Scenario D — Custom split

```text
Expense:
Dinner

Amount:
2,000 EGP

Paid by:
Friend

Split:
Me 70%
Friend 30%
```

Result:

```text
Friend EGP balance: -2,000 EGP

My share:      1,400 EGP
Friend share:    600 EGP
```

## Scenario E — Exchange

```text
Before:

USD: $150
EGP: 0
```

User exchanges:

```text
$100 → 4,900 EGP
Rate: 49
```

After:

```text
USD: $50
EGP: 4,900
```

No expense was created.

---

# 17. Database Model

Keep the database intentionally simple.

## 17.1 Users

```text
users
-----
id
name
email
created_at
```

## 17.2 Allowed Emails

```text
allowed_emails
--------------
id
email
created_at
```

The authentication layer checks the Google email against this table.

## 17.3 Initial Balances

```text
initial_balances
----------------
user_id
usd_amount
egp_amount
updated_at
```

Each user has one record.

Initial balances are directly stored here rather than being represented as transactions.

## 17.4 Expenses

```text
expenses
--------
id
title
amount
currency
paid_by
split_type
me_percentage
friend_percentage
date
created_at
```

### Currency

Allowed values:

```text
USD
EGP
```

### Paid By

References one of the two users.

### Split Type

Possible values:

```text
default_100
fifty_fifty
custom
```

### Percentages

For every expense:

```text
me_percentage + friend_percentage = 100
```

## 17.5 Exchanges

```text
exchanges
---------
id
user_id
from_currency
from_amount
to_currency
to_amount
exchange_rate
date
created_at
```

Each exchange belongs to the user who performed it.

Allowed currencies:

```text
USD
EGP
```

---

# 18. Important Data Rules

## Rule 1 — One expense, one currency

An expense can never contain both USD and EGP.

Correct:

```text
1,000 EGP
```

Incorrect:

```text
$20 + 1,000 EGP
```

## Rule 2 — No automatic conversion

The application never turns:

```text
1,000 EGP
```

into a USD value automatically.

## Rule 3 — Exchange is explicit

USD and EGP balances change through an exchange only when the user records an actual exchange.

## Rule 4 — Exchange rates are historical

Each exchange keeps its own entered rate.

## Rule 5 — Expense exists once

A shared expense is stored once and each user's share is derived from percentages.

## Rule 6 — Payer and consumer are separate concepts

`paid_by` determines whose balance physically decreases.

The split percentages determine the personal share.

## Rule 7 — Initial balances are not transactions

They belong in Settings and establish the starting balances.

---

# 19. UI/UX Principles

The interface should be simple and fast because expenses may be added frequently while traveling.

## General principles

- Minimal number of fields
- Large, obvious amounts
- Clear currency indicator
- Clear payer selection
- Fast split selection
- No unnecessary categories
- No unnecessary confirmation screens
- Strong separation between USD and EGP
- Chronological activity
- Easy editing/deletion

## Currency display

Use clear formatting:

```text
$25
```

and:

```text
1,250 EGP
```

Never hide the currency.

---

# 20. Suggested Home Layout

```text
--------------------------------
HOME
--------------------------------

MONEY

USD
You       $70
Friend    $80

EGP
You       3,500 EGP
Friend    5,000 EGP


RECENT ACTIVITY

Restaurant
1,200 EGP
You · 50/50

Exchange
$100 → 4,900 EGP
You

Taxi
$15
Friend · 100% Me

Coffee
300 EGP
You · 100% by default

                         +
--------------------------------
Home    My Tracker    Settings
--------------------------------
```

---

# 21. Suggested My Tracker Layout

```text
--------------------------------
MY TRACKER
--------------------------------

MY MONEY

USD
$70

EGP
3,500 EGP


MY EXPENSES

Taxi
$15
My share: $15


SHARED EXPENSES

Dinner
1,000 EGP
My share: 500 EGP

Groceries
2,000 EGP
My share: 1,400 EGP

                         +
--------------------------------
Home    My Tracker    Settings
--------------------------------
```

---

# 22. Suggested Settings Layout

```text
--------------------------------
SETTINGS
--------------------------------

INITIAL BALANCES

YOU
USD      $150
EGP      0 EGP

FRIEND
USD      $150
EGP      0 EGP


ALLOWED EMAILS

you@example.com
friend@example.com

[ Add Email ]


ACCOUNT

Google account information


DATA

Delete all data
--------------------------------
Home    My Tracker    Settings
--------------------------------
```

---

# 23. Initial Balance Workflow

Because the initial balances are part of Settings, the first-use flow can be:

```text
Google Login
     ↓
Check Allowed Email
     ↓
Open App
     ↓
Settings → Initial Balances
     ↓
Enter starting USD and EGP for each user
```

Example before traveling:

```text
You
USD: $150
EGP: 0

Friend
USD: $150
EGP: 0
```

The app then uses those values as the starting point for balance calculations.

There is no need to create an "Initial Balance" expense.

---

# 24. Deletion and Lifecycle

The app is temporary.

After returning from Egypt, the users should be able to delete the data easily.

A simple Settings action can provide:

```text
Delete all data
```

This should remove:

- Expenses
- Exchanges
- Initial balances
- User data associated with the app
- Allowed email records, if appropriate for the implementation

Authentication itself is managed by Google and is not deleted by the app.

---

# 25. MVP Feature Checklist

## Authentication

- [x] Google Sign-In
- [x] Allowed email whitelist
- [x] Only approved users can access the app

## Home

- [x] Current USD balances
- [x] Current EGP balances
- [x] Shared expense history
- [x] Exchange history
- [x] Add Expense
- [x] Add Exchange

## My Tracker

- [x] Personal USD balance
- [x] Personal EGP balance
- [x] Personal expenses
- [x] Shared expenses
- [x] Personal share calculation
- [x] Personal activity history

## Expenses

- [x] Title
- [x] Amount
- [x] USD or EGP
- [x] Paid by
- [x] 100% default
- [x] 50/50
- [x] Custom percentage split
- [x] Date/time
- [x] Edit
- [x] Delete

## Exchanges

- [x] USD → EGP
- [x] EGP → USD
- [x] Source amount
- [x] Destination amount
- [x] Actual exchange rate
- [x] Date/time
- [x] Edit
- [x] Delete

## Settings

- [x] Manage allowed emails
- [x] Manage initial balances
- [x] Delete application data

---

# 26. Final Product Definition

The application is a **simple two-user, two-currency money tracker**.

The entire system can be understood through three independent concepts:

```text
INITIAL BALANCES
Starting money

EXPENSES
Money spent

EXCHANGES
Money moved between USD and EGP
```

And one important calculation layer:

```text
PERSONAL SHARE
How much of each expense belongs to each user
```

The app never needs to understand DZD, never needs automatic currency conversion, and never needs a trip-management system.

The guiding rule is:

> **Keep USD and EGP separate. Keep expenses and exchanges separate. Keep initial balances separate. Make the payer and each person's expense share explicit.**
