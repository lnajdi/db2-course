# PostgreSQL Procedures and Functions Quiz - Structured Content

## Quiz Overview
- **Topic**: PostgreSQL Stored Procedures and Functions
- **Total Questions**: 20
- **Question Types**: Multiple Choice and True/False
- **Difficulty Distribution**: 30% Easy, 40% Medium, 30% Hard
- **Time Estimate**: 25-30 minutes

---

## Question 1 (Easy - Multiple Choice)
**Question**: What is the primary difference between a PostgreSQL function and a stored procedure?
**Options**:
A. Functions are faster than procedures
B. Functions must return a value, procedures may not return anything
C. Procedures can only be written in PL/pgSQL, functions can use any language
D. There is no difference, they are synonyms

**Correct Answer**: B
**Hint**: Think about what each one is designed to produce or accomplish.
**Explanation**: Functions must return a value and can be used in expressions and SELECT statements, while procedures perform operations and may not return anything, being called with the CALL statement.

---

## Question 2 (Easy - Multiple Choice)
**Question**: Which command is used to execute a stored procedure in PostgreSQL?
**Options**:
A. EXECUTE procedure_name()
B. RUN procedure_name()
C. CALL procedure_name()
D. SELECT procedure_name()

**Correct Answer**: C
**Hint**: Think about the SQL standard command for invoking procedures.
**Explanation**: The CALL statement is used to execute stored procedures in PostgreSQL. Functions are invoked in SELECT statements or expressions, but procedures require CALL.

---

## Question 3 (Easy - True/False)
**Question**: PostgreSQL functions can be used in WHERE clauses and SELECT statements.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Consider how functions integrate with SQL expressions.
**Explanation**: True. Functions can be used anywhere expressions are allowed, including WHERE clauses, SELECT lists, JOIN conditions, and other SQL contexts.

---

## Question 4 (Medium - Multiple Choice)
**Question**: What does the RETURNS TABLE syntax allow a function to do?
**Options**:
A. Return a single row with multiple columns
B. Return multiple rows with a predefined column structure
C. Return a JSON object representing a table
D. Return metadata about an existing table

**Correct Answer**: B
**Hint**: Think about table-valued functions and their output structure.
**Explanation**: RETURNS TABLE allows a function to return multiple rows with a predefined column structure, essentially acting like a parameterized view.

---

## Question 5 (Medium - Multiple Choice)
**Question**: Which of these is a valid way to create a simple SQL function that calculates tax?
**Options**:
A. CREATE FUNCTION calc_tax(amount DECIMAL) RETURNS DECIMAL AS 'SELECT amount * 0.08' LANGUAGE SQL;
B. CREATE FUNCTION calc_tax(amount DECIMAL) RETURNS DECIMAL BEGIN SELECT amount * 0.08; END;
C. CREATE FUNCTION calc_tax(amount DECIMAL) AS SELECT amount * 0.08;
D. FUNCTION calc_tax(amount DECIMAL) RETURNS DECIMAL = amount * 0.08;

**Correct Answer**: A
**Hint**: Think about the complete syntax for creating SQL language functions.
**Explanation**: Option A shows the correct syntax: CREATE FUNCTION with RETURNS clause, function body in quotes, and LANGUAGE specification.

---

## Question 6 (Medium - True/False)
**Question**: Stored procedures in PostgreSQL can manage their own transactions using COMMIT and ROLLBACK.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Think about what procedures can do that functions cannot.
**Explanation**: True. Stored procedures can control transactions using COMMIT, ROLLBACK, and transaction management, while functions cannot control transactions.

---

## Question 7 (Hard - Multiple Choice)
**Question**: What happens when you call a function that has side effects (like INSERT/UPDATE) from within a SELECT statement?
**Options**:
A. PostgreSQL prevents this and throws an error
B. The side effects execute once for each row processed
C. The side effects are ignored in SELECT contexts
D. The function is automatically converted to read-only mode

**Correct Answer**: B
**Hint**: Consider how functions are evaluated in the context of row processing.
**Explanation**: Functions with side effects will execute those side effects for each row they process, which can lead to unexpected behavior. It's generally recommended to keep functions pure (without side effects).

---

## Question 8 (Hard - Multiple Choice)
**Question**: In this function definition, what will happen if no rows are found?
```sql
CREATE OR REPLACE FUNCTION get_customer_email(cust_id INTEGER)
RETURNS VARCHAR(50) AS $$
DECLARE
    email_addr VARCHAR(50);
BEGIN
    SELECT email INTO email_addr FROM customer WHERE customer_id = cust_id;
    RETURN email_addr;
END;
$$ LANGUAGE plpgsql;
```
**Options**:
A. An exception will be raised
B. The function will return NULL
C. The function will return an empty string
D. The function will return the default value for VARCHAR

**Correct Answer**: B
**Hint**: Think about PL/pgSQL's behavior when SELECT INTO finds no rows.
**Explanation**: When SELECT INTO finds no rows, the target variable is set to NULL, and the function returns NULL. No exception is raised automatically.

---

## Question 9 (Medium - Multiple Choice)
**Question**: What is the difference between LANGUAGE SQL and LANGUAGE plpgsql in function creation?
**Options**:
A. SQL functions are faster, plpgsql functions are more flexible
B. SQL functions can only do simple calculations, plpgsql can use control structures
C. SQL functions are read-only, plpgsql functions can modify data
D. Both A and B are correct

**Correct Answer**: D
**Hint**: Think about the capabilities and performance characteristics of each language.
**Explanation**: SQL functions are generally faster for simple operations and are limited to SQL expressions, while plpgsql functions offer full procedural capabilities including variables, loops, and complex logic.

---

## Question 10 (Easy - True/False)
**Question**: You can overload functions in PostgreSQL by creating multiple functions with the same name but different parameter types.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Think about how PostgreSQL distinguishes between functions with the same name.
**Explanation**: True. PostgreSQL supports function overloading, allowing multiple functions with the same name as long as they have different parameter types or numbers of parameters.

---

## Question 11 (Hard - Multiple Choice)
**Question**: What is the purpose of the SECURITY DEFINER option when creating functions?
**Options**:
A. It makes the function run faster by bypassing security checks
B. It makes the function execute with the privileges of the function creator
C. It prevents unauthorized users from calling the function
D. It encrypts the function definition in the database

**Correct Answer**: B
**Hint**: Think about whose permissions are used when the function executes.
**Explanation**: SECURITY DEFINER makes the function execute with the privileges of the user who created it, not the user who calls it. This is useful for controlled access to restricted operations.

---

## Question 12 (Medium - Multiple Choice)
**Question**: How do you return multiple values from a PL/pgSQL function?
**Options**:
A. Use multiple RETURN statements
B. Return a composite type or use OUT parameters
C. Use RETURN NEXT for each value
D. PostgreSQL functions can only return single values

**Correct Answer**: B
**Hint**: Think about structured ways to package multiple values together.
**Explanation**: You can return multiple values by defining a composite type or using OUT parameters in the function signature, or by using RETURNS TABLE for tabular results.

---

## Question 13 (Easy - Multiple Choice)
**Question**: Which keyword is used to make a function replace an existing function with the same name and parameters?
**Options**:
A. CREATE FUNCTION
B. ALTER FUNCTION
C. CREATE OR REPLACE FUNCTION
D. UPDATE FUNCTION

**Correct Answer**: C
**Hint**: Think about the standard SQL pattern for creating objects that might already exist.
**Explanation**: CREATE OR REPLACE FUNCTION will create a new function or replace an existing one with the same name and parameter signature.

---

## Question 14 (Hard - True/False)
**Question**: PostgreSQL functions can modify the parameters passed to them if the parameters are declared with INOUT mode.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Consider the different parameter modes available in PostgreSQL functions.
**Explanation**: True. INOUT parameters allow functions to both receive input values and return modified values through the same parameter, effectively allowing parameter modification.

---

## Question 15 (Medium - Multiple Choice)
**Question**: What is the correct way to handle exceptions in a PL/pgSQL function?
**Options**:
A. Use TRY...CATCH blocks
B. Use EXCEPTION WHEN clauses in a BEGIN...END block
C. Use IF statements to check for errors
D. PostgreSQL functions cannot handle exceptions

**Correct Answer**: B
**Hint**: Think about PL/pgSQL's specific syntax for exception handling.
**Explanation**: PL/pgSQL uses EXCEPTION WHEN clauses within BEGIN...END blocks to handle exceptions, similar to try-catch but with PostgreSQL-specific syntax.

---

## Question 16 (Medium - True/False)
**Question**: Function parameters in PostgreSQL are passed by reference, so modifying them inside the function changes the original values.
**Options**:
A. True
B. False

**Correct Answer**: B
**Hint**: Consider how PostgreSQL handles parameter passing by default.
**Explanation**: False. By default, PostgreSQL function parameters are passed by value (IN mode), so modifications inside the function don't affect the original values unless using INOUT or OUT parameters.

---

## Question 17 (Hard - Multiple Choice)
**Question**: When should you use a stored procedure instead of a function?
**Options**:
A. When you need to return calculated values
B. When you need transaction control and complex workflows
C. When you want to use the result in a SELECT statement
D. When you need better performance

**Correct Answer**: B
**Hint**: Think about the unique capabilities that procedures offer over functions.
**Explanation**: Stored procedures are ideal for complex workflows that require transaction control, multiple operations, and side effects, while functions are better for calculations and operations that return values.

---

## Question 18 (Medium - Multiple Choice)
**Question**: What does the STABLE volatility category mean for a function?
**Options**:
A. The function might crash the database
B. The function returns the same result for the same inputs within a single statement
C. The function can only be called from stable connections
D. The function's definition cannot be changed

**Correct Answer**: B
**Hint**: Think about function optimization and when PostgreSQL can cache results.
**Explanation**: STABLE functions return the same result for the same inputs within a single statement, allowing PostgreSQL to optimize by potentially calling the function fewer times.

---

## Question 19 (Easy - True/False)
**Question**: You can create functions that return different data types based on runtime conditions.
**Options**:
A. True
B. False

**Correct Answer**: B
**Hint**: Think about PostgreSQL's type system and function signatures.
**Explanation**: False. PostgreSQL requires functions to have a fixed return type declared at creation time. The return type cannot change based on runtime conditions, though you can return different values of the same type.

---

## Question 20 (Hard - Multiple Choice)
**Question**: What is the main advantage of using SQL language functions over PL/pgSQL functions for simple calculations?
**Options**:
A. SQL functions can access more database features
B. SQL functions can be inlined by the query planner for better performance
C. SQL functions are more secure than PL/pgSQL functions
D. SQL functions can be used in more contexts

**Correct Answer**: B
**Hint**: Think about query optimization and how the planner can handle different function types.
**Explanation**: SQL functions can often be inlined by the PostgreSQL query planner, meaning their logic can be incorporated directly into the calling query for better optimization and performance.

---

## Scoring Guide

### Performance Levels:
- **18-20 correct (90-100%)**: Excellent! You have mastered PostgreSQL functions and procedures and can design effective database logic.
- **16-17 correct (80-89%)**: Very Good! You understand most concepts well with minor gaps in advanced topics.
- **14-15 correct (70-79%)**: Good! You grasp the fundamentals but should review parameter modes and exception handling.
- **12-13 correct (60-69%)**: Fair! Focus on the differences between functions and procedures, and their proper usage.
- **Below 12 correct (<60%)**: Needs Improvement! Review basic concepts of functions, procedures, and their syntax.

### Key Topics Covered:
- Functions vs Procedures (Purpose, Usage, Capabilities)
- Function Creation Syntax (RETURNS, LANGUAGE, Parameters)
- Parameter Modes (IN, OUT, INOUT)
- Return Types (Scalar, Composite, Table)
- Exception Handling in PL/pgSQL
- Function Volatility (VOLATILE, STABLE, IMMUTABLE)
- Security (SECURITY DEFINER vs INVOKER)
- Performance Considerations
- Transaction Control in Procedures
- Function Overloading and Best Practices
