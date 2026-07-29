# PostgreSQL Cursors Quiz - Structured Content

## Quiz Overview
- **Topic**: PostgreSQL Cursors and Row-by-Row Processing
- **Question Count**: 20 questions
- **Difficulty Distribution**: 7 Easy, 8 Medium, 5 Hard
- **Coverage**: Cursor concepts, operations, performance, and real-world applications

---

## Questions

### 1. What is a PostgreSQL cursor? (Easy)
**Question**: What is the primary purpose of a cursor in PostgreSQL?

**Options**:
A) To speed up database queries by caching results
B) To process result sets row by row instead of all at once  
C) To create temporary tables for complex operations
D) To manage database connections and transactions

**Correct Answer**: B) To process result sets row by row instead of all at once

**Hint**: Think about how cursors differ from regular SELECT statements in terms of data processing.

**Explanation**: A cursor allows you to traverse and process a result set one row at a time, maintaining a position in the result set. This is different from standard SELECT statements that return all rows simultaneously.

---

### 2. Which command is used to retrieve data from a cursor? (Easy)
**Question**: What command do you use to retrieve the next row from a cursor?

**Options**:
A) GET FROM cursor_name
B) FETCH cursor_name
C) SELECT FROM cursor_name  
D) RETRIEVE cursor_name

**Correct Answer**: B) FETCH cursor_name

**Hint**: This command literally means to go and get the next row from the cursor.

**Explanation**: FETCH is the standard SQL command used to retrieve rows from a cursor. You can FETCH one row at a time or multiple rows, and you can specify direction (NEXT, PRIOR, FIRST, LAST, etc.).

---

### 3. Cursors must always be used within a transaction block. (Easy)
**Question**: True or False: Cursors must be declared and used within a transaction block (BEGIN...COMMIT).

**Options**:
A) True
B) False

**Correct Answer**: A) True

**Hint**: Think about the lifecycle and scope of cursors in PostgreSQL.

**Explanation**: True. Cursors exist within the scope of a transaction. They are automatically closed when the transaction ends with COMMIT or ROLLBACK.

---

### 4. What does the SCROLL option do when declaring a cursor? (Medium)
**Question**: What capability does the SCROLL option provide when declaring a cursor?

**Options**:
A) It allows the cursor to process multiple tables simultaneously
B) It enables backward navigation and absolute positioning in the result set
C) It automatically closes the cursor when all rows are processed
D) It improves the performance of cursor operations

**Correct Answer**: B) It enables backward navigation and absolute positioning in the result set

**Hint**: Think about navigation directions and positioning capabilities.

**Explanation**: The SCROLL option makes a cursor scrollable, allowing you to move backward (FETCH PRIOR), jump to specific positions (FETCH ABSOLUTE n), and navigate in multiple directions, not just forward.

---

### 5. Which cursor attribute indicates if the last FETCH operation retrieved a row? (Medium)
**Question**: Which cursor attribute should you check to determine if the last FETCH operation successfully retrieved a row?

**Options**:
A) %ISOPEN
B) %ROWCOUNT
C) %FOUND
D) %STATUS

**Correct Answer**: C) %FOUND

**Hint**: Think about what you need to know after attempting to fetch a row.

**Explanation**: The %FOUND attribute returns TRUE if the last FETCH operation retrieved a row, and FALSE if no row was found. This is commonly used in loop exit conditions.

---

### 6. What is the correct way to loop through all rows in a cursor? (Medium)
**Question**: What is the standard pattern for processing all rows in a cursor using PL/pgSQL?

**Options**:
A) WHILE cursor_name%FOUND LOOP
B) FOR row_var IN cursor_name LOOP  
C) LOOP ... FETCH cursor_name ... EXIT WHEN NOT FOUND
D) Both B and C are correct

**Correct Answer**: D) Both B and C are correct

**Hint**: There are two common approaches for cursor loops in PL/pgSQL.

**Explanation**: You can use either a manual loop with FETCH and EXIT WHEN NOT FOUND, or the simplified cursor FOR loop syntax that automatically handles opening, fetching, and closing the cursor.

---

### 7. When should you use cursors instead of set-based operations? (Hard)
**Question**: In which scenario would cursors be most appropriate compared to set-based SQL operations?

**Options**:
A) When calculating simple aggregates like SUM or COUNT
B) When updating multiple rows with the same value
C) When applying complex row-by-row business logic that cannot be expressed in SQL
D) When joining multiple tables for reporting

**Correct Answer**: C) When applying complex row-by-row business logic that cannot be expressed in SQL

**Hint**: Consider when standard SQL set operations are insufficient.

**Explanation**: Cursors are most appropriate when you need to apply complex procedural logic to each row individually, especially when the logic cannot be efficiently expressed using standard SQL set-based operations.

---

### 8. What does FOR UPDATE do when used with a cursor declaration? (Medium)
**Question**: What is the purpose of the FOR UPDATE clause when declaring a cursor?

**Options**:
A) It automatically updates all rows in the result set
B) It locks the rows for exclusive access and allows updates via WHERE CURRENT OF
C) It creates an updatable view from the cursor results  
D) It enables automatic commit after each row update

**Correct Answer**: B) It locks the rows for exclusive access and allows updates via WHERE CURRENT OF

**Hint**: Think about row locking and the ability to modify rows through the cursor.

**Explanation**: FOR UPDATE locks the selected rows for exclusive access and enables you to update or delete the current row using WHERE CURRENT OF cursor_name syntax.

---

### 9. Cursor FOR loops automatically handle cursor opening and closing. (Easy)
**Question**: True or False: When using a cursor FOR loop, PostgreSQL automatically handles opening and closing the cursor.

**Options**:
A) True
B) False

**Correct Answer**: A) True

**Hint**: Consider the convenience features of cursor FOR loops.

**Explanation**: True. Cursor FOR loops automatically open the cursor at the beginning of the loop and close it at the end, simplifying cursor management and reducing the risk of resource leaks.

---

### 10. What happens if you forget to close an explicitly declared cursor? (Medium)
**Question**: What occurs if you explicitly declare and open a cursor but forget to close it?

**Options**:
A) The cursor remains open indefinitely and causes a memory leak
B) PostgreSQL automatically closes it when the function ends
C) The cursor is automatically closed when the transaction ends
D) An error is raised immediately

**Correct Answer**: C) The cursor is automatically closed when the transaction ends

**Hint**: Think about the relationship between cursor lifetime and transaction scope.

**Explanation**: PostgreSQL automatically closes all open cursors when the transaction ends (COMMIT or ROLLBACK), preventing permanent resource leaks, though it's still best practice to explicitly close cursors.

---

### 11. Which syntax creates a parameterized cursor? (Medium)
**Question**: How do you create a cursor that accepts parameters?

**Options**:
A) DECLARE cursor_name(param_name datatype) CURSOR FOR SELECT...
B) DECLARE cursor_name CURSOR(param_name datatype) FOR SELECT...  
C) DECLARE cursor_name CURSOR FOR SELECT... WHERE column = param_name
D) DECLARE cursor_name CURSOR WITH PARAMETERS(param_name datatype) FOR SELECT...

**Correct Answer**: B) DECLARE cursor_name CURSOR(param_name datatype) FOR SELECT...

**Hint**: The parameter list comes right after the CURSOR keyword.

**Explanation**: Parameterized cursors use the syntax CURSOR(parameter_list) where parameters are declared with their data types and can be referenced in the cursor's SELECT statement.

---

### 12. What is a REF CURSOR used for? (Hard)
**Question**: What is the primary purpose of REF CURSOR (cursor variables) in PostgreSQL?

**Options**:
A) To improve cursor performance through reference optimization
B) To create cursors that can be opened for different queries dynamically
C) To reference cursors declared in other functions
D) To create read-only cursors that cannot modify data

**Correct Answer**: B) To create cursors that can be opened for different queries dynamically

**Hint**: Think about dynamic SQL and runtime flexibility.

**Explanation**: REF CURSOR (REFCURSOR) allows you to create cursor variables that can be opened for different queries at runtime, providing flexibility for dynamic SQL operations.

---

### 13. The MOVE command in cursors changes position without retrieving data. (Easy)
**Question**: True or False: The MOVE command changes the cursor position without fetching data into variables.

**Options**:
A) True
B) False

**Correct Answer**: A) True

**Hint**: Think about the difference between positioning and retrieving data.

**Explanation**: True. MOVE changes the cursor position (forward, backward, to specific positions) without actually retrieving data into variables, unlike FETCH which both moves and retrieves.

---

### 14. In this code, what will happen when no more rows are available?

```sql
LOOP
    FETCH customer_cursor INTO customer_rec;
    -- Process customer_rec
    EXIT WHEN NOT FOUND;
END LOOP;
```

**Question**: What occurs when the FETCH statement cannot retrieve any more rows?

**Options**:
A) An exception is raised automatically
B) The FOUND variable becomes FALSE and the loop exits
C) The cursor automatically closes itself
D) The customer_rec variable is set to NULL

**Correct Answer**: B) The FOUND variable becomes FALSE and the loop exits

**Hint**: Think about how PostgreSQL indicates when no more data is available.

**Explanation**: When FETCH cannot retrieve a row, it sets the FOUND system variable to FALSE. The EXIT WHEN NOT FOUND condition then evaluates to TRUE, causing the loop to exit.

---

### 15. What is the main performance disadvantage of cursors? (Hard)
**Question**: What is the primary performance concern when using cursors compared to set-based operations?

**Options**:
A) Cursors use more disk space for temporary storage
B) Cursors process data row-by-row, missing out on SQL optimization benefits
C) Cursors cannot use database indexes effectively  
D) Cursors require more memory allocation per operation

**Correct Answer**: B) Cursors process data row-by-row, missing out on SQL optimization benefits

**Hint**: Think about how the database optimizer works with different approaches.

**Explanation**: Cursors process data one row at a time, which prevents the database optimizer from applying set-based optimizations. This typically results in slower performance compared to equivalent set-based SQL operations.

---

### 16. Which statement correctly demonstrates nested cursors? (Medium)
**Question**: What is the correct approach for using nested cursors?

**Options**:
A) You cannot nest cursors in PostgreSQL
B) Declare both cursors at the top, then open inner cursor inside outer cursor loop
C) Use cursor FOR loops exclusively for nesting
D) Inner cursors automatically inherit the outer cursor's transaction

**Correct Answer**: B) Declare both cursors at the top, then open inner cursor inside outer cursor loop

**Hint**: Think about cursor declaration placement and loop structure.

**Explanation**: For nested cursors, declare all cursors in the declaration section, then open the inner cursor inside the outer cursor's loop. Each cursor maintains its own position and state.

---

### 17. Cursor performance can be improved by limiting the result set size. (Easy)
**Question**: True or False: Using WHERE clauses to limit cursor result sets improves performance.

**Options**:
A) True
B) False

**Correct Answer**: A) True

**Hint**: Consider the impact of processing fewer rows.

**Explanation**: True. Limiting the cursor result set with WHERE clauses reduces the number of rows to process, decreasing memory usage and processing time, leading to better overall performance.

---

### 18. What happens with this cursor update operation?

```sql
UPDATE payment 
SET amount = amount * 0.90 
WHERE CURRENT OF payment_cursor;
```

**Question**: What does the WHERE CURRENT OF clause accomplish in this UPDATE statement?

**Options**:
A) It updates all rows in the payment table
B) It updates only the row currently positioned by the cursor
C) It updates the most recently inserted payment row
D) It creates a new cursor for the update operation

**Correct Answer**: B) It updates only the row currently positioned by the cursor

**Hint**: Think about what "CURRENT OF" refers to in cursor context.

**Explanation**: WHERE CURRENT OF updates only the row that the cursor is currently positioned on. This allows precise row-by-row updates based on cursor position and requires the cursor to be declared with FOR UPDATE.

---

### 19. How should you handle exceptions when working with cursors? (Hard)
**Question**: What is the recommended approach for handling exceptions in cursor operations?

**Options**:
A) Let PostgreSQL automatically handle all cursor cleanup
B) Use EXCEPTION blocks to ensure cursors are closed even when errors occur
C) Always use cursor FOR loops to avoid exception handling
D) Restart the transaction if any cursor error occurs

**Correct Answer**: B) Use EXCEPTION blocks to ensure cursors are closed even when errors occur

**Hint**: Think about resource management in error conditions.

**Explanation**: Use EXCEPTION blocks to check if cursors are open (%ISOPEN) and close them properly when errors occur. This prevents resource leaks and ensures clean error handling.

---

### 20. In which scenario would you prefer set-based operations over cursors? (Medium)
**Question**: When would set-based SQL operations be clearly preferable to cursor-based processing?

**Options**:
A) When processing customer records one by one for personalized emails
B) When applying a 10% discount to all orders over $100
C) When generating complex reports with conditional formatting per row  
D) When implementing multi-step business workflows

**Correct Answer**: B) When applying a 10% discount to all orders over $100

**Hint**: Consider operations that can affect many rows with the same logic.

**Explanation**: Set-based operations excel when applying uniform changes to multiple rows. A simple UPDATE with WHERE clause is much more efficient than processing each row individually with a cursor for this type of operation.

---

## Quiz Statistics
- **Total Questions**: 20
- **Easy Questions**: 7 (35%)
- **Medium Questions**: 8 (40%)  
- **Hard Questions**: 5 (25%)

## Topics Covered
1. **Cursor Basics**: Definition, purpose, and fundamental operations
2. **Cursor Operations**: FETCH, MOVE, cursor attributes (%FOUND, %ISOPEN, etc.)
3. **Advanced Features**: SCROLL cursors, FOR UPDATE, parameterized cursors
4. **Control Structures**: Cursor loops, nested cursors, exception handling
5. **Performance**: When to use cursors vs set-based operations
6. **Real-world Applications**: Practical usage patterns and best practices
