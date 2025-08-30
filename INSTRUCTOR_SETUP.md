# Instructor Setup Guide

# Instructor Setup Guide

## 🎓 Course Overview
This repository contains a complete PostgreSQL database course with 12 progressive labs covering essential database concepts using the Pagila sample database.

## 📋 Course Structure

### Lab Progression:
1. **Lab 01: Basic Queries and Filtering** - SELECT statements, WHERE clauses, basic filtering
2. **Lab 02: Advanced Queries and Joins** - INNER, LEFT, RIGHT, FULL OUTER joins, subqueries
3. **Lab 03: Aggregate Functions and Grouping** - GROUP BY, HAVING, aggregate functions
4. **Lab 04: Data Modification** - INSERT, UPDATE, DELETE operations, constraints
5. **Lab 05: Database Design and Normalization** - ER modeling, normalization forms
6. **Lab 06: Indexes and Query Optimization** - Query optimization, index types and strategies
7. **Lab 07: Views and Materialized Views** - Basic and complex views, materialized views
8. **Lab 08: Introduction to PL/pgSQL** - PL/pgSQL basics, variables, control structures
9. **Lab 09: Cursors in PL/pgSQL** - Cursor operations, row-by-row processing
10. **Lab 10: Triggers and Event Handling** - Trigger types, business rules, audit trails
11. **Lab 11: User Management and Security** - User/role management, privileges, RLS, auditing
12. **Lab 12: PostgreSQL Administrative Tasks** - Backup/recovery, monitoring, maintenance

### Recent Course Updates:
- **Lab 11 Specialization**: Split original administration lab into focused security lab
- **Lab 12 Addition**: New dedicated lab for operational database administration
- **Progressive Difficulty**: Structured progression from beginner to expert level
- **Enhanced Security Focus**: Comprehensive coverage of PostgreSQL security features

## 🚀 Quick Setup for Instructors

### GitHub Classroom Setup:
1. Create assignment from this template repository
2. Students will automatically get individual repositories
3. Environment automatically configures with PostgreSQL + Pagila database
4. All lab materials are pre-populated

### Manual Setup (Non-Classroom):
1. Fork or download this repository
2. Students can use GitHub Codespaces or local Docker
3. Run `docker-compose up` to start PostgreSQL
4. Environment auto-configures on first startup

## 🗂️ Database Schema (Pagila)
The course uses the Pagila database - a sample DVD rental store database that provides:
- Real-world complexity without overwhelming beginners
- Rich relationships for JOIN practice
- Temporal data for time-series analysis
- Hierarchical structures for advanced queries

### Key Tables:
- **customer**, **address**, **city**, **country** - Customer data
- **film**, **category**, **actor**, **film_actor** - Movie catalog
- **inventory**, **store**, **staff** - Business operations
- **rental**, **payment** - Transaction records

## 📊 Assessment Guidelines

### Grading Rubric:
Each lab is worth 100 points distributed as:
- **Correctness (60%)**: Solutions work and produce correct results
- **Code Quality (20%)**: Clean, well-commented, efficient code
- **Analysis (20%)**: Thoughtful answers to analytical questions

### Time Estimates:
- **Lab 01-02**: 2-3 hours each (Beginner)
- **Lab 03-04**: 3-4 hours each (Intermediate)
- **Lab 05-07**: 4-5 hours each (Advanced)
- **Lab 08**: 3-4 hours (Beginner-Intermediate)
- **Lab 09-10**: 4-5 hours each (Advanced)
- **Lab 11**: 4-5 hours (Intermediate)

### Difficulty Progression:
- ⭐⭐☆☆☆ Labs 1-2, 8: Beginner
- ⭐⭐⭐☆☆ Labs 3-4, 11: Intermediate  
- ⭐⭐⭐⭐☆ Labs 5-6, 9-10: Advanced
- ⭐⭐⭐⭐⭐ Lab 7: Expert

## 🔧 Technical Requirements

### Student Environment:
- GitHub Codespaces (recommended) or local Docker
- VS Code with PostgreSQL extension
- Access to PostgreSQL 15 with Pagila database

### Instructor Tools:
- Access to student repositories for review
- PostgreSQL client for testing solutions
- GitHub Classroom dashboard for progress tracking

## 📝 Lab Management

### Solution Files:
- Students work in `solutions.sql` files (gitignored by default)
- Instructors can access through GitHub Classroom
- Template files provide structure and guidance

### Auto-Grading Potential:
- SQL solutions can be tested against expected outputs
- Consider implementing automated testing for objective questions
- Manual review recommended for analytical components

## 🎯 Learning Outcomes Assessment

### By Lab Completion, Students Should:
1. **Design efficient database views** for data abstraction
2. **Optimize query performance** using indexes and materialized views
3. **Manage transactions** with appropriate isolation levels
4. **Perform advanced analytics** with window functions and CTEs
5. **Implement business logic** using stored procedures and triggers

### Assessment Methods:
- **Practical Exercises**: Hands-on SQL development
- **Performance Analysis**: Query optimization tasks
- **Design Decisions**: Justification of technical choices
- **Troubleshooting**: Debugging and problem-solving

## 🚨 Common Issues & Solutions

### Environment Problems:
- **Database not connecting**: Wait for full setup completion (2-3 minutes)
- **Missing tables**: Check if Pagila loaded successfully
- **Permission errors**: Verify student/password credentials

### Student Challenges:
- **Lab 01**: Distinguishing updatable vs read-only views
- **Lab 02**: Understanding refresh strategies and performance trade-offs
- **Lab 03**: Choosing appropriate index types and composite column order
- **Lab 04**: Grasping isolation level implications
- **Lab 05**: Window function frame specifications
- **Lab 06**: Recursive CTE termination conditions
- **Lab 07**: PL/pgSQL syntax and debugging

## 📚 Extension Activities

### For Advanced Students:
- **Performance Benchmarking**: Compare solutions across different approaches
- **Real-world Applications**: Adapt solutions to other domains
- **Optimization Challenges**: Push performance boundaries
- **Integration Projects**: Combine multiple lab concepts

### Additional Resources:
- PostgreSQL Documentation links
- Performance tuning guides
- Advanced SQL pattern libraries
- Industry best practices documentation

## 🔄 Course Maintenance

### Regular Updates:
- Keep PostgreSQL version current
- Update performance benchmarks
- Refresh real-world examples
- Incorporate student feedback

### Customization Options:
- Adjust lab difficulty levels
- Add domain-specific exercises
- Modify assessment criteria
- Include additional datasets

---

**Contact**: [Your contact information]
**Course Repository**: [Repository URL]
**Last Updated**: [Current Date]
