# Views Quiz - Structured Content

## Quiz Title: PostgreSQL Views and Materialized Views
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
**Key Concept Tested:** Basic definition of database views
**Difficulty:** Easy
**Type:** Multiple Choice
**Question:** What is a database view in PostgreSQL?

**Options:**
0. A physical table that permanently stores data on disk
1. A virtual table based on the result of a SELECT statement
2. A backup copy of an existing table
3. An index that speeds up query performance

**Correct Answer Index:** 1
**Hint:** Think about whether views actually store data or just show it.
**Correct Answer Explanation:** A view is a virtual table that doesn't store data physically. It's based on a SELECT statement and shows data dynamically from underlying tables.
**Incorrect Answer Explanations:**
- Option 0: Views don't store data physically - that's what distinguishes them from regular tables
- Option 2: Views aren't backups; they're live representations of data
- Option 3: Views aren't indexes; they're query-based virtual tables

---

## Question 2
**Question Number:** 2
**Key Concept Tested:** Characteristics of regular views
**Difficulty:** Easy
**Type:** Multiple Choice
**Question:** Which statement is TRUE about regular views in PostgreSQL?

**Options:**
0. They store data physically and need manual updates
1. They are always faster than querying base tables directly
2. They always reflect the current state of underlying tables
3. They can only be created from a single table

**Correct Answer Index:** 2
**Hint:** Consider whether views show live data or cached data.
**Correct Answer Explanation:** Regular views are dynamic and always reflect the current state of their underlying tables because they execute the SELECT statement each time they're queried.
**Incorrect Answer Explanations:**
- Option 0: Regular views don't store data physically - they're virtual
- Option 1: Views can be slower since they execute the underlying query each time
- Option 3: Views can be created from multiple tables using JOINs

---

## Question 3
**Question Number:** 3
**Key Concept Tested:** Benefits and use cases of views
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** Which is NOT a primary benefit of using database views?

**Options:**
0. Simplifying complex queries for end users
1. Providing controlled access to sensitive data
2. Improving storage efficiency by reducing data duplication
3. Creating consistent interfaces for applications

**Correct Answer Index:** 2
**Hint:** Think about whether views actually store any data.
**Correct Answer Explanation:** Views don't improve storage efficiency because they don't store data - they're virtual tables that generate results dynamically.
**Incorrect Answer Explanations:**
- Option 0: Views excel at hiding complex JOINs and aggregations behind simple names
- Option 1: Views are commonly used for security by showing only specific columns or rows
- Option 3: Views provide stable interfaces that can remain consistent even if underlying schema changes

---

## Question 4
**Question Number:** 4
**Key Concept Tested:** Materialized views vs regular views
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** When should you choose a materialized view over a regular view?

**Options:**
0. When you need real-time data that updates automatically
1. When you want to minimize disk space usage
2. When you have expensive queries and can tolerate slightly stale data
3. When you need to perform INSERT operations through the view

**Correct Answer Index:** 2
**Hint:** Consider the trade-off between performance and data freshness.
**Correct Answer Explanation:** Materialized views are best for expensive, complex queries where you can accept that data might be slightly outdated in exchange for much faster query performance.
**Incorrect Answer Explanations:**
- Option 0: Materialized views don't update automatically - they need manual refresh
- Option 1: Materialized views use MORE disk space because they store computed results
- Option 3: Materialized views are typically read-only and don't support INSERT operations

---

## Question 5
**Question Number:** 5
**Key Concept Tested:** Creating views syntax
**Difficulty:** Easy
**Type:** Multiple Choice
**Question:** What is the correct syntax to create a view in PostgreSQL?

**Options:**
0. CREATE TABLE viewname AS SELECT ...
1. CREATE VIEW viewname AS SELECT ...
2. CREATE VIRTUAL TABLE viewname AS SELECT ...
3. MAKE VIEW viewname FROM SELECT ...

**Correct Answer Index:** 1
**Hint:** The keyword should clearly indicate you're creating a view, not a table.
**Correct Answer Explanation:** The correct syntax is CREATE VIEW viewname AS SELECT ... which creates a virtual table based on the SELECT statement.
**Incorrect Answer Explanations:**
- Option 0: This creates a physical table, not a view
- Option 2: PostgreSQL doesn't use "VIRTUAL TABLE" syntax
- Option 3: "MAKE" is not valid PostgreSQL syntax for creating views

---

## Question 6
**Question Number:** 6
**Key Concept Tested:** View updatability rules
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** Which view definition would be updatable in PostgreSQL?

**Options:**
0. CREATE VIEW v AS SELECT customer_id, COUNT(*) FROM customer GROUP BY customer_id
1. CREATE VIEW v AS SELECT DISTINCT customer_id, first_name FROM customer
2. CREATE VIEW v AS SELECT customer_id, first_name, last_name FROM customer WHERE active = 1
3. CREATE VIEW v AS SELECT c.customer_id, f.title FROM customer c JOIN film f ON c.customer_id = f.film_id

**Correct Answer Index:** 2
**Hint:** Updatable views must reference a single table without aggregations, DISTINCT, or complex expressions.
**Correct Answer Explanation:** This view references a single table with simple column selections and a WHERE clause, making it updatable according to PostgreSQL rules.
**Incorrect Answer Explanations:**
- Option 0: Contains GROUP BY and aggregate function COUNT(*), making it non-updatable
- Option 1: Uses DISTINCT, which makes views non-updatable
- Option 3: Involves a JOIN between multiple tables, making it non-updatable

---

## Question 7
**Question Number:** 7
**Key Concept Tested:** Materialized view refresh
**Difficulty:** Medium
**Type:** True/False
**Question:** Materialized views in PostgreSQL automatically update when the underlying data changes.

**Options:**
0. True
1. False

**Correct Answer Index:** 1
**Hint:** Think about whether materialized views are "live" or need manual intervention.
**Correct Answer Explanation:** False. Materialized views store computed results physically and do not automatically update. They must be manually refreshed using REFRESH MATERIALIZED VIEW.
**Incorrect Answer Explanations:**
- Option 0: This would be true for regular views, but materialized views cache their results and need manual refresh

---

## Question 8
**Question Number:** 8
**Key Concept Tested:** View security and data hiding
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** In the following view creation, what is the primary security benefit?
```sql
CREATE VIEW customer_public AS 
SELECT customer_id, first_name, last_name, email 
FROM customer;
```

**Options:**
0. It improves query performance by caching results
1. It hides sensitive columns like addresses and payment information
2. It prevents unauthorized users from accessing the database
3. It encrypts the displayed data automatically

**Correct Answer Index:** 1
**Hint:** Look at which columns are included vs excluded from the original table.
**Correct Answer Explanation:** The view selects only basic contact information, hiding potentially sensitive columns like addresses, phone numbers, or payment details that might exist in the full customer table.
**Incorrect Answer Explanations:**
- Option 0: Regular views don't cache results - that's materialized views
- Option 2: Views don't control database access - that's done through user permissions
- Option 3: Views don't encrypt data automatically - they just limit what's visible

---

## Question 9
**Question Number:** 9
**Key Concept Tested:** Complex view with joins and aggregations
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** What would be the result of this view when queried?
```sql
CREATE VIEW film_stats AS
SELECT 
    f.title,
    COUNT(r.rental_id) as rental_count,
    AVG(f.rental_rate) as avg_rate
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title;
```

**Options:**
0. Only films that have been rented at least once
1. All films with their rental statistics, including films never rented
2. Only the most popular films based on rental count
3. An error because the syntax is incorrect

**Correct Answer Index:** 1
**Hint:** Pay attention to the type of JOINs used in the query.
**Correct Answer Explanation:** The LEFT JOINs ensure all films are included, even those never rented (they'll show rental_count = 0). The GROUP BY aggregates rental statistics for each film.
**Incorrect Answer Explanations:**
- Option 0: This would be true with INNER JOINs, but LEFT JOINs include all films
- Option 2: The view shows all films, not just popular ones
- Option 3: The syntax is correct PostgreSQL

---

## Question 10
**Question Number:** 10
**Key Concept Tested:** CHECK OPTION with views
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** What happens when you try to insert a record through this view?
```sql
CREATE VIEW active_customers AS
SELECT customer_id, first_name, last_name, active
FROM customer 
WHERE active = 1
WITH CHECK OPTION;
```

**Options:**
0. All insertions are allowed regardless of the active value
1. Only insertions with active = 1 are allowed
2. No insertions are allowed through this view
3. The CHECK OPTION is ignored in PostgreSQL

**Correct Answer Index:** 1
**Hint:** Consider what WITH CHECK OPTION enforces about inserted data.
**Correct Answer Explanation:** WITH CHECK OPTION ensures that any INSERT or UPDATE through the view must satisfy the view's WHERE condition, so only active = 1 records can be inserted.
**Incorrect Answer Explanations:**
- Option 0: CHECK OPTION specifically prevents insertions that don't meet the WHERE criteria
- Option 2: Insertions are allowed, but only those meeting the view's condition
- Option 3: PostgreSQL fully supports WITH CHECK OPTION

---

## Question 11
**Question Number:** 11
**Key Concept Tested:** View performance considerations
**Difficulty:** Medium
**Type:** True/False
**Question:** Creating a view on a very large table automatically improves query performance.

**Options:**
0. True
1. False

**Correct Answer Index:** 1
**Hint:** Consider whether views change how the underlying query is executed.
**Correct Answer Explanation:** False. Regular views don't improve performance by themselves - they still execute the underlying SELECT statement each time. Performance improvements come from better indexing, query optimization, or using materialized views.
**Incorrect Answer Explanations:**
- Option 0: Views are just stored queries; they don't inherently improve performance

---

## Question 12
**Question Number:** 12
**Key Concept Tested:** Dropping views and dependencies
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** What happens when you try to drop a view that other views depend on?

**Options:**
0. The dependent views are automatically dropped
1. PostgreSQL prevents the drop and shows an error
2. The view is dropped but dependent views become invalid
3. Only the data is removed but the view definition remains

**Correct Answer Index:** 1
**Hint:** Think about how PostgreSQL handles dependencies between database objects.
**Correct Answer Explanation:** PostgreSQL prevents dropping views that other views depend on, showing a dependency error. You must use CASCADE to force drop dependent objects.
**Incorrect Answer Explanations:**
- Option 0: Automatic dropping only happens with CASCADE option
- Option 2: PostgreSQL prevents the drop rather than creating invalid views
- Option 3: Views don't store data, so there's nothing to remove except the definition

---

## Question 13
**Question Number:** 13
**Key Concept Tested:** CREATE OR REPLACE VIEW
**Difficulty:** Easy
**Type:** Multiple Choice
**Question:** What is the advantage of using CREATE OR REPLACE VIEW instead of CREATE VIEW?

**Options:**
0. It provides better performance optimization
1. It allows modification of existing views without dropping dependencies
2. It automatically creates indexes on the view
3. It makes the view read-only for security

**Correct Answer Index:** 1
**Hint:** Consider what happens when you need to modify an existing view that other objects use.
**Correct Answer Explanation:** CREATE OR REPLACE VIEW allows you to modify an existing view's definition without breaking dependent objects like other views or applications that reference it.
**Incorrect Answer Explanations:**
- Option 0: REPLACE doesn't affect performance optimization
- Option 2: Views don't have indexes - only materialized views can be indexed
- Option 3: REPLACE doesn't affect view permissions or read-only status

---

## Question 14
**Question Number:** 14
**Key Concept Tested:** Materialized view storage
**Difficulty:** Easy
**Type:** True/False
**Question:** Materialized views consume disk space to store their computed results.

**Options:**
0. True
1. False

**Correct Answer Index:** 0
**Hint:** Think about the difference between "materialized" and regular views.
**Correct Answer Explanation:** True. Materialized views physically store their computed results on disk, which is why they're called "materialized" - they make the virtual results into physical storage.
**Incorrect Answer Explanations:**
- Option 1: This would be true for regular views, but materialized views definitely use disk space

---

## Question 15
**Question Number:** 15
**Key Concept Tested:** View naming and best practices
**Difficulty:** Easy
**Type:** Multiple Choice
**Question:** Which is the best practice for naming views?

**Options:**
0. Always prefix with "v_" to indicate it's a view
1. Use the same name as the base table for simplicity
2. Use descriptive names that indicate the view's purpose
3. Keep names as short as possible to save typing

**Correct Answer Index:** 2
**Hint:** Consider what makes code most maintainable and understandable.
**Correct Answer Explanation:** Descriptive names that clearly indicate the view's purpose make code more maintainable and help other developers understand what the view contains.
**Incorrect Answer Explanations:**
- Option 0: While prefixing is sometimes used, descriptive names are more important than rigid naming conventions
- Option 1: Same names would cause conflicts and confusion
- Option 3: Short names often sacrifice clarity for minimal typing savings

---

## Question 16
**Question Number:** 16
**Key Concept Tested:** View querying and filtering
**Difficulty:** Medium
**Type:** True/False
**Question:** You can add additional WHERE conditions when querying a view, even if the view already has its own WHERE clause.

**Options:**
0. True
1. False

**Correct Answer Index:** 0
**Hint:** Think about whether views behave like tables when you query them.
**Correct Answer Explanation:** True. You can query views just like tables, adding additional WHERE conditions. PostgreSQL combines your conditions with the view's existing conditions.
**Incorrect Answer Explanations:**
- Option 1: Views are fully queryable with additional conditions - this is a key feature

---

## Question 17
**Question Number:** 17
**Key Concept Tested:** View system catalogs
**Difficulty:** Hard
**Type:** Multiple Choice
**Question:** Which system view would you query to see all views in the current database?

**Options:**
0. pg_tables
1. pg_views
2. pg_indexes
3. pg_columns

**Correct Answer Index:** 1
**Hint:** Look for the system catalog that specifically tracks views.
**Correct Answer Explanation:** pg_views is the system catalog that contains information about all views in the database, including their definitions.
**Incorrect Answer Explanations:**
- Option 0: pg_tables shows regular tables, not views
- Option 2: pg_indexes shows indexes, not views
- Option 3: pg_columns shows column information, not views specifically

---

## Question 18
**Question Number:** 18
**Key Concept Tested:** Business logic in views
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** What is the benefit of creating this view?
```sql
CREATE VIEW premium_customers AS
SELECT customer_id, first_name, last_name, email
FROM customer c
JOIN (
    SELECT customer_id, SUM(amount) as total_spent
    FROM payment
    GROUP BY customer_id
    HAVING SUM(amount) > 100
) p ON c.customer_id = p.customer_id;
```

**Options:**
0. It improves database security by encrypting customer data
1. It encapsulates business logic for identifying premium customers
2. It automatically updates customer status in the database
3. It creates a backup of important customer information

**Correct Answer Index:** 1
**Hint:** Consider what business rule is being applied in the view definition.
**Correct Answer Explanation:** The view encapsulates the business logic that defines "premium customers" (those who spent >$100), making this rule reusable and consistent across applications.
**Incorrect Answer Explanations:**
- Option 0: Views don't encrypt data - they just limit visibility
- Option 2: Views don't update data automatically - they're query-based
- Option 3: Views aren't backups - they show live data from underlying tables

---

## Question 19
**Question Number:** 19
**Key Concept Tested:** Indexing materialized views
**Difficulty:** Hard
**Type:** True/False
**Question:** You can create indexes on materialized views to improve their query performance.

**Options:**
0. True
1. False

**Correct Answer Index:** 0
**Hint:** Consider whether materialized views behave more like tables or regular views.
**Correct Answer Explanation:** True. Since materialized views store data physically like tables, you can create indexes on them to improve query performance.
**Incorrect Answer Explanations:**
- Option 1: This would be true for regular views, but materialized views can definitely be indexed

---

## Question 20
**Question Number:** 20
**Key Concept Tested:** View vs table decision making
**Difficulty:** Medium
**Type:** Multiple Choice
**Question:** In which scenario would creating a regular table be better than creating a view?

**Options:**
0. When you need to simplify access to joined data from multiple tables
1. When you want to provide controlled access to sensitive information
2. When you need to store computed results that are expensive to calculate
3. When you want to create a consistent interface that hides schema changes

**Correct Answer Index:** 2
**Hint:** Consider when you need persistent storage rather than dynamic queries.
**Correct Answer Explanation:** When computations are expensive and the results don't need to be real-time, storing them in a table (or using a materialized view) is better than recalculating with a regular view each time.
**Incorrect Answer Explanations:**
- Option 0: This is a perfect use case for views, not tables
- Option 1: Views excel at controlling data access through limited column/row exposure
- Option 3: Views are ideal for creating stable interfaces that hide underlying complexity
