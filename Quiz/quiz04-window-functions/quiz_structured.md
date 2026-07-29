# CTE and Window Functions Quiz - Structured Content

## Quiz Title: PostgreSQL CTEs and Window Functions
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
**Key Concept Tested:** Basic definition of Common Table Expressions (CTEs)
**Difficulty:** Easy
**Type:** Multiple Choice
**Question:** What is a Common Table Expression (CTE) in PostgreSQL?

**Options:**
0. A permanent view that is stored in the database schema
1. A temporary named result set that exists only for the duration of a single SQL statement
2. A special type of index that improves query performance
3. A constraint that enforces data integrity across multiple tables

**Correct Answer Index:** 1
**Hint:** Think about the "temporary" and "named" aspects of CTEs.
**Correct Answer Explanation:** A CTE is a temporary named result set that exists only during the execution of a single SQL statement. It acts like a temporary view that can be referenced within the main query.
**Incorrect Answer Explanations:**
- Option 0: CTEs are temporary, not permanent like stored views
- Option 2: CTEs are query constructs, not performance indexes
- Option 3: CTEs don't enforce constraints; they organize query logic

---

## Question 2
**Question Number:** 2
**Key Concept Tested:** Basic CTE syntax
**Difficulty:** Easy
**Type:** Multiple Choice
**Question:** What is the correct syntax to create a CTE in PostgreSQL?

**Options:**
0. CREATE TEMP TABLE cte_name AS (SELECT ...)
1. WITH cte_name AS (SELECT ...)
2. DECLARE cte_name AS (SELECT ...)
3. LET cte_name = (SELECT ...)

**Correct Answer Index:** 1
**Hint:** CTEs use a specific keyword that indicates they're "with" the main query.
**Correct Answer Explanation:** The correct syntax is WITH cte_name AS (SELECT ...) followed by the main query that can reference the CTE.
**Incorrect Answer Explanations:**
- Option 0: This creates an actual temporary table, not a CTE
- Option 2: DECLARE is for variables in PL/pgSQL, not CTEs
- Option 3: LET is not valid PostgreSQL syntax

---

## Question 3
**Question Number:** 3
**Key Concept Tested:** Window functions basic concept
**Difficulty:** Easy
**Type:** Multiple Choice
**Question:** What is the primary difference between window functions and GROUP BY aggregations?

**Options:**
0. Window functions are faster than GROUP BY operations
1. Window functions preserve individual rows while GROUP BY collapses them
2. Window functions can only work with numeric data
3. Window functions require indexes while GROUP BY does not

**Correct Answer Index:** 1
**Hint:** Think about what happens to individual rows in each approach.
**Correct Answer Explanation:** Window functions perform calculations across sets of rows while preserving individual rows in the result set, whereas GROUP BY aggregations collapse rows into summary results.
**Incorrect Answer Explanations:**
- Option 0: Performance depends on the specific query, not the function type
- Option 2: Window functions work with various data types, not just numeric
- Option 3: Neither necessarily requires indexes, though both can benefit from them

---

## Question 4
**Question Number:** 4
**Key Concept Tested:** RANK vs DENSE_RANK vs ROW_NUMBER
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** Given these rental rates: 4.99, 4.99, 2.99, 2.99, 1.99, what would DENSE_RANK() produce?

**Options:**
0. 1, 2, 3, 4, 5
1. 1, 1, 2, 2, 3
2. 1, 1, 3, 3, 5
3. 1, 2, 2, 3, 4

**Correct Answer Index:** 1
**Hint:** DENSE_RANK gives the same rank to ties and doesn't skip any rank numbers.
**Correct Answer Explanation:** DENSE_RANK() assigns rank 1 to both 4.99 values, rank 2 to both 2.99 values, and rank 3 to 1.99, with no gaps in the sequence.
**Incorrect Answer Explanations:**
- Option 0: This would be ROW_NUMBER(), which always produces unique values
- Option 2: This would be RANK(), which skips rank numbers after ties
- Option 3: This sequence doesn't match any standard ranking function behavior

---

## Question 5
**Question Number:** 5
**Key Concept Tested:** PARTITION BY clause in window functions
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** What does the PARTITION BY clause do in a window function?

**Options:**
0. It divides the result set into separate groups for the window function calculation
1. It sorts the data in ascending order for the calculation
2. It limits the number of rows returned by the query
3. It creates a physical partition on the disk for better performance

**Correct Answer Index:** 0
**Hint:** Think about how you might want to calculate ranks separately within different categories.
**Correct Answer Explanation:** PARTITION BY divides the result set into separate groups (partitions), and the window function is applied independently within each partition.
**Incorrect Answer Explanations:**
- Option 1: That's what ORDER BY does, not PARTITION BY
- Option 2: That's what LIMIT does, not PARTITION BY
- Option 3: PARTITION BY in window functions is logical grouping, not physical disk partitioning

---

## Question 6
**Question Number:** 6
**Key Concept Tested:** Multiple CTEs
**Difficulty:** Medium
**Type:** True/False
**Question:** You can define multiple CTEs in a single query by separating them with commas.

**Options:**
0. True
1. False

**Correct Answer Index:** 0
**Hint:** Think about how you might break down a complex analysis into multiple logical steps.
**Correct Answer Explanation:** True. You can define multiple CTEs in one query using WITH cte1 AS (...), cte2 AS (...), cte3 AS (...) SELECT ... syntax.
**Incorrect Answer Explanations:**
- Option 1: Multiple CTEs are definitely supported and commonly used in complex queries

---

## Question 7
**Question Number:** 7
**Key Concept Tested:** LAG and LEAD functions
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** In this query, what will LAG(rental_date, 2) return for the third row?
```sql
SELECT rental_date, LAG(rental_date, 2) OVER (ORDER BY rental_date)
FROM rental ORDER BY rental_date;
```

**Options:**
0. The rental_date from the second row
1. The rental_date from the first row
2. The rental_date from the fifth row
3. NULL because there isn't a second previous row

**Correct Answer Index:** 1
**Hint:** LAG(column, n) looks n rows back from the current position.
**Correct Answer Explanation:** LAG(rental_date, 2) looks 2 rows back from the current row. For the third row, 2 rows back is the first row, so it returns the first row's rental_date.
**Incorrect Answer Explanations:**
- Option 0: That would be LAG(rental_date, 1) - looking back 1 row
- Option 2: LEAD looks forward, and 2 rows forward from row 3 would be row 5
- Option 3: There is a second previous row available (the first row)

---

## Question 8
**Question Number:** 8
**Key Concept Tested:** Window frame specifications
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** What does this window frame specification calculate?
```sql
SUM(amount) OVER (ORDER BY payment_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
```

**Options:**
0. Sum of all payments from the beginning to current row
1. Sum of current row plus the next 2 rows
2. Sum of current row plus the previous 2 rows (3 rows total)
3. Sum of only the 2 rows immediately before the current row

**Correct Answer Index:** 2
**Hint:** "ROWS BETWEEN 2 PRECEDING AND CURRENT ROW" defines a 3-row sliding window.
**Correct Answer Explanation:** This creates a sliding window that includes the current row plus the 2 preceding rows, calculating a 3-row moving sum.
**Incorrect Answer Explanations:**
- Option 0: That would be "ROWS UNBOUNDED PRECEDING"
- Option 1: That would be "ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING"
- Option 3: That would exclude the current row, which this frame specification includes

---

## Question 9
**Question Number:** 9
**Key Concept Tested:** FIRST_VALUE and LAST_VALUE functions
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** Why might you need "ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING" with LAST_VALUE?

**Options:**
0. To improve query performance
1. To ensure LAST_VALUE sees the actual last row in the partition, not just the current row
2. To make LAST_VALUE work the same as FIRST_VALUE
3. To prevent LAST_VALUE from returning NULL values

**Correct Answer Index:** 1
**Hint:** Consider the default window frame and how it affects what LAST_VALUE can "see."
**Correct Answer Explanation:** By default, window functions use "ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW", so LAST_VALUE would only see up to the current row. The extended frame ensures it sees the actual last row.
**Incorrect Answer Explanations:**
- Option 0: The frame specification doesn't necessarily improve performance
- Option 2: FIRST_VALUE and LAST_VALUE serve different purposes regardless of frame
- Option 3: NULL values are handled independently of the frame specification

---

## Question 10
**Question Number:** 10
**Key Concept Tested:** CTE vs subquery benefits
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** What is the main advantage of using a CTE instead of a subquery?

**Options:**
0. CTEs always execute faster than subqueries
1. CTEs can be referenced multiple times within the same query
2. CTEs use less memory than subqueries
3. CTEs automatically create indexes on their results

**Correct Answer Index:** 1
**Hint:** Think about reusability and readability when breaking down complex logic.
**Correct Answer Explanation:** CTEs can be referenced multiple times in the main query, improving code reusability and readability compared to duplicating subqueries.
**Incorrect Answer Explanations:**
- Option 0: Performance depends on the specific query, not whether it uses CTE or subquery
- Option 2: Memory usage is similar between CTEs and equivalent subqueries
- Option 3: CTEs don't automatically create indexes; they're temporary result sets

---

## Question 11
**Question Number:** 11
**Key Concept Tested:** Recursive CTEs
**Difficulty:** Hard
**Type:** True/False
**Question:** Recursive CTEs in PostgreSQL can potentially run infinitely if not properly constrained.

**Options:**
0. True
1. False

**Correct Answer Index:** 0
**Hint:** Think about what could happen if the recursive condition never becomes false.
**Correct Answer Explanation:** True. Recursive CTEs can create infinite loops if the recursive condition is never false and no limits are set. This is why proper termination conditions are crucial.
**Incorrect Answer Explanations:**
- Option 1: Without proper constraints, recursive CTEs can indeed run infinitely until system limits are reached

---

## Question 12
**Question Number:** 12
**Key Concept Tested:** NTILE function
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** What does NTILE(4) do in a window function?

**Options:**
0. Returns the top 4 rows from each partition
1. Divides the result set into 4 approximately equal groups
2. Calculates a 4-period moving average
3. Looks 4 rows ahead in the ordered result set

**Correct Answer Index:** 1
**Hint:** Think about dividing data into equal-sized buckets or quantiles.
**Correct Answer Explanation:** NTILE(4) divides the ordered result set into 4 approximately equal groups (quartiles), assigning each row a bucket number from 1 to 4.
**Incorrect Answer Explanations:**
- Option 0: NTILE distributes all rows into buckets, not just the top ones
- Option 2: That would be a moving average function, not NTILE
- Option 3: That would be LEAD(column, 4), not NTILE

---

## Question 13
**Question Number:** 13
**Key Concept Tested:** Window function performance
**Difficulty:** Medium
**Type:** True/False
**Question:** Window functions always perform better than equivalent GROUP BY queries with JOINs.

**Options:**
0. True
1. False

**Correct Answer Index:** 1
**Hint:** Performance depends on many factors including data size, indexes, and specific query requirements.
**Correct Answer Explanation:** False. Performance depends on various factors like data volume, available indexes, and specific query patterns. Sometimes GROUP BY with JOINs can be more efficient.
**Incorrect Answer Explanations:**
- Option 0: There's no universal performance advantage; it depends on the specific scenario

---

## Question 14
**Question Number:** 14
**Key Concept Tested:** CTE materialization
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** How are CTEs typically executed in PostgreSQL?

**Options:**
0. They are always materialized (stored) before the main query executes
1. They are always inlined (merged) with the main query
2. PostgreSQL decides whether to materialize or inline based on query optimization
3. They are executed once for each time they are referenced

**Correct Answer Index:** 2
**Hint:** Think about how query optimizers make decisions about execution plans.
**Correct Answer Explanation:** PostgreSQL's query planner decides whether to materialize the CTE or inline it based on factors like CTE complexity, reference count, and overall query optimization.
**Incorrect Answer Explanations:**
- Option 0: CTEs aren't always materialized; simple ones may be inlined
- Option 1: Complex CTEs or those referenced multiple times are often materialized
- Option 3: Materialized CTEs are executed once and reused, not re-executed per reference

---

## Question 15
**Question Number:** 15
**Key Concept Tested:** PERCENT_RANK function
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** What does PERCENT_RANK() return?

**Options:**
0. The percentage each value represents of the total sum
1. The relative rank of each row as a percentage between 0 and 1
2. The percentile that each value falls into (1-100)
3. The percentage change from the previous row's value

**Correct Answer Index:** 1
**Hint:** Think about ranking position relative to the total number of rows.
**Correct Answer Explanation:** PERCENT_RANK() returns the relative rank of each row as a value between 0 and 1, where 0 is the lowest rank and 1 is the highest rank.
**Incorrect Answer Explanations:**
- Option 0: That would be calculating percentage of total, not rank percentage
- Option 2: PERCENT_RANK returns 0-1, not 1-100; and it's rank-based, not value-based percentiles
- Option 3: That would be calculating rate of change, not rank percentage

---

## Question 16
**Question Number:** 16
**Key Concept Tested:** CTE scope and references
**Difficulty:** Easy
**Type:** True/False
**Question:** A CTE defined in one query can be used in a completely separate query later in the same session.

**Options:**
0. True
1. False

**Correct Answer Index:** 1
**Hint:** Consider the "temporary" nature of CTEs and their scope.
**Correct Answer Explanation:** False. CTEs exist only for the duration of the single SQL statement in which they are defined. They cannot be referenced in separate queries.
**Incorrect Answer Explanations:**
- Option 0: CTEs are scoped to the single statement where they're defined, not the entire session

---

## Question 17
**Question Number:** 17
**Key Concept Tested:** Running totals with window functions
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** Which window function specification creates a running total from the beginning of the partition?

**Options:**
0. SUM(amount) OVER (ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
1. SUM(amount) OVER (ROWS UNBOUNDED PRECEDING)
2. SUM(amount) OVER (PARTITION BY customer_id)
3. SUM(amount) OVER (ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)

**Correct Answer Index:** 1
**Hint:** A running total accumulates all values from the start up to the current row.
**Correct Answer Explanation:** "ROWS UNBOUNDED PRECEDING" creates a window from the beginning of the partition to the current row, producing a running total.
**Incorrect Answer Explanations:**
- Option 0: This would sum from current row to the end, not from the beginning
- Option 2: Without ORDER BY and frame specification, this would sum the entire partition for each row
- Option 3: This creates a 3-row moving average, not a running total

---

## Question 18
**Question Number:** 18
**Key Concept Tested:** Recursive CTE structure
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** What are the two main parts of a recursive CTE?

**Options:**
0. SELECT clause and WHERE clause
1. Base case (anchor) and recursive case
2. PARTITION BY and ORDER BY clauses
3. Initial query and final query

**Correct Answer Index:** 1
**Hint:** Think about how recursion works - you need a starting point and a way to continue.
**Correct Answer Explanation:** Recursive CTEs have a base case (anchor member) that provides initial rows, and a recursive case that defines how to generate additional rows from existing ones.
**Incorrect Answer Explanations:**
- Option 0: These are general SQL clauses, not specific to recursive CTE structure
- Option 2: These are window function clauses, not recursive CTE components
- Option 3: Too vague; doesn't capture the specific recursive structure requirements

---

## Question 19
**Question Number:** 19
**Key Concept Tested:** Window functions with NULL values
**Difficulty:** Easy
**Type:** True/False
**Question:** Window functions like LAG() and LEAD() return NULL when looking beyond the available rows in the partition.

**Options:**
0. True
1. False

**Correct Answer Index:** 0
**Hint:** Consider what happens when LAG tries to look at a previous row that doesn't exist.
**Correct Answer Explanation:** True. When LAG() or LEAD() functions try to access rows that don't exist (e.g., LAG on the first row, or LEAD on the last row), they return NULL.
**Incorrect Answer Explanations:**
- Option 1: These functions do return NULL when trying to access non-existent rows

---

## Question 20
**Question Number:** 20
**Key Concept Tested:** Combining CTEs with window functions
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** What is a common pattern when combining CTEs with window functions?

**Options:**
0. Use CTEs to prepare base data, then apply window functions in the main query
1. Never use them together as they conflict with each other
2. Always use window functions inside CTE definitions, never in the main query
3. Use CTEs only for recursive operations and window functions only for rankings

**Correct Answer Index:** 0
**Hint:** Think about how you might break down complex analytical queries into logical steps.
**Correct Answer Explanation:** A common pattern is to use CTEs to prepare, clean, and structure base data, then apply window functions in the main query for analytical calculations like rankings, running totals, or comparisons.
**Incorrect Answer Explanations:**
- Option 1: CTEs and window functions work well together and are commonly combined
- Option 2: Window functions can be used effectively in both CTEs and main queries
- Option 3: Both CTEs and window functions have much broader applications than these specific use cases
