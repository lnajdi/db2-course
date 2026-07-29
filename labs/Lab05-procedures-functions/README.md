# Lab 04: Stored Procedures and Functions

## 🎯 Learning Objectives
By completing this lab, you will:
- Understand the differences between functions and procedures
- Create scalar functions that return single values
- Build table-returning functions (set-returning functions)
- Implement stored procedures for data modification
- Use parameters effectively (IN, OUT, INOUT)
- Apply validation logic within functions
- Combine multiple database operations in procedures
- Handle transactions and error scenarios
- Implement real-world business logic encapsulation

## 📚 Theory Overview

### Functions vs Procedures: What's the Difference?

Think of it like cooking:
- **Functions** are like recipes that **produce something** (return a value) - like making a cake
- **Procedures** are like instructions that **do something** (perform actions) - like cleaning the kitchen

| Feature | Functions | Procedures |
|---------|-----------|------------|
| **Returns** | MUST return a value | No return value |
| **Call Method** | `SELECT function_name()` | `CALL procedure_name()` |
| **Usage** | Can be used in SELECT, WHERE | Standalone execution only |
| **Transactions** | Cannot control transactions | Can commit/rollback |
| **Main Purpose** | Calculate and return data | Perform actions, modify data |

### PostgreSQL Functions

Functions are reusable blocks of code that **always return a value**.

**Basic Syntax:**
```sql
CREATE OR REPLACE FUNCTION function_name(param1 TYPE, param2 TYPE)
RETURNS return_type AS $$
DECLARE
    -- variable declarations
BEGIN
    -- logic here
    RETURN result;
END;
$$ LANGUAGE plpgsql;
```

**Types of Functions:**

1. **Scalar Functions** - Return single value
```sql
CREATE FUNCTION get_full_name(first TEXT, last TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN first || ' ' || last;
END;
$$ LANGUAGE plpgsql;

-- Usage: SELECT get_full_name('John', 'Doe');
```

2. **Table Functions** - Return multiple rows
```sql
CREATE FUNCTION get_customers_by_city(city_name TEXT)
RETURNS TABLE(customer_id INT, full_name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT c.customer_id, c.first_name || ' ' || c.last_name
    FROM customer c
    JOIN address a ON c.address_id = a.address_id
    JOIN city ct ON a.city_id = ct.city_id
    WHERE ct.city = city_name;
END;
$$ LANGUAGE plpgsql;

-- Usage: SELECT * FROM get_customers_by_city('London');
```

### PostgreSQL Procedures

Procedures perform actions and don't return values directly.

**Basic Syntax:**
```sql
CREATE OR REPLACE PROCEDURE procedure_name(param1 TYPE, param2 TYPE)
AS $$
DECLARE
    -- variable declarations
BEGIN
    -- logic and operations here
    -- Can include INSERT, UPDATE, DELETE
    RAISE NOTICE 'Operation completed';
END;
$$ LANGUAGE plpgsql;
```

**When to Use Procedures:**
- Performing INSERT, UPDATE, DELETE operations
- Complex multi-step operations
- Transaction management
- Batch processing
- Data cleanup/maintenance tasks

### Visual Analogy: Restaurant Operations

Think of a restaurant database system:

**Functions (The Chef):**
- `calculate_tip(bill_amount)` → Returns tip amount
- `get_menu_item_price(item_id)` → Returns price
- `find_available_tables(party_size)` → Returns table list
- **Purpose**: Answer questions, provide information

**Procedures (The Manager):**
- `process_order(customer_id, items)` → Places order, updates inventory
- `close_daily_register()` → Calculates totals, archives data
- `apply_discounts(promotion_id)` → Updates prices, logs changes
- **Purpose**: Execute operations, change state

### Parameters and Return Types

**Function Parameters:**
```sql
-- Simple parameters
CREATE FUNCTION add_numbers(num1 INTEGER, num2 INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN num1 + num2;
END;
$$ LANGUAGE plpgsql;

-- Default values
CREATE FUNCTION greet(name TEXT, greeting TEXT DEFAULT 'Hello')
RETURNS TEXT AS $$
BEGIN
    RETURN greeting || ', ' || name || '!';
END;
$$ LANGUAGE plpgsql;
-- Usage: SELECT greet('Alice');  -- "Hello, Alice!"
-- Usage: SELECT greet('Bob', 'Hi');  -- "Hi, Bob!"
```

**Procedure Parameters:**
```sql
-- INOUT parameters (both input and output)
CREATE PROCEDURE calculate_discount(
    INOUT price NUMERIC,
    discount_pct NUMERIC
)
AS $$
BEGIN
    price := price * (1 - discount_pct / 100.0);
END;
$$ LANGUAGE plpgsql;
```

### Using %TYPE for Type Safety

Copy a column's data type directly from the database:

```sql
CREATE FUNCTION get_customer_email(cust_id INTEGER)
RETURNS customer.email%TYPE AS $$  -- Uses exact type from customer.email
DECLARE
    customer_email customer.email%TYPE;
BEGIN
    SELECT email INTO customer_email
    FROM customer
    WHERE customer_id = cust_id;
    
    RETURN customer_email;
END;
$$ LANGUAGE plpgsql;
```

**Benefits:**
- ✅ Automatic type matching
- ✅ Schema change safety
- ✅ No type mismatch errors
- ✅ Self-documenting code

### Validation Functions

Functions can validate data before operations:

```sql
CREATE FUNCTION is_valid_rental_rate(rate NUMERIC)
RETURNS BOOLEAN AS $$
BEGIN
    -- Rate must be positive and reasonable (under $100)
    IF rate IS NULL OR rate <= 0 OR rate > 100 THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Usage in WHERE clause:
SELECT * FROM film 
WHERE is_valid_rental_rate(rental_rate);
```

### Calling Functions from Functions

Functions can call other functions to build complex logic:

```sql
-- Helper function
CREATE FUNCTION calculate_tax(amount NUMERIC, rate NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN ROUND(amount * rate, 2);
END;
$$ LANGUAGE plpgsql;

-- Main function using helper
CREATE FUNCTION calculate_total_price(amount NUMERIC, tax_rate NUMERIC)
RETURNS NUMERIC AS $$
DECLARE
    tax_amount NUMERIC;
BEGIN
    tax_amount := calculate_tax(amount, tax_rate);
    RETURN amount + tax_amount;
END;
$$ LANGUAGE plpgsql;
```

### Common Patterns

#### Pattern 1: Safe Division
```sql
CREATE FUNCTION safe_divide(numerator NUMERIC, denominator NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    IF denominator = 0 THEN
        RETURN NULL;  -- or raise exception
    END IF;
    RETURN numerator / denominator;
END;
$$ LANGUAGE plpgsql;
```

#### Pattern 2: Data Aggregation
```sql
CREATE FUNCTION customer_summary(cust_id INTEGER)
RETURNS TABLE(
    total_rentals BIGINT,
    total_spent NUMERIC,
    avg_payment NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(DISTINCT r.rental_id),
        COALESCE(SUM(p.amount), 0),
        COALESCE(AVG(p.amount), 0)
    FROM customer c
    LEFT JOIN rental r ON c.customer_id = r.customer_id
    LEFT JOIN payment p ON r.rental_id = p.rental_id
    WHERE c.customer_id = cust_id;
END;
$$ LANGUAGE plpgsql;
```

#### Pattern 3: Data Validation and Update
```sql
CREATE PROCEDURE update_film_price(
    film_id INTEGER,
    new_rate NUMERIC
)
AS $$
BEGIN
    -- Validate input
    IF NOT is_valid_rental_rate(new_rate) THEN
        RAISE EXCEPTION 'Invalid rental rate: %', new_rate;
    END IF;
    
    -- Perform update
    UPDATE film
    SET rental_rate = new_rate,
        last_update = CURRENT_TIMESTAMP
    WHERE film.film_id = update_film_price.film_id;
    
    -- Check if update was successful
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Film ID % not found', film_id;
    END IF;
    
    RAISE NOTICE 'Film % rate updated to $%', film_id, new_rate;
END;
$$ LANGUAGE plpgsql;
```

## 🎨 Visual Analogies

### Functions as Calculators
Imagine functions as specialized calculators:
- **Input**: You provide numbers/data (parameters)
- **Process**: Calculator performs operations
- **Output**: You get a result (return value)
- **Non-destructive**: Original data unchanged

### Procedures as Robots
Think of procedures as task-performing robots:
- **Input**: You give instructions (parameters)
- **Process**: Robot performs actions (INSERT/UPDATE/DELETE)
- **Output**: Work is done, state is changed
- **Side effects**: Database is modified

### Function Call Flow
```
User → SELECT calculate_discount(100, 10)
       ↓
   Function receives: amount=100, discount=10
       ↓
   Function calculates: 100 * 0.9 = 90
       ↓
   Function returns: 90
       ↓
User ← Gets result: 90
```

### Procedure Call Flow
```
User → CALL update_inventory(item_id=5, qty=100)
       ↓
   Procedure receives: item_id=5, qty=100
       ↓
   Procedure validates: Check if item exists
       ↓
   Procedure updates: UPDATE inventory SET quantity=100
       ↓
   Procedure logs: INSERT INTO audit_log
       ↓
User ← Gets confirmation: "Inventory updated"
```

## ⚠️ Common Mistakes to Avoid

### 1. Forgetting RETURN Statement
```sql
-- ❌ WRONG - Function must return
CREATE FUNCTION get_price(film_id INT)
RETURNS NUMERIC AS $$
DECLARE
    price NUMERIC;
BEGIN
    SELECT rental_rate INTO price FROM film WHERE film_id = film_id;
    -- Missing RETURN!
END;
$$ LANGUAGE plpgsql;

-- ✅ CORRECT
CREATE FUNCTION get_price(film_id INT)
RETURNS NUMERIC AS $$
DECLARE
    price NUMERIC;
BEGIN
    SELECT rental_rate INTO price FROM film WHERE film.film_id = get_price.film_id;
    RETURN price;  -- Always return!
END;
$$ LANGUAGE plpgsql;
```

### 2. Name Collision (Parameter vs Column)
```sql
-- ❌ WRONG - Ambiguous reference
CREATE FUNCTION get_customer_name(customer_id INT)
RETURNS TEXT AS $$
DECLARE
    name TEXT;
BEGIN
    -- Which customer_id? Parameter or column?
    SELECT first_name INTO name FROM customer WHERE customer_id = customer_id;
    RETURN name;
END;
$$ LANGUAGE plpgsql;

-- ✅ CORRECT - Qualify with table name or function name
CREATE FUNCTION get_customer_name(customer_id INT)
RETURNS TEXT AS $$
DECLARE
    name TEXT;
BEGIN
    SELECT first_name INTO name 
    FROM customer c
    WHERE c.customer_id = get_customer_name.customer_id;
    RETURN name;
END;
$$ LANGUAGE plpgsql;
```

### 3. Not Handling NULL Values
```sql
-- ❌ RISKY - Doesn't handle NULL
CREATE FUNCTION calculate_percentage(part NUMERIC, total NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (part / total) * 100;  -- What if total is 0 or NULL?
END;
$$ LANGUAGE plpgsql;

-- ✅ CORRECT - Proper NULL and zero handling
CREATE FUNCTION calculate_percentage(part NUMERIC, total NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    IF total IS NULL OR total = 0 THEN
        RETURN NULL;
    END IF;
    
    IF part IS NULL THEN
        RETURN 0;
    END IF;
    
    RETURN ROUND((part / total) * 100, 2);
END;
$$ LANGUAGE plpgsql;
```

### 4. Using Functions When Procedures Are Needed
```sql
-- ❌ WRONG - Function trying to modify data
CREATE FUNCTION delete_old_rentals()  -- Functions shouldn't modify data
RETURNS INTEGER AS $$
BEGIN
    DELETE FROM rental WHERE rental_date < CURRENT_DATE - INTERVAL '5 years';
    RETURN 1;
END;
$$ LANGUAGE plpgsql;

-- ✅ CORRECT - Use procedure for modifications
CREATE PROCEDURE archive_old_rentals()
AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM rental WHERE rental_date < CURRENT_DATE - INTERVAL '5 years';
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RAISE NOTICE 'Archived % old rentals', deleted_count;
END;
$$ LANGUAGE plpgsql;
```

### 5. Not Validating Input
```sql
-- ❌ RISKY - No validation
CREATE PROCEDURE update_rental_rate(film_id INT, new_rate NUMERIC)
AS $$
BEGIN
    UPDATE film SET rental_rate = new_rate WHERE film.film_id = film_id;
END;
$$ LANGUAGE plpgsql;

-- ✅ CORRECT - Validate inputs
CREATE PROCEDURE update_rental_rate(film_id INT, new_rate NUMERIC)
AS $$
BEGIN
    -- Check if rate is valid
    IF new_rate IS NULL OR new_rate <= 0 OR new_rate > 100 THEN
        RAISE EXCEPTION 'Invalid rental rate: %', new_rate;
    END IF;
    
    -- Check if film exists
    IF NOT EXISTS (SELECT 1 FROM film WHERE film.film_id = update_rental_rate.film_id) THEN
        RAISE EXCEPTION 'Film ID % not found', film_id;
    END IF;
    
    -- Perform update
    UPDATE film SET rental_rate = new_rate WHERE film.film_id = update_rental_rate.film_id;
    RAISE NOTICE 'Updated film % rate to $%', film_id, new_rate;
END;
$$ LANGUAGE plpgsql;
```

## 💡 Tips for Success

### Design Tips
1. **Single Responsibility**: Each function/procedure should do one thing well
2. **Meaningful Names**: Use descriptive names (`get_customer_total_spent` not `func1`)
3. **Document Parameters**: Add comments explaining what each parameter does
4. **Return Types**: Choose the most appropriate return type for your data

### Performance Tips
1. **Use RETURN QUERY**: For table-returning functions, more efficient than loops
2. **Minimize Queries**: Combine operations when possible
3. **Index Aware**: Consider how your function uses indexes
4. **Avoid SELECT ***: Only select columns you need

### Debugging Tips
1. **Use RAISE NOTICE**: Add debug messages during development
   ```sql
   RAISE NOTICE 'Processing customer %', customer_id;
   RAISE NOTICE 'Total calculated: %', total;
   ```

2. **Test Incrementally**: Build and test small pieces first
3. **Check Return Values**: Always verify your function returns what you expect
4. **Handle Edge Cases**: Test with NULL, zero, negative, very large values

### Code Organization
1. **Helper Functions First**: Create small utility functions, then build on them
2. **Logical Grouping**: Keep related functions together
3. **Consistent Style**: Use consistent naming and formatting
4. **Version Control**: Keep track of changes to your functions

## 🚀 Best Practices

### 1. Use Proper Error Handling
```sql
CREATE FUNCTION get_customer_info(cust_id INTEGER)
RETURNS TEXT AS $$
DECLARE
    info TEXT;
BEGIN
    SELECT first_name || ' ' || last_name INTO STRICT info
    FROM customer
    WHERE customer_id = cust_id;
    
    RETURN info;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Customer not found';
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'Data integrity error: duplicate customer ID';
END;
$$ LANGUAGE plpgsql;
```

### 2. Document Your Functions
```sql
-- Function: calculate_late_fee
-- Purpose: Calculate late fees for overdue rentals
-- Parameters:
--   days_late: Number of days past due date
--   rental_rate: Original rental rate of the film
-- Returns: Late fee amount (NUMERIC)
-- Business Rule: $1.50 per day, max $50
CREATE FUNCTION calculate_late_fee(days_late INTEGER, rental_rate NUMERIC)
RETURNS NUMERIC AS $$
DECLARE
    fee NUMERIC;
    max_fee NUMERIC := 50.00;
BEGIN
    IF days_late <= 0 THEN
        RETURN 0;
    END IF;
    
    fee := days_late * 1.50;
    
    -- Apply maximum cap
    IF fee > max_fee THEN
        fee := max_fee;
    END IF;
    
    RETURN fee;
END;
$$ LANGUAGE plpgsql;
```

### 3. Use Transactions in Procedures
```sql
CREATE PROCEDURE transfer_inventory(
    from_store INTEGER,
    to_store INTEGER,
    item_inventory_id INTEGER
)
AS $$
BEGIN
    -- Validate source store has item
    IF NOT EXISTS (
        SELECT 1 FROM inventory 
        WHERE inventory_id = item_inventory_id 
        AND store_id = from_store
    ) THEN
        RAISE EXCEPTION 'Item not found in source store';
    END IF;
    
    -- Perform transfer
    UPDATE inventory
    SET store_id = to_store,
        last_update = CURRENT_TIMESTAMP
    WHERE inventory_id = item_inventory_id;
    
    RAISE NOTICE 'Transferred inventory % from store % to store %',
                 item_inventory_id, from_store, to_store;
END;
$$ LANGUAGE plpgsql;
```

## 📖 Additional Resources

### PostgreSQL Documentation
- [PL/pgSQL Functions](https://www.postgresql.org/docs/current/plpgsql.html)
- [CREATE FUNCTION](https://www.postgresql.org/docs/current/sql-createfunction.html)
- [CREATE PROCEDURE](https://www.postgresql.org/docs/current/sql-createprocedure.html)

### Useful Queries
```sql
-- List all functions
SELECT routine_name, routine_type, data_type
FROM information_schema.routines
WHERE routine_schema = 'public' AND routine_type = 'FUNCTION';

-- List all procedures  
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'public' AND routine_type = 'PROCEDURE';

-- View function definition
SELECT pg_get_functiondef(oid)
FROM pg_proc
WHERE proname = 'your_function_name';

-- Drop a function
DROP FUNCTION IF EXISTS function_name(parameter_types);

-- Drop a procedure
DROP PROCEDURE IF EXISTS procedure_name(parameter_types);
```

## 🛠️ Lab Exercises Overview

This lab contains **6 progressive sections** covering:

1. **Basic Scalar Functions** (20 points) - Simple calculations and transformations
2. **Functions with Database Queries** (20 points) - Retrieving and processing data
3. **Table-Returning Functions** (20 points) - Multi-row result sets
4. **Validation Functions** (15 points) - Business rules and data validation
5. **Basic Procedures** (15 points) - Data modification operations
6. **Advanced Procedures** (10 points) - Complex multi-step operations

**Bonus Challenges**: +10 points for advanced implementations

**Total Points**: 100 base points + 10 bonus = **110 points possible**

## ⏱️ Time Estimate
- **Reading & Understanding**: 30 minutes
- **Basic Functions (Parts 1-2)**: 30 minutes
- **Table Functions (Part 3)**: 25 minutes
- **Validation & Procedures (Parts 4-5)**: 35 minutes
- **Advanced Procedures (Part 6)**: 20 minutes
- **Testing & Verification**: 20 minutes
- **Total**: Approximately **2.5-3 hours**

## 📋 Pre-Lab Checklist
Before starting, ensure you have:
- [ ] Access to PostgreSQL database with Pagila schema
- [ ] Database connection configured in VS Code or psql
- [ ] Reviewed PL/pgSQL basics from Lab 03
- [ ] Basic understanding of functions vs procedures
- [ ] SQL editor ready for writing and testing code

## ✅ Grading Rubric

### Functionality (70%)
- **Correct Implementation** (40%): Code works as specified
- **Proper Return Types** (15%): Functions return correct data types
- **Parameter Handling** (15%): Correct use of parameters

### Code Quality (20%)
- **Error Handling** (7%): Proper exception handling
- **Validation** (7%): Input validation where needed
- **Code Clarity** (6%): Readable and well-structured

### Best Practices (10%)
- **Naming Conventions** (3%): Clear, descriptive names
- **Comments** (3%): Adequate documentation
- **Type Safety** (4%): Proper use of %TYPE and type declarations

### Bonus Points (10%)
- **Advanced Features**: Extra credit for going beyond requirements
- **Optimization**: Efficient implementations
- **Creativity**: Novel solutions to problems

## 📤 Submission Instructions

1. **Complete the SQL file**: Fill in all `___` placeholders
2. **Test thoroughly**: Verify each function/procedure works correctly
3. **Document your work**: Add comments explaining complex logic
4. **Submit files**:
   - `Lab-04-procedures-functions.sql` (your completed work)
   - Optional: Screenshots of successful test outputs

## 🎓 Learning Outcomes

After completing this lab, you will be able to:
- ✅ Distinguish between functions and procedures
- ✅ Create functions that encapsulate business logic
- ✅ Build reusable database utilities
- ✅ Implement data validation at the database level
- ✅ Design procedures for complex operations
- ✅ Apply functions in SELECT statements and WHERE clauses
- ✅ Handle errors gracefully in procedural code
- ✅ Optimize database applications with stored logic

---

**Ready to begin?** Open `Lab-04-procedures-functions.sql` and start coding! 🚀

**Remember**: Functions RETURN values, Procedures PERFORM actions!
