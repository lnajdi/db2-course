# Quiz 01: Views and Materialized Views 👁️

## Learning Objectives 🎯
After completing this module, students should be able to:
- Define and explain the concept of database views
- Differentiate between regular views and materialized views
- Create, modify, and drop views using SQL
- Understand when to use views for security, simplification, and performance
- Implement updatable views with proper constraints
- Apply views in real-world database scenarios

## Instructions 📋
- **Total Points**: 100
- **Time Limit**: 30 minutes
- **Database**: Pagila
- **Open Book**: Yes (course materials allowed)
- **Tools**: PostgreSQL client of your choice

## Prerequisites ✅
Ensure you have:
- [ ] Access to Pagila database
- [ ] Basic understanding of SELECT statements
- [ ] Knowledge of JOIN operations
- [ ] Familiarity with PostgreSQL syntax

---

## Part A: Multiple Choice Questions (40 points)
*Choose the best answer for each question (2 points each)*

### Question 1
What is a database view?
a) A physical table that stores data permanently
b) A virtual table based on a SELECT statement  
c) A backup copy of a table
d) An index on a table

### Question 2
Which of the following is TRUE about regular views?
a) They store data physically on disk
b) They are faster than querying base tables
c) They reflect real-time data from underlying tables
d) They require manual refresh to update data

### Question 3
When should you use a materialized view instead of a regular view?
a) When you need real-time data
b) When the query is simple and fast
c) When you have complex, expensive queries that don't need real-time data
d) When you want to save disk space

### Question 4
Which statement about updatable views is CORRECT?
a) All views are automatically updatable
b) Views with GROUP BY clauses are always updatable
c) Only views based on a single table without aggregations are typically updatable
d) Materialized views are more updatable than regular views

### Question 5
What does the CHECK OPTION do in a view?
a) It checks the syntax of the view definition
b) It ensures that modified data still satisfies the view's WHERE condition
c) It automatically refreshes materialized views
d) It optimizes view performance

### Question 6
How do you refresh a materialized view named 'sales_summary'?
a) UPDATE MATERIALIZED VIEW sales_summary;
b) REFRESH MATERIALIZED VIEW sales_summary;
c) RELOAD VIEW sales_summary;
d) SYNC MATERIALIZED VIEW sales_summary;

### Question 7
Which SQL command is used to modify an existing view?
a) ALTER VIEW
b) UPDATE VIEW  
c) CREATE OR REPLACE VIEW
d) MODIFY VIEW

### Question 8
What is the main security benefit of using views?
a) They encrypt data automatically
b) They provide controlled access to specific columns/rows
c) They prevent all unauthorized access
d) They create automatic backups

### Question 9
Which of the following queries would be FASTEST?
a) SELECT * FROM customer_summary_view; (regular view with complex joins)
b) SELECT * FROM customer_summary_mv; (materialized view with same data)
c) Both would have identical performance
d) It depends on the current database load

### Question 10
What happens when you drop a table that has views based on it?
a) The views are automatically updated
b) The views become invalid but still exist
c) The views are automatically dropped
d) PostgreSQL prevents you from dropping the table

---

## Part B: True/False Questions (20 points)
*Mark each statement as True (T) or False (F) (1 point each)*

1. **T/F**: Views can be based on other views (nested views)
2. **T/F**: Materialized views automatically update when base tables change
3. **T/F**: You can create indexes on materialized views
4. **T/F**: Views always improve query performance
5. **T/F**: The WITH CHECK OPTION prevents inserting rows that don't match the view's WHERE clause
6. **T/F**: Regular views take up storage space like regular tables
7. **T/F**: You can use ORDER BY in a view definition
8. **T/F**: Views can join tables from different databases
9. **T/F**: Materialized views are automatically refreshed during database restarts
10. **T/F**: Views can contain aggregate functions like COUNT() and SUM()
11. **T/F**: You can grant different permissions on views than on underlying tables
12. **T/F**: Views can improve database security by hiding sensitive columns
13. **T/F**: All views in PostgreSQL are updatable by default
14. **T/F**: Materialized views can be refreshed concurrently without blocking reads
15. **T/F**: Views can simplify complex queries for application developers
16. **T/F**: You can use DISTINCT in a view definition
17. **T/F**: Views automatically inherit all constraints from base tables
18. **T/F**: Materialized views can have triggers
19. **T/F**: Views can be used in subqueries
20. **T/F**: Creating a view requires exclusive locks on base tables

---

## Part C: Practical SQL Exercises (40 points)

### Exercise 1: Basic View Creation (8 points)
Create a view called `customer_contact` that shows only the customer ID, first name, last name, and email from the customer table. Write the SQL statement below:

```sql
-- Your solution here:

```

### Exercise 2: Complex Join View (10 points)  
Create a view named `rental_details` that combines information from rental, customer, film, and inventory tables to show:
- Rental ID
- Customer's full name (first + last)
- Film title
- Rental date
- Return date (if available)

```sql
-- Your solution here:

```

### Exercise 3: Filtered Business View (8 points)
Create a view called `active_recent_customers` that shows active customers who have made at least one rental in the last 90 days. Include customer ID, full name, email, and their last rental date.

```sql
-- Your solution here:

```

### Exercise 4: Materialized View (10 points)
Create a materialized view named `film_rental_stats` that shows:
- Film ID
- Film title  
- Total number of rentals
- Total revenue generated
- Average rental duration (in days)

```sql
-- Your solution here:

```

### Exercise 5: View with Security (4 points)
Create a view called `staff_public_info` that shows staff information but excludes the password field. Include staff ID, first name, last name, email, and active status.

```sql
-- Your solution here:

```

---

## Bonus Question (Extra 5 points)
Explain in 2-3 sentences when you would choose a materialized view over a regular view, and describe one potential drawback of using materialized views.

**Your answer:**
```
[Write your answer here]
```

---

## Submission Guidelines 📤
1. Save your SQL solutions in a file named `quiz01_solutions_[your_name].sql`
2. Test all queries against the Pagila database
3. Include comments explaining your logic where helpful
4. Submit both the SQL file and your written answers

## Grading Rubric
- **Correctness**: Does the query produce the expected results?
- **Efficiency**: Is the solution reasonably optimized?
- **Style**: Is the SQL code well-formatted and readable?
- **Completeness**: Are all requirements addressed?

---
*Good luck! Remember to test your queries before submitting.*
