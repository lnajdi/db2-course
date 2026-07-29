# Lab 01: Views and Materialized Views

## 🎯 Learning Objectives
By completing this lab, you will:
- Understand the purpose and benefits of database views
- Create simple and complex views
- Work with updatable and read-only views
- Use views for data security and simplification
- Understand materialized views and their performance benefits
- Create and manage materialized views for optimization
- Implement refresh strategies for materialized views
- Analyze performance trade-offs between views and materialized views

## 📚 Theory Overview

### Regular Views
Views are virtual tables based on the result of SQL statements. They contain rows and columns like real tables, but don't store data physically.

**Benefits:**
- **Simplification**: Hide complex queries behind simple names
- **Security**: Restrict access to specific columns/rows
- **Consistency**: Ensure consistent data presentation
- **Abstraction**: Isolate applications from schema changes

**Types of Views:**
- **Simple Views**: Based on single table
- **Complex Views**: Join multiple tables, use functions
- **Updatable Views**: Allow INSERT, UPDATE, DELETE operations
- **Read-only Views**: Query access only

### Materialized Views
Materialized views store the result set physically, unlike regular views which are computed on-demand.

**Key Differences:**
- **Regular Views**: Virtual tables, computed on-demand, always current
- **Materialized Views**: Physical storage, pre-computed results, may be stale
- **Performance**: Materialized views much faster for complex queries
- **Storage**: Materialized views consume disk space
- **Freshness**: Data may be outdated until refreshed

**When to Use Materialized Views:**
- Complex aggregations over large datasets
- Frequently accessed but slowly changing data
- Analytical reporting queries
- Cross-database joins
- Performance-critical read operations

**Refresh Strategies:**
- **Manual Refresh**: `REFRESH MATERIALIZED VIEW view_name`
- **Complete Refresh**: Rebuilds entire view
- **Concurrent Refresh**: Allows queries during refresh (requires unique index)

## 🛠️ Exercises

### Exercise 1: Simple Views (20 points)
Create views that simplify data access for common queries.

**1.1** Create a view called `customer_info` that shows:
- Customer ID, first name, last name, email
- Full address (concatenated street, city, country)
- Active status

**1.2** Create a view called `film_catalog` that displays:
- Film ID, title, description
- Release year, rating, length in hours (convert minutes)
- Rental rate and replacement cost

**1.3** Create a view called `staff_overview` that shows:
- Staff ID, full name (first + last)
- Store ID, store address
- Active status, last update

### Exercise 2: Complex Multi-table Views (25 points)

**2.1** Create a view called `rental_details` that combines:
- Rental information (rental_id, rental_date, return_date)
- Customer details (customer_id, full name, email)
- Film information (film_id, title, category)
- Staff information (staff_id, staff name)
- Payment details (amount, payment_date)

**2.2** Create a view called `customer_activity` that shows:
- Customer ID and full name
- Total rentals, total payments
- Average rental frequency
- Customer ranking based on total spending

**2.3** Create a view called `inventory_status` showing:
- Film title and category
- Store ID and address
- Total copies, available copies, rented copies
- Utilization percentage

### Exercise 3: Security and Restricted Views (15 points)

**3.1** Create a `public_customer_list` view for customer service:
- Customer ID, first name, last name, phone (if available)
- City and country (no street address)
- Active status
- Exclude email and other sensitive data

**3.2** Create a `film_summary` view for public catalog:
- Film title, description, category, rating
- Release year, length in hours
- Exclude internal pricing information

### Exercise 4: Basic Materialized Views (20 points)

**4.1** Create a materialized view `film_stats` containing:
- Film category name
- Total films in category
- Average rental rate and replacement cost
- Average film length
- Most expensive film title in category

```sql
-- Example structure
CREATE MATERIALIZED VIEW film_stats AS
SELECT 
    c.name as category_name,
    -- Add your aggregations here
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id;
```

**4.2** Create a materialized view `monthly_revenue` showing:
- Year and month from rental dates
- Total rental transactions
- Total revenue
- Average transaction value
- Number of unique customers served

**4.3** Create a materialized view `customer_segments` for analytics:
- Customer ID and full name
- Total lifetime rentals and payments
- Average days between rentals
- Customer segment (High/Medium/Low based on spending)
- Last rental date

### Exercise 5: Advanced Materialized Views (15 points)

**5.1** Create `inventory_optimization` materialized view:
- Film title and category
- Store information
- Total inventory, current rentals
- Utilization rate (rented/total ratio)
- Revenue per copy
- Optimization recommendation

**5.2** Create `staff_performance_dashboard` materialized view:
- Staff ID, full name, store
- Total rentals processed
- Total revenue generated
- Average transaction value
- Performance ranking

### Exercise 6: Refresh Strategies and Performance (5 points)

**6.1** Test refresh operations:
- Manually refresh all materialized views
- Create a function to refresh multiple views
- Test concurrent refresh (create unique index first)

**6.2** Performance comparison:
- Create equivalent regular views for your materialized views
- Compare execution times for identical queries
- Document the performance differences

## 💡 Solutions and Examples

### Example: Simple View Creation
```sql
-- Customer information view with address concatenation
CREATE OR REPLACE VIEW customer_info AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    CONCAT(a.address, ', ', ci.city, ', ', co.country) AS full_address,
    c.active
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;
```

### Example: Complex View with Multiple Joins
```sql
-- Rental details view combining multiple tables
CREATE OR REPLACE VIEW rental_details AS
SELECT 
    r.rental_id,
    r.rental_date,
    r.return_date,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    f.title AS film_title,
    cat.name AS category,
    p.amount,
    p.payment_date
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
LEFT JOIN payment p ON r.rental_id = p.rental_id;
```

### Example: Materialized View with Aggregations
```sql
-- Film statistics materialized view
CREATE MATERIALIZED VIEW film_stats AS
SELECT 
    c.name AS category_name,
    COUNT(f.film_id) AS total_films,
    ROUND(AVG(f.rental_rate), 2) AS avg_rental_rate,
    ROUND(AVG(f.replacement_cost), 2) AS avg_replacement_cost,
    ROUND(AVG(f.length), 0) AS avg_length_minutes
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id, c.name;

-- Refresh the materialized view
REFRESH MATERIALIZED VIEW film_stats;
```

### Example: Refresh Function
```sql
-- Function to refresh multiple materialized views
CREATE OR REPLACE FUNCTION refresh_all_materialized_views()
RETURNS TEXT AS $$
DECLARE
    start_time TIMESTAMP := NOW();
    end_time TIMESTAMP;
BEGIN
    REFRESH MATERIALIZED VIEW film_stats;
    REFRESH MATERIALIZED VIEW monthly_revenue;
    REFRESH MATERIALIZED VIEW customer_segments;
    
    end_time := NOW();
    
    RETURN 'All materialized views refreshed in ' || 
           EXTRACT(epoch FROM (end_time - start_time)) || ' seconds';
END;
$$ LANGUAGE plpgsql;
```

## 🔍 Testing Your Solutions

Use these queries to verify your views work correctly:

```sql
-- Test view creation
SELECT * FROM information_schema.views WHERE table_name = 'customer_info';

-- Test materialized view creation
SELECT * FROM information_schema.tables WHERE table_name = 'film_stats';

-- Test view data
SELECT * FROM customer_info LIMIT 5;
SELECT * FROM film_stats ORDER BY total_films DESC;

-- Test complex view performance
EXPLAIN ANALYZE SELECT * FROM rental_details WHERE rental_date > '2005-08-01';

-- Compare regular vs materialized view performance
\timing
SELECT * FROM film_stats;
SELECT * FROM film_stats_regular;
```

## 📝 Deliverables

Submit your completed `solutions.sql` file containing:
1. All regular view definitions (Exercises 1-3)
2. All materialized view definitions (Exercises 4-5)
3. Refresh strategies and performance testing (Exercise 6)
4. Comments explaining your design decisions
5. Test queries demonstrating view functionality

## 🎯 Best Practices

### Regular Views:
- **Keep views simple** when possible for better performance
- **Use meaningful names** that describe the view's purpose
- **Add comments** to explain complex logic
- **Consider security** when exposing data through views
- **Test updatability** if views need to support DML operations

### Materialized Views:
- **Index materialized views** for better query performance
- **Monitor storage usage** as they consume disk space
- **Plan refresh schedules** based on data change frequency
- **Use CONCURRENTLY** for large views to avoid blocking
- **Document refresh requirements** for production deployment

### Performance Considerations:
- **Use materialized views** for expensive aggregations
- **Regular views** for simple data transformations
- **Consider view dependencies** when designing schemas
- **Monitor query execution plans** for performance optimization

## 🔍 Common Pitfalls

1. **Complex views without indexes**: Can lead to poor performance
2. **Forgetting to refresh materialized views**: Results in stale data
3. **Over-using materialized views**: Unnecessary storage overhead
4. **Views with too many joins**: Can be slow and hard to maintain
5. **Security views exposing sensitive data**: Always validate column selection

## 🚀 Advanced Topics (Optional)

1. **Updatable Views**: Rules and limitations for DML operations
2. **View Dependencies**: Managing cascading view updates
3. **Partitioned Views**: Views over partitioned tables
4. **Recursive Views**: Self-referencing view definitions
5. **Cross-Database Views**: Views spanning multiple databases

---

**Time Estimate**: 3-4 hours
**Difficulty**: ⭐⭐⭐ (Intermediate to Advanced)
**Prerequisites**: Basic SQL joins and aggregations