-- ============================================================================
-- POSTGRESQL TRIGGERS DEMO 
-- Database: Pagila (DVD Rental sample database)
-- ============================================================================

-- ============================================================================
-- PREREQUISITES
-- ============================================================================
-- Before starting this demo, ensure you have:
--
-- 1. PostgreSQL 15 (matching the course devcontainer/Docker setup)
-- 2. Pagila sample database loaded and available
-- 3. Connected to the 'pagila' database
-- 4. Basic PL/pgSQL knowledge (helpful but not required)
--
-- NOTE: Later sections rely on modern features such as INSERT ... ON CONFLICT and event triggers,
--       so running against older PostgreSQL releases will fail.
--
-- Verify you're connected to the correct database:
SELECT current_database(), version();

-- Expected: current_database should show 'pagila'
--
-- LEARNING OBJECTIVES:
-- After completing this demo, you will be able to:
-- 1. Understand what triggers are and when to use them
-- 2. Create BEFORE and AFTER triggers
-- 3. Work with NEW and OLD variables
-- 4. Implement audit trails and data validation
-- 5. Understand row-level vs statement-level triggers
-- 6. Handle trigger timing and events correctly
-- ============================================================================


-- ============================================================================
-- WHAT ARE TRIGGERS?
-- ============================================================================
-- Triggers are automatic actions that fire when data changes in your database.
-- Think of them as "database robots" that watch for events and respond.
--
-- KEY CONCEPT: Triggers = Automatic actions when data changes!
--
-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                        TRIGGER CONCEPT                           │
-- ├─────────────────────────────────────────────────────────────────────────┤
-- │                                                                         │
-- │  You write SQL:                                                         │
-- │  ┌──────────────────────────────────────────────────┐                  │
-- │  │ UPDATE customer SET email = 'new@email.com'  │                      │
-- │  │ WHERE customer_id = 5;                       │                      │
-- │  └──────────────────┬───────────────────────────────┘                  │
-- │                     │                                                   │
-- │                     ↓                                                   │
-- │  ┌─────────────────────────────────────────────────────────────────┐   │
-- │  │  Trigger Watches and Automatically Responds!            │           │
-- │  ├─────────────────────────────────────────────────────────────────┤   │
-- │  │  • Validates the new email format                        │           │
-- │  │  • Logs the change to audit table                       │           │
-- │  │  • Sends notification                                   │           │
-- │  │  • Updates related records                              │           │
-- │  └─────────────────────────────────────────────────────────────────┘   │
-- │                                                                         │
-- │  Result: Multiple automatic actions from ONE SQL statement!            │
-- │                                                                         │
-- └─────────────────────────────────────────────────────────────────────────┘
-- ============================================================================


-- ============================================================================
-- TRIGGER BASICS: THE TWO-STEP PROCESS
-- ============================================================================
-- Creating a trigger ALWAYS requires 2 steps:
--
-- STEP 1: Create a FUNCTION (what to do, or what will be executed)
-- STEP 2: Create a TRIGGER (when to do it)
--
-- Think of it like:
-- - FUNCTION = The recipe (instructions)
-- - TRIGGER = The timer (when to execute)
--
-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                    THE TWO-STEP TRIGGER RECIPE                          │
-- ├─────────────────────────────────────────────────────────────────────────┤
-- │                                                                         │
-- │  STEP 1: Create the FUNCTION (What to do)                               │
-- │  ┌────────────────────────────────────────────────────────┐             │
-- │  │ CREATE FUNCTION log_changes()                          │             │
-- │  │ RETURNS TRIGGER AS $$                                  │             │
-- │  │ BEGIN                                                  │             │
-- │  │     INSERT INTO audit_log VALUES (NEW.id, NOW());     │             │
-- │  │     RETURN NEW;                                        │             │
-- │  │ END;                                                   │             │
-- │  │ $$ LANGUAGE plpgsql;                                   │             │
-- │  └────────────────────────────────────────────────────────┘             │
-- │                           │                                             │
-- │                           │ Function sits and waits...                  │
-- │                           ↓                                             │
-- │  STEP 2: Create the TRIGGER (When to do it)                             │
-- │  ┌────────────────────────────────────────────────────────┐             │
-- │  │ CREATE TRIGGER audit_trigger                           │             │
-- │  │     AFTER INSERT ON customer                           │             │
-- │  │     FOR EACH ROW                                       │             │
-- │  │     EXECUTE FUNCTION log_changes();                    │             │
-- │  └────────────────────────────────────────────────────────┘             │
-- │                           │                                             │
-- │                           │ Now it's active!                            │
-- │                           ↓                                             │
-- │  ┌────────────────────────────────────────────────────────┐             │
-- │  │ When someone inserts into customer table...            │             │
-- │  │ → log_changes() function executes automatically!       │             │
-- │  └────────────────────────────────────────────────────────┘             │
-- │                                                                         │
-- └─────────────────────────────────────────────────────────────────────────┘
-- ============================================================================


-- ============================================================================
-- TRIGGER SYNTAX EXPLAINED
-- ============================================================================
--
-- PART 1: THE FUNCTION (What to do)
-- ┌────────────────────────────────────────────────────────────────────────┐
-- │ CREATE OR REPLACE FUNCTION function_name()                             │
-- │ RETURNS TRIGGER AS $$                ← Must return TRIGGER type        │
-- │ BEGIN                                                                  │
-- │     -- Your code here                                                  │
-- │     -- Use NEW to access new row data                                  │
-- │     -- Use OLD to access old row data                                  │
-- │     RETURN NEW;                      ← REQUIRED! (or OLD, or NULL)     │
-- │ END;                                                                   │
-- │ $$ LANGUAGE plpgsql;                                                   │
-- └────────────────────────────────────────────────────────────────────────┘
--
-- PART 2: THE TRIGGER (When to do it)
-- ┌────────────────────────────────────────────────────────────────────────┐
-- │ CREATE TRIGGER trigger_name                                            │
-- │     BEFORE/AFTER                     ← Timing: before or after?        │
-- │     INSERT/UPDATE/DELETE             ← Event: what operation?          │
-- │     ON table_name                    ← Which table to watch?           │
-- │     FOR EACH ROW                     ← Run for every affected row      │
-- │     EXECUTE FUNCTION function_name();← Call your function              │
-- └────────────────────────────────────────────────────────────────────────┘
--
-- KEY ELEMENTS EXPLAINED:
--
-- TIMING:
--   BEFORE  → Runs before the data changes (can modify or cancel)
--   AFTER   → Runs after the data changes (for logging/updates)
--
-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                    TRIGGER TIMING EXPLAINED                             │
-- ├─────────────────────────────────────────────────────────────────────────┤
-- │                                                                         │
-- │  BEFORE TRIGGER:                                                        │
-- │  ════════════════                                                       │
-- │                                                                         │
-- │  Your SQL: UPDATE customer SET email = 'bad email'                      │
-- │      │                                                                  │
-- │      ↓                                                                  │
-- │  ┌──────────────────────────┐                                          │
-- │  │  BEFORE TRIGGER fires    │                                          │
-- │  │  • Can see NEW values    │                                          │
-- │  │  • Can MODIFY NEW values │                                          │
-- │  │  • Can CANCEL operation  │                                          │
-- │  └──────────┬───────────────┘                                          │
-- │             │                                                           │
-- │             ↓                                                           │
-- │  ┌──────────────────────────┐                                          │
-- │  │  Database saves data     │                                          │
-- │  │  (if not cancelled)      │                                          │
-- │  └──────────────────────────┘                                          │
-- │                                                                         │
-- │  Use BEFORE for: Validation, Data cleanup, Preventing bad data         │
-- │                                                                         │
-- │  ─────────────────────────────────────────────────────────────────     │
-- │                                                                         │
-- │  AFTER TRIGGER:                                                         │
-- │  ═══════════════                                                        │
-- │                                                                         │
-- │  Your SQL: UPDATE customer SET email = 'new@email.com'                 │
-- │      │                                                                  │
-- │      ↓                                                                  │
-- │  ┌──────────────────────────┐                                          │
-- │  │  Database saves data     │                                          │
-- │  └──────────┬───────────────┘                                          │
-- │             │                                                          │
-- │             ↓                                                          │
-- │  ┌──────────────────────────┐                                          │
-- │  │  AFTER TRIGGER fires     │                                          │
-- │  │  • Data already saved    │                                          │
-- │  │  • CANNOT modify data    │                                          │
-- │  │  • CANNOT cancel         │                                          │
-- │  └──────────────────────────┘                                          │
-- │                                                                        │
-- │  Use AFTER for: Audit logs, Update related tables, Notifications       │
-- │                                                                         │
-- └─────────────────────────────────────────────────────────────────────────┘
--
-- EVENTS:
--   INSERT  → When new rows are added
--   UPDATE  → When rows are modified
--   DELETE  → When rows are removed
--   Can combine: INSERT OR UPDATE OR DELETE
--
-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                    TRIGGER EVENTS EXPLAINED                             │
-- ├─────────────────────────────────────────────────────────────────────────┤
-- │                                                                         │
-- │  INSERT Event:                                                          │
-- │  ────────────                                                           │
-- │  INSERT INTO customer (name, email) VALUES ('John', 'j@test.com');     │
-- │                           ↓                                             │
-- │              ┌────────────────────────┐                                 │
-- │              │  INSERT TRIGGER fires  │                                 │
-- │              │  • NEW exists (new row)│                                 │
-- │              │  • OLD doesn't exist   │                                 │
-- │              └────────────────────────┘                                 │
-- │                                                                         │
-- │  UPDATE Event:                                                          │
-- │  ────────────                                                           │
-- │  UPDATE customer SET email = 'new@test.com' WHERE id = 5;              │
-- │         
---  NEW.salary 6000    OLD.salary 5000
                  ↓                                             │
-- │              ┌────────────────────────┐                                 │
-- │              │  UPDATE TRIGGER fires                    │                                 │
-- │              │  • NEW exists (new row)  'new@test.com'  │                                 │
-- │              │  • OLD exists (old row) 'j@test.com'│                                 │
-- │              └────────────────────────      ┘                                 │
-- │                                                                         │
-- │  DELETE Event:                                                          │
-- │  ────────────                                                           │
-- │  DELETE FROM customer WHERE id = 5;                                     │
-- │                           ↓                                             │
-- │              ┌────────────────────────┐                                 │
-- │              │  DELETE TRIGGER fires  │                                 │
-- │              │  • NEW doesn't exist   │                                 │
-- │              │  • OLD exists (old row)│                                 │
-- │              └────────────────────────┘                                 │
-- │                                                                         │
-- └─────────────────────────────────────────────────────────────────────────┘
--
-- SPECIAL VARIABLES (available inside function):
--   NEW     → The new row data (INSERT, UPDATE)
--   OLD     → The original row data (UPDATE, DELETE)
--   TG_OP   → Operation type: 'INSERT', 'UPDATE', or 'DELETE'
--
-- RETURN VALUES:
--   RETURN NEW;   → Proceed with the new data (most common)
--   RETURN OLD;   → Use original data (mainly for DELETE)
--   RETURN NULL;  → Cancel the operation (BEFORE triggers only)
-- ============================================================================


-- ============================================================================
-- COMMON  PITFALLS 
-- ============================================================================
--
-- ❌ PITFALL #1: Forgetting RETURN
--    CREATE FUNCTION my_trigger() RETURNS TRIGGER AS $$
--    BEGIN
--        INSERT INTO log VALUES (NEW.id);
--        -- ERROR: Missing RETURN!
--    END; $$ LANGUAGE plpgsql;
--    ✅ Fix: Always add RETURN NEW; (or OLD, or NULL)
--
-- ❌ PITFALL #2: Using NEW in DELETE triggers
--    DELETE trigger can only access OLD, not NEW
--    ✅ Fix: Use OLD for DELETE, NEW for INSERT, both for UPDATE
--
-- ❌ PITFALL #3: Creating infinite loops
--    CREATE FUNCTION bad_trigger() RETURNS TRIGGER AS $$
--    BEGIN
--        UPDATE customer SET updated = NOW() WHERE id = NEW.id;  -- Triggers itself!
--        RETURN NEW;
--    END; $$ LANGUAGE plpgsql;
--    ✅ Fix: Modify NEW directly: NEW.updated := NOW(); RETURN NEW;
--
-- ❌ PITFALL #4: Running examples out of order
--    Some examples depend on tables created in earlier examples
--    ✅ Fix: Run examples in order, or check table existence first
--
-- ❌ PITFALL #5: Not using transactions for testing
--    Without BEGIN/ROLLBACK, test data stays in database
--    ✅ Fix: Always wrap tests in BEGIN; ... ROLLBACK;
--
-- ============================================================================


-- A STATEMENT level trigger is a trigger that fires once per SQL statement, 
-- rather than once per row.


-- ============================================================================
-- EXAMPLE 1: STATEMENT-LEVEL TRIGGER - WORKING HOURS VALIDATION
-- ============================================================================
-- DESCRIPTION:
--   Allows customer updates ONLY during business hours (9 AM - 5 PM)
--
-- TRIGGER NATURE:
--   - Type: STATEMENT-LEVEL (FOR EACH STATEMENT)
--   - Timing: BEFORE UPDATE
--   - Event: UPDATE operation on customer table
--
-- WHEN IT FIRES:
--   - Fires ONCE per UPDATE statement (not per row)
--   - Executes BEFORE any rows are updated
--   - Checks system time against business hours
--
-- BEHAVIOR:
--   - If time is before 9 AM or after 5 PM: RAISES EXCEPTION (blocks update)
--   - If time is between 9 AM and 5 PM: Allows update to proceed
--   - Returns NULL (standard for statement-level triggers)
--
-- USE CASE:
--   Enforce business rules at statement level without processing each row
-- ============================================================================



--  before starting the trigger function
SELECT c.relname, tg.tgname,
       pg_get_triggerdef(tg.oid) AS definition
FROM pg_trigger tg
JOIN pg_class c ON tg.tgrelid = c.oid
WHERE c.relname = 'customer'
  AND NOT tg.tgisinternal;


drop TRIGGER IF EXISTS allow_customer_updates_work_hours ON customer;
DROP TRIGGER IF EXISTS audit_customer_email ON customer;
DROP TRIGGER IF EXISTS block_customer_updates_work_hours ON customer;
DROP TRIGGER IF EXISTS allow_customer_updates_work_hours ON customer;

-- Step 1: Create the trigger function
-- This function will check if the current time is within working hours (9 AM - 5 PM)

CREATE OR REPLACE FUNCTION allow_customer_updates_only_work_hours()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    current_hour INTEGER;
BEGIN
    -- Get current hour (0-23)
    current_hour := EXTRACT(HOUR FROM CURRENT_TIMESTAMP);
    
    -- Check if it's OUTSIDE working hours (before 9 AM or after 5 PM)
    -- Block updates outside 9 AM - 5 PM range
    IF current_hour < 9 OR current_hour >= 17 THEN
        RAISE EXCEPTION 'Customer updates are only allowed during working hours (9 AM - 5 PM). Current time: %', 
            TO_CHAR(CURRENT_TIMESTAMP, 'HH24:MI:SS')
        USING HINT = 'Please perform customer updates during business hours (9 AM - 5 PM).';
    END IF;
    
    -- If we reach here, it's during working hours (9 AM - 5 PM) - allow the operation
    RETURN NULL;  -- For statement-level triggers, return NULL
END;
$$;

-- Step 2: Create the statement-level trigger (drop first so script is rerunnable)
-- DROP TRIGGER IF EXISTS allow_customer_updates_work_hours ON customer;
CREATE TRIGGER allow_customer_updates_work_hours
    BEFORE UPDATE ON customer
    FOR EACH STATEMENT  -- STATEMENT-LEVEL trigger like update delete insert
    EXECUTE FUNCTION allow_customer_updates_only_work_hours();


-- Test it:
-- This will work if run between 9 AM and 5 PM:

-- display current time
SELECT TO_CHAR(CURRENT_TIMESTAMP, 'HH24:MI:SS') AS current_time;

-- look at email value before update
SELECT email FROM customer WHERE customer_id = 1;

-- Test DURING working hours (9 AM - 5 PM) - SHOULD SUCCEED
BEGIN;
    UPDATE customer SET email = 'MARY@example.com' WHERE customer_id = 1;
    -- SUCCESS: Update allowed during working hours (9 AM - 5 PM)
    SELECT 'Update succeeded during working hours!' AS result;
ROLLBACK;

-- Test OUTSIDE working hours (before 9 AM or after 5 PM) - SHOULD FAIL
-- Run PowerShell as Administrator to change system time:
--   Set-Date -Date "2025-11-20 18:00:00"  # Set to 6 PM
--   # Run your test, then reset to current time for example: 2h30 pm
BEGIN;
    UPDATE customer SET email = 'updated@example.com' WHERE customer_id = 1;
    -- ERROR: Customer updates are NOT allowed outside working hours!
    -- Expected result: EXCEPTION with message blocking the update
ROLLBACK;



-- Check if trigger exists:
SELECT 
    trigger_name,
    event_manipulation,   -- INSERT, UPDATE, DELETE
    action_timing,        -- BEFORE, AFTER
    action_orientation    -- ROW, STATEMENT
FROM information_schema.triggers
WHERE trigger_name = 'allow_customer_updates_work_hours';


-- ===========================================================================
-- Return Values in PostgreSQL
-- ===========================================================================
--
-- RETURN VALUES IN POSTGRESQL:
-- - RETURN NEW;  -> Proceed with the new row (most common)
-- - RETURN OLD;  -> Use for DELETE triggers
-- - RETURN NULL; -> Skip the operation (BEFORE triggers only)
--
-- OPERATION DETECTION:
-- PostgreSQL:  IF TG_OP = 'INSERT' THEN ... ELSIF TG_OP = 'UPDATE' ...
-- Oracle:      IF INSERTING THEN ... ELSIF UPDATING THEN ...
--


-- ============================================================================
-- STATEMENT-LEVEL vs ROW-LEVEL TRIGGERS
-- ============================================================================
--

--
-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                 STATEMENT-LEVEL TRIGGER (FOR EACH STATEMENT)            │
-- ├─────────────────────────────────────────────────────────────────────────┤
-- │                                                                         │
-- │  SQL Statement: UPDATE customer SET active = 0 WHERE store_id = 1;     │
-- │   FOR EACH STATEMENT  -- STATEMENT-LEVEL trigger like update delete insert
                                                           │
-- │  ┌─────────┐                                                            │
-- │  │ Row 1   │                                                            │
-- │  └─────────┘                                                            │
-- │  ┌─────────┐                                                            │
-- │  │ Row 2   │                                                            │
-- │  └─────────┘    ┌──────────────────────────────────┐                   │
-- │  ┌─────────┐    │                                  │                   │
-- │  │ Row 3   │───▶│  Trigger fires ONCE for all rows │                   │
-- │  └─────────┘    │                                  │                   │
-- │  ┌─────────┐    └──────────────────────────────────┘                   │
-- │  │ Row 4   │                                                            │
-- │  └─────────┘                                                            │
-- │  ┌─────────┐                                                            │
-- │  │ Row 5   │                                                            │
-- │  └─────────┘                                                            │
-- │                                                                         │
-- │  Result: Trigger executed 1 time (once for entire statement)           │
-- │  Access to: NO access to NEW/OLD (statement-level context only)        │
-- │                                                                         │
-- └─────────────────────────────────────────────────────────────────────────┘
--
-- SCENARIO: UPDATE customer SET active = 0 WHERE store_id = 1;
--          (This affects 5 customers)
--
-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │                    ROW-LEVEL TRIGGER (FOR EACH ROW)                     │
-- ├─────────────────────────────────────────────────────────────────────────┤
-- │                                                                         │
-- │  SQL Statement: UPDATE customer SET active = 0 WHERE store_id = 1;     │
-- │         FOR EACH ROW  -- ROW-LEVEL trigger like update delete insert     │
-- │  ┌─────────┐    ┌──────────────┐                                       │
-- │  │ Row 1   │───▶│ Trigger fires│                                       │
-- │  └─────────┘    └──────────────┘                                       │
-- │                                                                         │
-- │  ┌─────────┐    ┌──────────────┐                                       │
-- │  │ Row 2   │───▶│ Trigger fires│                                       │
-- │  └─────────┘    └──────────────┘                                       │
-- │                                                                         │
-- │  ┌─────────┐    ┌──────────────┐                                       │
-- │  │ Row 3   │───▶│ Trigger fires│                                       │
-- │  └─────────┘    └──────────────┘                                       │
-- │                                                                         │
-- │  ┌─────────┐    ┌──────────────┐                                       │
-- │  │ Row 4   │───▶│ Trigger fires│                                       │
-- │  └─────────┘    └──────────────┘                                       │
-- │                                                                         │
-- │  ┌─────────┐    ┌──────────────┐                                       │
-- │  │ Row 5   │───▶│ Trigger fires│                                       │
-- │  └─────────┘    └──────────────┘                                       │
-- │                                                                         │
-- │  Result: Trigger executed 5 times (once per row)                       │
-- │  Access to: NEW and OLD row data for each row  
     -- we have access to the context of the row being modified  
     -- Old provide details about the previous state of the row
     -- New provide details about the new state of the row
-- │                                                                         │
-- └─────────────────────────────────────────────────────────────────────────┘
--
-- KEY DIFFERENCES:
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Aspect              │ ROW-LEVEL              │ STATEMENT-LEVEL
-- ────────────────────┼────────────────────────┼─────────────────────────
-- Execution count     │ Once per affected row  │ Once per SQL statement
-- Access to row data  │ YES (NEW/OLD)          │ NO (NEW/OLD not available)
-- Performance (bulk)  │ Slower (many rows)     │ Faster (one execution)
-- Use case            │ Row-specific logic     │ Bulk operation logging
-- Return value        │ NEW/OLD/NULL           │ Usually NULL
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--
-- ============================================================================




-- ============================================================================
-- POSTGRESQL vs ORACLE TRIGGERS
-- ============================================================================
--
-- ┌────────────────────────────────────────────────────────────────────────┐
-- │ POSTGRESQL TRIGGER STRUCTURE                                           │
-- ├────────────────────────────────────────────────────────────────────────┤
-- │                                                                        │
-- │ CREATE OR REPLACE FUNCTION my_function()                               │
-- │ RETURNS TRIGGER AS $$                                                  │
-- │ BEGIN                                                                  │
-- │     -- Your logic here                                                 │
-- │     RETURN NEW;  -- ⚠️ REQUIRED!                                       │
-- │ END;                                                                   │
-- │ $$ LANGUAGE plpgsql;                                                   │
-- │                                                                        │
-- │ CREATE TRIGGER my_trigger                                              │
-- │     BEFORE/AFTER INSERT OR UPDATE OR DELETE ON table_name              │
-- │     FOR EACH ROW                                                       │
-- │     EXECUTE FUNCTION my_function();                                    │
-- │                                                                        │
-- └────────────────────────────────────────────────────────────────────────┘
--
-- ┌────────────────────────────────────────────────────────────────────────┐
-- │ ORACLE TRIGGER STRUCTURE                                               │
-- ├────────────────────────────────────────────────────────────────────────┤
-- │                                                                        │
-- │ CREATE OR REPLACE TRIGGER my_trigger                                   │
-- │     BEFORE/AFTER INSERT OR UPDATE OR DELETE ON table_name              │
-- │     FOR EACH ROW                                                       │
-- │ BEGIN                                                                  │
-- │     -- Your logic here                                                 │
-- │     -- NO RETURN statement needed                                      │
-- │ END;                                                                   │
-- │                                                                        │
-- └────────────────────────────────────────────────────────────────────────┘
--
-- KEY SYNTAX DIFFERENCES:
-- ┌─────────────────────────┬──────────────────┬──────────────────────────┐
-- │ Feature                 │ PostgreSQL       │ Oracle                   │
-- ├─────────────────────────┼──────────────────┼──────────────────────────┤
-- │ Structure               │ Function + Trig  │ Single block             │
-- │ Return statement        │ Required         │ Not allowed              │
-- │ OLD/NEW reference       │ OLD.column       │ :OLD.column              │
-- │ Check operation type    │ TG_OP            │ INSERTING/UPDATING       │
-- │ Language declaration    │ LANGUAGE plpgsql │ Implicit (PL/SQL)        │
-- │ Function execution      │ EXECUTE FUNCTION │ N/A                      │
-- │ Raise exception         │ RAISE EXCEPTION  │ RAISE_APPLICATION_ERROR  │
-- │ Current timestamp       │ CURRENT_TIMESTAMP│ SYSDATE                  │
-- │ Current user            │ CURRENT_USER     │ USER                     │
-- │ Conditional (WHEN)      │ WHEN (condition) │ WHEN condition           │
-- └─────────────────────────┴──────────────────┴──────────────────────────┘

-- ============================================================================



-- ============================================================================
-- EXAMPLE 2: ROW-LEVEL BEFORE TRIGGER - AUTOMATIC DATA CLEANUP
-- ============================================================================
-- DESCRIPTION:
--   Automatically cleans and normalizes customer data before saving to database
--
-- TRIGGER NATURE:
--   - Type: ROW-LEVEL (FOR EACH ROW)
--   - Timing: BEFORE INSERT OR UPDATE
--   - Event: INSERT or UPDATE operations on customer table
--
-- WHEN IT FIRES:
--   - Fires BEFORE each row is inserted or updated
--   - Executes once for each affected row
--   - Has access to NEW row data (can modify it)
--
-- BEHAVIOR:
--   - Trims whitespace from first_name and last_name
--   - Converts email to lowercase
--   - Capitalizes first letter of names (INITCAP)
--   - Returns modified NEW data
--
-- USE CASE:
--   Ensure data consistency and cleanliness without application-level validation
-- ============================================================================

-- Goal: Automatically clean up customer data before saving

CREATE OR REPLACE FUNCTION cleanup_customer_data()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Trim whitespace from names
    NEW.first_name := TRIM(NEW.first_name);  -- trim built-in SQL function removes leading and trailing spaces
    NEW.last_name := TRIM(NEW.last_name);
    
    -- Convert email to lowercase
    NEW.email := LOWER(TRIM(NEW.email));
    
    -- Capitalize first letter of names
    NEW.first_name := INITCAP(NEW.first_name);  -- INITCAP capitalizes the first letter of each word 
    NEW.last_name := INITCAP(NEW.last_name);
    
    RETURN NEW;
END $$;

CREATE TRIGGER clean_customer_data
    BEFORE INSERT OR UPDATE ON customer
    FOR EACH ROW       -- This is very important to ensure each row is cleaned
    EXECUTE FUNCTION cleanup_customer_data();

-- Test it:
-- BEGIN;
    -- Insert messy data
    INSERT INTO customer (store_id, first_name, last_name, email, address_id)
    VALUES (1, '  JOHN  ', 'DOE  ', '  JOHN.DOE@EMAIL.COM  ', 1);
    
    -- Check what was actually saved - all cleaned up!
    SELECT first_name, last_name, email 
    FROM customer 
    WHERE email = 'john.doe@email.com';

--ROLLBACK;




-- ============================================================================
-- EXAMPLE 3: ROW-LEVEL BEFORE TRIGGER - DATA VALIDATION
-- ============================================================================
-- DESCRIPTION:
--   Validates rental rates to ensure they fall within acceptable range
--
-- TRIGGER NATURE:
--   - Type: ROW-LEVEL (FOR EACH ROW)
--   - Timing: BEFORE INSERT OR UPDATE
--   - Event: INSERT or UPDATE operations on film table
--
-- WHEN IT FIRES:
--   - Fires BEFORE each row is inserted or updated
--   - Executes once per affected row
--   - Has access to NEW row data for validation
--
-- BEHAVIOR:
--   - Checks if rental_rate is NULL, negative, too low (<$0.50), or too high (>$10.00)
--   - If validation fails: RAISES EXCEPTION (prevents the operation)
--   - If validation passes: Returns NEW (allows operation to proceed)
--
-- USE CASE:
--   Enforce business rules at database level to prevent invalid data entry
-- ============================================================================

-- Goal: Make sure rental rates are reasonable (between $0.50 and $10.00)

-- Step 1: Create validation function
CREATE OR REPLACE FUNCTION validate_rental_rate()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Check if rental rate is NULL
    IF NEW.rental_rate IS NULL THEN
        RAISE EXCEPTION 'Rental rate cannot be NULL';
    END IF;
    
    -- Check if rental rate is negative
    IF NEW.rental_rate < 0 THEN
        RAISE EXCEPTION 'Rental rate cannot be negative: %', NEW.rental_rate;
    END IF;
    
    -- Check if rental rate is too low
    IF NEW.rental_rate < 0.50 THEN
        RAISE EXCEPTION 'Rental rate too low (minimum $0.50): %', NEW.rental_rate;
    END IF;
    
    -- Check if rental rate is too high
    IF NEW.rental_rate > 10.00 THEN
        RAISE EXCEPTION 'Rental rate too high (maximum $10.00): %', NEW.rental_rate;
    END IF;
    
    RETURN NEW;
END $$;

-- Step 2: Create the trigger (BEFORE so we stop bad data)
CREATE TRIGGER check_rental_rate
    BEFORE INSERT OR UPDATE ON film
    FOR EACH ROW
    EXECUTE FUNCTION validate_rental_rate();

-- Test with valid data:
BEGIN;
    UPDATE film SET rental_rate = 2.99 WHERE film_id = 2;
    -- Should work fine
ROLLBACK;

-- Test with invalid data:
BEGIN;
    UPDATE film SET rental_rate = -5.00 WHERE film_id = 2;
    -- ERROR: Rental rate cannot be negative!
ROLLBACK;

BEGIN;
    UPDATE film SET rental_rate = 15.00 WHERE film_id = 2;
    -- ERROR: Rental rate too high!
ROLLBACK;




-- ============================================================================
-- EXAMPLE 4: ROW-LEVEL AFTER TRIGGER - AUDIT LOGGING
-- ============================================================================
-- DESCRIPTION:
--   Creates an audit trail by logging every customer email change
--
-- TRIGGER NATURE:
--   - Type: ROW-LEVEL (FOR EACH ROW)
--   - Timing: AFTER UPDATE
--   - Event: UPDATE of email column on customer table
--
-- WHEN IT FIRES:
--   - Fires AFTER each row's email is updated
--   - Only fires when email column specifically changes
--   - Executes once per affected row
--   - Has access to both OLD and NEW row data
--
-- BEHAVIOR:
--   - Captures OLD email value (before update)
--   - Captures NEW email value (after update)
--   - Inserts audit record with customer_id, old/new emails, and timestamp
--   - Returns NEW (standard for AFTER triggers)
--
-- USE CASE:
--   Maintain complete history of email changes for compliance and tracking
-- ============================================================================
-- Goal: Log every time a customer's email changes (audit trail)

-- Step 1: Create audit table
CREATE TABLE IF NOT EXISTS customer_audit_log (
    audit_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    old_email VARCHAR(255),
    new_email VARCHAR(255),
    changed_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 2: Create the trigger function
CREATE OR REPLACE FUNCTION log_email_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert old email into audit log
    INSERT INTO customer_audit_log (customer_id, old_email, new_email, changed_on)
    VALUES (OLD.customer_id, OLD.email, NEW.email, NOW());
    
    RETURN NEW;  -- ⚠️ MUST return NEW for AFTER UPDATE trigger
END $$;

-- Step 3: Create the trigger
CREATE TRIGGER audit_customer_email
    AFTER UPDATE OF email ON customer  -- Only fires when email changes
    FOR EACH ROW
    EXECUTE FUNCTION log_email_change();


-- ============================================================================ 
-- UNDERSTANDING NEW AND OLD
-- ============================================================================
-- UNDERSTANDING NEW AND OLD
-- ============================================================================
-- Triggers have access to special variables:
-- - NEW = The new data being inserted or updated
-- - OLD = The original data before update or deletion
--
-- Availability by operation:
-- INSERT: Only NEW exists (no previous data)
-- UPDATE: Both NEW and OLD exist
-- DELETE: Only OLD exists (no new data)
--

-- ============================================================================


--  Test it:

-- check the audit log before change
SELECT * FROM customer_audit_log ORDER BY changed_on DESC LIMIT 1;


BEGIN;
    UPDATE customer SET email = 'newemail@example.com' WHERE customer_id = 1;
    SELECT * FROM customer_audit_log ORDER BY changed_on DESC LIMIT 1;
ROLLBACK;


-- to validate the trigger exiists
SELECT * FROM pg_trigger WHERE tgname = 'audit_customer_email';



-- lets test it again with am update that affects several rows
-- Test the trigger with multiple row updates
BEGIN;
    -- Check audit log before
    SELECT COUNT(*) as count_before FROM customer_audit_log;
    
    -- Update multiple customers at once
    UPDATE customer 
    SET email = CONCAT('updated_', customer_id, '@example.com')
    WHERE customer_id IN (1, 2, 3, 4, 5);
    
    -- Check audit log after - should show 5 new entries (one per row)
    SELECT 
        audit_id,
        customer_id,
        old_email,
        new_email,
        changed_on
    FROM customer_audit_log 
    ORDER BY changed_on DESC 
    LIMIT 5;
    
    -- Verify the count increased by 5
    SELECT COUNT(*) as count_after FROM customer_audit_log;
    
ROLLBACK;


-- ============================================================================
-- EXAMPLE 4B: DDL TRIGGER - LOGGING TABLE CHANGES
-- ============================================================================
-- Goal: Track when tables are created, altered, or dropped
-- Note: Requires superuser privileges

-- Create log table
CREATE TABLE IF NOT EXISTS ddl_change_log (
    log_id SERIAL PRIMARY KEY,
    command_type TEXT,        -- CREATE TABLE, ALTER TABLE, DROP TABLE
    table_name TEXT,
    performed_by VARCHAR(100),
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create event trigger function
CREATE OR REPLACE FUNCTION log_table_changes()
RETURNS event_trigger
LANGUAGE plpgsql
AS $$
DECLARE
    obj record;
BEGIN
    FOR obj IN SELECT * FROM pg_event_trigger_ddl_commands()
    LOOP
        INSERT INTO ddl_change_log (command_type, table_name, performed_by)
        VALUES (obj.command_tag, obj.object_identity, CURRENT_USER);
    END LOOP;
END $$;

-- Create the event trigger (requires superuser)
-- Uncomment if you have superuser access:
/*
CREATE EVENT TRIGGER track_table_changes
    ON ddl_command_end
    EXECUTE FUNCTION log_table_changes();
*/


-- ============================================================================
-- EXAMPLE 4C: CASCADING TRIGGERS - ONE TRIGGER FIRES ANOTHER
-- ============================================================================
-- Goal: Show how one trigger can fire another trigger automatically

-- Create simple order tracking tables
CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    status VARCHAR(50) DEFAULT 'NEW'
);

CREATE TABLE IF NOT EXISTS order_log (
    log_id SERIAL PRIMARY KEY,
    order_id INTEGER,
    status VARCHAR(50),
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS order_stats (
    stat_id SERIAL PRIMARY KEY,
    total_orders INTEGER DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Initialize stats
INSERT INTO order_stats (stat_id) VALUES (1) ON CONFLICT DO NOTHING;

-- TRIGGER 1: When order status changes, log it
CREATE OR REPLACE FUNCTION log_order_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO order_log (order_id, status)
    VALUES (NEW.order_id, NEW.status);
    
    RETURN NEW;
END $$;

CREATE TRIGGER track_order_changes
    AFTER INSERT OR UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION log_order_change();

-- TRIGGER 2: When log is updated, update stats (fires automatically!)
CREATE OR REPLACE FUNCTION update_order_stats()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE order_stats
    SET 
        total_orders = (SELECT COUNT(*) FROM orders),
        last_updated = CURRENT_TIMESTAMP
    WHERE stat_id = 1;
    
    RETURN NEW;
END $$;

CREATE TRIGGER maintain_order_stats
    AFTER INSERT ON order_log
    FOR EACH ROW
    EXECUTE FUNCTION update_order_stats();

-- Test the cascading triggers:
BEGIN;
    -- Insert order → Trigger 1 fires → Trigger 2 fires automatically!
    INSERT INTO orders (customer_id, status) VALUES (1, 'NEW');
    
    -- Check results
    SELECT * FROM orders;
    SELECT * FROM order_log;
    SELECT * FROM order_stats;
ROLLBACK;






-- ============================================================================
-- EXAMPLE 5: ROW-LEVEL AFTER TRIGGER - AUTOMATIC CALCULATIONS
-- ============================================================================
-- DESCRIPTION:
--   Automatically maintains count of active rentals for each customer
--
-- TRIGGER NATURE:
--   - Type: ROW-LEVEL (FOR EACH ROW)
--   - Timing: AFTER INSERT OR UPDATE OR DELETE
--   - Event: INSERT, UPDATE, or DELETE operations on rental table
--
-- WHEN IT FIRES:
--   - INSERT: Fires after new rental is created (increments count)
--   - UPDATE: Fires after rental is updated (decrements if returned)
--   - DELETE: Fires after rental is deleted (decrements if was active)
--   - Uses TG_OP to determine which operation triggered it
--
-- BEHAVIOR:
--   - INSERT: Increases customer's active_rentals count by 1
--   - UPDATE: Decreases count by 1 if return_date changed from NULL to a value
--   - DELETE: Decreases count by 1 if deleted rental was active (return_date NULL)
--   - Updates customer table to maintain accurate count
--
-- USE CASE:
--   Keep denormalized counts in sync without manual application updates
-- ============================================================================

-- Goal: Keep track of how many active rentals each customer has

-- Step 1: Add counter column (if not exists)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'customer' AND column_name = 'active_rentals'
    ) THEN
        ALTER TABLE customer ADD COLUMN active_rentals INTEGER DEFAULT 0;
    END IF;
END $$;

-- Step 2: Create function to maintain count
CREATE OR REPLACE FUNCTION update_active_rental_count()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- New rental - increase count
        UPDATE customer 
        SET active_rentals = active_rentals + 1
        WHERE customer_id = NEW.customer_id;
        RETURN NEW;
        
    ELSIF TG_OP = 'UPDATE' THEN
        -- Check if return_date changed from NULL to a value (rental returned)
        IF OLD.return_date IS NULL AND NEW.return_date IS NOT NULL THEN
            UPDATE customer 
            SET active_rentals = active_rentals - 1
            WHERE customer_id = NEW.customer_id;
        END IF;
        RETURN NEW;
        
    ELSIF TG_OP = 'DELETE' THEN
        -- Rental deleted - decrease count if it was active
        IF OLD.return_date IS NULL THEN
            UPDATE customer 
            SET active_rentals = active_rentals - 1
            WHERE customer_id = OLD.customer_id;
        END IF;
        RETURN OLD;
    END IF;
    
    RETURN NULL;
END $$;

-- Step 3: Create the trigger
CREATE TRIGGER maintain_active_rental_count
    AFTER INSERT OR UPDATE OR DELETE ON rental
    FOR EACH ROW
    EXECUTE FUNCTION update_active_rental_count();

-- Test it:
-- First, initialize counts
UPDATE customer c
SET active_rentals = (
    SELECT COUNT(*)
    FROM rental r
    WHERE r.customer_id = c.customer_id
    AND r.return_date IS NULL
);

-- Check a customer's current count
SELECT customer_id, first_name, last_name, active_rentals 
FROM customer 
WHERE customer_id = 5;

-- Simulate returning a rental
UPDATE rental 
SET return_date = CURRENT_TIMESTAMP 
WHERE rental_id = (
    SELECT rental_id FROM rental 
    WHERE customer_id = 5 AND return_date IS NULL 
    LIMIT 1
);

-- Check count again - it decreased!
SELECT customer_id, first_name, last_name, active_rentals 
FROM customer 
WHERE customer_id = 5;



-- ============================================================================
-- SECTION 5: UNDERSTANDING TG_OP
-- ============================================================================
-- TG_OP is a special variable that tells you what operation triggered the function
-- Values: 'INSERT', 'UPDATE', 'DELETE'
--
-- This allows ONE function to handle multiple operations!
-- ============================================================================


-- ============================================================================
-- SECTION 6: BEFORE vs AFTER TRIGGERS
-- ============================================================================
-- BEFORE triggers:
-- - Run BEFORE the change happens
-- - Can modify NEW data before it's saved
-- - Can prevent the operation (RETURN NULL or RAISE EXCEPTION)
-- - Use for: validation, data cleanup, preventing operations
--
-- AFTER triggers:
-- - Run AFTER the change is committed
-- - Cannot modify the data being changed
-- - Use for: logging, updating related tables, notifications
-- ============================================================================



-- ============================================================================
-- EXAMPLE 6: ROW-LEVEL AFTER TRIGGER - CONDITIONAL LOGIC
-- ============================================================================
-- DESCRIPTION:
--   Generates notifications based on rental return duration
--
-- TRIGGER NATURE:
--   - Type: ROW-LEVEL (FOR EACH ROW)
--   - Timing: AFTER UPDATE
--   - Event: UPDATE operations on rental table
--
-- WHEN IT FIRES:
--   - Fires AFTER a rental's return_date is updated from NULL to a value
--   - Only processes completed rentals (when return_date changes)
--   - Executes once per returned rental
--
-- BEHAVIOR:
--   - Calculates rental duration (return_date - rental_date)
--   - Applies conditional logic based on duration:
--     * ≤3 days: Thank you message
--     * 4-7 days: Normal return message
--     * >7 days: Late return warning
--   - Inserts notification record with appropriate message type
--
-- USE CASE:
--   Automatically categorize and notify based on business rules
-- ============================================================================

-- Goal: Send different messages based on rental duration

CREATE TABLE IF NOT EXISTS rental_notifications (
    notification_id SERIAL PRIMARY KEY,
    rental_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    message TEXT,
    notification_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION check_rental_duration()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    days_rented INTEGER;
    rental_message TEXT;
    msg_type VARCHAR(50);
BEGIN
    -- Only process when rental is returned
    IF OLD.return_date IS NULL AND NEW.return_date IS NOT NULL THEN
        -- Calculate days rented
        days_rented := EXTRACT(DAY FROM NEW.return_date - NEW.rental_date);
        
        -- Determine message based on duration
        IF days_rented <= 3 THEN
            rental_message := 'Thank you for returning on time!';
            msg_type := 'THANK_YOU';
        ELSIF days_rented <= 7 THEN
            rental_message := 'Rental returned. No late fees.';
            msg_type := 'NORMAL';
        ELSE
            rental_message := 'Late return! Late fees may apply.';
            msg_type := 'WARNING';
        END IF;
        
        -- Insert notification
        INSERT INTO rental_notifications (rental_id, customer_id, message, notification_type)
        VALUES (NEW.rental_id, NEW.customer_id, rental_message, msg_type);
    END IF;
    
    RETURN NEW;
END $$;

CREATE TRIGGER rental_return_notification
    AFTER UPDATE ON rental
    FOR EACH ROW
    EXECUTE FUNCTION check_rental_duration();

-- Test it:
BEGIN;
    -- Return a rental
    UPDATE rental 
    SET return_date = rental_date + INTERVAL '10 days'
    WHERE rental_id = 100;
    
    -- Check notifications
    SELECT * FROM rental_notifications WHERE rental_id = 100;
ROLLBACK;


-- ============================================================================
-- SECTION 9: ROW-LEVEL vs STATEMENT-LEVEL TRIGGERS
-- ============================================================================
-- ROW-LEVEL (FOR EACH ROW):
-- - Fires once for EACH row affected
-- - Has access to NEW and OLD
-- - Most common type
-- - Use when you need to process individual rows
--
-- STATEMENT-LEVEL (FOR EACH STATEMENT):
-- - Fires once for the entire SQL statement
-- - Does NOT have access to NEW and OLD
-- - Use for logging bulk operations
-- - Better performance for bulk operations
-- ============================================================================


-- ============================================================================
-- EXAMPLE 7: ROW-LEVEL AFTER TRIGGER - DETAILED PRICE CHANGE LOGGING
-- ============================================================================
-- DESCRIPTION:
--   Logs detailed information about each film price change
--
-- TRIGGER NATURE:
--   - Type: ROW-LEVEL (FOR EACH ROW)
--   - Timing: AFTER UPDATE
--   - Event: UPDATE operations on film table
--
-- WHEN IT FIRES:
--   - Fires AFTER each film row is updated
--   - Only logs when rental_rate actually changes
--   - Executes once per updated film
--
-- BEHAVIOR:
--   - Compares OLD.rental_rate with NEW.rental_rate
--   - Calculates price difference and percentage change
--   - Logs film_id, old price, new price, change amount, and percentage
--   - Returns NEW (standard for AFTER triggers)
--
-- USE CASE:
--   Track pricing history with calculations for analysis
-- ============================================================================

CREATE TABLE IF NOT EXISTS price_change_log (
    log_id SERIAL PRIMARY KEY,
    film_id INTEGER NOT NULL,
    old_price NUMERIC(4,2),
    new_price NUMERIC(4,2),
    price_change NUMERIC(4,2),
    percent_change NUMERIC(5,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Row-level: Log each price change with details
CREATE OR REPLACE FUNCTION log_each_price_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    price_diff NUMERIC(4,2);
    pct_change NUMERIC(5,2);
BEGIN
    IF OLD.rental_rate IS DISTINCT FROM NEW.rental_rate THEN
        price_diff := NEW.rental_rate - OLD.rental_rate;
        
        -- Protect against division by zero
        IF OLD.rental_rate = 0 OR OLD.rental_rate IS NULL THEN
            pct_change := NULL;
        ELSE
            pct_change := (price_diff / OLD.rental_rate) * 100;
        END IF;
        
        INSERT INTO price_change_log (film_id, old_price, new_price, price_change, percent_change)
        VALUES (NEW.film_id, OLD.rental_rate, NEW.rental_rate, price_diff, pct_change);
    END IF;
    
    RETURN NEW;
END $$;

CREATE TRIGGER row_level_price_logger
    AFTER UPDATE ON film
    FOR EACH ROW
    EXECUTE FUNCTION log_each_price_change();

-- Test it:
BEGIN;
    -- Update a small subset of PG films (LIMIT applied inside subquery)
    UPDATE film
    SET rental_rate = rental_rate * 1.1
    WHERE film_id IN (
        SELECT film_id
        FROM film
        WHERE rating = 'PG'
        ORDER BY film_id
        LIMIT 5
    );
    
    -- Check log - one entry per film updated
    SELECT * FROM price_change_log ORDER BY changed_at DESC LIMIT 5;
ROLLBACK;


-- ============================================================================
-- EXAMPLE 8: STATEMENT-LEVEL AFTER TRIGGER - BULK OPERATION LOGGING
-- ============================================================================
-- DESCRIPTION:
--   Logs bulk operations without processing each individual row
--
-- TRIGGER NATURE:
--   - Type: STATEMENT-LEVEL (FOR EACH STATEMENT)
--   - Timing: AFTER UPDATE
--   - Event: UPDATE operations on film table
--
-- WHEN IT FIRES:
--   - Fires ONCE per UPDATE statement (regardless of rows affected)
--   - Executes AFTER all rows have been updated
--   - Does NOT have access to NEW/OLD row data
--
-- BEHAVIOR:
--   - Logs operation type (TG_OP), table name (TG_TABLE_NAME), user, and timestamp
--   - Creates single log entry for entire operation
--   - Returns NULL (standard for statement-level triggers)
--
-- USE CASE:
--   Efficient logging for bulk operations without per-row overhead
-- ============================================================================

CREATE TABLE IF NOT EXISTS bulk_operation_log (
    operation_id SERIAL PRIMARY KEY,
    operation_type VARCHAR(50),
    table_name VARCHAR(100),
    performed_by VARCHAR(100),
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT
);

-- Statement-level: Log that a bulk update occurred
CREATE OR REPLACE FUNCTION log_bulk_operation()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO bulk_operation_log (operation_type, table_name, performed_by, description)
    VALUES (
        TG_OP,
        TG_TABLE_NAME,
        CURRENT_USER,
        'Bulk ' || TG_OP || ' operation on ' || TG_TABLE_NAME
    );
    
    RETURN NULL;  -- Statement-level triggers often return NULL
END $$;

CREATE TRIGGER statement_level_operation_logger
    AFTER UPDATE ON film
    FOR EACH STATEMENT
    EXECUTE FUNCTION log_bulk_operation();

-- Test it:
BEGIN;
    -- Update multiple films
    UPDATE film SET rental_rate = rental_rate * 1.1 WHERE rating = 'PG';
    
    -- Check log - only ONE entry for entire statement
    SELECT * FROM bulk_operation_log ORDER BY performed_at DESC LIMIT 1;
ROLLBACK;


-- ============================================================================
-- EXAMPLE 9: ROW-LEVEL AFTER TRIGGER - INVENTORY MANAGEMENT
-- ============================================================================
-- DESCRIPTION:
--   Automatically updates film inventory counts when rentals change
--
-- ⚠️ PERFORMANCE NOTE:
--   This trigger queries the inventory table on every rental operation.
--   In production, ensure these indexes exist:
--   - rental(inventory_id) - usually exists via foreign key
--   - inventory(film_id) - usually exists via foreign key
--
-- TRIGGER NATURE:
--   - Type: ROW-LEVEL (FOR EACH ROW)
--   - Timing: AFTER INSERT OR UPDATE OR DELETE
--   - Event: INSERT, UPDATE, or DELETE operations on rental table
--
-- WHEN IT FIRES:
--   - INSERT: When new rental is created (decreases available copies)
--   - UPDATE: When rental return_date changes (may increase available copies)
--   - DELETE: When rental is deleted (may increase available copies)
--   - Executes once per affected rental
--
-- BEHAVIOR:
--   - Identifies affected film_id from inventory table
--   - Recalculates available_copies and rented_copies for that film
--   - Updates film_inventory_summary table with new counts
--   - Uses TG_OP to handle INSERT, UPDATE, DELETE differently
--
-- USE CASE:
--   Real-time inventory tracking without manual count updates
-- ============================================================================

-- Goal: Automatically update inventory when orders are placed

-- Create simplified inventory tracking
CREATE TABLE IF NOT EXISTS film_inventory_summary (
    film_id INTEGER PRIMARY KEY,
    total_copies INTEGER DEFAULT 0,
    available_copies INTEGER DEFAULT 0,
    rented_copies INTEGER DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Initialize the summary table
INSERT INTO film_inventory_summary (film_id, total_copies, available_copies, rented_copies)
SELECT 
    i.film_id,
    COUNT(*) as total_copies,
    COUNT(*) FILTER (WHERE NOT EXISTS (
        SELECT 1 FROM rental r 
        WHERE r.inventory_id = i.inventory_id 
        AND r.return_date IS NULL
    )) as available_copies,
    COUNT(*) FILTER (WHERE EXISTS (
        SELECT 1 FROM rental r 
        WHERE r.inventory_id = i.inventory_id 
        AND r.return_date IS NULL
    )) as rented_copies
FROM inventory i
GROUP BY i.film_id
ON CONFLICT (film_id) DO UPDATE SET
    total_copies = EXCLUDED.total_copies,
    available_copies = EXCLUDED.available_copies,
    rented_copies = EXCLUDED.rented_copies;

-- Function to update inventory counts
CREATE OR REPLACE FUNCTION update_inventory_counts()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_film_id INTEGER;
BEGIN
    -- Get the film_id from inventory
    IF TG_OP = 'DELETE' THEN
        SELECT film_id INTO v_film_id 
        FROM inventory 
        WHERE inventory_id = OLD.inventory_id;
    ELSE
        SELECT film_id INTO v_film_id 
        FROM inventory 
        WHERE inventory_id = NEW.inventory_id;
    END IF;
    
    -- Update the summary
    UPDATE film_inventory_summary
    SET 
        available_copies = (
            SELECT COUNT(*)
            FROM inventory i
            WHERE i.film_id = v_film_id
            AND NOT EXISTS (
                SELECT 1 FROM rental r 
                WHERE r.inventory_id = i.inventory_id 
                AND r.return_date IS NULL
            )
        ),
        rented_copies = (
            SELECT COUNT(*)
            FROM inventory i
            WHERE i.film_id = v_film_id
            AND EXISTS (
                SELECT 1 FROM rental r 
                WHERE r.inventory_id = i.inventory_id 
                AND r.return_date IS NULL
            )
        ),
        last_updated = CURRENT_TIMESTAMP
    WHERE film_id = v_film_id;
    
    RETURN COALESCE(NEW, OLD);
END $$;

CREATE TRIGGER track_inventory_changes
    AFTER INSERT OR UPDATE OR DELETE ON rental
    FOR EACH ROW
    EXECUTE FUNCTION update_inventory_counts();

-- Test it:
-- Check current inventory for a film
SELECT f.title, fis.*
FROM film_inventory_summary fis
JOIN film f ON f.film_id = fis.film_id
WHERE fis.film_id = 1;

-- Create a rental (if available)
BEGIN;
    INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
    SELECT CURRENT_TIMESTAMP, i.inventory_id, 1, 1
    FROM inventory i
    WHERE i.film_id = 1
    AND NOT EXISTS (
        SELECT 1 FROM rental r 
        WHERE r.inventory_id = i.inventory_id 
        AND r.return_date IS NULL
    )
    LIMIT 1;
    
    -- Check inventory again - available decreased, rented increased!
    SELECT f.title, fis.*
    FROM film_inventory_summary fis
    JOIN film f ON f.film_id = fis.film_id
    WHERE fis.film_id = 1;
ROLLBACK;


-- ============================================================================
-- EXAMPLE 10: ROW-LEVEL BEFORE TRIGGER - ERROR HANDLING & VALIDATION
-- ============================================================================
-- DESCRIPTION:
--   Prevents rentals when no inventory is available, with helpful error messages
--
-- TRIGGER NATURE:
--   - Type: ROW-LEVEL (FOR EACH ROW)
--   - Timing: BEFORE INSERT
--   - Event: INSERT operations on rental table
--
-- WHEN IT FIRES:
--   - Fires BEFORE each new rental is inserted
--   - Executes once per rental attempt
--   - Has ability to prevent INSERT by raising exception
--
-- BEHAVIOR:
--   - Looks up film_id and title from inventory
--   - Checks available_copies in film_inventory_summary
--   - If available_copies ≤ 0: RAISES EXCEPTION with film details
--   - If copies available: Returns NEW (allows insert to proceed)
--
-- USE CASE:
--   Business rule enforcement with user-friendly error messages
-- ============================================================================

-- Goal: Prevent inventory from going negative with helpful error message

CREATE OR REPLACE FUNCTION prevent_negative_inventory()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_film_id INTEGER;
    v_film_title VARCHAR(255);
    v_available INTEGER;
BEGIN
    -- Get film information
    SELECT i.film_id, f.title INTO v_film_id, v_film_title
    FROM inventory i
    JOIN film f ON f.film_id = i.film_id
    WHERE i.inventory_id = NEW.inventory_id;
    
    -- Count available copies
    SELECT available_copies INTO v_available
    FROM film_inventory_summary
    WHERE film_id = v_film_id;
    
    -- Check if any copies are available
    IF v_available <= 0 THEN
        RAISE EXCEPTION 'Film "%" (ID: %) is not available for rent. All copies are currently rented out.',
            v_film_title, v_film_id
        USING HINT = 'Please choose a different film or wait for a copy to be returned.';
    END IF;
    
    RETURN NEW;
END $$;

CREATE TRIGGER check_inventory_availability
    BEFORE INSERT ON rental
    FOR EACH ROW
    EXECUTE FUNCTION prevent_negative_inventory();

-- Test it:
BEGIN;
    -- Try to rent a film that's fully rented (this will error)
    INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
    VALUES (CURRENT_TIMESTAMP, 
            (SELECT inventory_id FROM inventory WHERE film_id = 1 LIMIT 1),
            1, 1);
ROLLBACK;


-- ============================================================================
-- EXAMPLE 11: CASCADING TRIGGERS - LOYALTY POINTS SYSTEM
-- ============================================================================
-- DESCRIPTION:
--   Demonstrates trigger chaining where one trigger activates another
--
-- TRIGGER NATURE:
--   Two triggers working together:
--   
--   Trigger 1: payment_loyalty_points
--   - Type: ROW-LEVEL (FOR EACH ROW)
--   - Timing: AFTER INSERT
--   - Event: INSERT on payment table
--   
--   Trigger 2: maintain_loyalty_tier
--   - Type: ROW-LEVEL (FOR EACH ROW)
--   - Timing: BEFORE UPDATE
--   - Event: UPDATE on customer_loyalty table
--   - Condition: WHEN points change
--
-- WHEN THEY FIRE:
--   1. New payment inserted → Trigger 1 fires
--   2. Trigger 1 updates customer_loyalty points
--   3. Points update → Trigger 2 fires
--   4. Trigger 2 recalculates tier based on new points
--
-- BEHAVIOR:
--   - Payment INSERT awards points (1 point per dollar)
--   - Points update automatically adjusts loyalty tier:
--     * <200 points: BRONZE
--     * 200-499 points: SILVER
--     * 500-999 points: GOLD
--     * 1000+ points: PLATINUM
--
-- USE CASE:
--   Complex business logic with automatic tier management
--
-- ⚠️ WARNING: Cascading triggers can create unexpected behavior and performance issues
-- ============================================================================

-- Warning: Be careful with triggers that modify other tables!
-- This can create cascading effects where one trigger fires another.

-- Example: Customer loyalty points system

CREATE TABLE IF NOT EXISTS customer_loyalty (
    customer_id INTEGER PRIMARY KEY,
    points INTEGER DEFAULT 0,
    tier VARCHAR(20) DEFAULT 'BRONZE',
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Initialize loyalty table
INSERT INTO customer_loyalty (customer_id, points)
SELECT customer_id, 0
FROM customer
ON CONFLICT (customer_id) DO NOTHING;

-- Trigger 1: Award points for payments
CREATE OR REPLACE FUNCTION award_loyalty_points()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Award 1 point per dollar spent (rounded)
    UPDATE customer_loyalty
    SET 
        points = points + FLOOR(NEW.amount),
        last_updated = CURRENT_TIMESTAMP
    WHERE customer_id = NEW.customer_id;
    
    RETURN NEW;
END $$;

CREATE TRIGGER payment_loyalty_points
    AFTER INSERT ON payment
    FOR EACH ROW
    EXECUTE FUNCTION award_loyalty_points();

-- Trigger 2: Update tier based on points
CREATE OR REPLACE FUNCTION update_loyalty_tier()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    new_tier VARCHAR(20);
BEGIN
    -- Determine tier based on points
    IF NEW.points >= 1000 THEN
        new_tier := 'PLATINUM';
    ELSIF NEW.points >= 500 THEN
        new_tier := 'GOLD';
    ELSIF NEW.points >= 200 THEN
        new_tier := 'SILVER';
    ELSE
        new_tier := 'BRONZE';
    END IF;
    
    -- Update tier if it changed
    IF NEW.tier IS DISTINCT FROM new_tier THEN
        NEW.tier := new_tier;
        RAISE NOTICE 'Customer % promoted to % tier!', NEW.customer_id, new_tier;
    END IF;
    
    RETURN NEW;
END $$;

CREATE TRIGGER maintain_loyalty_tier
    BEFORE UPDATE ON customer_loyalty
    FOR EACH ROW
    WHEN (OLD.points IS DISTINCT FROM NEW.points)
    EXECUTE FUNCTION update_loyalty_tier();

-- Test the cascading triggers:
BEGIN;
    -- Make a payment - this triggers TWO triggers!
    INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
    VALUES (5, 1, 1, 150.00, CURRENT_TIMESTAMP);
    
    -- Check loyalty status
    SELECT * FROM customer_loyalty WHERE customer_id = 5;
ROLLBACK;


-- ============================================================================
-- EXAMPLE 12: INSTEAD OF TRIGGER - UPDATABLE VIEWS
-- ============================================================================
-- DESCRIPTION:
--   Makes a complex multi-table view updatable by intercepting updates
--
-- TRIGGER NATURE:
--   - Type: ROW-LEVEL (FOR EACH ROW)
--   - Timing: INSTEAD OF UPDATE
--   - Event: UPDATE operations on customer_contact_info VIEW
--
-- WHEN IT FIRES:
--   - Fires when user attempts to UPDATE the view
--   - Replaces the original UPDATE operation entirely
--   - Executes once per row being updated
--
-- BEHAVIOR:
--   - Intercepts UPDATE on view (which would normally fail)
--   - Manually updates underlying customer table (first_name, last_name, email)
--   - Manually updates underlying address table (phone)
--   - Returns NEW (required even though original operation is replaced)
--
-- USE CASE:
--   Make complex views writable by handling updates to base tables
--
-- NOTE: INSTEAD OF triggers ONLY work on VIEWS, not regular tables
-- ============================================================================

-- INSTEAD OF triggers replace the original operation
-- Most commonly used with VIEWS to make them updatable

-- Create a view combining customer and address info
CREATE OR REPLACE VIEW customer_contact_info AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    a.address,
    a.phone,
    ci.city,
    a.district,
    co.country
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- Problem: Can't update this view directly (it joins multiple tables)
-- Solution: Create INSTEAD OF trigger

CREATE OR REPLACE FUNCTION update_customer_contact()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Update customer table
    UPDATE customer
    SET 
        first_name = NEW.first_name,
        last_name = NEW.last_name,
        email = NEW.email
    WHERE customer_id = NEW.customer_id;
    
    -- Update address table
    UPDATE address
    SET 
        phone = NEW.phone
    WHERE address_id = (
        SELECT address_id FROM customer WHERE customer_id = NEW.customer_id
    );
    
    RAISE NOTICE 'Updated contact info for customer %', NEW.customer_id;
    
    RETURN NEW;
END $$;

CREATE TRIGGER instead_update_customer_contact
    INSTEAD OF UPDATE ON customer_contact_info
    FOR EACH ROW
    EXECUTE FUNCTION update_customer_contact();

-- Test it:
BEGIN;
    -- Update through the view - works now!
    UPDATE customer_contact_info
    SET email = 'newemail@example.com',
        phone = '123-456-7890'
    WHERE customer_id = 1;
    
    -- Verify the change
    SELECT * FROM customer_contact_info WHERE customer_id = 1;
ROLLBACK;


-- ============================================================================
-- EXAMPLE 13: ROW-LEVEL AFTER TRIGGER WITH WHEN CLAUSE - CONDITIONAL EXECUTION
-- ============================================================================
-- DESCRIPTION:
--   Logs only significant price changes (>10%) using WHEN clause optimization
--
-- TRIGGER NATURE:
--   - Type: ROW-LEVEL (FOR EACH ROW)
--   - Timing: AFTER UPDATE
--   - Event: UPDATE operations on film table
--   - Condition: WHEN rental_rate changes by more than 10%
--
-- WHEN IT FIRES:
--   - Only fires when rental_rate actually changes
--   - Only fires when change is greater than 10% of old value
--   - WHEN clause evaluated BEFORE function execution (performance optimization)
--   - Executes once per qualifying update
--
-- BEHAVIOR:
--   - WHEN clause filters at trigger level (more efficient than IF inside function)
--   - Calculates price change, absolute difference, and percentage
--   - Logs film_id, old price, new price, change amount, and percentage
--   - Small changes (<10%) never invoke the trigger function
--
-- USE CASE:
--   Performance optimization - only process significant changes
--
-- PERFORMANCE NOTE:
--   WHEN clause evaluation happens BEFORE function call, saving resources
-- ============================================================================

-- You can add a WHEN clause to make triggers more efficient
-- The trigger only fires if the condition is true

-- Only log significant price changes (more than 10%)
CREATE OR REPLACE FUNCTION log_significant_price_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO price_change_log (film_id, old_price, new_price, price_change, percent_change)
    VALUES (
        NEW.film_id,
        OLD.rental_rate,
        NEW.rental_rate,
        NEW.rental_rate - OLD.rental_rate,
        ((NEW.rental_rate - OLD.rental_rate) / OLD.rental_rate) * 100
    );
    
    RETURN NEW;
END $$;

CREATE TRIGGER log_major_price_changes
    AFTER UPDATE ON film
    FOR EACH ROW
    WHEN (
        OLD.rental_rate IS DISTINCT FROM NEW.rental_rate
        AND ABS(NEW.rental_rate - OLD.rental_rate) > (OLD.rental_rate * 0.10)
    )
    EXECUTE FUNCTION log_significant_price_changes();

-- Test it:
BEGIN;
    -- Small change - trigger won't fire
    UPDATE film SET rental_rate = rental_rate + 0.05 WHERE film_id = 10;
    
    -- Large change - trigger will fire
    UPDATE film SET rental_rate = rental_rate * 1.5 WHERE film_id = 11;
    
    -- Check log - only the large change is recorded
    SELECT * FROM price_change_log ORDER BY changed_at DESC LIMIT 5;
ROLLBACK;


-- ============================================================================
-- SECTION 17: DISABLING AND ENABLING TRIGGERS
-- ============================================================================

-- Sometimes you need to temporarily turn off triggers
-- (for bulk imports, migrations, etc.)

-- Disable a specific trigger
ALTER TABLE film DISABLE TRIGGER film_update_modified;

-- Re-enable it
ALTER TABLE film ENABLE TRIGGER film_update_modified;

-- Disable ALL triggers on a table (dangerous!)
ALTER TABLE film DISABLE TRIGGER ALL;

-- Re-enable all triggers
ALTER TABLE film ENABLE TRIGGER ALL;

-- Check trigger status
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers
WHERE event_object_table = 'film'
ORDER BY trigger_name;


-- ============================================================================
-- SECTION 18: EVENT TRIGGERS (DDL OPERATIONS)
-- ============================================================================

-- Event triggers respond to schema changes (CREATE, ALTER, DROP)
-- They're different from regular triggers!

-- Create audit table for DDL operations
CREATE TABLE IF NOT EXISTS ddl_audit_log (
    audit_id SERIAL PRIMARY KEY,
    command_tag TEXT,
    object_type TEXT,
    object_identity TEXT,
    performed_by VARCHAR(100),
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create event trigger function
CREATE OR REPLACE FUNCTION audit_ddl_commands()
RETURNS event_trigger
LANGUAGE plpgsql
AS $$
DECLARE
    obj record;
BEGIN
    -- Log DDL operation
    FOR obj IN SELECT * FROM pg_event_trigger_ddl_commands()
    LOOP
        INSERT INTO ddl_audit_log (command_tag, object_type, object_identity, performed_by)
        VALUES (
            obj.command_tag,  -- Correct: use obj.command_tag (not TG_TAG for event triggers)
            obj.object_type,
            obj.object_identity,
            CURRENT_USER
        );
    END LOOP;
END $$;

-- Create event trigger (requires superuser privileges)
-- Uncomment if you have superuser access:
/*
CREATE EVENT TRIGGER log_all_ddl
    ON ddl_command_end
    EXECUTE FUNCTION audit_ddl_commands();
*/

-- Test it (if event trigger is enabled):
/*
CREATE TABLE test_table (id INTEGER);
ALTER TABLE test_table ADD COLUMN name TEXT;
DROP TABLE test_table;

-- Check DDL audit log
SELECT * FROM ddl_audit_log ORDER BY performed_at DESC;
*/


-- ============================================================================
-- SECTION 19: COMMON MISTAKES AND HOW TO AVOID THEM
-- ============================================================================

-- ❌ MISTAKE 1: Forgetting RETURN
/*
CREATE OR REPLACE FUNCTION my_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Do something
    -- Oops! Forgot to RETURN
END $$ LANGUAGE plpgsql;
*/

-- ✅ CORRECT: Always return something
CREATE OR REPLACE FUNCTION correct_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Do something
    RETURN NEW;  -- or OLD for DELETE, or NULL to skip operation
END $$ LANGUAGE plpgsql;


-- ❌ MISTAKE 2: Using NEW in DELETE triggers
/*
CREATE OR REPLACE FUNCTION wrong_delete()
RETURNS TRIGGER AS $$
BEGIN
    -- NEW doesn't exist for DELETE!
    INSERT INTO log (customer_id) VALUES (NEW.customer_id);
    RETURN NEW;
END $$ LANGUAGE plpgsql;
*/

-- ✅ CORRECT: Use OLD for DELETE
CREATE OR REPLACE FUNCTION correct_delete()
RETURNS TRIGGER AS $$
BEGIN
    -- Use OLD for DELETE operations
    INSERT INTO customer_email_audit (customer_id, old_email) 
    VALUES (OLD.customer_id, OLD.email);
    RETURN OLD;
END $$ LANGUAGE plpgsql;


-- ❌ MISTAKE 3: Infinite loops
/*
-- BAD: This trigger updates the same table!
CREATE OR REPLACE FUNCTION infinite_loop()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE customer SET last_update = NOW() WHERE customer_id = NEW.customer_id;
    RETURN NEW;  -- This causes another update, which triggers again!
END $$ LANGUAGE plpgsql;
*/

-- ✅ CORRECT: Modify NEW directly in BEFORE trigger
CREATE OR REPLACE FUNCTION no_infinite_loop()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_update := CURRENT_TIMESTAMP;  -- Modify NEW, don't UPDATE
    RETURN NEW;
END $$ LANGUAGE plpgsql;


-- ============================================================================
-- SECTION 20: PERFORMANCE CONSIDERATIONS
-- ============================================================================

-- Tips for efficient triggers:
--
-- 1. Keep triggers SIMPLE and FAST
-- 2. Avoid complex calculations in row-level triggers
-- 3. Use WHEN clauses to filter unnecessary executions
-- 4. Consider statement-level for bulk operations
-- 5. Be careful with cascading triggers
-- 6. Use indexes on columns referenced in trigger queries
-- 7. Test with realistic data volumes

-- Example: Efficient trigger with WHEN clause
CREATE OR REPLACE FUNCTION efficient_audit()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO customer_email_audit (customer_id, old_email, new_email)
    VALUES (NEW.customer_id, OLD.email, NEW.email);
    RETURN NEW;
END $$;

CREATE TRIGGER efficient_email_audit
    AFTER UPDATE ON customer
    FOR EACH ROW
    WHEN (OLD.email IS DISTINCT FROM NEW.email)  -- Only when email actually changes
    EXECUTE FUNCTION efficient_audit();


-- ============================================================================
-- SECTION 21: DEBUGGING TRIGGERS
-- ============================================================================

-- Use RAISE NOTICE to debug triggers

CREATE OR REPLACE FUNCTION debug_trigger()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Trigger fired! Operation: %, Table: %', TG_OP, TG_TABLE_NAME;
    RAISE NOTICE 'OLD values: %', OLD;
    RAISE NOTICE 'NEW values: %', NEW;
    
    RETURN NEW;
END $$;

-- View PostgreSQL messages
-- In psql: \set VERBOSITY verbose
-- Messages appear in the console

-- Check if trigger exists
SELECT 
    t.trigger_name,
    t.event_manipulation,
    t.action_timing,
    t.action_orientation
FROM information_schema.triggers t
WHERE t.event_object_table = 'customer'
ORDER BY t.trigger_name;


-- ============================================================================
-- SECTION 22: VIEWING AND MANAGING TRIGGERS
-- ============================================================================

-- List all triggers in the database
SELECT 
    trigger_name,
    event_object_table AS table_name,
    event_manipulation AS event,
    action_timing AS timing,
    action_orientation AS level
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

-- Get trigger definition (psql command)
-- \df+ function_name

-- Drop a trigger
-- DROP TRIGGER trigger_name ON table_name;

-- Drop the function too
-- DROP FUNCTION function_name();


-- ============================================================================
-- SECTION 23: REAL-WORLD USE CASES SUMMARY
-- ============================================================================

-- ✅ GOOD uses for triggers:
-- 1. Automatic timestamps (created_at, updated_at)
-- 2. Simple audit logs
-- 3. Data validation that must ALWAYS happen
-- 4. Maintaining counts/totals
-- 5. Enforcing business rules at database level
-- 6. Preventing invalid data
-- 7. Automatic data cleanup/normalization

-- ❌ AVOID triggers for:
-- 1. Complex business logic (put in application code)
-- 2. Calling external APIs
-- 3. Heavy calculations
-- 4. Sending emails or notifications
-- 5. Operations that slow down normal database work


-- ============================================================================
-- SECTION 24: PRACTICE EXERCISES
-- ============================================================================

-- EXERCISE 1: Create a trigger to prevent deleting customers with active rentals
-- Hint: Check if customer has rentals with return_date IS NULL
-- Test: Try to delete a customer with active rentals

-- EXERCISE 2: Create an audit trail for film deletions
-- Hint: Create a deleted_films table and copy data before deletion
-- Test: Delete a film and check if it was logged

-- EXERCISE 3: Create a trigger to automatically set customer status to 'VIP'
-- when total payments exceed $200
-- Hint: Add a status column to customer, sum payments in trigger
-- Test: Insert payments for a customer until they hit VIP status

-- EXERCISE 4: Create a trigger to prevent renting more than 5 films at once
-- Hint: Count active rentals for customer in BEFORE INSERT trigger
-- Test: Try to create a 6th rental for a customer with 5 active rentals

-- EXERCISE 5: Create a trigger that logs whenever someone updates rental rates
-- Include old value, new value, and percentage change
-- Hint: Use AFTER UPDATE with WHEN clause to check if rental_rate changed
-- Test: Update rental_rate and check the log


-- ============================================================================
-- SECTION 25: TRIGGER TEMPLATES FOR COMMON PATTERNS
-- ============================================================================

-- TEMPLATE 1: Auto-timestamp (BEFORE UPDATE)
/*
CREATE OR REPLACE FUNCTION auto_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER table_name_timestamp
    BEFORE UPDATE ON table_name
    FOR EACH ROW
    EXECUTE FUNCTION auto_timestamp();
*/


-- TEMPLATE 2: Audit trail (AFTER INSERT/UPDATE/DELETE)
/*
CREATE OR REPLACE FUNCTION audit_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (operation, table_name, old_data, changed_by)
        VALUES (TG_OP, TG_TABLE_NAME, to_jsonb(OLD), CURRENT_USER);
        RETURN OLD;
    ELSE
        INSERT INTO audit_log (operation, table_name, new_data, changed_by)
        VALUES (TG_OP, TG_TABLE_NAME, to_jsonb(NEW), CURRENT_USER);
        RETURN NEW;
    END IF;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER table_name_audit
    AFTER INSERT OR UPDATE OR DELETE ON table_name
    FOR EACH ROW
    EXECUTE FUNCTION audit_changes();
*/


-- TEMPLATE 3: Validation (BEFORE INSERT/UPDATE)
/*
CREATE OR REPLACE FUNCTION validate_data()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.column_name < 0 THEN
        RAISE EXCEPTION 'Value cannot be negative';
    END IF;
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER table_name_validate
    BEFORE INSERT OR UPDATE ON table_name
    FOR EACH ROW
    EXECUTE FUNCTION validate_data();
*/


-- TEMPLATE 4: Maintain counts (AFTER INSERT/UPDATE/DELETE)
/*
CREATE OR REPLACE FUNCTION maintain_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE summary_table 
        SET count = count + 1 
        WHERE id = NEW.parent_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE summary_table 
        SET count = count - 1 
        WHERE id = OLD.parent_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER maintain_counts
    AFTER INSERT OR DELETE ON detail_table
    FOR EACH ROW
    EXECUTE FUNCTION maintain_count();
*/


-- TEMPLATE 5: Data cleanup (BEFORE INSERT/UPDATE)
/*
CREATE OR REPLACE FUNCTION cleanup_data()
RETURNS TRIGGER AS $$
BEGIN
    NEW.email := LOWER(TRIM(NEW.email));
    NEW.name := INITCAP(TRIM(NEW.name));
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER clean_before_save
    BEFORE INSERT OR UPDATE ON table_name
    FOR EACH ROW
    EXECUTE FUNCTION cleanup_data();
*/


-- ============================================================================
-- SECTION 26: QUICK REFERENCE
-- ============================================================================

-- TRIGGER TIMING:
-- BEFORE  - Run before change (can modify NEW, prevent operation)
-- AFTER   - Run after change (cannot modify data, good for logging)
-- INSTEAD OF - Replace operation entirely (for views)

-- TRIGGER EVENTS:
-- INSERT  - When new rows added
-- UPDATE  - When rows modified
-- DELETE  - When rows removed

-- TRIGGER LEVEL:
-- FOR EACH ROW       - Fires once per row (has NEW/OLD)
-- FOR EACH STATEMENT - Fires once per SQL statement (no NEW/OLD)

-- SPECIAL VARIABLES:
-- NEW     - New row data (INSERT, UPDATE)
-- OLD     - Old row data (UPDATE, DELETE)
-- TG_OP   - Operation type: 'INSERT', 'UPDATE', 'DELETE'
-- TG_TABLE_NAME - Name of the table
-- TG_WHEN - 'BEFORE', 'AFTER', or 'INSTEAD OF'

-- RETURN VALUES:
-- RETURN NEW  - Proceed with NEW data (BEFORE/AFTER)
-- RETURN OLD  - Use for DELETE operations
-- RETURN NULL - Skip operation (BEFORE only) or no-op (AFTER)


-- ============================================================================
-- COMMON MISTAKES (PostgreSQL Specific)
-- ============================================================================

-- ❌ MISTAKE #1: Forgetting RETURN (PostgreSQL ONLY!)
/*
CREATE OR REPLACE FUNCTION my_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log VALUES (OLD.id, NOW());
    -- ERROR: No RETURN statement!
END;
$$ LANGUAGE plpgsql;
*/

-- ✅ CORRECT: Always RETURN NEW, OLD, or NULL
CREATE OR REPLACE FUNCTION my_trigger_correct()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO audit_log VALUES (OLD.id, NOW());
    RETURN NEW;  -- ✅ Required in PostgreSQL
END $$;


-- ❌ MISTAKE #2: Using :NEW instead of NEW
/*
CREATE OR REPLACE FUNCTION oracle_style()
RETURNS TRIGGER AS $$
BEGIN
    :NEW.updated_at := NOW();  -- ERROR: Don't use colons in PostgreSQL!
    RETURN :NEW;
END;
$$ LANGUAGE plpgsql;
*/

-- ✅ CORRECT: No colons in PostgreSQL
CREATE OR REPLACE FUNCTION postgres_style()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.last_update := CURRENT_TIMESTAMP;  -- ✅ No colons
    RETURN NEW;
END $$;


-- ❌ MISTAKE #3: Using INSERTING/UPDATING instead of TG_OP
/*
CREATE OR REPLACE FUNCTION oracle_check()
RETURNS TRIGGER AS $$
BEGIN
    IF INSERTING THEN  -- ERROR: Oracle syntax doesn't work!
        -- do something
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
*/

-- ✅ CORRECT: Use TG_OP variable
CREATE OR REPLACE FUNCTION postgres_check()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN  -- ✅ PostgreSQL way
        -- do something
    ELSIF TG_OP = 'UPDATE' THEN
        -- do something else
    END IF;
    RETURN NEW;
END $$;


-- ============================================================================
-- BEST PRACTICES
-- ============================================================================
-- ✅ Keep triggers SIMPLE and FAST
-- ✅ Use WHEN clause to avoid unnecessary executions
-- ✅ Always test with ROLLBACK first
-- ✅ Document what each trigger does
-- ✅ Use descriptive function and trigger names
-- ✅ Avoid complex business logic in triggers
-- ✅ Remember: PostgreSQL requires RETURN, Oracle doesn't
-- ✅ Use NEW (no colon) in PostgreSQL, :NEW (with colon) in Oracle
-- ============================================================================


-- ============================================================================
-- MIGRATION TIPS: ORACLE → POSTGRESQL
-- ============================================================================
-- When converting Oracle triggers to PostgreSQL:
--
-- 1. Split into FUNCTION + TRIGGER (two statements)
-- 2. Add RETURNS TRIGGER and LANGUAGE plpgsql
-- 3. Add RETURN NEW/OLD at the end
-- 4. Remove colons from :NEW and :OLD
-- 5. Replace INSERTING/UPDATING with TG_OP = 'INSERT'/'UPDATE'
-- 6. Replace RAISE_APPLICATION_ERROR with RAISE EXCEPTION
-- 7. Replace SYSDATE with CURRENT_TIMESTAMP
-- 8. Add EXECUTE FUNCTION in trigger definition
--
-- Example conversion:
--
-- ORACLE:
--   CREATE OR REPLACE TRIGGER my_trig
--   AFTER UPDATE ON customer FOR EACH ROW
--   BEGIN
--       INSERT INTO log VALUES (:OLD.id, SYSDATE);
--   END;
--
-- POSTGRESQL:
--   CREATE OR REPLACE FUNCTION my_trig_func()
--   RETURNS TRIGGER AS $$
--   BEGIN
--       INSERT INTO log VALUES (OLD.id, CURRENT_TIMESTAMP);
--       RETURN NEW;
--   END;
--   $$ LANGUAGE plpgsql;
--
--   CREATE TRIGGER my_trig
--   AFTER UPDATE ON customer FOR EACH ROW
--   EXECUTE FUNCTION my_trig_func();
--
-- ============================================================================


-- ============================================================================
-- VIEWING YOUR TRIGGERS
-- ============================================================================

-- List all triggers in the database
SELECT 
    trigger_name,
    event_object_table AS table_name,
    event_manipulation AS event,
    action_timing AS timing
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;


-- ============================================================================
-- CLEANUP (Run if you want to remove demo triggers)
-- ============================================================================
/*
DROP TRIGGER IF EXISTS audit_customer_email ON customer;
DROP TRIGGER IF EXISTS check_rental_rate ON film;
DROP TRIGGER IF EXISTS maintain_rental_count ON rental;
DROP TRIGGER IF EXISTS track_price_changes ON film;

DROP FUNCTION IF EXISTS log_email_change();
DROP FUNCTION IF EXISTS validate_rental_rate();
DROP FUNCTION IF EXISTS update_active_rental_count();
DROP FUNCTION IF EXISTS log_price_change();

DROP TABLE IF EXISTS customer_audit_log;
DROP TABLE IF EXISTS price_change_history;
*/


-- ============================================================================
-- EXAMPLES SUMMARY TABLE
-- ============================================================================
-- Quick reference of all examples covered in this demo:
--
-- ┌─────┬────────────────────────────────┬──────────────┬────────┬───────────┐
-- │ Ex# │ Topic                          │ Trigger Type │ Timing │ Level     │
-- ├─────┼────────────────────────────────┼──────────────┼────────┼───────────┤
-- │  1  │ Work Hours Validation          │ Validation   │ BEFORE │ Statement │
-- │  2  │ Data Cleanup                   │ Modification │ BEFORE │ Row       │
-- │  3  │ Rental Rate Validation         │ Validation   │ BEFORE │ Row       │
-- │  4  │ Email Change Audit Log         │ Audit        │ AFTER  │ Row       │
-- │ 4B  │ DDL Trigger (Event)            │ DDL Logging  │ AFTER  │ Event     │
-- │ 4C  │ Cascading Triggers             │ Auto-Update  │ AFTER  │ Row       │
-- │  5  │ Active Rental Count            │ Calculation  │ AFTER  │ Row       │
-- │  6  │ Rental Duration Messages       │ Conditional  │ AFTER  │ Row       │
-- │  7  │ Price Change Log (Detailed)    │ Audit        │ AFTER  │ Row       │
-- │  8  │ Bulk Operation Log             │ Audit        │ AFTER  │ Statement │
-- │  9  │ Inventory Management           │ Auto-Update  │ AFTER  │ Row       │
-- │ 10  │ Prevent Negative Inventory     │ Validation   │ BEFORE │ Row       │
-- │ 11  │ Loyalty Points System          │ Cascading    │ AFTER  │ Row       │
-- │ 12  │ Updatable Views                │ INSTEAD OF   │ INSTEAD│ Row       │
-- │ 13  │ Significant Price Changes      │ Conditional  │ AFTER  │ Row+WHEN  │
-- └─────┴────────────────────────────────┴──────────────┴────────┴───────────┘
--
-- USE CASES BY TYPE:
-- ══════════════════
-- ✓ BEFORE + Row       → Data validation, cleanup, modification
-- ✓ AFTER + Row        → Audit logs, cascading updates, calculations
-- ✓ BEFORE + Statement → Bulk validation, access control
-- ✓ AFTER + Statement  → Bulk operation logging
-- ✓ INSTEAD OF         → Making views updatable
-- ============================================================================

-- ============================================================================
-- END OF SIMPLIFIED TRIGGERS DEMO
-- ============================================================================
-- Key Takeaways:
--
-- 1. PostgreSQL: Function + Trigger (2 steps)
--    Oracle: Single trigger block (1 step)
--
-- 2. PostgreSQL: MUST return NEW/OLD/NULL
--    Oracle: No return statement
--
-- 3. PostgreSQL: NEW.column (no colon)
--    Oracle: :NEW.column (with colon)
--
-- 4. PostgreSQL: TG_OP = 'INSERT'
--    Oracle: INSERTING keyword
--
-- 5. Four main uses:
--    - Audit trails (record-keeping)
--    - Data validation (prevent bad data)
--    - Automatic calculations (update related data)
--    - Event logging (history tracking)
--
-- 6. Remember the beginner pitfalls:
--    - Always RETURN something
--    - Use correct variables (NEW/OLD)
--    - Avoid infinite loops
--    - Test with BEGIN/ROLLBACK
--
-- "Keep it simple, test thoroughly, and always RETURN something!"
-- ============================================================================
