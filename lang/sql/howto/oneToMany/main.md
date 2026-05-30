# SQL How To - One To Many

## Abstract
```sql
CREATE TABLE IF NOT EXISTS refresh_tokens(
    token TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id)
);
```

## Directory

## Useful Links

## Tags
