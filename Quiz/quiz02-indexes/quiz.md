# Quiz 02: Database Indexes and Performance Optimization 🚀

## Learning Objectives 🎯
After completing this module, students should be able to:
- Understand different types of database indexes (B-tree, Hash, GIN, GIST)
- Create and manage indexes effectively
- Analyze query execution plans to identify indexing opportunities
- Understand the trade-offs between query performance and maintenance overhead
- Implement partial indexes and composite indexes
- Use EXPLAIN and EXPLAIN ANALYZE for performance tuning

## Instructions 📋
- **Total Points**: 100
- **Time Limit**: 45 minutes  
- **Database**: Pagila
- **Tools**: PostgreSQL client with EXPLAIN capabilities
- **Prerequisites**: Understanding of SELECT, JOIN, and WHERE clauses

---

## Part A: Multiple Choice Questions (30 points)
*Choose the best answer (2 points each)*

### Question 1
What is the primary purpose of a database index?
a) To store backup data
b) To speed up data retrieval operations
c) To enforce data constraints
d) To compress table data

### Question 2  
Which index type is most suitable for equality searches (WHERE column = value)?
a) B-tree index
b) Hash index
c) GIN index
d) Both A and B

### Question 3
What is a composite index?
a) An index made of multiple data types
b) An index spanning multiple columns
c) An index that combines two tables
d) An index using multiple algorithms

### Question 4
When should you avoid creating an index?
a) On frequently queried columns
b) On foreign key columns
c) On columns with very low cardinality (few distinct values)
d) On primary key columns

### Question 5
What does EXPLAIN ANALYZE show that EXPLAIN alone doesn't?
a) The query execution plan
b) Actual execution time and row counts
c) Index usage information
d) Query syntax errors

### Question 6
Which statement about partial indexes is TRUE?
a) They index all rows in a table
b) They only index rows meeting specific conditions
c) They are faster than regular indexes
d) They require more storage space

### Question 7
What happens when you insert data into a table with many indexes?
a) Insert performance improves significantly
b) Insert performance may decrease due to index maintenance
c) Indexes are automatically disabled
d) The database creates additional indexes

### Question 8
Which PostgreSQL command shows all indexes on a table named 'customer'?
a) SHOW INDEXES customer;
b) SELECT * FROM pg_indexes WHERE tablename = 'customer';
c) DESCRIBE INDEXES customer;
d) LIST INDEXES customer;

### Question 9
What is index selectivity?
a) The ability to choose which index to use
b) The ratio of distinct values to total rows
c) The speed of index creation
d) The size of the index file

### Question 10
Which type of query benefits LEAST from indexing?
a) WHERE column = 'value'
b) WHERE column LIKE 'pattern%'  
c) WHERE column > 100
d) WHERE LOWER(column) = 'value'

### Question 11
What is a covering index?
a) An index that covers the entire table
b) An index that includes all columns needed for a query
c) An index that covers multiple tables
d) An index with error handling

### Question 12
How do you create a case-insensitive index on a text column?
a) CREATE INDEX ON table (column) CASE INSENSITIVE;
b) CREATE INDEX ON table (LOWER(column));
c) CREATE IINDEX ON table (column NOCASE);
d) CREATE INDEX ON table (column) WITH CASE_INSENSITIVE;

### Question 13
What is index bloat?
a) Creating too many indexes
b) Unused space in index pages due to updates/deletes
c) Index files becoming corrupted
d) Indexes consuming too much memory

### Question 14
Which command rebuilds an index to reduce bloat?
a) REBUILD INDEX index_name;
b) REINDEX INDEX index_name;
c) REFRESH INDEX index_name;
d) OPTIMIZE INDEX index_name;

### Question 15
What is the main disadvantage of having too many indexes?
a) Increased storage requirements and slower write operations
b) Reduced query performance
c) Database crashes
d) Data corruption

---

## Part B: True/False Questions (15 points)
*Mark as True (T) or False (F) (1 point each)*

1. **T/F**: Indexes always improve query performance
2. **T/F**: Primary keys automatically have indexes in PostgreSQL
3. **T/F**: You can create an index on multiple columns (composite index)
4. **T/F**: Hash indexes are good for range queries (WHERE column > value)
5. **T/F**: Partial indexes can be smaller and more efficient than full indexes
6. **T/F**: Dropping an index immediately improves insert performance
7. **T/F**: GIN indexes are optimal for full-text search
8. **T/F**: You can create indexes on expressions like UPPER(column)
9. **T/F**: UNIQUE indexes automatically prevent duplicate values
10. **T/F**: Index scans are always faster than sequential scans
11. **T/F**: PostgreSQL can use multiple indexes in a single query
12. **T/F**: Indexes take up no additional storage space
13. **T/F**: CLUSTER command physically reorders table data based on an index
14. **T/F**: Foreign key constraints automatically create indexes
15. **T/F**: You should index every column that appears in a WHERE clause

---

## Part C: Query Analysis and Optimization (35 points)

### Exercise 1: Execution Plan Analysis (10 points)
Given this query and its execution plan:

```sql
EXPLAIN ANALYZE 
SELECT c.first_name, c.last_name, COUNT(r.rental_id)
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
WHERE c.active = 1
GROUP BY c.customer_id, c.first_name, c.last_name;
```

**Execution Plan:**
```
GroupAggregate (cost=1234.56..1345.67 rows=599 width=45) (actual time=12.34..23.45 rows=599 loops=1)
  Group Key: c.customer_id, c.first_name, c.last_name
  -> Sort (cost=1234.56..1236.06 rows=599 width=37) (actual time=12.00..12.50 rows=599 loops=1)
        Sort Key: c.customer_id
        -> Hash Right Join (cost=456.78..789.01 rows=599 width=37) (actual time=3.45..8.90 rows=1234 loops=1)
              Hash Cond: (r.customer_id = c.customer_id)
              -> Seq Scan on rental r (cost=0.00..234.56 rows=15678 width=8) (actual time=0.01..1.23 rows=16044 loops=1)
              -> Hash (cost=456.78..456.78 rows=599 width=33) (actual time=2.34..2.34 rows=599 loops=1)
                    -> Seq Scan on customer c (cost=0.00..456.78 rows=599 width=33) (actual time=0.01..2.10 rows=599 loops=1)
                          Filter: (active = 1)
                          Rows Removed by Filter: 0
```

**Questions:**
1. Identify performance bottlenecks in this execution plan (3 points)
2. Suggest specific indexes that could improve this query (4 points)  
3. Explain why your suggested indexes would help (3 points)

**Your Analysis:**
```
Bottlenecks:
[Your answer here]

Suggested Indexes:
[Your answer here]

Explanation:
[Your answer here]
```

### Exercise 2: Index Design (15 points)

For each scenario, design appropriate indexes:

**Scenario A (5 points)**: Frequent queries like:
```sql
SELECT * FROM rental 
WHERE customer_id = 123 AND rental_date >= '2024-01-01';
```

**Your Index Design:**
```sql
-- Your solution here:
```

**Scenario B (5 points)**: Queries searching for customers by email:
```sql
SELECT customer_id FROM customer WHERE email = 'customer@email.com';
```

**Your Index Design:**
```sql
-- Your solution here:  
```

**Scenario C (5 points)**: Full-text search on film descriptions:
```sql
SELECT title FROM film WHERE to_tsvector('english', description) @@ to_tsquery('action & hero');
```

**Your Index Design:**
```sql
-- Your solution here:
```

### Exercise 3: Index Maintenance (10 points)

Write SQL commands for these index management tasks:

**Task A (3 points)**: Check the size and usage statistics of all indexes on the 'rental' table
```sql
-- Your solution here:
```

**Task B (4 points)**: Find unused indexes in the database (indexes that are never used by queries)
```sql  
-- Your solution here:
```

**Task C (3 points)**: Rebuild all indexes on the 'customer' table to reduce bloat
```sql
-- Your solution here:
```

---

## Part D: Performance Scenario (20 points)

### Scenario: Slow Reporting Query

The marketing team runs this monthly report, but it takes 45 seconds to complete:

```sql
SELECT 
    c.category_name,
    DATE_TRUNC('month', r.rental_date) as rental_month,
    COUNT(*) as rental_count,
    SUM(p.amount) as total_revenue,
    COUNT(DISTINCT cust.customer_id) as unique_customers
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id  
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
JOIN customer cust ON r.customer_id = cust.customer_id
WHERE r.rental_date >= '2023-01-01'
GROUP BY c.category_name, DATE_TRUNC('month', r.rental_date)
ORDER BY rental_month DESC, rental_count DESC;
```

**Your Optimization Strategy (20 points):**

1. **Index Recommendations (8 points)**:
```sql
-- List the indexes you would create:
```

2. **Alternative Approaches (7 points)**:
```
-- Describe other optimization strategies (materialized views, query rewriting, etc.):
```

3. **Testing Plan (5 points)**:
```
-- How would you validate that your optimizations work:
```

---

## Bonus Section (Extra 10 points)

### Advanced Indexing Challenge

Design a complete indexing strategy for a high-traffic rental application with these characteristics:
- 1 million customers
- 10 million rental records  
- 50,000 films
- Heavy read workload (90% SELECT queries)
- Moderate write workload (10% INSERT/UPDATE)

**Your Strategy:**
```
[Describe your comprehensive indexing approach, considering:]
- Primary access patterns
- Index types and combinations
- Maintenance strategies  
- Performance monitoring
- Trade-off decisions
```

---

## Submission Guidelines 📤
1. Test all SQL commands against the Pagila database
2. Include execution plans where requested
3. Explain your reasoning for index choices
4. Consider both performance gains and maintenance costs

## Grading Rubric
- **Technical Accuracy**: Correct SQL syntax and valid recommendations
- **Performance Understanding**: Demonstrates grasp of index impact
- **Analysis Quality**: Thorough evaluation of execution plans
- **Practical Application**: Solutions that work in real-world scenarios

---
*Remember: The goal is not just to make queries faster, but to balance performance with system resources and maintenance overhead.*
