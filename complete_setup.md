# Complete GitHub Classroom Setup Files - Structured Labs

## File Structure
```
your-assignment-repo/
├── .devcontainer/
│   ├── devcontainer.json
│   └── setup.sh
├── labs/
│   ├── lab01-basic-queries/
│   │   ├── README.md
│   │   ├── exercises.sql
│   │   └── solutions.sql
│   ├── lab02-advanced-queries/
│   │   ├── README.md
│   │   ├── exercises.sql
│   │   └── solutions.sql
│   ├── lab03-aggregates-grouping/
│   │   ├── README.md
│   │   ├── exercises.sql
│   │   └── solutions.sql
│   ├── lab04-data-modification/
│   │   ├── README.md
│   │   ├── exercises.sql
│   │   └── solutions.sql
│   ├── lab05-database-design/
│   │   ├── README.md
│   │   ├── exercises.sql
│   │   └── solutions.sql
│   ├── lab06-indexes-optimization/
│   │   ├── README.md
│   │   ├── exercises.sql
│   │   └── solutions.sql
│   ├── lab07-views/
│   │   ├── README.md
│   │   ├── exercises.sql
│   │   └── solutions.sql
│   ├── lab08-plpgsql-intro/
│   │   ├── README.md
│   │   ├── exercises.sql
│   │   └── solutions.sql
│   ├── lab09-plpgsql-cursors/
│   │   ├── README.md
│   │   ├── exercises.sql
│   │   └── solutions.sql
│   ├── lab10-triggers/
│   │   ├── README.md
│   │   ├── exercises.sql
│   │   └── solutions.sql
│   ├── lab11-admin-basics/
│   │   ├── README.md
│   │   ├── exercises.sql
│   │   └── solutions.sql
│   └── lab12-admin-tasks/
│       ├── README.md
│       ├── exercises.sql
│       └── solutions.sql
├── docker-compose.yml
├── README.md
├── .gitignore
└── INSTRUCTOR_SETUP.md
```

---

## 1. `.devcontainer/devcontainer.json`

```json
{
  "name": "PostgreSQL Database Lab Environment",
  "dockerComposeFile": "../docker-compose.yml",
  "service": "app",
  "workspaceFolder": "/workspace",
  
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-ossdata.vscode-postgresql",
        "ms-vscode.vscode-json",
        "redhat.vscode-yaml"
      ],
      "settings": {
        "postgresql.connections": [
          {
            "host": "localhost",
            "hostaddr": "127.0.0.1",
            "port": "5432",
            "dbname": "pagila",
            "username": "student",
            "password": "password"
          }
        ]
      }
    }
  },
  
  "forwardPorts": [5432],
  "portsAttributes": {
    "5432": {
      "label": "PostgreSQL",
      "onAutoForward": "notify"
    }
  },
  
  "postCreateCommand": "bash .devcontainer/setup.sh",
  
  "remoteUser": "vscode",
  
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  }
}
```

---

## 2. `.devcontainer/setup.sh`

```bash
#!/bin/bash

# Setup script for PostgreSQL Database Lab Environment
echo "🚀 Setting up PostgreSQL Database Lab Environment..."

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
until pg_isready -h localhost -p 5432 -U student; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

echo "✅ PostgreSQL is ready!"

# Create sql directory
mkdir -p /workspace/sql

# Download Pagila database if not exists
if [ ! -f "/workspace/sql/pagila-schema.sql" ]; then
    echo "📥 Downloading Pagila database..."
    cd /workspace/sql
    
    # Download Pagila database files
    curl -L -o pagila-schema.sql https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-schema.sql
    curl -L -o pagila-data.sql https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-data.sql
    
    echo "✅ Pagila database files downloaded!"
fi

# Load Pagila database
echo "📊 Loading Pagila database..."
PGPASSWORD=password psql -h localhost -U student -d pagila -f /workspace/sql/pagila-schema.sql
PGPASSWORD=password psql -h localhost -U student -d pagila -f /workspace/sql/pagila-data.sql

# Create lab folders and files if they don't exist
echo "📁 Setting up lab structure..."

# Create lab directories
mkdir -p /workspace/labs/{lab01-views,lab02-materialized-views,lab03-indexes,lab04-tcl,lab05-window-functions,lab06-ctes,lab07-stored-procedures}

# Create placeholder solution files for each lab
for lab in lab01-views lab02-materialized-views lab03-indexes lab04-tcl lab05-window-functions lab06-ctes lab07-stored-procedures; do
    if [ ! -f "/workspace/labs/$lab/solutions.sql" ]; then
        cat > "/workspace/labs/$lab/solutions.sql" << 'EOF'
-- Solutions for LABNAME
-- Student Name: [Your Name]
-- Date: [Date]

-- Exercise 1
-- Your solution here

-- Exercise 2
-- Your solution here

-- Exercise 3
-- Your solution here
EOF
        sed -i "s/LABNAME/$lab/g" "/workspace/labs/$lab/solutions.sql"
    fi
done

# Verify installation
echo "🔍 Verifying database installation..."
TABLE_COUNT=$(PGPASSWORD=password psql -h localhost -U student -d pagila -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")

if [ "$TABLE_COUNT" -gt 10 ]; then
    echo "✅ Database setup complete! Found $TABLE_COUNT tables."
    echo "🎉 Environment is ready for database labs!"
    echo ""
    echo "📋 Lab Structure:"
    echo "- lab01-views: Basic and advanced views"
    echo "- lab02-materialized-views: Performance with materialized views"
    echo "- lab03-indexes: Query optimization and indexing"
    echo "- lab04-tcl: Transaction Control Language"
    echo "- lab05-window-functions: Advanced analytical queries"
    echo "- lab06-ctes: Common Table Expressions"
    echo "- lab07-stored-procedures: Functions and procedures"
    echo ""
    echo "🔗 Database Connection Details:"
    echo "Host: localhost | Port: 5432 | Database: pagila"
    echo "Username: student | Password: password"
else
    echo "❌ Database setup may have failed. Please check the logs."
fi
```

---

## 3. `docker-compose.yml`

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    container_name: postgres-lab
    environment:
      POSTGRES_DB: pagila
      POSTGRES_USER: student
      POSTGRES_PASSWORD: password
      POSTGRES_HOST_AUTH_METHOD: trust
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./sql:/docker-entrypoint-initdb.d
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U student -d pagila"]
      interval: 10s
      timeout: 5s
      retries: 5

  app:
    image: mcr.microsoft.com/devcontainers/base:ubuntu
    depends_on:
      postgres:
        condition: service_healthy
    volumes:
      - ..:/workspace:cached
    command: sleep infinity
    network_mode: service:postgres

volumes:
  postgres_data:
```

---

## 4. `README.md`

```markdown
# PostgreSQL Database Labs 🗃️

Welcome to your structured PostgreSQL learning environment! This repository contains 7 progressive labs covering essential database concepts.

## 🚀 Getting Started

1. **Wait for setup**: The environment will automatically configure when the Codespace starts (2-3 minutes)
2. **Open PostgreSQL extension**: Click the PostgreSQL icon in the sidebar
3. **Connect to database**: Use the pre-configured "pagila" connection
4. **Choose your lab**: Navigate to the `labs/` folder and select a lab to begin

## 📚 Lab Structure

Each lab is in its own folder with:
- **README.md**: Lab instructions and learning objectives
- **exercises.sql**: Template file with exercise questions
- **solutions.sql**: Your solution file (complete and submit this)

## 🎯 Available Labs

### Lab 01: Views
**Folder**: `labs/lab01-views/`
**Topics**: Basic views, complex multi-table views, view security
**Prerequisites**: Basic SQL SELECT, JOIN knowledge

### Lab 02: Materialized Views  
**Folder**: `labs/lab02-materialized-views/`
**Topics**: Performance optimization, refresh strategies, use cases
**Prerequisites**: Lab 01 (Views)

### Lab 03: Indexes
**Folder**: `labs/lab03-indexes/`
**Topics**: B-tree indexes, partial indexes, query optimization
**Prerequisites**: Understanding of SQL queries

### Lab 04: Transaction Control Language (TCL)
**Folder**: `labs/lab04-tcl/`
**Topics**: ACID properties, transactions, rollbacks, isolation levels
**Prerequisites**: Basic SQL DML operations

### Lab 05: Window Functions
**Folder**: `labs/lab05-window-functions/`
**Topics**: Analytical functions, ranking, running totals
**Prerequisites**: Advanced SELECT queries

### Lab 06: Common Table Expressions (CTEs)
**Folder**: `labs/lab06-ctes/`
**Topics**: Recursive queries, complex data transformations
**Prerequisites**: Subqueries and JOIN operations

### Lab 07: Stored Procedures & Functions
**Folder**: `labs/lab07-stored-procedures/`
**Topics**: PL/pgSQL, functions, triggers, automation
**Prerequisites**: All previous labs

## 🗂️ Pagila Database Schema

The labs use the Pagila database (DVD rental store) containing:

**Core Tables:**
- `customer`, `address`, `city`, `country` - Customer information
- `film`, `category`, `actor` - Movie catalog
- `inventory`, `store`, `staff` - Business operations
- `rental`, `payment` - Transaction records

**Key Relationships:**
- Films belong to categories and feature actors
- Customers rent films from store inventory
- Rentals generate payment records
- Geographic hierarchy: country → city → address

## 🔧 Connection Details

- **Host**: localhost
- **Port**: 5432
- **Database**: pagila
- **Username**: student
- **Password**: password

## 📝 Working with Labs

### Starting a Lab:
1. Navigate to the lab folder (e.g., `labs/lab01-views/`)
2. Read the `README.md` for instructions
3. Review `exercises.sql` for the questions
4. Write your solutions in `solutions.sql`

### Testing Your Solutions:
```sql
-- Connect to the database and run your queries
-- Use EXPLAIN ANALYZE to check performance
-- Verify results with sample data
```

### Submitting Your Work:
1. Complete the `solutions.sql` file in each lab folder
2. Commit your changes: `git add -A && git commit -m "Complete Lab X"`
3. Push to GitHub: `git push origin main`

## 🆘 Troubleshooting

**Database not connecting?**
- Wait for setup completion (check terminal logs)
- Reload VS Code window if needed
- Restart Codespace as last resort

**Lab files missing?**
- Check that setup completed successfully
- Look in `/workspace/labs/` directory
- Manually create folders if needed

**Need to reset database?**
```bash
# In terminal:
PGPASSWORD=password psql -h localhost -U student -d pagila -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
bash .devcontainer/setup.sh
```

## 📊 Recommended Lab Progression

**Beginner Path**: Labs 1 → 3 → 4 → 2
**Intermediate Path**: Labs 1 → 2 → 3 → 4 → 5
**Advanced Path**: All labs in sequence (1-7)

## 📚 Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Pagila Database GitHub](https://github.com/devrimgunduz/pagila)
- [SQL Learning Resources](https://www.postgresqltutorial.com/)

---

🎓 **Ready to learn? Pick a lab and start coding!**
```

---

## 5. `labs/lab01-views/README.md`

```markdown
# Lab 01: Database Views

## 🎯 Learning Objectives
By completing this lab, you will:
- Understand the purpose and benefits of database views
- Create simple and complex views
- Work with updatable and read-only views
- Use views for data security and simplification
- Practice view maintenance and modification

## 📚 Theory Overview

### What are Views?
Views are virtual tables based on the result of SQL statements. They contain rows and columns like real tables, but don't store data physically.

**Benefits:**
- **Simplification**: Hide complex queries behind simple names
- **Security**: Restrict access to specific columns/rows
- **Consistency**: Ensure consistent data presentation
- **Abstraction**: Isolate applications from schema changes

### Types of Views:
- **Simple Views**: Based on single table
- **Complex Views**: Join multiple tables, use functions
- **Updatable Views**: Allow INSERT, UPDATE, DELETE operations
- **Read-only Views**: Query access only

## 🛠️ Exercises

### Exercise 1: Simple Views (25 points)
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

### Exercise 2: Complex Multi-table Views (35 points)

**2.1** Create a view called `rental_details` that combines:
- Rental information (rental_id, rental_date, return_date)
- Customer details (name, email)
- Film information (title, category)
- Store information (store_id, staff name)

**2.2** Create a view called `customer_activity` that shows:
- Customer information (id, name, email)
- Total rentals count
- Total amount paid
- Last rental date
- Customer lifetime value ranking

**2.3** Create a view called `inventory_status` that displays:
- Film title and category
- Store location
- Total copies available
- Currently rented copies
- Available copies for rent

### Exercise 3: Security and Restricted Views (20 points)

**3.1** Create a view called `public_customer_list` for customer service:
- Customer ID, first name, last name
- City and country (no street address)
- Email and phone
- Exclude staff email addresses

**3.2** Create a view called `film_summary` for public catalog:
- Title, description, rating
- Category, release year
- Length in hours and minutes format
- Exclude replacement cost and other internal data

### Exercise 4: Updatable Views (20 points)

**4.1** Create an updatable view called `active_customers`:
- Include only active customers
- Show customer_id, first_name, last_name, email
- Test updating a customer's email through the view

**4.2** Create a view called `current_rentals`:
- Show only rentals that haven't been returned
- Include rental_id, customer_name, film_title, rental_date
- Determine if this view is updatable and explain why

## 🔍 Testing Your Solutions

Use these queries to verify your views work correctly:

```sql
-- Test view creation
SELECT * FROM information_schema.views WHERE table_name = 'customer_info';

-- Test view data
SELECT * FROM customer_info LIMIT 5;

-- Test complex view performance
EXPLAIN ANALYZE SELECT * FROM rental_details WHERE rental_date > '2005-08-01';

-- Test updatable view
UPDATE active_customers SET email = 'test@example.com' WHERE customer_id = 1;
SELECT * FROM customer WHERE customer_id = 1;
```

## 📝 Deliverables

Complete the `solutions.sql` file with:
1. All CREATE VIEW statements
2. Test queries demonstrating each view works
3. Comments explaining your design decisions
4. Analysis of which views are updatable and why

## 💡 Tips for Success

- **Start Simple**: Begin with single-table views, then build complexity
- **Use Meaningful Names**: View names should clearly indicate their purpose
- **Add Comments**: Document complex logic in your views
- **Test Thoroughly**: Verify views return expected data
- **Check Performance**: Use EXPLAIN to analyze complex view queries
- **Consider Updates**: Think about which views might need to be updatable

## 🚀 Advanced Challenges (Optional)

1. **Parameterized Views**: Research PostgreSQL functions to create "parameterized views"
2. **View Dependencies**: Create views that depend on other views
3. **Performance Comparison**: Compare view query performance vs direct table queries
4. **View Modification**: Practice ALTER VIEW and DROP VIEW operations

## 📊 Sample Expected Results

**customer_info view:**
```
customer_id | first_name | last_name | email | full_address | active
1 | Mary | Smith | mary.smith@sakilacustomer.org | 1913 Hanoi Way, Sasebo, Japan | true
```

**rental_details view:**
```
rental_id | rental_date | customer_name | film_title | category | staff_name
1 | 2005-05-24 | Mary Smith | Academy Dinosaur | Documentary | Mike Hillyer
```

---

**Time Estimate**: 2-3 hours
**Difficulty**: ⭐⭐☆☆☆ (Beginner-Intermediate)
```

---

## 6. `labs/lab01-views/exercises.sql`

```sql
-- Lab 01: Database Views - Exercise Template
-- Student Name: ______________________
-- Date: ______________________

-- ==========================================
-- Exercise 1: Simple Views (25 points)
-- ==========================================

-- 1.1: Create customer_info view
-- TODO: Create a view showing customer ID, names, email, full address, active status

-- 1.2: Create film_catalog view  
-- TODO: Create a view showing film details with length converted to hours

-- 1.3: Create staff_overview view
-- TODO: Create a view showing staff information with store details

-- Test queries for Exercise 1:
-- SELECT * FROM customer_info LIMIT 3;
-- SELECT * FROM film_catalog WHERE rating = 'G' LIMIT 3;
-- SELECT * FROM staff_overview;

-- ==========================================
-- Exercise 2: Complex Multi-table Views (35 points)
-- ==========================================

-- 2.1: Create rental_details view
-- TODO: Create a comprehensive rental view joining multiple tables

-- 2.2: Create customer_activity view
-- TODO: Create a view showing customer statistics and rankings

-- 2.3: Create inventory_status view
-- TODO: Create a view showing inventory availability by film and store

-- Test queries for Exercise 2:
-- SELECT * FROM rental_details WHERE rental_date > '2005-07-01' LIMIT 5;
-- SELECT * FROM customer_activity ORDER BY total_paid DESC LIMIT 10;
-- SELECT * FROM inventory_status WHERE available_copies > 0;

-- ==========================================
-- Exercise 3: Security and Restricted Views (20 points)
-- ==========================================

-- 3.1: Create public_customer_list view
-- TODO: Create a customer view for customer service (limited data)

-- 3.2: Create film_summary view
-- TODO: Create a public film catalog view (no internal pricing)

-- Test queries for Exercise 3:
-- SELECT * FROM public_customer_list LIMIT 5;
-- SELECT * FROM film_summary WHERE category = 'Action';

-- ==========================================
-- Exercise 4: Updatable Views (20 points)
-- ==========================================

-- 4.1: Create active_customers view (updatable)
-- TODO: Create an updatable view for active customers only

-- 4.2: Create current_rentals view
-- TODO: Create a view for unreturned rentals and test if updatable

-- Test queries for Exercise 4:
-- SELECT * FROM active_customers LIMIT 3;
-- Test update: UPDATE active_customers SET email = 'new@example.com' WHERE customer_id = 1;
-- SELECT * FROM current_rentals LIMIT 5;

-- ==========================================
-- Analysis Questions
-- ==========================================

/*
1. Which of your views are updatable and why?

2. What are the performance implications of your complex views?

3. How do views improve data security in this scenario?

4. What maintenance considerations exist for your views?
*/
```

---

## 7. `labs/lab02-materialized-views/README.md`

```markdown
# Lab 02: Materialized Views

## 🎯 Learning Objectives
- Understand the difference between views and materialized views
- Create and manage materialized views for performance optimization
- Implement refresh strategies for materialized views
- Analyze performance benefits and trade-offs
- Design materialized views for analytical workloads

## 📚 Theory Overview

### Materialized Views vs Regular Views
- **Regular Views**: Virtual tables, computed on-demand
- **Materialized Views**: Physical storage, pre-computed results
- **Performance**: Materialized views faster for complex queries
- **Storage**: Materialized views consume disk space
- **Freshness**: Data may be stale until refreshed

### When to Use Materialized Views:
- Complex aggregations over large datasets
- Frequently accessed but slowly changing data
- Analytical reporting queries
- Cross-database joins
- Performance-critical read operations

## 🛠️ Exercises

### Exercise 1: Basic Materialized Views (25 points)

**1.1** Create a materialized view `film_stats` containing:
- Film category
- Total films in category
- Average rental rate
- Average film length
- Most expensive film in category

**1.2** Create a materialized view `monthly_revenue` showing:
- Year and month
- Total rental transactions
- Total revenue
- Average transaction value
- Unique customers served

**1.3** Compare performance between regular view and materialized view:
- Create equivalent regular views
- Run identical queries against both
- Document execution time differences

### Exercise 2: Advanced Materialized Views (35 points)

**2.1** Create `customer_segment_analysis`:
- Customer segments based on rental frequency (Low/Medium/High)
- Segment demographics (average age, location distribution)
- Segment preferences (favorite categories, actors)
- Segment value metrics (total spent, average rental rate)

**2.2** Create `inventory_optimization`:
- Film utilization rates (rentals per copy)
- Revenue per inventory item
- Underperforming inventory identification
- Seasonal rental patterns by category

**2.3** Create `staff_performance_dashboard`:
- Staff member performance metrics
- Monthly transaction volumes
- Revenue generated per staff member
- Customer satisfaction indicators

### Exercise 3: Refresh Strategies (25 points)

**3.1** Implement different refresh approaches:
- Manual refresh using `REFRESH MATERIALIZED VIEW`
- Create a refresh function for multiple views
- Test refresh performance with timing

**3.2** Design refresh scheduling:
- Determine optimal refresh frequency for each view
- Consider data staleness vs. refresh cost
- Create a refresh priority system

**3.3** Handle concurrent access:
- Use `REFRESH MATERIALIZED VIEW CONCURRENTLY`
- Create unique indexes for concurrent refresh
- Test behavior during refresh operations

### Exercise 4: Performance Analysis (15 points)

**4.1** Benchmark query performance:
- Compare materialized view vs. regular view queries
- Measure refresh overhead
- Analyze storage requirements

**4.2** Index optimization:
- Create appropriate indexes on materialized views
- Test query performance improvements
- Document index strategy

## 🔍 Sample Materialized View

```sql
CREATE MATERIALIZED VIEW film_performance AS
SELECT 
    c.name AS category,
    COUNT(r.rental_id) AS total_rentals,
    AVG(f.rental_rate) AS avg_rental_rate,
    SUM(p.amount) AS total_revenue,
    AVG(f.length) AS avg_length,
    COUNT(DISTINCT r.customer_id) AS unique_customers
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
WITH DATA;

-- Create index for performance
CREATE INDEX idx_film_performance_category ON film_performance(category);

-- Refresh the materialized view
REFRESH MATERIALIZED VIEW film_performance;
```

## 📝 Deliverables

Complete the `solutions.sql` file with:
1. All materialized view creation statements
2. Appropriate indexes for performance
3. Refresh commands and timing analysis
4. Performance comparison queries
5. Documentation of refresh strategies

## 💡 Pro Tips

- **Size Matters**: Materialized views are most beneficial for large, complex queries
- **Index Everything**: Create indexes on materialized views just like regular tables
- **Monitor Size**: Track storage consumption of materialized views
- **Refresh Cost**: Balance data freshness with refresh performance
- **Concurrent Refresh**: Use `CONCURRENTLY` for large views in production

---

**Time Estimate**: 3-4 hours
**Difficulty**: ⭐⭐⭐☆☆ (Intermediate)
```

---

## 8. `labs/lab03-indexes/README.md`

```markdown
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
```

---

## 9. `labs/lab04-tcl/README.md`

```markdown
# Lab 04: Transaction Control Language (TCL)

## 🎯 Learning Objectives
- Understand ACID properties and their implementation
- Master transaction control commands (BEGIN, COMMIT, ROLLBACK)
- Work with savepoints for complex transaction management
- Explore transaction isolation levels and their effects
- Handle concurrent transactions an