# PostgreSQL Database Labs 🗃️

Welcome to your structured PostgreSQL learning environment! This repository contains 10 progressive labs covering essential database concepts from basic queries to advanced administration.

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

### Lab 01: Views and Materialized Views ⭐⭐⭐
**Folder**: `labs/lab01-views/`
**Topics**: Regular views, materialized views, complex queries, view security, refresh strategies
**Prerequisites**: Basic SQL knowledge

### Lab 02: Indexes and Query Optimization ⭐⭐⭐
**Folder**: `labs/lab03-indexes/`
**Topics**: Index types, B-tree, GIN, GiST indexes, query execution plans, performance optimization
**Prerequisites**: Lab 01

### Lab 03: Transaction Control Language (TCL) ⭐⭐
**Folder**: `labs/lab04-tcl/`
**Topics**: ACID properties, transaction management, isolation levels, locking
**Prerequisites**: Lab 02

### Lab 04: Window Functions and CTEs ⭐⭐⭐⭐
**Folder**: `labs/lab05-window-functions/`
**Topics**: Window functions, ranking functions, LAG/LEAD, CTEs, recursive CTEs, analytical queries
**Prerequisites**: Lab 03

### Lab 05: Stored Procedures ⭐⭐⭐
**Folder**: `labs/lab07-stored-procedures/`
**Topics**: Creating procedures, parameter handling, exception management
**Prerequisites**: Lab 04

### Lab 06: Introduction to PL/pgSQL ⭐⭐⭐
**Folder**: `labs/lab08-intro-plpgsql/`
**Topics**: PL/pgSQL basics, variables, control structures, simple functions
**Prerequisites**: Lab 05

### Lab 07: Cursors in PL/pgSQL ⭐⭐⭐⭐
**Folder**: `labs/lab09-cursors/`
**Topics**: Cursor operations, explicit/implicit cursors, record processing
**Prerequisites**: Lab 06

### Lab 08: Triggers and Event Handling ⭐⭐⭐⭐
**Folder**: `labs/lab10-triggers/`
**Topics**: Trigger functions, BEFORE/AFTER triggers, audit trails
**Prerequisites**: Lab 06

### Lab 09: PostgreSQL Administration Basics ⭐⭐⭐⭐
**Folder**: `labs/lab11-admin-basics/`
**Topics**: User/role management, privileges, row-level security, database monitoring
**Prerequisites**: Basic PostgreSQL knowledge

### Lab 10: Advanced Administrative Tasks ⭐⭐⭐⭐
**Folder**: `labs/lab12-admin-tasks/`
**Topics**: Backup/recovery, performance monitoring, maintenance automation, replication
**Prerequisites**: Lab 09

**Difficulty Legend**: ⭐ = Beginner, ⭐⭐ = Intermediate, ⭐⭐⭐ = Advanced, ⭐⭐⭐⭐ = Expert

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

**Beginner Path**: Labs 1 → 2 → 3 → 4 → 10
**Intermediate Path**: Labs 1 → 2 → 3 → 4 → 5 → 6 → 7 → 10
**Advanced Path**: Labs 1-9 in sequence, then 10 → 11
**Specialization Paths**:
- **Development Focus**: 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 → 9
- **Administration Focus**: 1 → 2 → 3 → 10 → 11 → 7 → 9

## 📚 Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Pagila Database GitHub](https://github.com/devrimgunduz/pagila)
- [SQL Learning Resources](https://www.postgresqltutorial.com/)

---

🎓 **Ready to learn? Pick a lab and start coding!**