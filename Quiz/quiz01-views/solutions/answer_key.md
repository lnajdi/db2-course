# Quiz 01 Solutions: Views and Materialized Views

## Part A: Multiple Choice Questions (40 points)

### Question 1: **b) A virtual table based on a SELECT statement**
**Explanation**: A view is a virtual table that doesn't store data physically but presents data from one or more base tables based on a SELECT query.

### Question 2: **c) They reflect real-time data from underlying tables**  
**Explanation**: Regular views are "live" - they always show current data from base tables since they execute the underlying query each time they're accessed.

### Question 3: **c) When you have complex, expensive queries that don't need real-time data**
**Explanation**: Materialized views are ideal for complex analytical queries that are expensive to run repeatedly, especially when slightly stale data is acceptable.

### Question 4: **c) Only views based on a single table without aggregations are typically updatable**
**Explanation**: Updatable views have strict requirements - single table, no aggregations, no DISTINCT, no complex expressions.

### Question 5: **b) It ensures that modified data still satisfies the view's WHERE condition**
**Explanation**: CHECK OPTION prevents INSERT/UPDATE operations that would create rows not visible through the view.

### Question 6: **b) REFRESH MATERIALIZED VIEW sales_summary;**
**Explanation**: This is the correct PostgreSQL syntax to refresh a materialized view.

### Question 7: **c) CREATE OR REPLACE VIEW**
**Explanation**: PostgreSQL uses CREATE OR REPLACE VIEW to modify existing views. ALTER VIEW has limited functionality.

### Question 8: **b) They provide controlled access to specific columns/rows**
**Explanation**: Views can hide sensitive columns and filter rows, providing a security layer for data access.

### Question 9: **b) SELECT * FROM customer_summary_mv; (materialized view)**
**Explanation**: Materialized views store pre-computed results, making queries faster than regular views that must execute underlying queries.

### Question 10: **b) The views become invalid but still exist**
**Explanation**: Views remain in the system catalog but become invalid when their base tables are dropped.

---

## Part B: True/False Questions (20 points)

1. **True** - Views can be based on other views (though not recommended for deep nesting)
2. **False** - Materialized views require manual REFRESH commands
3. **True** - You can create indexes on materialized views for better performance
4. **False** - Views can sometimes hurt performance due to query complexity
5. **True** - CHECK OPTION validates data modifications against view conditions
6. **False** - Regular views are virtual and don't consume storage for data
7. **True** - ORDER BY is allowed in view definitions
8. **False** - Views typically work within a single database (dblink is an exception)
9. **False** - Materialized views don't auto-refresh on restart
10. **True** - Views can contain aggregate functions
11. **True** - Views can have different permissions than base tables
12. **True** - Views provide security by hiding sensitive columns
13. **False** - Only simple views meeting specific criteria are updatable
14. **True** - REFRESH MATERIALIZED VIEW CONCURRENTLY allows non-blocking refresh
15. **True** - Views abstract complex queries behind simple names
16. **True** - DISTINCT is allowed in view definitions
17. **False** - Views don't automatically inherit constraints
18. **True** - Materialized views can have triggers like regular tables
19. **True** - Views can be used anywhere a table can be used
20. **False** - Creating views doesn't require exclusive locks

---

## Part C: Practical SQL Solutions (40 points)

### Exercise 1: Basic View Creation (8 points)
```sql
CREATE VIEW customer_contact AS
SELECT 
    customer_id,
    first_name,
    last_name,
    email
FROM customer;
```

**Grading Criteria:**
- Correct syntax (2 points)
- Includes all required columns (4 points)  
- Uses appropriate view name (2 points)

### Exercise 2: Complex Join View (10 points)
```sql
CREATE VIEW rental_details AS
SELECT 
    r.rental_id,
    c.first_name || ' ' || c.last_name AS customer_full_name,
    f.title AS film_title,
    r.rental_date,
    r.return_date
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id  
JOIN film f ON i.film_id = f.film_id;
```

**Grading Criteria:**
- Correct joins (4 points)
- All required columns (3 points)
- Proper column aliases (2 points)
- Correct syntax (1 point)

### Exercise 3: Filtered Business View (8 points)
```sql
CREATE VIEW active_recent_customers AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    MAX(r.rental_date) AS last_rental_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE c.active = 1
    AND r.rental_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;
```

**Grading Criteria:**
- Correct filtering for active customers (2 points)
- Correct date filtering (2 points)
- Proper grouping and aggregation (3 points)
- Includes all required columns (1 point)

### Exercise 4: Materialized View (10 points)  
```sql
CREATE MATERIALIZED VIEW film_rental_stats AS
SELECT 
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS total_rentals,
    COALESCE(SUM(p.amount), 0) AS total_revenue,
    ROUND(AVG(EXTRACT(days FROM (r.return_date - r.rental_date))), 2) AS avg_rental_days
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
WHERE r.return_date IS NOT NULL  -- Only completed rentals for duration calculation
GROUP BY f.film_id, f.title
ORDER BY total_rentals DESC;
```

**Grading Criteria:**
- Correct MATERIALIZED VIEW syntax (2 points)
- Proper joins (3 points)
- Correct aggregations (3 points)
- Handles NULL values appropriately (2 points)

### Exercise 5: View with Security (4 points)
```sql
CREATE VIEW staff_public_info AS
SELECT 
    staff_id,
    first_name,
    last_name,
    email,
    active
FROM staff;
```

**Grading Criteria:**
- Excludes password field (2 points)
- Includes all other required fields (2 points)

---

## Bonus Question Solution (5 points)

**Sample Answer:**
Materialized views should be chosen over regular views when dealing with complex, resource-intensive queries that don't require real-time data, such as analytical reports or dashboards that aggregate large amounts of historical data. The main drawback is that materialized views can become stale since they don't automatically update when base tables change, requiring manual refreshes which can be resource-intensive and may temporarily lock the materialized view.

**Grading Criteria:**
- Correctly identifies when to use materialized views (2 points)
- Identifies at least one valid drawback (2 points)
- Clear, well-written explanation (1 point)

---

## Total Points: 105 possible (100 base + 5 bonus)

## Performance Standards:
- **95-105**: Excellent - Advanced understanding
- **85-94**: Good - Solid grasp with minor gaps  
- **75-84**: Satisfactory - Basic understanding, needs practice
- **65-74**: Needs improvement - Review core concepts
- **Below 65**: Requires additional study and practice
