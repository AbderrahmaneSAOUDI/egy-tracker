# Data Schema & Storage Specifications

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "egy_tracker_schema",
  "definitions": {
    "Currency": {
      "type": "string",
      "enum": ["USD", "EGP"]
    },
    "SplitType": {
      "type": "string",
      "enum": ["default_100", "fifty_fifty", "custom"]
    },
    "Expense": {
      "type": "object",
      "required": ["id", "title", "amount", "currency", "paid_by", "split_type", "me_percentage", "friend_percentage", "date"],
      "properties": {
        "id": { "type": "string" },
        "title": { "type": "string", "minLength": 1 },
        "amount": { "type": "number", "minimum": 0.01 },
        "currency": { "$ref": "#/definitions/Currency" },
        "paid_by": { "type": "string" },
        "split_type": { "$ref": "#/definitions/SplitType" },
        "me_percentage": { "type": "number", "minimum": 0, "maximum": 100 },
        "friend_percentage": { "type": "number", "minimum": 0, "maximum": 100 },
        "date": { "type": "string", "format": "date-time" },
        "created_at": { "type": "string", "format": "date-time" }
      }
    },
    "Exchange": {
      "type": "object",
      "required": ["id", "user_id", "from_currency", "from_amount", "to_currency", "to_amount", "exchange_rate", "date"],
      "properties": {
        "id": { "type": "string" },
        "user_id": { "type": "string" },
        "from_currency": { "$ref": "#/definitions/Currency" },
        "from_amount": { "type": "number", "minimum": 0.01 },
        "to_currency": { "$ref": "#/definitions/Currency" },
        "to_amount": { "type": "number", "minimum": 0.01 },
        "exchange_rate": { "type": "number", "minimum": 0.0001 },
        "date": { "type": "string", "format": "date-time" },
        "created_at": { "type": "string", "format": "date-time" }
      }
    }
  }
}
```
