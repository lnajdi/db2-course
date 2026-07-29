# PL/pgSQL Quick Reference Cheat Sheet

## Basic Block Structure

```sql
DO $$
DECLARE
    -- Variables go here (optional section)
    variable_name TYPE := initial_value;
BEGIN
    -- Your code goes here (required)
    -- Statements end with ;
EXCEPTION
    -- Error handling (optional)
    WHEN exception_name THEN
        -- Handle error
END $$;
```

---

## Key Syntax Rules

| Concept | Syntax | Remember |
|---------|--------|----------|
| **Assignment** | `var := value;` | `:=` not `=` |
| **Comparison** | `IF var = 5 THEN` | `=` for comparing |
| **Block wrapper** | `DO $$ ... END $$;` | Don't forget `$$` |
| **Statement end** | Every statement needs `;` | Even the last one |

---

## Common Data Types

```sql
-- Numbers
counter INTEGER;
price NUMERIC(10,2);
percentage REAL;

-- Text
name VARCHAR(100);
description TEXT;
code CHAR(3);

-- Date/Time
birth_date DATE;
created_at TIMESTAMP := NOW();
duration INTERVAL;

-- Boolean
is_active BOOLEAN := TRUE;

-- Match column type
customer_email customer.email%TYPE;
```

---

## Getting Data from Database

```sql
-- Single value
SELECT first_name INTO customer_name
FROM customer WHERE customer_id = 1;

-- Multiple values
SELECT first_name, last_name INTO fname, lname
FROM customer WHERE customer_id = 1;

-- Entire row
SELECT * INTO customer_rec
FROM customer WHERE customer_id = 1;

-- With safety (STRICT)
SELECT name INTO STRICT customer_name
FROM customer WHERE customer_id = 1;
```

---

## Control Flow

### IF Statements
```sql
IF condition THEN
    -- do something
ELSIF other_condition THEN
    -- do something else
ELSE
    -- default action
END IF;
```

### NULL-Safe Comparisons
```sql
-- Use COALESCE
IF COALESCE(total, 0) > 100 THEN

-- Or check explicitly
IF total IS NOT NULL AND total > 100 THEN
```

---

## Loops

### FOR Loop (Range)
```sql
FOR i IN 1..10 LOOP
    RAISE NOTICE 'Number: %', i;
END LOOP;
```

### FOR Loop (Query)
```sql
FOR record_var IN SELECT * FROM customer LOOP
    RAISE NOTICE 'Customer: %', record_var.first_name;
END LOOP;
```

### WHILE Loop
```sql
WHILE counter > 0 LOOP
    counter := counter - 1;
END LOOP;
```

---

## Output and Debugging

```sql
-- Simple message
RAISE NOTICE 'Processing started';

-- With variables
RAISE NOTICE 'Customer: %, Total: $%', name, total;

-- Multiple placeholders
RAISE NOTICE 'ID: %, Name: %, Email: %', id, name, email;
```

---

## Exception Handling

```sql
BEGIN
    -- Your code that might fail
    SELECT name INTO STRICT customer_name
    FROM customer WHERE customer_id = 999;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Customer not found';
    WHEN TOO_MANY_ROWS THEN
        RAISE NOTICE 'Multiple customers found';
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
```

---

## Common Patterns

### Pattern 1: Safe Lookup
```sql
DECLARE
    result TEXT;
BEGIN
    SELECT column INTO STRICT result
    FROM table WHERE id = value;
    
    -- Use result
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Not found';
END;
```

### Pattern 2: Loop and Process
```sql
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT * FROM table WHERE condition LOOP
        -- Process each record
        RAISE NOTICE 'Processing: %', rec.name;
    END LOOP;
END;
```

### Pattern 3: Conditional Logic
```sql
DECLARE
    count_val INTEGER;
BEGIN
    SELECT COUNT(*) INTO count_val FROM table;
    
    IF count_val > 0 THEN
        -- Do something
    ELSE
        -- Do something else
    END IF;
END;
```

### Pattern 4: Calculate and Report
```sql
DECLARE
    total NUMERIC;
    average NUMERIC;
BEGIN
    SELECT SUM(amount), AVG(amount) 
    INTO total, average
    FROM payment;
    
    RAISE NOTICE 'Total: $%, Average: $%', total, average;
END;
```

---

## Common Errors and Fixes

| Error Message | Likely Cause | Fix |
|---------------|--------------|-----|
| `syntax error at or near "BEGIN"` | Missing `DO $$` | Add `DO $$` at start, `END $$;` at end |
| `syntax error at or near "END"` | Missing `;` | Add `;` after each statement |
| `query has no destination` | Missing `INTO` | Add `INTO variable_name` to SELECT |
| `column "x" does not exist` | Typo in column name | Check spelling and table schema |
| `too many rows returned` | Query returns multiple rows | Add WHERE clause or use STRICT with EXCEPTION |

---

## Debugging Checklist

When stuck, check:
- [ ] Did you wrap with `DO $$` and `END $$;`?
- [ ] Are you using `:=` for assignment?
- [ ] Does every statement end with `;`?
- [ ] Did you DECLARE variables before using them?
- [ ] Are you using `INTO` with SELECT?
- [ ] Did you handle NULL values with COALESCE?
- [ ] Did you add EXCEPTION handling for STRICT?

---

## Quick Tips

✅ **DO:**
- Use `:=` for assignment
- Use `COALESCE` for NULL safety
- Use `STRICT` to catch data issues
- Add `EXCEPTION` blocks
- Use `RAISE NOTICE` to debug
- Match types with `%TYPE`

❌ **DON'T:**
- Use `=` for assignment
- Assume data exists (use STRICT)
- Forget to handle NULL values
- Write 50 lines before testing
- Ignore error messages

---

## Variable Types Reference

### RECORD vs %TYPE vs %ROWTYPE

```sql
-- RECORD: Flexible, any structure
rec RECORD;
SELECT col1, col2 INTO rec FROM table;

-- %TYPE: Single column, type-safe
cust_email customer.email%TYPE;

-- %ROWTYPE: Entire row, type-safe
cust_row customer%ROWTYPE;
SELECT * INTO cust_row FROM customer WHERE id = 1;
```

---

## NULL Handling Rules

```sql
-- ❌ WRONG: NULL breaks comparison
IF total > 100 THEN  -- If total is NULL, this is NULL (not FALSE)

-- ✅ RIGHT: Use COALESCE
IF COALESCE(total, 0) > 100 THEN

-- ✅ RIGHT: Check explicitly
IF total IS NOT NULL AND total > 100 THEN

-- ✅ RIGHT: Use in SELECT
SELECT COALESCE(SUM(amount), 0) INTO total
FROM payment WHERE customer_id = 999;
```

---

## Useful Functions

```sql
-- Current date/time
NOW()               -- Current timestamp
CURRENT_DATE        -- Current date
CURRENT_TIME        -- Current time

-- String operations
first_name || ' ' || last_name    -- Concatenation
UPPER(text_value)                  -- To uppercase
LOWER(text_value)                  -- To lowercase
LENGTH(text_value)                 -- String length

-- NULL handling
COALESCE(value, default)           -- Replace NULL
NULLIF(value1, value2)             -- Return NULL if equal

-- Type casting
value::INTEGER                     -- Cast to integer
CAST(value AS TEXT)                -- Cast to text
TO_CHAR(date, 'YYYY-MM-DD')       -- Format date
```

---

## When to Use PL/pgSQL vs Plain SQL

| Task | Use SQL | Use PL/pgSQL |
|------|---------|--------------|
| Simple SELECT | ✅ | ❌ |
| Single UPDATE/INSERT | ✅ | ❌ |
| Conditional logic | ❌ | ✅ |
| Loops | ❌ | ✅ |
| Multi-step operations | ❌ | ✅ |
| Error handling | ❌ | ✅ |
| Complex calculations | ❌ | ✅ |

**Rule of thumb:** Start with SQL. Use PL/pgSQL when SQL gets complicated.

---

## Practice Template

```sql
DO $$
DECLARE
    -- Declare your variables here
    
BEGIN
    -- Your main code here
    
EXCEPTION
    -- Handle errors here
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END $$;
```

---

**Remember:** The best way to learn is by doing! Try modifying examples and see what happens.

**Resources:**
- PostgreSQL Documentation: https://www.postgresql.org/docs/current/plpgsql.html
- Practice with Pagila database
- Ask questions when stuck!

---

*Print this reference and keep it handy while coding!*
