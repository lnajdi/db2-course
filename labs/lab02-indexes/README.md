# Lab 03: Database Indexes

## 🎯 Learning Objectives
- Understand different types of indexes and their use cases
- Analyze query performance using EXPLAIN and EXPLAIN ANALYZE
- Create optimal indexes for various query patterns
- Understand the trade-offs between query speed and write performance
- Implement partial and composite indexes

## 📚 Theory Overview

### Index Types in PostgreSQL:
- **B-tree**: Default, good for equality and range queries
- **Hash**: Fast equality lookups, no range queries
- **GIN**: Full-text search, array operations
- **GiST**: Geometric data, full-text search
- **BRIN**: Very large tables with natural ordering

### When to Use Indexes:
- ✅ Columns in WHERE clauses
- ✅ Foreign key columns
- ✅ ORDER BY columns
- ✅ Frequently joined columns
- ❌ Small tables
- ❌ Frequently updated columns
- ❌ Columns with low cardinality

## 🛠️ Exercises

### Exercise 1: Query Analysis (25 points)

**1.1** Analyze these queries without indexes:
```sql
-- Query A: Customer lookup by last name
SELECT * FROM customer WHERE last_name = 'SMITH';

-- Query B: Film search by rental rate range  
SELECT * FROM film WHERE rental_rate BETWEEN 2.00 AND 4.00;

-- Query C: Complex join query
SELECT c.first_name, c.last_name, f.title, r.rental_date
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id  
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE c.last_name = 'DAVIS' AND r.rental_date > '2005-07-01';
```

Use `EXPLAIN ANALYZE` to document:
- Execution time
- Node types (Seq Scan, Hash Join, etc.)
- Rows examined vs. rows returned
- Most expensive operations

**1.2** Identify indexing opportunities:
- Which columns are used in WHERE clauses?
- Which joins lack supporting indexes?
- What are the selectivity characteristics?

### Exercise 2: Basic Index Creation (30 points)

**2.1** Create single-column indexes:
```sql
-- Create indexes for common lookup patterns
-- Customer searches
-- Film searches  
-- Date range queries
```

**2.2** Create composite indexes:
```sql
-- Multi-column indexes for complex queries
-- Consider column order based on selectivity
-- Support ORDER BY operations
```

**2.3** Re-run analysis queries:
- Document performance improvements
- Compare before/after execution plans
- Measure actual time improvements

### Exercise 3: Advanced Indexing (25 points)

**3.1** Partial indexes:
```sql
-- Create indexes for subset of data
-- Active customers only
-- Recent rentals only
-- Available inventory only
```

**3.2** Expression indexes:
```sql
-- Indexes on computed columns
-- Full name searches (first_name || ' ' || last_name)
-- Date extractions (EXTRACT(year FROM rental_date))
-- Case-insensitive searches
```

**3.3** Covering indexes:
```sql
-- Include additional columns in index
-- Eliminate table lookups
-- Support index-only scans
```

### Exercise 4: Performance Optimization (20 points)

**4.1** Real-world query optimization:
Optimize this analytical query:
```sql
SELECT 
    c.name AS category,
    COUNT(*) AS rental_count,
    AVG(f.rental_rate) AS avg_rate,
    SUM(p.amount) AS total_revenue
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
WHERE r.rental_date BETWEEN '2005-06-01' AND '2005-08-31'
GROUP BY c.name
ORDER BY total_revenue DESC;
```

**4.2** Index maintenance:
- Monitor index usage with `pg_stat_user_indexes`
- Identify unused indexes
- Calculate index size overhead
- Create index maintenance strategy

## 🔍 Index Analysis Tools

### Check Index Usage:
```sql
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

### Check Index Sizes:
```sql
SELECT schemaname, tablename, indexname, 
       pg_size_pretty(pg_relation_size(indexrelid)) as size
FROM pg_stat_user_indexes
ORDER BY pg_relation_size(indexrelid) DESC;
```

### Find Unused Indexes:
```sql
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes 
WHERE idx_scan = 0;
```

## 📝 Deliverables

Complete the `solutions.sql` file with:
1. EXPLAIN ANALYZE output for queries before indexing
2. All index creation statements with rationale
3. Performance comparison analysis
4. Index maintenance recommendations
5. Documentation of index strategy decisions

## 💡 Index Best Practices

- **Measure First**: Always analyze before creating indexes
- **Column Order**: Most selective columns first in composite indexes
- **Maintenance Cost**: Consider write performance impact
- **Monitor Usage**: Remove unused indexes
- **Partial Indexes**: For large tables with skewed data distribution
- **Expression Indexes**: For computed column searches

## 🚀 Advanced Challenges (Optional)

1. **Multi-column Statistics**: Create extended statistics for correlated columns
2. **Index-Only Scans**: Design indexes that eliminate table access
3. **Constraint Exclusion**: Use CHECK constraints with partial indexes
4. **Parallel Index Creation**: Understand parallel index building

---

**Time Estimate**: 3-4 hours
**Difficulty**: ⭐⭐⭐☆☆ (Intermediate)
