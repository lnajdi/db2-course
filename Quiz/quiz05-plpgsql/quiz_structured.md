# PostgreSQL Intro to PL/pgSQL Quiz - Structured Content

## Quiz Overview
- **Topic**: Introduction to PL/pgSQL (Procedural Language/PostgreSQL)
- **Total Questions**: 20
- **Question Types**: Multiple Choice and True/False
- **Difficulty Distribution**: 30% Easy, 40% Medium, 30% Hard
- **Time Estimate**: 25-30 minutes

---

## Question 1 (Easy - Multiple Choice)
**Question**: What does PL/pgSQL stand for?
**Options**:
A. Procedural Language/PostgreSQL
B. Programming Logic/PostgreSQL
C. Persistent Language/PostgreSQL  
D. Public Library/PostgreSQL

**Correct Answer**: A
**Hint**: Think about what the "PL" and "pgSQL" parts represent in PostgreSQL's procedural language.
**Explanation**: PL/pgSQL stands for Procedural Language/PostgreSQL, which is PostgreSQL's native procedural programming language that extends SQL with programming constructs.

---

## Question 2 (Easy - Multiple Choice)
**Question**: Which keyword is used to start an anonymous PL/pgSQL block?
**Options**:
A. BEGIN
B. DO
C. EXECUTE
D. CALL

**Correct Answer**: B
**Hint**: Think about how you execute a block of PL/pgSQL code without creating a named function.
**Explanation**: The DO keyword is used to execute an anonymous PL/pgSQL block. The syntax is DO $$ ... END $$;

---

## Question 3 (Easy - True/False)
**Question**: Variables in PL/pgSQL must be declared in the DECLARE section before the BEGIN block.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Consider the structure of a PL/pgSQL block and where variable declarations go.
**Explanation**: True. All variables must be declared in the DECLARE section, which comes before the BEGIN block in PL/pgSQL.

---

## Question 4 (Medium - Multiple Choice)
**Question**: What is the correct syntax to declare a variable that matches a database column's type?
**Options**:
A. DECLARE var_name LIKE table.column;
B. DECLARE var_name table.column%TYPE;
C. DECLARE var_name AS table.column;
D. DECLARE var_name TYPE OF table.column;

**Correct Answer**: B
**Hint**: PL/pgSQL uses a specific syntax with % to reference column types.
**Explanation**: The %TYPE syntax allows you to declare a variable with the same data type as a specific database column, ensuring type consistency.

---

## Question 5 (Medium - Multiple Choice)
**Question**: Which command is used to display messages from within a PL/pgSQL block?
**Options**:
A. PRINT
B. ECHO
C. RAISE NOTICE
D. OUTPUT

**Correct Answer**: C
**Hint**: Think about PostgreSQL's specific command for raising informational messages.
**Explanation**: RAISE NOTICE is used to display informational messages from within PL/pgSQL code, similar to print statements in other languages.

---

## Question 6 (Medium - True/False)
**Question**: You can assign multiple values from a SELECT statement to multiple variables using SELECT INTO.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Consider how you might retrieve multiple column values into separate variables.
**Explanation**: True. You can use SELECT col1, col2, col3 INTO var1, var2, var3 FROM table to assign multiple values to multiple variables in one statement.

---

## Question 7 (Hard - Multiple Choice)
**Question**: What happens if a SELECT INTO statement returns no rows?
**Options**:
A. An exception is raised automatically
B. The variables are set to NULL
C. The program terminates with an error
D. The variables retain their previous values

**Correct Answer**: B
**Hint**: Think about PL/pgSQL's default behavior when no data is found.
**Explanation**: When SELECT INTO returns no rows, all target variables are set to NULL. No exception is raised automatically unless explicitly checked.

---

## Question 8 (Hard - Multiple Choice)
**Question**: In this PL/pgSQL code, what will be the final value of counter?
```sql
DECLARE 
    counter INTEGER := 0;
BEGIN
    FOR i IN 1..5 LOOP
        counter := counter + i;
        IF i = 3 THEN
            EXIT;
        END IF;
    END LOOP;
END;
```
**Options**:
A. 6 (1+2+3)
B. 15 (1+2+3+4+5)
C. 5 (just the last i value)
D. 3 (the i value when EXIT occurred)

**Correct Answer**: A
**Hint**: Trace through the loop execution and note when EXIT is called.
**Explanation**: The loop runs for i=1 (counter=1), i=2 (counter=3), i=3 (counter=6), then EXIT is called. Final counter value is 6.

---

## Question 9 (Medium - Multiple Choice)
**Question**: Which loop construct allows you to iterate over the results of a SELECT statement?
**Options**:
A. WHILE loop
B. FOR ... IN REVERSE loop
C. FOR ... IN (SELECT ...) loop
D. REPEAT loop

**Correct Answer**: C
**Hint**: Think about how you can iterate over query results in PL/pgSQL.
**Explanation**: FOR record IN (SELECT ...) LOOP allows you to iterate over the results of a SELECT statement, with each row accessible as a record.

---

## Question 10 (Easy - True/False)
**Question**: PL/pgSQL supports both IF/ELSE and CASE statements for conditional logic.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Think about the different ways to implement conditional logic in PL/pgSQL.
**Explanation**: True. PL/pgSQL supports both IF/ELSIF/ELSE statements and CASE/WHEN statements for implementing conditional logic.

---

## Question 11 (Hard - Multiple Choice)
**Question**: What is the difference between RECORD and ROWTYPE variables in PL/pgSQL?
**Options**:
A. RECORD is for single values, ROWTYPE is for multiple values
B. RECORD has dynamic structure, ROWTYPE has fixed structure based on a table
C. RECORD is faster, ROWTYPE uses more memory
D. There is no difference, they are synonyms

**Correct Answer**: B
**Hint**: Think about static vs dynamic typing in PL/pgSQL variable declarations.
**Explanation**: RECORD variables have a dynamic structure determined at runtime, while %ROWTYPE variables have a fixed structure matching a specific table's columns.

---

## Question 12 (Medium - Multiple Choice)
**Question**: How do you handle the case where a SELECT INTO statement might return multiple rows?
**Options**:
A. Use SELECT INTO with LIMIT 1
B. Use exception handling to catch TOO_MANY_ROWS
C. Use a FOR loop instead of SELECT INTO
D. All of the above are valid approaches

**Correct Answer**: D
**Hint**: Consider different strategies for handling multiple-row scenarios.
**Explanation**: All approaches are valid: LIMIT 1 restricts results, exception handling catches the error, and FOR loops naturally handle multiple rows.

---

## Question 13 (Easy - Multiple Choice)
**Question**: Which section of a PL/pgSQL block contains the main program logic?
**Options**:
A. DECLARE section
B. BEGIN section  
C. EXCEPTION section
D. END section

**Correct Answer**: B
**Hint**: Think about the structure of a PL/pgSQL block and where executable statements go.
**Explanation**: The BEGIN section contains the main program logic and executable statements in a PL/pgSQL block.

---

## Question 14 (Hard - True/False)
**Question**: In PL/pgSQL, you can modify the structure of a RECORD variable by assigning it results from different SELECT statements with different column sets.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Think about the dynamic nature of RECORD variables.
**Explanation**: True. RECORD variables are dynamically typed and their structure changes based on the SELECT statement results assigned to them.

---

## Question 15 (Medium - Multiple Choice)
**Question**: What is the correct way to concatenate strings in PL/pgSQL?
**Options**:
A. Using the + operator
B. Using the CONCAT() function  
C. Using the || operator
D. Both B and C are correct

**Correct Answer**: D
**Hint**: PL/pgSQL supports standard SQL string operations plus additional functions.
**Explanation**: Both the || operator (standard SQL) and the CONCAT() function work for string concatenation in PL/pgSQL.

---

## Question 16 (Medium - True/False)
**Question**: PL/pgSQL variables are case-sensitive, so 'CustomerID' and 'customerid' are different variables.
**Options**:
A. True
B. False

**Correct Answer**: B
**Hint**: Consider PostgreSQL's general approach to identifier case sensitivity.
**Explanation**: False. PL/pgSQL follows PostgreSQL's case-insensitive naming rules unless identifiers are quoted. Unquoted identifiers are folded to lowercase.

---

## Question 17 (Hard - Multiple Choice)
**Question**: When should you use a WHILE loop instead of a FOR loop in PL/pgSQL?
**Options**:
A. When you need better performance
B. When the number of iterations is not known in advance
C. When working with query results
D. WHILE loops should be avoided in favor of FOR loops

**Correct Answer**: B
**Hint**: Think about when you might not know how many times you need to loop.
**Explanation**: WHILE loops are best when the number of iterations depends on a condition that might change during execution, rather than a predetermined range or result set.

---

## Question 18 (Medium - Multiple Choice)
**Question**: What does the %FOUND attribute tell you after a SELECT INTO statement?
**Options**:
A. Whether the operation completed successfully
B. Whether at least one row was returned
C. The number of rows that were found
D. Whether an exception occurred

**Correct Answer**: B
**Hint**: Think about checking if your SELECT INTO actually found data.
**Explanation**: %FOUND is a boolean attribute that returns TRUE if the last SQL statement found at least one row, and FALSE if no rows were found.

---

## Question 19 (Easy - True/False)
**Question**: You can nest PL/pgSQL blocks inside other PL/pgSQL blocks.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Think about the flexibility of PL/pgSQL's block structure.
**Explanation**: True. PL/pgSQL supports nested blocks, allowing you to create inner blocks with their own DECLARE sections and exception handling.

---

## Question 20 (Hard - Multiple Choice)
**Question**: What is the main advantage of using PL/pgSQL functions over executing multiple separate SQL statements from a client application?
**Options**:
A. PL/pgSQL functions are always faster
B. Reduced network round trips and better transaction control
C. PL/pgSQL uses less memory than client applications  
D. PL/pgSQL functions are easier to debug

**Correct Answer**: B
**Hint**: Think about client-server communication and where the logic executes.
**Explanation**: The main advantage is reduced network round trips (all logic executes on the server) and better transaction control, as all operations happen within the same database session.

---

## Scoring Guide

### Performance Levels:
- **18-20 correct (90-100%)**: Excellent! You have mastered PL/pgSQL fundamentals and can write effective procedural code.
- **16-17 correct (80-89%)**: Very Good! You understand core concepts well with minor gaps in advanced topics.
- **14-15 correct (70-79%)**: Good! You grasp basic PL/pgSQL but should review loops, records, and error handling.
- **12-13 correct (60-69%)**: Fair! Focus on variables, control structures, and SELECT INTO concepts.
- **Below 12 correct (<60%)**: Needs Improvement! Review basic PL/pgSQL syntax and programming concepts.

### Key Topics Covered:
- PL/pgSQL Block Structure (DECLARE, BEGIN, END)
- Variable Declaration and Assignment
- Data Types (%TYPE, %ROWTYPE, RECORD)
- SELECT INTO Statements
- Control Structures (IF/ELSE, CASE, Loops)
- String and Numeric Operations
- Error Handling and Attributes (%FOUND, %NOTFOUND)
- Best Practices and Performance Considerations
