# Lab 09: Database Administration Basics - User Management and Security

## 🎯 Learning Objectives
- Create and manage PostgreSQL users and roles
- Grant and revoke database privileges effectively
- Organize database objects using schemas
- Implement Row-Level Security (RLS) policies
- Understand the principle of least privilege
- Practice security verification and auditing

## 📚 Theory Overview

### PostgreSQL Security Architecture:

**Users and Roles:**
- A **role** is a database entity that can own objects and have privileges
- A **user** is a role with the LOGIN attribute (can connect to database)
- Roles can inherit privileges from other roles (role hierarchy)
- Example: `CREATE USER app_user WITH PASSWORD 'secret';` creates a role that can login

**Privilege Types:**
- **Database privileges**: CONNECT, CREATE, TEMPORARY
- **Schema privileges**: USAGE (access), CREATE (create objects)
- **Table privileges**: SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER
- **Sequence privileges**: USAGE (nextval), SELECT (currval), UPDATE (setval)
- **Function privileges**: EXECUTE

**Schemas:**
- Logical containers for organizing database objects
- Provide namespace isolation (prevent naming conflicts)
- Enable schema-level access control
- Default schema is "public"
- Example: `CREATE SCHEMA app_data;`

**Row-Level Security (RLS):**
- Fine-grained access control at the row level
- Policies define which rows are visible to which users
- Applied automatically to all queries
- Example: Users can only see their own data

**Key Security Concepts:**
- **Principle of Least Privilege**: Grant only necessary permissions
- **Separation of Duties**: Different users for different roles
- **Defense in Depth**: Multiple layers of security
- **Audit Trail**: Track who did what and when

## ⏱️ Lab Duration
- **Estimated Time**: 90-120 minutes
- **Difficulty**: ⭐⭐⭐ (Intermediate)

## 📋 Prerequisites
- PostgreSQL installed and running
- Connected to the `pagila` database
- Connected as `postgres` superuser
- Basic understanding of SQL

## 🛠️ Exercises

### Exercise 1: Basic User Creation and Privileges (25 points)

**Scenario**: You need to create a user for a new application that needs limited access to the pagila database.

**1.1** Create a basic user (5 points)
- Create a user named `app_user` with password `app_pass123`
- Grant CONNECT privilege on the `pagila` database
- Verify the user was created by querying `pg_roles`

**Expected Output:**
```
 rolname  | rolcanlogin | rolsuper
----------+-------------+----------
 app_user | t           | f
```

**1.2** Grant SELECT privileges (10 points)
- Grant SELECT privilege on these tables to `app_user`:
  - `film`
  - `actor`
  - `customer`
- Verify privileges using `information_schema.table_privileges`
- Test by connecting as `app_user` and running SELECT queries

**Expected Behavior:**
- ✅ `SELECT * FROM film LIMIT 5;` should work
- ✅ `SELECT * FROM actor LIMIT 5;` should work
- ❌ `SELECT * FROM payment LIMIT 5;` should fail (no permission)

**1.3** Grant INSERT privileges (10 points)
- Grant INSERT privilege on `film` table to `app_user`
- Grant USAGE on sequence `film_film_id_seq` to `app_user`
- Test by inserting a test record as `app_user`
- Verify the insert worked

**Challenge Question**: Why do we need to grant USAGE on the sequence?

**Hint**: Use `\c pagila app_user` in psql to switch users

### Exercise 2: Role-Based Access Control (30 points)

**Scenario**: Instead of granting privileges directly to users, create roles for different access levels.

**2.1** Create a view_reader role (10 points)
- Create a role named `view_reader` (note: role, not user)
- Grant SELECT on all pagila views to this role:
  - `actor_info`
  - `film_list`
  - `customer_list`
  - `sales_by_film_category`
  - `staff_list`
- Grant the `view_reader` role to `app_user`
- Verify `app_user` can now query these views

**Key Concept**: Roles are reusable. You can grant the same role to multiple users!

**2.2** Create an analyst_role (10 points)
- Create a role named `analyst_role`
- Grant SELECT on all tables in the public schema to `analyst_role`
- Create a new user `analyst_user` with password `analyst_pass`
- Grant CONNECT and `analyst_role` to `analyst_user`
- Test by querying all tables as `analyst_user`

**2.3** Verify role memberships (10 points)
- Query `pg_auth_members` to see role memberships
- Create a query showing which users belong to which roles
- Document the privilege hierarchy you've created

**Verification Query:**
```sql
SELECT 
    r.rolname AS role_name,
    m.rolname AS member_name
FROM pg_roles r
JOIN pg_auth_members am ON r.oid = am.roleid
JOIN pg_roles m ON am.member = m.oid
WHERE m.rolname IN ('app_user', 'analyst_user')
ORDER BY r.rolname, m.rolname;
```

### Exercise 3: Schema Management and Organization (20 points)

**Scenario**: Create a separate schema for application-specific data to keep it organized.

**3.1** Create a new schema (5 points)
- Create a schema named `app_data`
- Grant USAGE on the schema to `app_user`
- Verify the schema was created

**3.2** Control schema privileges (10 points)
- Test: Try to create a table as `app_user` in `app_data` schema (should fail)
- As postgres, grant CREATE on schema `app_data` to `app_user`
- Test again: Create a table as `app_user` (should succeed now)
- Create table: `app_data.user_preferences (user_id INT, theme VARCHAR(50))`

**3.3** Test schema isolation (5 points)
- Insert test data into `app_data.user_preferences`
- Verify `app_user` can access their own schema
- Verify `analyst_user` cannot access `app_data` schema (no privileges)

**Key Learning**: Schemas provide logical organization AND security boundaries!

### Exercise 4: Row-Level Security (RLS) (25 points)

**Scenario**: Create a task management system where users can only see their own tasks.

**4.1** Create tasks table with RLS (10 points)
- Create table `app_data.tasks` with columns:
  - `task_id SERIAL PRIMARY KEY`
  - `task_name VARCHAR(200)`
  - `description TEXT`
  - `assigned_to VARCHAR(100)`
  - `completed BOOLEAN DEFAULT FALSE`
  - `created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP`
- Enable Row-Level Security on the tasks table
- Verify RLS is enabled using `pg_tables`

**4.2** Create RLS policy (10 points)
- Create a policy named `user_tasks_policy` that:
  - Applies to ALL operations
  - Uses condition: `assigned_to = current_user`
- Grant ALL privileges on `tasks` table to `app_user` and `analyst_user`
- Grant USAGE on sequence `tasks_task_id_seq` to both users

**Policy Explanation:**
```sql
-- This policy filters rows automatically:
CREATE POLICY user_tasks_policy ON app_data.tasks
    FOR ALL
    USING (assigned_to = current_user);
-- Now users only see rows where assigned_to matches their username!
```

**4.3** Test RLS policies (5 points)
- As postgres, insert test tasks assigned to different users:
  - 2 tasks for `app_user`
  - 2 tasks for `analyst_user`
- Connect as `app_user` and query tasks (should see only 2)
- Connect as `analyst_user` and query tasks (should see only 2)
- Try to insert a task assigned to someone else (should fail or be filtered)

**Expected Behavior:**
```sql
-- As app_user:
SELECT * FROM app_data.tasks;
-- Shows only: assigned_to = 'app_user'

-- As analyst_user:
SELECT * FROM app_data.tasks;
-- Shows only: assigned_to = 'analyst_user'

-- As postgres:
SELECT * FROM app_data.tasks;
-- Shows ALL tasks (superuser bypasses RLS)
```

## 🔍 Verification and Monitoring Queries

### Check User Creation:
```sql
-- View all users and their attributes
SELECT rolname, rolcanlogin, rolsuper, rolcreatedb, rolcreaterole
FROM pg_roles
WHERE rolname IN ('app_user', 'analyst_user')
ORDER BY rolname;
```

### Check Table Privileges:
```sql
-- View privileges for a specific user
SELECT 
    grantee,
    table_schema,
    table_name,
    privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'app_user'
ORDER BY table_schema, table_name, privilege_type;
```

### Check Role Memberships:
```sql
-- View which roles are granted to users
SELECT 
    r.rolname AS role_name,
    m.rolname AS member_name
FROM pg_roles r
JOIN pg_auth_members am ON r.oid = am.roleid
JOIN pg_roles m ON am.member = m.oid
WHERE m.rolname IN ('app_user', 'analyst_user')
ORDER BY r.rolname, m.rolname;
```

### Check Schema Privileges:
```sql
-- View schema access for users
SELECT 
    n.nspname AS schema_name,
    r.rolname AS grantee,
    p.privilege_type
FROM pg_namespace n,
     aclexplode(n.nspacl) p
JOIN pg_roles r ON p.grantee = r.oid
WHERE r.rolname IN ('app_user', 'analyst_user')
ORDER BY schema_name, grantee;
```

### Check RLS Policies:
```sql
-- View all RLS policies
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies
WHERE schemaname = 'app_data'
ORDER BY tablename, policyname;
```

### Check Active Connections:
```sql
-- View current connections by user
SELECT 
    usename,
    application_name,
    client_addr,
    state,
    query_start
FROM pg_stat_activity
WHERE usename IN ('app_user', 'analyst_user')
ORDER BY usename, query_start DESC;
```
## 📝 Deliverables

Complete the `solutions.sql` file with:
1. **User creation commands** - Create `app_user` and `analyst_user`
2. **Privilege grants** - All necessary GRANT statements
3. **Role creation** - Create `view_reader` and `analyst_role`
4. **Schema setup** - Create and configure `app_data` schema
5. **RLS implementation** - Tasks table with RLS policies
6. **Verification queries** - Document your testing results in comments

## 💡 Security Best Practices

- **Principle of Least Privilege**: Grant only the minimum permissions needed
- **Use Roles**: Create reusable roles instead of granting to users directly
- **Schema Isolation**: Use schemas to organize and secure objects
- **Row-Level Security**: Implement RLS for multi-tenant data isolation
- **Regular Audits**: Review user privileges and access patterns regularly
- **Documentation**: Document who has access to what and why
- **Password Management**: Use strong passwords and consider expiration dates
- **Testing**: Always test privileges by connecting as the user

## 🚨 Common Security Mistakes to Avoid

1. **Over-privileging**: Giving users more access than they need
   - ❌ `GRANT ALL ON DATABASE pagila TO app_user;`
   - ✅ `GRANT CONNECT ON DATABASE pagila TO app_user;`

2. **Forgetting Sequences**: INSERT fails without sequence access
   - ❌ Only granting INSERT on table
   - ✅ Also grant USAGE on associated sequences

3. **Public Schema Issues**: Everyone has CREATE on public by default
   - ⚠️ Consider: `REVOKE CREATE ON SCHEMA public FROM PUBLIC;`

4. **Superuser Usage**: Using postgres for application connections
   - ❌ Connecting as `postgres` from applications
   - ✅ Create dedicated application users

5. **Testing as Wrong User**: Testing with superuser privileges
   - ❌ Testing as `postgres` (bypasses all restrictions)
   - ✅ Actually connect as the limited user

## 🔧 Essential psql Commands

```bash
# Connect to database as specific user
\c pagila app_user

# View current connection info
\conninfo

# List all roles
\du

# List all schemas
\dn+

# List tables in a schema
\dt app_data.*

# Describe a table (including policies)
\d+ app_data.tasks

# View table privileges
\dp film

# Quit psql
\q
```

## 🎓 Key Concepts Review

**Users vs. Roles:**
- A role becomes a user when given LOGIN privilege
- Roles can inherit from other roles (role membership)
- Best practice: Create roles for permissions, users for login

**Privilege Hierarchy:**
```
Database Level (CONNECT)
  ↓
Schema Level (USAGE, CREATE)
  ↓
Object Level (SELECT, INSERT, UPDATE, DELETE)
  ↓
Row Level (RLS Policies)
```

**RLS vs. Traditional Privileges:**
- Traditional: Controls WHICH objects you can access
- RLS: Controls WHICH rows you can see within an object
- RLS policies are transparent to applications

**Why Schemas Matter:**
- Namespace: Avoid naming conflicts
- Organization: Group related objects
- Security: Control access at schema level
- Multi-tenancy: Separate data by tenant

## 🧹 Cleanup Script

When you're done with the lab, run this to clean up:

```sql
-- Connect as postgres first
\c pagila postgres

-- Drop policies
DROP POLICY IF EXISTS user_tasks_policy ON app_data.tasks;

-- Drop objects in app_data schema
DROP TABLE IF EXISTS app_data.tasks CASCADE;
DROP TABLE IF EXISTS app_data.user_preferences CASCADE;
DROP SCHEMA IF EXISTS app_data CASCADE;

-- Revoke privileges and drop roles
REVOKE ALL PRIVILEGES ON DATABASE pagila FROM app_user;
REVOKE ALL PRIVILEGES ON DATABASE pagila FROM analyst_user;
REVOKE view_reader FROM app_user;
REVOKE analyst_role FROM analyst_user;

DROP ROLE IF EXISTS view_reader;
DROP ROLE IF EXISTS analyst_role;
DROP USER IF EXISTS app_user;
DROP USER IF EXISTS analyst_user;

-- Verify cleanup
SELECT rolname FROM pg_roles WHERE rolname IN ('app_user', 'analyst_user', 'view_reader', 'analyst_role');
```

---

**Time Estimate**: 90-120 minutes  
**Difficulty**: ⭐⭐⭐ (Intermediate)  
**Prerequisites**: PostgreSQL basics, SQL knowledge  
**Focus**: User management, roles, schemas, and RLS
