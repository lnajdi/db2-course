# PostgreSQL TCL (Transaction Control Language) Quiz - Structured Content

## Quiz Overview
- **Topic**: Transaction Control Language (TCL) and ACID Properties
- **Total Questions**: 20
- **Question Types**: Multiple Choice and True/False
- **Difficulty Distribution**: 30% Easy, 40% Medium, 30% Hard
- **Time Estimate**: 25-30 minutes

---

## Question 1 (Easy - Multiple Choice)
**Question**: What does the acronym ACID stand for in database transactions?
**Options**:
A. Atomicity, Consistency, Isolation, Durability
B. Availability, Consistency, Integrity, Durability
C. Atomicity, Completeness, Isolation, Dependability
D. Accuracy, Consistency, Independence, Durability

**Correct Answer**: A
**Hint**: Think about the four fundamental properties that ensure reliable database transactions.
**Explanation**: ACID stands for Atomicity (all-or-nothing), Consistency (maintains integrity rules), Isolation (concurrent transactions don't interfere), and Durability (committed changes survive crashes).

---

## Question 2 (Easy - Multiple Choice)
**Question**: Which command is used to start a transaction in PostgreSQL?
**Options**:
A. START TRANSACTION
B. BEGIN
C. BEGIN TRANSACTION
D. All of the above

**Correct Answer**: D
**Hint**: PostgreSQL provides multiple ways to start a transaction block.
**Explanation**: PostgreSQL accepts START TRANSACTION, BEGIN, and BEGIN TRANSACTION as equivalent commands to start a transaction block.

---

## Question 3 (Easy - True/False)
**Question**: In PostgreSQL, individual SQL statements are automatically committed by default (auto-commit mode).
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Consider what happens when you execute a single UPDATE statement without explicitly starting a transaction.
**Explanation**: True. PostgreSQL operates in auto-commit mode by default, meaning each individual SQL statement is automatically wrapped in its own transaction and committed immediately unless explicitly started within a transaction block.

---

## Question 4 (Medium - Multiple Choice)
**Question**: What happens if you execute ROLLBACK TO SAVEPOINT after committing a transaction?
**Options**:
A. The transaction rolls back to the specified savepoint
B. An error occurs because savepoints are destroyed after commit
C. Only changes after the savepoint are undone
D. The entire transaction history is restored

**Correct Answer**: B
**Hint**: Think about the lifetime of savepoints in relation to transaction boundaries.
**Explanation**: After a transaction is committed, all savepoints within that transaction are destroyed. Attempting to rollback to a savepoint after commit will result in an error.

---

## Question 5 (Medium - Multiple Choice)
**Question**: Which isolation level prevents dirty reads but allows non-repeatable reads and phantom reads?
**Options**:
A. READ UNCOMMITTED
B. READ COMMITTED
C. REPEATABLE READ
D. SERIALIZABLE

**Correct Answer**: B
**Hint**: This is PostgreSQL's default isolation level.
**Explanation**: READ COMMITTED prevents dirty reads (reading uncommitted changes) but allows non-repeatable reads (same query returns different results) and phantom reads (new rows appearing).

---

## Question 6 (Medium - True/False)
**Question**: Savepoints can be nested, allowing you to create multiple checkpoint levels within a single transaction.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Consider complex business processes that might need multiple rollback points.
**Explanation**: True. PostgreSQL supports nested savepoints, allowing you to create multiple checkpoint levels and rollback to different points within a single transaction.

---

## Question 7 (Hard - Multiple Choice)
**Question**: In this transaction sequence, what will be the final state?
```sql
BEGIN;
UPDATE customer SET email = 'new@email.com' WHERE id = 1;
SAVEPOINT sp1;
UPDATE customer SET phone = '555-1234' WHERE id = 1;
SAVEPOINT sp2;
UPDATE customer SET address = 'New Address' WHERE id = 1;
ROLLBACK TO sp1;
UPDATE customer SET phone = '555-5678' WHERE id = 1;
COMMIT;
```
**Options**:
A. Only email is updated
B. Email and phone ('555-1234') are updated
C. Email and phone ('555-5678') are updated
D. All three fields are updated

**Correct Answer**: C
**Hint**: Trace through each operation and consider what ROLLBACK TO sp1 undoes.
**Explanation**: ROLLBACK TO sp1 undoes the phone and address changes made after sp1. The subsequent phone update to '555-5678' then occurs before commit, so final state has updated email and phone ('555-5678').

---

## Question 8 (Hard - Multiple Choice)
**Question**: What is a deadlock in the context of database transactions?
**Options**:
A. When a transaction takes too long to complete
B. When two or more transactions are waiting for each other to release locks
C. When a transaction cannot acquire any locks
D. When the database runs out of memory for transactions

**Correct Answer**: B
**Hint**: Think about a circular dependency situation between transactions.
**Explanation**: A deadlock occurs when two or more transactions are each waiting for the other to release locks, creating a circular dependency that cannot resolve without external intervention (usually automatic deadlock detection and rollback).

---

## Question 9 (Medium - Multiple Choice)
**Question**: Which PostgreSQL system view can you query to monitor active locks?
**Options**:
A. pg_stat_activity
B. pg_locks
C. pg_stat_database
D. pg_transactions

**Correct Answer**: B
**Hint**: The view name directly relates to what it monitors.
**Explanation**: pg_locks provides information about currently held locks, including lock types, objects being locked, and which processes hold the locks.

---

## Question 10 (Easy - True/False)
**Question**: The ROLLBACK command undoes all changes made since the beginning of the current transaction.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Consider what ROLLBACK does without any additional parameters.
**Explanation**: True. ROLLBACK (without TO SAVEPOINT) undoes all changes made since the transaction began, returning the database to its state before BEGIN was executed.

---

## Question 11 (Hard - Multiple Choice)
**Question**: In SERIALIZABLE isolation level, what happens when PostgreSQL detects a serialization anomaly?
**Options**:
A. The transaction is automatically retried
B. One of the conflicting transactions is rolled back with a serialization failure error
C. The database switches to a lower isolation level
D. All transactions are temporarily suspended

**Correct Answer**: B
**Hint**: Think about how the database resolves conflicts at the highest isolation level.
**Explanation**: In SERIALIZABLE isolation, PostgreSQL detects serialization anomalies and rolls back one of the conflicting transactions with a serialization failure error, which the application must handle and retry.

---

## Question 12 (Medium - Multiple Choice)
**Question**: What is the key difference between COMMIT and COMMIT AND CHAIN?
**Options**:
A. COMMIT AND CHAIN is faster than regular COMMIT
B. COMMIT AND CHAIN starts a new transaction immediately after committing
C. COMMIT AND CHAIN only commits certain tables
D. There is no difference in PostgreSQL

**Correct Answer**: B
**Hint**: Consider what "chain" might mean in the context of transactions.
**Explanation**: COMMIT AND CHAIN commits the current transaction and immediately starts a new transaction with the same characteristics (isolation level, access mode, etc.).

---

## Question 13 (Easy - Multiple Choice)
**Question**: Which command makes all changes in the current transaction permanent?
**Options**:
A. SAVE
B. COMMIT
C. APPLY
D. FINALIZE

**Correct Answer**: B
**Hint**: This is one of the fundamental TCL commands.
**Explanation**: COMMIT makes all changes in the current transaction permanent and ends the transaction block.

---

## Question 14 (Hard - True/False)
**Question**: In PostgreSQL, READ UNCOMMITTED isolation level behaves identically to READ COMMITTED due to PostgreSQL's implementation.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Consider PostgreSQL's specific implementation compared to other database systems.
**Explanation**: True. PostgreSQL treats READ UNCOMMITTED the same as READ COMMITTED because PostgreSQL never allows dirty reads in any isolation level, unlike some other database systems.

---

## Question 15 (Medium - Multiple Choice)
**Question**: What happens to uncommitted changes when a database session is terminated unexpectedly?
**Options**:
A. Changes are automatically committed
B. Changes are automatically rolled back
C. Changes remain in a pending state
D. The database becomes corrupted

**Correct Answer**: B
**Hint**: Think about what happens to transactions that haven't been explicitly committed.
**Explanation**: Uncommitted changes are automatically rolled back when a session terminates unexpectedly, ensuring data consistency and maintaining the atomicity property of transactions.

---

## Question 16 (Medium - True/False)
**Question**: You can have multiple active savepoints with the same name within a single transaction.
**Options**:
A. True
B. False

**Correct Answer**: B
**Hint**: Consider how savepoint names work as identifiers.
**Explanation**: False. Savepoint names must be unique within a transaction. Creating a savepoint with an existing name will release the previous savepoint with that name.

---

## Question 17 (Hard - Multiple Choice)
**Question**: Consider this scenario: Transaction A reads a row, Transaction B updates the same row and commits, then Transaction A reads the row again. Under which isolation level would Transaction A see different values?
**Options**:
A. SERIALIZABLE only
B. READ COMMITTED only
C. Both READ COMMITTED and REPEATABLE READ
D. READ COMMITTED but not REPEATABLE READ

**Correct Answer**: D
**Hint**: Think about which isolation levels allow non-repeatable reads.
**Explanation**: In READ COMMITTED, Transaction A would see the updated values on the second read. In REPEATABLE READ and SERIALIZABLE, Transaction A would see the same values both times (preventing non-repeatable reads).

---

## Question 18 (Medium - Multiple Choice)
**Question**: What is the primary purpose of the Durability property in ACID transactions?
**Options**:
A. To ensure transactions execute quickly
B. To guarantee that committed changes survive system failures
C. To prevent concurrent transaction conflicts
D. To maintain referential integrity

**Correct Answer**: B
**Hint**: Think about what happens to your data after a system crash.
**Explanation**: Durability ensures that once a transaction is committed, the changes are permanently stored and will survive system crashes, power failures, or other unexpected shutdowns.

---

## Question 19 (Easy - True/False)
**Question**: PostgreSQL automatically detects and resolves deadlocks by rolling back one of the involved transactions.
**Options**:
A. True
B. False

**Correct Answer**: A
**Hint**: Consider how databases handle the circular waiting problem.
**Explanation**: True. PostgreSQL has a deadlock detector that automatically identifies deadlock situations and resolves them by rolling back one of the involved transactions, allowing the others to proceed.

---

## Question 20 (Hard - Multiple Choice)
**Question**: In a high-concurrency environment, what is the trade-off when using higher isolation levels like SERIALIZABLE?
**Options**:
A. Better performance but less data consistency
B. Stronger data consistency but potentially more serialization failures and retries
C. Higher memory usage but faster queries
D. Lower CPU usage but increased disk I/O

**Correct Answer**: B
**Hint**: Consider what happens when the database has to maintain stronger consistency guarantees.
**Explanation**: Higher isolation levels like SERIALIZABLE provide stronger consistency guarantees but may result in more serialization failures when conflicts are detected, requiring applications to handle retries and potentially reducing overall throughput in high-concurrency scenarios.

---

## Scoring Guide

### Performance Levels:
- **18-20 correct (90-100%)**: Excellent! You have mastered PostgreSQL transactions and TCL concepts.
- **16-17 correct (80-89%)**: Very Good! You understand transaction control well with minor gaps.
- **14-15 correct (70-79%)**: Good! You grasp the fundamentals but should review isolation levels and advanced concepts.
- **12-13 correct (60-69%)**: Fair! Review transaction basics, ACID properties, and savepoints.
- **Below 12 correct (<60%)**: Needs Improvement! Focus on understanding basic transaction concepts and TCL commands.

### Key Topics Covered:
- ACID Properties (Atomicity, Consistency, Isolation, Durability)
- TCL Commands (BEGIN, COMMIT, ROLLBACK, SAVEPOINT)
- Transaction Isolation Levels
- Concurrency Issues (Deadlocks, Lock conflicts)
- Savepoints and Nested Transactions
- PostgreSQL-specific Transaction Behavior
- Error Handling in Transactions
- Performance Considerations
