# Indexes Quiz - Structured Content

## Quiz Title: PostgreSQL Indexes and Performance Optimization
## Number of Questions: 20
## Target Audience: University students
## Language: English

### Question Distribution:
- Multiple Choice: 15 questions
- True/False: 5 questions
- Difficulty: Easy (6), Medium (8), Hard (6)

---

## Question 1
**Question Number:** 1
**Key Concept Tested:** Basic definition of database indexes
**Difficulty:** Easy
**Type:** Multiple Choice
**Question:** What is a database index in PostgreSQL?

**Options:**
0. A copy of the entire table stored separately for backup purposes
1. A data structure that improves the speed of data retrieval operations
2. A constraint that prevents duplicate values in a column
3. A view that shows only the most frequently accessed rows

**Correct Answer Index:** 1
**Hint:** Think about the primary purpose of indexes in database performance.
**Correct Answer Explanation:** A database index is a data structure that improves the speed of data retrieval operations on a database table, at the cost of additional writes and storage space to maintain the index.
**Incorrect Answer Explanations:**
- Option 0: Indexes aren't backups; they're performance optimization structures
- Option 2: That's a unique constraint, not an index (though unique constraints use indexes)
- Option 3: That describes a view, not an index

---

## Question 2
**Question Number:** 2
**Key Concept Tested:** Index trade-offs and costs
**Difficulty:** Easy
**Type:** Multiple Choice
**Question:** What is the main trade-off when using indexes?

**Options:**
0. They improve read performance but slow down write operations
1. They reduce storage space but increase query time
2. They improve security but reduce data integrity
3. They speed up all operations with no downsides

**Correct Answer Index:** 0
**Hint:** Consider what happens when the database needs to maintain the index during data modifications.
**Correct Answer Explanation:** Indexes improve SELECT query performance but slow down INSERT, UPDATE, and DELETE operations because the index must be maintained when data changes.
**Incorrect Answer Explanations:**
- Option 1: Indexes actually use MORE storage space and REDUCE query time
- Option 2: Indexes don't directly affect security or data integrity
- Option 3: There are always trade-offs; indexes have maintenance costs

---

## Question 3
**Question Number:** 3
**Key Concept Tested:** Default index type in PostgreSQL
**Difficulty:** Easy
**Type:** Multiple Choice
**Question:** What is the default index type in PostgreSQL?

**Options:**
0. Hash
1. B-Tree
2. GIN
3. GiST

**Correct Answer Index:** 1
**Hint:** Think about which index type is most versatile and commonly used.
**Correct Answer Explanation:** B-Tree is the default index type in PostgreSQL. It's the most versatile, supporting equality and range queries efficiently.
**Incorrect Answer Explanations:**
- Option 0: Hash indexes are specialized for equality comparisons only
- Option 2: GIN indexes are for complex data types like arrays and JSONB
- Option 3: GiST indexes are for geometric data and full-text search

---

## Question 4
**Question Number:** 4
**Key Concept Tested:** Query execution without indexes
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** What happens when a query runs on a table without an appropriate index?

**Options:**
0. The query will fail with an error
1. PostgreSQL automatically creates a temporary index
2. The database performs a full table scan
3. Only the first 1000 rows are examined

**Correct Answer Index:** 2
**Hint:** Consider how the database would find data if it can't use an index to jump directly to relevant rows.
**Correct Answer Explanation:** Without an appropriate index, PostgreSQL must perform a full table scan, examining every row in the table to find matches.
**Incorrect Answer Explanations:**
- Option 0: Queries don't fail without indexes; they just run slower
- Option 1: PostgreSQL doesn't create temporary indexes automatically
- Option 3: The database examines all rows, not just a subset

---

## Question 5
**Question Number:** 5
**Key Concept Tested:** Basic index creation syntax
**Difficulty:** Easy
**Type:** Multiple Choice
**Question:** What is the correct syntax to create a basic index on a column in PostgreSQL?

**Options:**
0. ADD INDEX idx_name ON table_name (column_name)
1. CREATE INDEX idx_name ON table_name (column_name)
2. INSERT INDEX idx_name INTO table_name (column_name)
3. MAKE INDEX idx_name FOR table_name (column_name)

**Correct Answer Index:** 1
**Hint:** The command should clearly indicate you're creating an index structure.
**Correct Answer Explanation:** The correct syntax is CREATE INDEX idx_name ON table_name (column_name) to create an index on a specific column.
**Incorrect Answer Explanations:**
- Option 0: ADD INDEX is not valid PostgreSQL syntax
- Option 2: INSERT is for data, not for creating database objects
- Option 3: MAKE is not a valid PostgreSQL command for index creation

---

## Question 6
**Question Number:** 6
**Key Concept Tested:** Composite indexes and column order
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** For a composite index on (customer_id, rental_date), which query would benefit MOST from this index?

**Options:**
0. WHERE rental_date = '2005-07-01'
1. WHERE customer_id = 123 AND rental_date > '2005-07-01'
2. WHERE rental_date > '2005-07-01' AND customer_id = 123
3. WHERE customer_id IN (1,2,3) OR rental_date = '2005-07-01'

**Correct Answer Index:** 1
**Hint:** In composite indexes, the order of columns matters - the leftmost column should be used first.
**Correct Answer Explanation:** Option 1 benefits most because it uses the leftmost column (customer_id) first, then the second column, matching the index structure perfectly.
**Incorrect Answer Explanations:**
- Option 0: Only uses the second column of the composite index, not as efficient
- Option 2: Same conditions as option 1 but PostgreSQL can still optimize this effectively
- Option 3: Uses OR which typically can't utilize composite indexes efficiently

---

## Question 7
**Question Number:** 7
**Key Concept Tested:** Hash indexes characteristics
**Difficulty:** Medium
**Type:** True/False
**Question:** Hash indexes in PostgreSQL can be used for range queries (e.g., WHERE column > 100).

**Options:**
0. True
1. False

**Correct Answer Index:** 1
**Hint:** Consider what type of operations hash functions are designed for.
**Correct Answer Explanation:** False. Hash indexes are optimized only for equality comparisons (=). They cannot be used for range queries, sorting, or pattern matching.
**Incorrect Answer Explanations:**
- Option 0: Hash indexes only support equality; B-Tree indexes are needed for ranges

---

## Question 8
**Question Number:** 8
**Key Concept Tested:** Partial indexes
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** What is the main advantage of a partial index like this?
```sql
CREATE INDEX idx_active_customers ON customer (last_name) WHERE active = 1;
```

**Options:**
0. It speeds up all queries on the customer table
1. It takes up less storage space and only indexes relevant rows
2. It automatically updates when customers become inactive
3. It prevents inactive customers from being queried

**Correct Answer Index:** 1
**Hint:** Consider what "partial" means and how it affects storage and performance.
**Correct Answer Explanation:** Partial indexes are smaller because they only index rows meeting the WHERE condition, saving storage space and making index maintenance faster for the relevant subset of data.
**Incorrect Answer Explanations:**
- Option 0: It only speeds up queries that match the WHERE condition
- Option 2: The index updates when data changes, but this isn't its main advantage
- Option 3: Partial indexes don't prevent queries; they just don't help with non-matching rows

---

## Question 9
**Question Number:** 9
**Key Concept Tested:** Functional indexes
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** Why would you create this functional index?
```sql
CREATE INDEX idx_customer_lower_name ON customer (LOWER(last_name));
```

**Options:**
0. To make the last_name column case-sensitive
1. To enable case-insensitive searches on last_name
2. To automatically convert all last_name values to lowercase
3. To prevent uppercase letters from being stored

**Correct Answer Index:** 1
**Hint:** Think about what queries this index would help optimize.
**Correct Answer Explanation:** This functional index enables efficient case-insensitive searches using queries like WHERE LOWER(last_name) = 'smith', without requiring a full table scan.
**Incorrect Answer Explanations:**
- Option 0: This makes searches case-insensitive, not case-sensitive
- Option 2: The index doesn't change stored data, only provides efficient access
- Option 3: The index doesn't prevent data storage, it just provides optimized access

---

## Question 10
**Question Number:** 10
**Key Concept Tested:** Covering indexes and INCLUDE clause
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** What is the benefit of using INCLUDE in this index?
```sql
CREATE INDEX idx_film_rating ON film (rating) INCLUDE (title, rental_rate);
```

**Options:**
0. It makes the index smaller by excluding unnecessary columns
1. It allows the query to be satisfied entirely from the index without accessing the table
2. It creates separate indexes on the included columns automatically
3. It ensures the included columns are always sorted

**Correct Answer Index:** 1
**Hint:** Think about what happens when all needed data is available in the index itself.
**Correct Answer Explanation:** The INCLUDE clause creates a covering index that stores additional column values, allowing queries that need rating, title, and rental_rate to be satisfied entirely from the index without accessing the table data.
**Incorrect Answer Explanations:**
- Option 0: INCLUDE actually makes the index larger by adding more data
- Option 2: INCLUDE doesn't create separate indexes, it adds columns to the existing index
- Option 3: Included columns are stored but not part of the index key structure

---

## Question 11
**Question Number:** 11
**Key Concept Tested:** Index usage monitoring
**Difficulty:** Medium
**Type:** True/False
**Question:** The pg_stat_user_indexes view shows how many times each index has been used by queries.

**Options:**
0. True
1. False

**Correct Answer Index:** 0
**Hint:** Think about PostgreSQL's built-in statistics collection for performance monitoring.
**Correct Answer Explanation:** True. The pg_stat_user_indexes view provides statistics including idx_scan (number of index scans), idx_tup_read, and idx_tup_fetch, helping identify unused or heavily used indexes.
**Incorrect Answer Explanations:**
- Option 1: PostgreSQL does track index usage statistics in this system view

---

## Question 12
**Question Number:** 12
**Key Concept Tested:** Index creation in production environments
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** What is the recommended way to create indexes on large production tables?

**Options:**
0. CREATE INDEX (standard method)
1. CREATE INDEX CONCURRENTLY
2. CREATE INDEX WITH LOCK
3. CREATE INDEX IMMEDIATELY

**Correct Answer Index:** 1
**Hint:** Consider what happens to table availability during index creation on large tables.
**Correct Answer Explanation:** CREATE INDEX CONCURRENTLY allows index creation without locking the table for writes, making it safe for production environments where table availability is critical.
**Incorrect Answer Explanations:**
- Option 0: Standard CREATE INDEX locks the table, which can cause downtime
- Option 2: No such syntax exists in PostgreSQL
- Option 3: No such syntax exists in PostgreSQL

---

## Question 13
**Question Number:** 13
**Key Concept Tested:** Foreign key indexing best practices
**Difficulty:** Easy
**Type:** True/False
**Question:** Foreign key columns should almost always have indexes for optimal join performance.

**Options:**
0. True
1. False

**Correct Answer Index:** 0
**Hint:** Think about what happens during JOIN operations and referential integrity checks.
**Correct Answer Explanation:** True. Indexing foreign key columns dramatically improves JOIN performance and speeds up referential integrity checks when parent records are updated or deleted.
**Incorrect Answer Explanations:**
- Option 1: Foreign key indexes are crucial for join performance and referential integrity

---

## Question 14
**Question Number:** 14
**Key Concept Tested:** Index selectivity and effectiveness
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** Which column would be the WORST candidate for indexing?

**Options:**
0. customer_id (unique identifier)
1. email (mostly unique values)
2. gender (only 'M' and 'F' values)
3. order_date (many different dates)

**Correct Answer Index:** 2
**Hint:** Consider how many different values exist and how much an index would narrow down the search.
**Correct Answer Explanation:** Gender with only 'M' and 'F' values has very low selectivity. An index wouldn't significantly narrow down searches since it would still return roughly half the table.
**Incorrect Answer Explanations:**
- Option 0: Unique identifiers have perfect selectivity and benefit greatly from indexing
- Option 1: Mostly unique values have high selectivity and work well with indexes
- Option 3: Date columns typically have good selectivity and are frequently used in range queries

---

## Question 15
**Question Number:** 15
**Key Concept Tested:** GIN indexes and complex data types
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** GIN (Generalized Inverted Index) indexes are primarily designed for:

**Options:**
0. Speeding up mathematical calculations
1. Indexing arrays, JSONB, and full-text search data
2. Improving performance of simple equality comparisons
3. Reducing storage space requirements

**Correct Answer Index:** 1
**Hint:** Think about what types of data structures need special indexing strategies.
**Correct Answer Explanation:** GIN indexes are specialized for complex data types like arrays, JSONB documents, and full-text search where you need to find rows containing specific elements or terms.
**Incorrect Answer Explanations:**
- Option 0: GIN indexes don't perform calculations; they optimize data retrieval
- Option 2: Simple equality is better handled by B-Tree or Hash indexes
- Option 3: GIN indexes typically use more space, not less

---

## Question 16
**Question Number:** 16
**Key Concept Tested:** EXPLAIN and query plan analysis
**Difficulty:** Medium
**Type:** True/False
**Question:** The EXPLAIN command shows whether PostgreSQL is using an index for a specific query.

**Options:**
0. True
1. False

**Correct Answer Index:** 0
**Hint:** Consider what information EXPLAIN provides about query execution plans.
**Correct Answer Explanation:** True. EXPLAIN shows the query execution plan, including whether indexes are being used (Index Scan, Index Only Scan) or if a Sequential Scan (full table scan) is being performed.
**Incorrect Answer Explanations:**
- Option 1: EXPLAIN specifically shows index usage in the query plan

---

## Question 17
**Question Number:** 17
**Key Concept Tested:** Index maintenance operations
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** What is the purpose of the REINDEX command?

**Options:**
0. To create a new index on an existing table
1. To rebuild an existing index to optimize its structure and reclaim space
2. To delete unused indexes automatically
3. To copy an index from one table to another

**Correct Answer Index:** 1
**Hint:** Think about what happens to indexes over time with many data modifications.
**Correct Answer Explanation:** REINDEX rebuilds an existing index, removing bloat and optimizing its structure. This can improve performance and reclaim disk space after many INSERT, UPDATE, DELETE operations.
**Incorrect Answer Explanations:**
- Option 0: That's CREATE INDEX, not REINDEX
- Option 2: REINDEX doesn't delete indexes; it rebuilds them
- Option 3: Indexes can't be copied between tables; they must be created based on table structure

---

## Question 18
**Question Number:** 18
**Key Concept Tested:** Redundant indexes and optimization
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** If you have an index on (customer_id, rental_date), do you also need a separate index on just (customer_id)?

**Options:**
0. Yes, always create both for maximum performance
1. No, the composite index can handle queries filtering by customer_id alone
2. Yes, but only if customer_id queries are more frequent
3. No, composite indexes cannot be used for single-column queries

**Correct Answer Index:** 1
**Hint:** Think about how PostgreSQL can use the leftmost columns of a composite index.
**Correct Answer Explanation:** No separate index is needed. PostgreSQL can use the leftmost portion of a composite index (customer_id, rental_date) to efficiently handle queries that filter by customer_id alone.
**Incorrect Answer Explanations:**
- Option 0: This creates redundant indexes that waste space and slow down writes
- Option 2: The composite index handles single-column queries efficiently regardless of frequency
- Option 3: Composite indexes CAN be used for queries on leftmost columns

---

## Question 19
**Question Number:** 19
**Key Concept Tested:** Index size and storage considerations
**Difficulty:** Easy
**Type:** True/False
**Question:** Indexes consume additional disk storage space beyond the original table data.

**Options:**
0. True
1. False

**Correct Answer Index:** 0
**Hint:** Think about whether indexes are stored separately from table data.
**Correct Answer Explanation:** True. Indexes are separate data structures that require their own storage space. Large tables with many indexes can use significant additional disk space.
**Incorrect Answer Explanations:**
- Option 1: Indexes definitely require additional storage space

---

## Question 20
**Question Number:** 20
**Key Concept Tested:** When NOT to use indexes
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** In which scenario would adding an index likely NOT improve performance?

**Options:**
0. A large table with frequent SELECT queries filtering by a specific column
1. A table with heavy INSERT, UPDATE, DELETE operations and rare SELECT queries
2. A foreign key column used in frequent JOIN operations
3. A column used in WHERE clauses of slow queries

**Correct Answer Index:** 1
**Hint:** Consider the trade-off between read and write performance.
**Correct Answer Explanation:** When a table has heavy write operations (INSERT, UPDATE, DELETE) but rare SELECT queries, indexes would slow down the frequent writes without providing much benefit for the rare reads.
**Incorrect Answer Explanations:**
- Option 0: This is exactly when indexes provide the most benefit
- Option 2: Foreign key indexes are almost always beneficial for JOIN performance
- Option 3: Indexes are specifically designed to speed up WHERE clause filtering
