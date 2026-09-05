---
name: data-model-and-firestore
description: >-
  Use this skill when designing, creating, querying, or migrating database entities,
  Firestore collections, local SQLite/Hive models, or implementing the complete
  data wipe lifecycle for egy_tracker.
---

# Data Model & Storage Skill

Guides schema structure, validation constraints, and data operations in `egy_tracker`.

## Collections / Tables

1. **`users`**:
   - `id`: String (unique)
   - `name`: String
   - `email`: String (Google account email)
   - `created_at`: ISO timestamp

2. **`allowed_emails`**:
   - `id`: String
   - `email`: String (lowercase normalized)
   - `created_at`: ISO timestamp

3. **`initial_balances`**:
   - `user_id`: String (matches `users.id`)
   - `usd_amount`: Double / num
   - `egp_amount`: Double / num
   - `updated_at`: ISO timestamp

4. **`expenses`**:
   - `id`: String
   - `title`: String
   - `amount`: Double
   - `currency`: String (`'USD'` or `'EGP'`)
   - `paid_by`: String (user ID)
   - `split_type`: String (`'default_100'`, `'fifty_fifty'`, `'custom'`)
   - `me_percentage`: Double
   - `friend_percentage`: Double
   - `date`: ISO timestamp
   - `created_at`: ISO timestamp

5. **`exchanges`**:
   - `id`: String
   - `user_id`: String
   - `from_currency`: String (`'USD'` or `'EGP'`)
   - `from_amount`: Double
   - `to_currency`: String (`'USD'` or `'EGP'`)
   - `to_amount`: Double
   - `exchange_rate`: Double
   - `date`: ISO timestamp
   - `created_at`: ISO timestamp

## Data Wipe Protocol ("Delete all data")
To execute the post-trip wipe:
1. Delete all documents in `expenses`.
2. Delete all documents in `exchanges`.
3. Reset `initial_balances` to zero (or remove document).
4. Optionally purge or retain `allowed_emails` based on user choice.

Read [references/schema.md](references/schema.md) for detailed JSON schemas, index rules, and security constraints.
