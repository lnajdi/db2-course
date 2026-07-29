# PostgreSQL Triggers Quiz - Structured Content

## Quiz Overview
- **Topic**: PostgreSQL Database Triggers and Automation
- **Question Count**: 20 questions
- **Difficulty Distribution**: 7 Easy, 8 Medium, 5 Hard
- **Coverage**: Trigger concepts, types, implementation, and best practices

---

## Questions

### 1. What is a database trigger in PostgreSQL? (Easy)
**Question**: What is the primary characteristic that defines a database trigger?

**Options**:
A) A stored procedure that must be called manually
B) A special function that automatically executes in response to database events
C) A table constraint that prevents invalid data
D) A view that automatically updates when tables change

**Correct Answer**: B) A special function that automatically executes in response to database events

**Hint**: Think about the "automatic" nature of triggers compared to regular functions.

**Explanation**: A trigger is a special type of stored procedure that automatically fires (executes) when specific database events occur, such as INSERT, UPDATE, or DELETE operations.

---

### 2. Which timing options are available for PostgreSQL triggers? (Easy)
**Question**: What are the valid timing options when creating a trigger?

**Options**:
A) BEFORE, DURING, AFTER
B) BEFORE, AFTER, INSTEAD OF
C) START, MIDDLE, END
D) PRE, POST, REPLACE

**Correct Answer**: B) BEFORE, AFTER, INSTEAD OF

**Hint**: Think about when a trigger can execute relative to the triggering event.

**Explanation**: PostgreSQL supports BEFORE triggers (execute before the event), AFTER triggers (execute after the event), and INSTEAD OF triggers (replace the event, typically used with views).

---

### 3. Triggers must return a value of type TRIGGER. (Easy)
**Question**: True or False: Trigger functions must have a return type of TRIGGER.

**Options**:
A) True
B) False

**Correct Answer**: A) True

**Hint**: Consider the special return type required for trigger functions.

**Explanation**: True. All trigger functions must be declared with RETURNS TRIGGER, and they typically return NEW, OLD, or NULL depending on the trigger type and operation.

---

### 4. What do the OLD and NEW variables represent in a trigger function? (Medium)
**Question**: In a trigger function, what do the OLD and NEW special variables contain?

**Options**:
A) Previous and current database state
B) Row data before and after the triggering operation
C) The oldest and newest records in the table
D) Error state and success state information

**Correct Answer**: B) Row data before and after the triggering operation

**Hint**: Think about what data is available during row modifications.

**Explanation**: OLD contains the row data before the operation (available in UPDATE and DELETE), while NEW contains the row data after the operation (available in INSERT and UPDATE).

---

### 5. Which events can trigger a PostgreSQL trigger? (Medium)
**Question**: Which database operations can cause a trigger to fire?

**Options**:
A) SELECT, INSERT, UPDATE
B) INSERT, UPDATE, DELETE, TRUNCATE
C) CREATE, ALTER, DROP
D) All SQL statements

**Correct Answer**: B) INSERT, UPDATE, DELETE, TRUNCATE

**Hint**: Think about operations that modify data in tables.

**Explanation**: Triggers can fire on INSERT (new rows), UPDATE (modified rows), DELETE (removed rows), and TRUNCATE (table emptying) operations. SELECT doesn't modify data so doesn't trigger.

---

### 6. What is the purpose of FOR EACH ROW vs FOR EACH STATEMENT in triggers? (Medium)
**Question**: What is the difference between row-level and statement-level triggers?

**Options**:
A) Row-level triggers are faster than statement-level triggers
B) Row-level triggers execute once per affected row, statement-level once per SQL statement
C) Statement-level triggers can only be used with SELECT statements
D) Row-level triggers cannot access OLD and NEW variables

**Correct Answer**: B) Row-level triggers execute once per affected row, statement-level once per SQL statement

**Hint**: Think about how many times the trigger function runs.

**Explanation**: Row-level triggers (FOR EACH ROW) execute once for each row affected by the triggering statement, while statement-level triggers (FOR EACH STATEMENT) execute once for the entire SQL statement regardless of how many rows are affected.

---

### 7. In a BEFORE trigger that returns NULL, what happens to the operation? (Hard)
**Question**: What occurs when a BEFORE trigger returns NULL instead of NEW or OLD?

**Options**:
A) The trigger execution continues normally
B) An error is raised immediately
C) The triggering operation is skipped for that row
D) The operation is converted to an UPDATE

**Correct Answer**: C) The triggering operation is skipped for that row

**Hint**: Think about how BEFORE triggers can control whether operations proceed.

**Explanation**: When a BEFORE trigger returns NULL, it signals PostgreSQL to skip the triggering operation for that row. This is a way to conditionally prevent INSERT, UPDATE, or DELETE operations.

---

### 8. Which special variable is used to determine the triggering operation in a multi-event trigger? (Medium)
**Question**: How can a trigger function determine which operation (INSERT, UPDATE, DELETE) caused it to fire?

**Options**:
A) TG_EVENT
B) TG_OP
C) TG_ACTION
D) TG_TYPE

**Correct Answer**: B) TG_OP

**Hint**: Think about the special variables available in trigger functions that provide context.

**Explanation**: TG_OP contains the operation name ('INSERT', 'UPDATE', 'DELETE', or 'TRUNCATE') that triggered the function, allowing one function to handle multiple trigger events.

---

### 9. AFTER triggers can modify the NEW record before it's stored in the database. (Easy)
**Question**: True or False: AFTER triggers can modify the NEW record to change what gets stored.

**Options**:
A) True
B) False

**Correct Answer**: B) False

**Hint**: Think about when AFTER triggers execute relative to the data modification.

**Explanation**: False. AFTER triggers execute after the triggering operation has already completed and the data has been stored. Only BEFORE triggers can modify NEW to change what gets stored.

---

### 10. What is the recommended approach for creating audit trails with triggers? (Medium)
**Question**: What is the best practice for implementing audit logging with triggers?

**Options**:
A) Store all changes in the same table with additional columns
B) Create separate audit tables to track changes without affecting performance
C) Use only BEFORE triggers for audit logging
D) Log changes directly to files instead of database tables

**Correct Answer**: B) Create separate audit tables to track changes without affecting performance

**Hint**: Consider the impact on the original table and query performance.

**Explanation**: Separate audit tables prevent performance impact on the original table, allow for different retention policies, and provide a clear separation between operational data and audit information.

---

### 11. Which trigger timing is most appropriate for data validation? (Medium)
**Question**: When implementing data validation, which trigger timing should you typically use?

**Options**:
A) AFTER triggers, because you need to see the final data
B) BEFORE triggers, because you can prevent invalid data from being stored
C) INSTEAD OF triggers, because they replace the operation
D) Any timing works equally well for validation

**Correct Answer**: B) BEFORE triggers, because you can prevent invalid data from being stored

**Hint**: Think about when you want to catch and prevent invalid data.

**Explanation**: BEFORE triggers are ideal for validation because they can examine and modify the NEW data before it's stored, and can raise exceptions to prevent invalid data from being committed.

---

### 12. What is the correct way to handle errors in trigger functions? (Hard)
**Question**: How should you properly handle and report errors in trigger functions?

**Options**:
A) Use TRY-CATCH blocks like in other programming languages
B) Use RAISE EXCEPTION to throw errors that will rollback the transaction
C) Return FALSE to indicate an error occurred
D) Log errors to a file and continue processing

**Correct Answer**: B) Use RAISE EXCEPTION to throw errors that will rollback the transaction

**Hint**: Think about PostgreSQL's error handling mechanism and transaction safety.

**Explanation**: RAISE EXCEPTION is the proper way to handle errors in triggers. It stops the triggering operation and rolls back the transaction, ensuring data consistency.

---

### 13. Triggers can call other functions or execute dynamic SQL statements. (Easy)
**Question**: True or False: Trigger functions can call other PostgreSQL functions and execute dynamic SQL.

**Options**:
A) True
B) False

**Correct Answer**: A) True

**Hint**: Consider the capabilities available within PL/pgSQL trigger functions.

**Explanation**: True. Trigger functions are regular PL/pgSQL functions that can call other functions, execute dynamic SQL with EXECUTE, and perform any operations available to stored procedures.

---

### 14. In this trigger function, what will happen if the customer is inactive?

```sql
CREATE OR REPLACE FUNCTION check_customer_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT (SELECT active FROM customer WHERE customer_id = NEW.customer_id) THEN
        RAISE EXCEPTION 'Cannot process inactive customer';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

**Question**: What occurs when this BEFORE trigger encounters an inactive customer?

**Options**:
A) The trigger returns NULL and skips the operation
B) An exception is raised and the transaction is rolled back
C) The customer is automatically activated
D) A warning is logged but the operation continues

**Correct Answer**: B) An exception is raised and the transaction is rolled back

**Hint**: Look at the RAISE EXCEPTION statement and consider its effect on the transaction.

**Explanation**: The RAISE EXCEPTION statement throws an error that stops the triggering operation and rolls back the entire transaction, preventing any changes from being committed.

---

### 15. What is the main performance consideration when using triggers? (Hard)
**Question**: What is the primary performance concern when implementing database triggers?

**Options**:
A) Triggers consume too much disk space
B) Triggers execute for every affected row and add overhead to DML operations
C) Triggers cannot use database indexes
D) Triggers require too much memory allocation

**Correct Answer**: B) Triggers execute for every affected row and add overhead to DML operations

**Hint**: Think about when triggers fire and their impact on normal database operations.

**Explanation**: Triggers add processing overhead because they execute automatically on every triggering operation. Row-level triggers especially can significantly impact performance when processing many rows.

---

### 16. Which approach is best for implementing complex business logic in triggers? (Medium)
**Question**: How should you structure complex business logic in trigger functions?

**Options**:
A) Put all logic directly in the trigger function
B) Call separate functions from the trigger to keep the trigger simple
C) Use multiple triggers instead of complex logic
D) Avoid complex logic in triggers entirely

**Correct Answer**: B) Call separate functions from the trigger to keep the trigger simple

**Hint**: Think about maintainability and debugging of trigger code.

**Explanation**: Keeping trigger functions simple and calling separate functions for complex logic makes the code more maintainable, testable, and easier to debug while still providing the automation benefits of triggers.

---

### 17. Triggers are automatically disabled when a table is dropped. (Easy)
**Question**: True or False: When you drop a table, all associated triggers are automatically removed.

**Options**:
A) True
B) False

**Correct Answer**: A) True

**Hint**: Consider what happens to table-dependent objects when the table is removed.

**Explanation**: True. Triggers are dependent on their associated tables, so dropping a table automatically removes all triggers defined on that table.

---

### 18. What does this trigger pattern accomplish?

```sql
CREATE TRIGGER audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON customer
    FOR EACH ROW EXECUTE FUNCTION log_customer_changes();
```

**Question**: What type of functionality does this trigger pattern typically implement?

**Options**:
A) Data validation before changes are made
B) Automatic calculation of derived values
C) Audit trail logging of all customer changes
D) Prevention of unauthorized operations

**Correct Answer**: C) Audit trail logging of all customer changes

**Hint**: Notice the AFTER timing and the comprehensive event coverage.

**Explanation**: This is a classic audit trigger pattern that captures all changes (INSERT, UPDATE, DELETE) to the customer table after they occur, typically for logging and compliance purposes.

---

### 19. Which scenario would benefit most from trigger implementation? (Hard)
**Question**: In which situation would triggers be the most appropriate solution?

**Options**:
A) Generating monthly reports from existing data
B) Automatically calculating and updating related values when data changes
C) Performing one-time data migration between systems
D) Implementing user interface validation logic

**Correct Answer**: B) Automatically calculating and updating related values when data changes

**Hint**: Think about scenarios requiring automatic, immediate response to data changes.

**Explanation**: Triggers excel at automatically maintaining derived data and enforcing business rules that must be consistently applied whenever data changes, regardless of how the change occurs.

---

### 20. What is the best practice for trigger naming and organization? (Medium)
**Question**: What is the recommended approach for organizing and naming database triggers?

**Options**:
A) Use generic names like trigger1, trigger2, etc.
B) Use descriptive names that indicate the table, timing, and purpose
C) Name all triggers the same to simplify management
D) Use random names to prevent unauthorized access

**Correct Answer**: B) Use descriptive names that indicate the table, timing, and purpose

**Hint**: Think about maintenance and documentation of trigger systems.

**Explanation**: Descriptive naming like "customer_audit_after_trigger" or "inventory_validation_before_trigger" makes triggers easier to understand, maintain, and debug in complex database systems.

---

## Quiz Statistics
- **Total Questions**: 20
- **Easy Questions**: 7 (35%)
- **Medium Questions**: 8 (40%)  
- **Hard Questions**: 5 (25%)

## Topics Covered
1. **Trigger Basics**: Definition, automatic execution, and core concepts
2. **Trigger Types**: BEFORE, AFTER, INSTEAD OF, row-level vs statement-level
3. **Special Variables**: OLD, NEW, TG_OP, and trigger context information
4. **Implementation**: Trigger function creation, return values, and event handling
5. **Error Handling**: Exception management and transaction rollback
6. **Performance**: Impact considerations and optimization strategies
7. **Best Practices**: Naming, organization, and appropriate usage patterns
8. **Real-world Applications**: Audit trails, validation, and business logic automation
