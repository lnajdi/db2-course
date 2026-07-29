# Database 2 Course - Quiz Collection 📚

## Overview

This quiz collection is designed to assess and enhance student comprehension of advanced PostgreSQL concepts covered in the DB2 course. Each quiz module corresponds to a specific topic and includes multiple assessment formats to cater to different learning styles.

## Quiz Structure

Each quiz folder contains the following components:

### 📋 Assessment Types
- **Multiple Choice Questions** (`mcq.md`) - Quick concept validation
- **True/False Questions** (`true-false.md`) - Statement verification  
- **Practical SQL Exercises** (`practical.sql`) - Hands-on coding challenges
- **Case Studies** (`case-study.md`) - Real-world scenario analysis
- **Answer Keys** (`solutions/`) - Complete solutions and explanations

### 🎯 Learning Objectives
Each quiz clearly states:
- What students should know after completing the module
- Key concepts being assessed
- Practical skills being tested
- Expected proficiency level

## Quiz Modules

| Module | Topic | Difficulty | Duration |
|--------|-------|------------|----------|
| [Quiz 01](quiz01-views/) | Views & Materialized Views | Beginner | 30 min |
| [Quiz 02](quiz02-indexes/) | Database Indexes | Intermediate | 45 min |
| [Quiz 03](quiz03-tcl-transactions/) | TCL & Transactions | Intermediate | 40 min |
| [Quiz 04](quiz04-window-functions/) | Window Functions & CTEs | Advanced | 50 min |
| [Quiz 05](quiz05-plpgsql/) | PL/pgSQL Basics | Intermediate | 45 min |
| [Quiz 06](quiz06-procedures-functions/) | Stored Procedures & Functions | Advanced | 60 min |
| [Quiz 07](quiz07-cursors/) | Database Cursors | Advanced | 35 min |
| [Quiz 08](quiz08-triggers/) | Database Triggers | Advanced | 55 min |
| [Quiz 09](quiz09-admin-security/) | DB Administration & Security | Expert | 50 min |
| [Quiz 10](quiz10-final-comprehensive/) | Comprehensive Final Quiz | Expert | 90 min |

## Assessment Rubric

### Scoring Guidelines
- **Multiple Choice**: 2 points each
- **True/False**: 1 point each  
- **Practical SQL**: 5-10 points based on complexity
- **Case Studies**: 10-15 points with rubric breakdown

### Grade Scale
- **A (90-100%)**: Excellent understanding, ready for advanced topics
- **B (80-89%)**: Good grasp, minor gaps to address
- **C (70-79%)**: Satisfactory, needs practice in some areas  
- **D (60-69%)**: Basic understanding, requires additional study
- **F (<60%)**: Needs significant review and practice

## How to Use These Quizzes

### For Instructors 👨‍🏫
1. **Pre-Assessment**: Use before introducing new topics
2. **Formative Assessment**: Use during learning for feedback
3. **Summative Assessment**: Use after module completion
4. **Review Sessions**: Use incorrect answers for targeted review

### For Students 👩‍🎓
1. **Self-Assessment**: Test your understanding before exams
2. **Practice**: Reinforce learning with hands-on exercises
3. **Preparation**: Use as study guides for major assessments
4. **Progress Tracking**: Monitor your learning journey

## Database Setup

All quizzes use the **Pagila** sample database. Ensure you have:
```sql
-- Connect to your PostgreSQL instance
\c pagila

-- Verify tables exist
\dt
```

## Quiz Navigation

- 🟢 **Beginner**: Start here for foundational concepts
- 🟡 **Intermediate**: Build upon basic knowledge  
- 🔴 **Advanced**: Complex scenarios and optimization
- ⚫ **Expert**: Production-level challenges

## Contributing

To add new quiz questions or improve existing ones:
1. Follow the established format in each folder
2. Include detailed explanations in solutions
3. Test all SQL queries against the Pagila database
4. Update difficulty ratings appropriately

## Support Resources

- [Course Materials](../README.md)
- [Lab Exercises](../labs/)
- [Demo Sessions](../demos/)
- [Database Setup Guide](../CONNECTION_GUIDE.md)

---
*Last Updated: September 2025*
*Course: Advanced PostgreSQL (DB2)*
