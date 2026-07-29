# Lab 03: Introduction to PL/pgSQL and Cursors

## 🎯 Learning Objectives
By completing this lab, you will:
- Master PL/pgSQL procedural language basics
- Declare and use variables with proper type safety
- Implement control structures (IF, LOOP, FOR, WHILE)
- Create and use cursors for row-by-row processing
- Understand when to use cursors vs set-based operations
- Implement parameterized and nested cursors
- Handle exceptions and errors gracefully
- Apply PL/pgSQL to real-world business scenarios

## 📚 Theory Overview

### What is PL/pgSQL?
PL/pgSQL (Procedural Language/PostgreSQL) is PostgreSQL's procedural programming language that extends SQL with:
- **Variables and Data Types**: Store and manipulate data
- **Control Structures**: IF/ELSE, loops, conditionals
- **Exception Handling**: Robust error management
- **Cursors**: Row-by-row result set processing
- **Functions and Procedures**: Reusable code blocks

### DO Blocks
DO blocks allow you to execute PL/pgSQL code without creating a permanent function:
```sql
DO $$
DECLARE
    -- Variable declarations
BEGIN
    -- Executable code
EXCEPTION
    -- Error handling
END $$;
```

**Key Components:**
- `$$` - Dollar-quoted string delimiter
- `DECLARE` - Variable declaration section (optional)
- `BEGIN...END` - Executable code block
- `EXCEPTION` - Error handling section (optional)

### Variables and Type Safety

**Declaration Syntax:**
```sql
DECLARE
    customer_name VARCHAR(100);           -- Fixed type
    rental_count INTEGER := 0;            -- With initialization
    customer_email customer.email%TYPE;   -- Copy column type
    film_rec RECORD;                      -- Flexible row container
```

**Benefits of %TYPE:**
- Automatic type matching with table columns
- Schema change safety
- Self-documenting code
- Prevents type mismatch errors

### SELECT INTO
Load query results into variables:
```sql
SELECT column1, column2
INTO variable1, variable2
FROM table
WHERE condition;
```

**STRICT keyword:**
- `SELECT INTO` - Returns first row if multiple, NULL if none
- `SELECT INTO STRICT` - Raises exception if 0 or >1 rows
- **Best Practice**: Use STRICT when expecting exactly one row

### Control Structures

#### IF Statement
```sql
IF condition THEN
    -- statements
ELSIF another_condition THEN
    -- statements
ELSE
    -- statements
END IF;
```

#### FOR Loop (Integer Range)
```sql
FOR counter IN 1..10 LOOP
    -- statements using counter
END LOOP;
```

#### FOR Loop (Query Results)
```sql
FOR record_var IN query LOOP
    -- process record_var.column_name
END LOOP;
```

#### WHILE Loop
```sql
WHILE condition LOOP
    -- statements
    -- update condition variable
END LOOP;
```

### What Are Cursors?

**Definition**: A cursor is a database object that allows you to retrieve and process query results **one row at a time**, rather than all at once.

**Think of it like:**
- A **pointer** that moves through your result set
- A **bookmark** in a book that helps you process page by page
- A **scanner** that reads items one by one

### When to Use Cursors

✅ **Use Cursors When:**
- You need different actions per row based on complex conditions
- Processing requires multiple steps per row
- You need to track state between rows
- Early exit after finding specific data
- Memory constraints with large result sets
- Row-by-row updates with different logic per row

❌ **DON'T Use Cursors When:**
- Simple aggregations (use `SUM`, `AVG`, `COUNT`)
- Set-based updates (use `UPDATE...WHERE`)
- Simple filtering (use `WHERE` clauses)
- Bulk operations (use set-based SQL)

**Golden Rule**: *Try SQL first. Use cursors only when SQL can't do it.*

### Cursor Types

#### 1. Simple FOR Loop Cursor (RECOMMENDED)
**Best for**: 80% of cursor use cases
```sql
DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT * FROM table WHERE condition LOOP
        -- Process rec.column_name
    END LOOP;
END $$;
```

**Advantages:**
- Simplest syntax
- Automatic OPEN/CLOSE
- No manual memory management
- Forward-only iteration

#### 2. Named Cursor with FOR Loop
**Best for**: When you need reusability or parameters
```sql
DO $$
DECLARE
    my_cursor CURSOR FOR SELECT * FROM table;
    rec RECORD;
BEGIN
    FOR rec IN my_cursor LOOP
        -- Process rec
    END LOOP;
END $$;
```

#### 3. Manual Cursor Management
**Best for**: When you need fine control (scrolling, specific fetches)
```sql
DO $$
DECLARE
    my_cursor CURSOR FOR SELECT * FROM table;
    rec RECORD;
BEGIN
    OPEN my_cursor;
    LOOP
        FETCH my_cursor INTO rec;
        EXIT WHEN NOT FOUND;
        -- Process rec
    END LOOP;
    CLOSE my_cursor;
END $$;
```

### Parameterized Cursors

Reusable cursors with parameters (like functions):

```sql
DO $$
DECLARE
    -- Cursor with ONE parameter
    films_by_rating CURSOR(p_rating TEXT) FOR 
        SELECT * FROM film WHERE rating = p_rating;
    
    -- Cursor with MULTIPLE parameters  
    filtered_films CURSOR(min_rate DECIMAL, min_length INT) FOR
        SELECT * FROM film 
        WHERE rental_rate >= min_rate AND length >= min_length;
    
    rec RECORD;
BEGIN
    -- Use with parameter
    FOR rec IN films_by_rating('PG') LOOP
        RAISE NOTICE '%', rec.title;
    END LOOP;
    
    -- Reuse with different parameter
    FOR rec IN films_by_rating('R') LOOP
        RAISE NOTICE '%', rec.title;
    END LOOP;
END $$;
```

### Nested Cursors

Cursor within cursor (use sparingly - performance impact!):

```sql
DO $$
DECLARE
    category_cursor CURSOR FOR SELECT * FROM category LIMIT 3;
    film_cursor CURSOR(cat_id INT) FOR 
        SELECT * FROM film WHERE category_id = cat_id LIMIT 5;
    
    cat_rec RECORD;
    film_rec RECORD;
BEGIN
    -- Outer loop: categories
    FOR cat_rec IN category_cursor LOOP
        RAISE NOTICE 'Category: %', cat_rec.name;
        
        -- Inner loop: films in this category
        FOR film_rec IN film_cursor(cat_rec.category_id) LOOP
            RAISE NOTICE '  Film: %', film_rec.title;
        END LOOP;
    END LOOP;
END $$;
```

### Exception Handling

Handle errors gracefully:

```sql
DO $$
DECLARE
    customer_rec RECORD;
BEGIN
    SELECT * INTO STRICT customer_rec
    FROM customer
    WHERE customer_id = 99999;  -- Doesn't exist
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Customer not found!';
        -- Fallback logic
        
    WHEN TOO_MANY_ROWS THEN
        RAISE NOTICE 'Multiple customers found!';
        
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;
```

**Common Exception Names:**
- `NO_DATA_FOUND` - SELECT INTO found no rows (with STRICT)
- `TOO_MANY_ROWS` - SELECT INTO found multiple rows (with STRICT)
- `DIVISION_BY_ZERO` - Arithmetic error
- `OTHERS` - Catch-all for any exception

### Performance Tips

1. **Always Test with LIMIT First**
   ```sql
   FOR rec IN SELECT * FROM large_table LIMIT 10 LOOP
   ```

2. **Show Progress for Long Operations**
   ```sql
   IF counter % 100 = 0 THEN
       RAISE NOTICE 'Processed % rows...', counter;
   END IF;
   ```

3. **Use Appropriate Cursor Type**
   - Simple FOR loop → Fastest for forward-only
   - Named cursor → When you need parameters/reuse
   - Manual cursor → Only when you need backward navigation

4. **Exit Early When Possible**
   ```sql
   EXIT WHEN condition_met;  -- Stop processing
   ```

5. **Prefer Set-Based Operations**
   ```sql
   -- ❌ DON'T: Loop to sum
   FOR rec IN SELECT amount FROM payment LOOP
       total := total + rec.amount;
   END LOOP;
   
   -- ✅ DO: Use SQL aggregate
   SELECT SUM(amount) INTO total FROM payment;
   ```

### Common Mistakes to Avoid

#### ❌ Mistake 1: Forgetting EXIT Condition
```sql
-- Infinite loop!
LOOP
    FETCH cursor INTO rec;
    -- Forgot: EXIT WHEN NOT FOUND;
END LOOP;
```

#### ❌ Mistake 2: Using Cursor When SQL Would Work
```sql
-- DON'T do this with cursor:
total := 0;
FOR rec IN SELECT amount FROM payment LOOP
    total := total + rec.amount;
END LOOP;

-- DO this instead:
SELECT SUM(amount) INTO total FROM payment;
```

#### ❌ Mistake 3: No Error Handling in Production
```sql
-- Risky - one error crashes everything
FOR rec IN SELECT * FROM customer LOOP
    -- Complex processing
END LOOP;

-- Better - wrap in exception handler
BEGIN
    FOR rec IN SELECT * FROM customer LOOP
        -- Processing
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
```

### Debugging Tips

```sql
DO $$
DECLARE
    counter INTEGER := 0;
BEGIN
    RAISE NOTICE 'Starting processing...';
    
    FOR rec IN SELECT * FROM table LOOP
        counter := counter + 1;
        
        -- Checkpoint
        IF counter % 10 = 0 THEN
            RAISE NOTICE 'Checkpoint: % rows processed', counter;
        END IF;
        
        -- Debug specific row
        IF rec.id = 42 THEN
            RAISE NOTICE 'Debug row 42: %', rec;
        END IF;
    END LOOP;
    
    RAISE NOTICE 'Complete: % total rows', counter;
END $$;
```

## 🛠️ Lab Structure

### Part 1: PL/pgSQL Basics (25 points)
- DO blocks with variables
- Using %TYPE for type safety
- SELECT INTO for data retrieval
- Conditional logic with IF statements
- Simple FOR loops

### Part 2: Working with Query Results (25 points)
- FOR loops with RECORD type
- Processing with accumulation
- Customer spending analysis
- WHILE loops

### Part 3: Cursor Basics (20 points)
- Simple cursor with FOR loop
- Direct query in FOR loop
- Manual cursor management
- Cursors with conditional processing

### Part 4: Parameterized Cursors (15 points)
- Single parameter cursors
- Multiple parameter cursors
- Reusable cursors

### Part 5: Advanced Cursor Scenarios (15 points)
- Nested cursors
- Early exit from cursor loop
- Cursor with progress tracking

### Part 6: Exception Handling (10 points)
- Handling NO_DATA_FOUND
- Handling TOO_MANY_ROWS

### Part 7: Real-World Business Scenario (10 points)
- Comprehensive monthly revenue report
- Multiple cursor techniques combined
- Business logic implementation

### Bonus Challenges (10 extra points)
- Inventory alert system
- Customer loyalty scoring

## 📊 Grading Rubric

| Category | Points | Criteria |
|----------|--------|----------|
| **Part 1: Basics** | 25 | Correct variable declarations, SELECT INTO usage, control structures |
| **Part 2: Query Results** | 25 | FOR loops with RECORD, accumulation logic, WHILE loops |
| **Part 3: Cursor Basics** | 20 | Simple cursors, direct queries, manual management |
| **Part 4: Parameterized** | 15 | Single/multiple parameters, cursor reusability |
| **Part 5: Advanced** | 15 | Nested cursors, early exit, progress tracking |
| **Part 6: Exceptions** | 10 | Proper exception handling, fallback logic |
| **Part 7: Business Scenario** | 10 | Complete working solution, accurate results |
| **Code Quality** | 10 | Comments, formatting, variable naming |
| **Bonus Challenges** | +10 | Extra credit for optional exercises |
| **Total** | **130** | (120 base + 10 bonus) |

### Grading Scale
- **A (90-100%)**: Exceptional work, all exercises complete, clean code
- **B (80-89%)**: Good work, minor issues, most exercises complete
- **C (70-79%)**: Satisfactory, some exercises incomplete or errors
- **D (60-69%)**: Needs improvement, significant gaps
- **F (<60%)**: Incomplete or major errors

## 🚀 Getting Started

1. **Connect to Pagila Database**
   ```sql
   -- Verify connection
   SELECT current_database(), current_user;
   ```

2. **Test PL/pgSQL**
   ```sql
   DO $$ 
   BEGIN 
       RAISE NOTICE 'PL/pgSQL is working!'; 
   END $$;
   ```

3. **Open Lab File**
   - Open `Lab-03-intro-plpgsql-cursors.sql`
   - Read through the entire file first
   - Complete exercises in order

4. **Test Incrementally**
   - Complete one exercise at a time
   - Run it to verify it works
   - Move to the next exercise

## 💡 Tips for Success

1. **Read the demos first** (`pl-pgsql.sql` and `cursors.sql` in demos folder)
2. **Start simple** - Get basic DO blocks working before complex cursors
3. **Use LIMIT** - Always test with small datasets first
4. **Add RAISE NOTICE** - Use liberally for debugging
5. **Check syntax** - Semicolons, END IF, END LOOP, etc.
6. **Test each exercise** - Don't move on until it works
7. **Comment your code** - Explain your logic
8. **Handle errors** - Add EXCEPTION blocks to production code

## 📖 Resources

### In This Repository
- `demos/05-intro-plpgsql/pl-pgsql.sql` - Complete PL/pgSQL examples
- `demos/06-cursors/cursors.sql` - Comprehensive cursor guide
- Lecture slides in `DB2-Site/Slides/`

### PostgreSQL Documentation
- [PL/pgSQL - SQL Procedural Language](https://www.postgresql.org/docs/current/plpgsql.html)
- [PL/pgSQL Control Structures](https://www.postgresql.org/docs/current/plpgsql-control-structures.html)
- [PL/pgSQL Cursors](https://www.postgresql.org/docs/current/plpgsql-cursors.html)
- [Error Handling](https://www.postgresql.org/docs/current/plpgsql-errors-and-messages.html)

## ⏱️ Time Management

Suggested time allocation (120 minutes total):
- Part 1: 20 minutes
- Part 2: 25 minutes
- Part 3: 20 minutes
- Part 4: 15 minutes
- Part 5: 15 minutes
- Part 6: 10 minutes
- Part 7: 15 minutes
- Bonus: Extra time if available

## 🆘 Getting Help

If you get stuck:

1. **Check the demos** - Most patterns are demonstrated
2. **Read error messages** - PostgreSQL errors are descriptive
3. **Use RAISE NOTICE** - Debug by printing variable values
4. **Simplify** - Break complex logic into smaller steps
5. **Test queries separately** - Verify SQL works before adding to PL/pgSQL
6. **Ask for help** - Don't spend too long on one exercise

## 📝 Submission Instructions

1. **Complete all exercises** in `Lab-03-intro-plpgsql-cursors.sql`
2. **Test everything** - Ensure all DO blocks execute without errors
3. **Add comments** - Include your output as comments below each exercise
4. **Save as**: `Lab-03-intro-plpgsql-cursors-YOURNAME.sql`
5. **Submit** via the course platform by the deadline

## ✅ Pre-Submission Checklist

Before submitting, verify:
- [ ] All TODO sections completed
- [ ] All DO blocks execute without syntax errors
- [ ] Output messages are clear and well-formatted
- [ ] Variable names are descriptive
- [ ] Complex logic has comments
- [ ] Exception handling implemented where required
- [ ] Cursors properly closed (if manual management)
- [ ] Tested each exercise individually
- [ ] Business scenario produces accurate, complete report
- [ ] File renamed with your name
- [ ] Ready to submit!

## 🎓 Learning Outcomes

After completing this lab, you should be able to:
- ✅ Write PL/pgSQL DO blocks with proper structure
- ✅ Declare and use variables with type safety
- ✅ Retrieve data with SELECT INTO
- ✅ Implement control structures (IF, FOR, WHILE)
- ✅ Create and use cursors effectively
- ✅ Understand when to use cursors vs SQL
- ✅ Implement parameterized and nested cursors
- ✅ Handle exceptions and errors gracefully
- ✅ Apply PL/pgSQL to real business problems
- ✅ Debug and troubleshoot procedural code

Good luck! 🚀

---

**Questions?** Contact your instructor or post in the course forum.

**Deadline**: Check course platform for submission deadline.
