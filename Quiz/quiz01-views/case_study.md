# Case Study: Video Rental Analytics System

## Scenario Overview 📊

You are a database developer for **CineMax Rentals**, a growing video rental business. The company uses a PostgreSQL database (similar to Pagila) to track customers, films, rentals, and payments. The business team has requested several analytical views to help them make data-driven decisions.

## Business Requirements

### Executive Dashboard Views 📈
The CEO needs high-level metrics displayed on a dashboard that updates hourly:
1. **Monthly revenue trends** over the past 2 years
2. **Top-performing film categories** by rental volume and revenue  
3. **Customer lifetime value** rankings
4. **Store performance** comparison (if multiple locations)

### Operational Views 🔧
Store managers need real-time operational data:
1. **Currently overdue rentals** with customer contact info
2. **Inventory availability** for popular films
3. **Staff performance** metrics for the current month
4. **Daily rental activity** summary

### Security and Access Control 🔐
Different user roles need different data access:
1. **Customer service reps** - Customer info WITHOUT financial data
2. **Store managers** - Full operational data for their location only
3. **Finance team** - Payment and revenue data WITHOUT customer personal info
4. **Marketing team** - Customer demographics and rental patterns

## Your Assignment 📋

Design and implement a comprehensive view strategy that addresses these business needs while considering:
- **Performance** (when to use materialized vs regular views)
- **Security** (appropriate data access controls)  
- **Maintainability** (clear naming conventions and documentation)
- **Scalability** (handling growing data volumes)

---

## Part 1: Analysis Questions (25 points)

### Question 1 (8 points)
For the executive dashboard requirements, explain your choice between regular views and materialized views for each metric. Consider data freshness requirements, query complexity, and update frequency.

**Your Analysis:**
```
[Write your analysis here - consider each requirement separately]

Monthly revenue trends:
- Choice: ________________
- Justification: ___________

Top-performing categories:  
- Choice: ________________
- Justification: ___________

Customer lifetime value:
- Choice: ________________  
- Justification: ___________

Store performance:
- Choice: ________________
- Justification: ___________
```

### Question 2 (9 points)  
Design a security strategy using views for the different user roles. Explain what data each role should see and what should be hidden.

**Your Security Design:**
```
Customer Service Reps:
- Can see: _______________
- Cannot see: ____________
- View naming: ___________

Store Managers:
- Can see: _______________
- Cannot see: ____________  
- View naming: ___________

Finance Team:
- Can see: _______________
- Cannot see: ____________
- View naming: ___________

Marketing Team:
- Can see: _______________
- Cannot see: ____________
- View naming: ___________
```

### Question 3 (8 points)
Identify potential performance challenges with your view strategy and propose solutions. Consider indexing, refresh schedules, and query optimization.

**Performance Analysis:**
```
[Identify 3-4 potential performance issues and propose solutions]

Challenge 1: _____________
Solution: _______________

Challenge 2: _____________
Solution: _______________

Challenge 3: _____________  
Solution: _______________

Challenge 4: _____________
Solution: _______________
```

---

## Part 2: Implementation (50 points)

### Task 1: Executive Dashboard Views (20 points)

Create the following views/materialized views:

```sql
-- A) Monthly Revenue Trends (5 points)
-- Show total revenue by month for the past 24 months
-- Include: month_year, total_revenue, rental_count, avg_rental_value

-- Your solution:




-- B) Top Film Categories (8 points)  
-- Show category performance metrics
-- Include: category_name, total_films, total_rentals, total_revenue, avg_rental_rate

-- Your solution:




-- C) Customer Lifetime Value (7 points)
-- Rank customers by their total value to the business
-- Include: customer_id, full_name, total_rentals, total_spent, first_rental, last_rental, customer_tier

-- Your solution:



```

### Task 2: Operational Views (15 points)

```sql
-- A) Overdue Rentals Alert (8 points)
-- Show rentals that are past due (rental_duration exceeded)
-- Include: rental_id, customer_name, phone, film_title, days_overdue, expected_return

-- Your solution:




-- B) Current Inventory Status (7 points)  
-- Show availability status for all films
-- Include: film_title, category, total_copies, rented_copies, available_copies, availability_rate

-- Your solution:



```

### Task 3: Security Views (15 points)

```sql  
-- A) Customer Service View (5 points)
-- Safe customer information for customer service team

-- Your solution:




-- B) Finance Team View (5 points)
-- Payment and revenue data without personal customer info

-- Your solution:




-- C) Marketing Demographics View (5 points)
-- Customer patterns and demographics for marketing analysis

-- Your solution:



```

---

## Part 3: Advanced Implementation (25 points)

### Task 4: Materialized View Management (15 points)

```sql
-- A) Create a materialized view refresh strategy (8 points)
-- Design a materialized view that requires periodic refresh
-- Include the refresh command and explain timing

-- Your solution:




-- B) Implement concurrent refresh capability (7 points)
-- Ensure the materialized view can be refreshed without blocking readers

-- Your solution:



```

### Task 5: View Dependencies and Maintenance (10 points)

```sql
-- A) Create a view that depends on other views (5 points)
-- Show how to build layered views appropriately

-- Your solution:




-- B) Document view relationships (5 points)  
-- Write queries to show view dependencies in your system

-- Your solution:



```

---

## Deliverables 📦

1. **Analysis Document** - Your answers to Part 1 questions
2. **Implementation SQL** - All view creation scripts from Part 2 & 3  
3. **Testing Script** - Queries to validate your views work correctly
4. **Documentation** - Comments explaining design decisions
5. **Refresh Schedule** - Proposed schedule for materialized view updates

## Grading Rubric

### Excellent (A): 90-100 points
- Comprehensive analysis considering all business requirements
- Efficient, secure view implementations  
- Creative solutions to complex challenges
- Clear documentation and reasoning

### Good (B): 80-89 points  
- Solid understanding with minor gaps
- Most requirements addressed effectively
- Some optimization opportunities missed
- Generally good documentation

### Satisfactory (C): 70-79 points
- Basic requirements met
- Some security or performance issues
- Limited analysis depth
- Minimal documentation

### Needs Improvement (D): 60-69 points
- Major gaps in requirements
- Significant security or performance problems
- Poor understanding of view types
- Inadequate documentation

---

## Bonus Challenges (Extra Credit)

1. **Dynamic Views** (5 points): Create a view that adapts based on user permissions
2. **Performance Benchmarking** (5 points): Compare query performance before/after your views
3. **Automated Refresh** (3 points): Design a system to automatically refresh materialized views
4. **View Versioning** (2 points): Propose a strategy for managing view changes over time

---

*This case study simulates real-world database challenges. Focus on practical solutions that balance business needs with technical constraints.*
