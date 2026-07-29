-- ============================================================================
-- PostgreSQL Security & User Management - Hands-On Lab
-- ============================================================================
-- This lab demonstrates user creation, roles, privileges, schemas, and RLS
-- Follow each section step by step and verify results using pg_catalog queries
-- ============================================================================

-- ----------------------------------------------------------------------------
-- SECTION 1: CONNECTION SETUP
-- ----------------------------------------------------------------------------
-- You should connect to the 'pagila' database as the 'postgres' superuser
-- using one of the following methods:


-- -- Open access CLI tool for postgres (from Docker or local installation)

-- Option 1 : Docker Command (if using Docker)

-- Docker users: 
    -- docker exec -it postgres_db bash 
    -- -- ( replace 'postgres_db' with your container name)
    -- Then inside the container, run:   psql -U postgres -d pagila


-- Option 2 : Connect using psql (local installation)
-- psql -U postgres -d pagila
--  postgres is the superuser you have set up when you installed PostgreSQL,
--  make sure to connect as this user to have the necessary privileges.
-- Enter password when prompted

-- Option 3 : Full connection string (if needed)
-- psql -h localhost -p 5432 -U postgres -d pagila 


-- You could also psql -U postgres  , this time you will connect to the default 'postgres' database,
-- then switch to 'pagila' using the command:  \c pagila
-- ----------------------------------------------------------------------------


-- Verify you're connected to the right database
SELECT current_database()

, current_user;

-- (eqivalent meta-command in psql: \conninfo  )

-- View existing roles
SELECT rolname, rolsuper, rolcreatedb, rolcanlogin 
FROM pg_roles 
ORDER BY rolname;

-- Sample Output:
--                  
--   rolname          | rolsuper | rolcreatedb | rolcanlogin
-- rolname  is the name of the role
-- rolsuper indicates if the role is a superuser (t = true, f = false)
-- rolcreatedb indicates if the role can create databases
-- rolcanlogin indicates if the role can log in (t = true, f = false)




-- ----------------------------------------------------------------------------
-- SECTION 2: CREATE REGULAR USER WITH LIMITED PRIVILEGES
-- ----------------------------------------------------------------------------
-- Create a new user with basic access
CREATE USER regular_user WITH PASSWORD 'regular_pass';

-- Grant database connection privilege
GRANT CONNECT ON DATABASE pagila TO regular_user;

-- Grant SELECT privilege on specific tables
GRANT SELECT ON film TO regular_user;
GRANT SELECT ON actor TO regular_user;
GRANT SELECT ON customer TO regular_user;


-- CHECKPOINT: Verify privileges were granted
SELECT 
    grantee,
    table_schema,
    table_name,
    privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'regular_user'
ORDER BY table_name, privilege_type;

-- ----------------------------------------------------------------------------
-- SECTION 3: TEST AS REGULAR_USER (LIMITED ACCESS)
-- ----------------------------------------------------------------------------
-- Switch to regular_user connection
-- In psql, run: \c pagila regular_user
-- or start a new psql session: psql -U regular_user -d pagila 
-- Enter password: regular_pass

-- As regular_user, try to select from granted tables (SHOULD WORK)
SELECT film_id, title, release_year 
FROM film 
LIMIT 5;

SELECT actor_id, first_name, last_name 
FROM actor 
LIMIT 5;

-- Try to select from a view (SHOULD FAIL - no privileges on views yet)
SELECT * 
FROM film_list 
LIMIT 5;
-- Expected error: permission denied for view film_list

-- lets fix it 
-- GRANT SELECT ON film_list TO regular_user;


-- Try to INSERT into a table (SHOULD FAIL - only have SELECT)
INSERT INTO film (title, language_id) 
VALUES ('Test Movie', 1);
-- Expected error: permission denied for table film

-- ----------------------------------------------------------------------------
-- SECTION 4: GRANT INSERT PRIVILEGE (AS SUPERUSER)
-- ----------------------------------------------------------------------------
-- Switch back to postgres superuser
-- In psql, run: \c pagila postgres

-- Grant INSERT privilege on film table
GRANT INSERT ON film TO regular_user;

-- Also need to grant USAGE on the sequence for auto-incrementing IDs
GRANT USAGE, SELECT ON SEQUENCE film_film_id_seq TO regular_user;

-- CHECKPOINT: Verify INSERT privilege was granted
SELECT 
    grantee,
    table_name,
    privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'regular_user' 
AND table_name = 'film'
ORDER BY privilege_type;

-- ----------------------------------------------------------------------------
-- SECTION 5: TEST INSERT AS REGULAR_USER
-- ----------------------------------------------------------------------------
-- Switch to regular_user again
-- In psql, run: \c pagila regular_user

-- Try INSERT again (SHOULD WORK NOW)
INSERT INTO film (title, language_id, rental_duration, rental_rate, replacement_cost) 
VALUES ('My Test Movie', 1, 3, 4.99, 19.99);

-- Verify the insert worked
SELECT film_id, title, release_year 
FROM film 
WHERE title = 'My Test Movie';

-- ----------------------------------------------------------------------------
-- SECTION 6: CREATE ROLE FOR VIEW ACCESS (AS SUPERUSER)
-- ----------------------------------------------------------------------------
-- Switch back to postgres superuser
-- In psql, run: \c pagila postgres

-- Create a role specifically for reading views
CREATE ROLE view_reader;

-- Grant SELECT on all views in the public schema
GRANT SELECT ON actor_info TO view_reader;
GRANT SELECT ON customer_list TO view_reader;
GRANT SELECT ON film_list TO view_reader;
GRANT SELECT ON nicer_but_slower_film_list TO view_reader;
GRANT SELECT ON sales_by_film_category TO view_reader;
GRANT SELECT ON sales_by_store TO view_reader;
GRANT SELECT ON staff_list TO view_reader;

SELECT * from  staff_list ; 

-- Grant this role to regular_user
GRANT view_reader TO regular_user;

-- CHECKPOINT: Verify role membership
SELECT 
    r.rolname AS role_name,
    m.rolname AS member_name
FROM pg_roles r
JOIN pg_auth_members am ON r.oid = am.roleid
JOIN pg_roles m ON am.member = m.oid
WHERE m.rolname = 'regular_user';

-- CHECKPOINT: Verify view privileges
SELECT 
    grantee,
    table_name,
    privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'view_reader'
ORDER BY table_name;

-- ----------------------------------------------------------------------------
-- SECTION 7: TEST VIEW ACCESS AS REGULAR_USER
-- ----------------------------------------------------------------------------
-- Switch to regular_user
-- In psql, run: \c pagila regular_user

-- Try to select from views (SHOULD WORK NOW)
SELECT * 
FROM film_list 
LIMIT 5;

SELECT * 
FROM actor_info 
LIMIT 5;

-- from psql, 
-- The colon (:) is the prompt you see at the bottom. It means psql is waiting for your command.
-- If the output is long, psql may use a pager (like 'less') to display results one page at a time.
-- You press the q key on your keyboard to quit the pager and go back to the regular command line.



-- ----------------------------------------------------------------------------
-- SECTION 8: CREATE NEW SCHEMA (AS SUPERUSER)
-- ----------------------------------------------------------------------------
-- Switch back to postgres superuser
-- In psql, run: \c pagila postgres


-- display current schemas
SELECT schema_name, schema_owner
FROM information_schema.schemata
ORDER BY schema_name;

-- or use the meta-command in psql:  \dn+   
-- the d letters stands for "display namespaces" (schemas) the n is for "namespaces" (schemas)
-- the + adds more details like owner, access privileges, etc.




-- Create a new schema for organizing objects
CREATE SCHEMA IF NOT EXISTS app_schemas;

--  use  again  \dn+   to see the new schema created 
-- or run the SQL query again:
SELECT schema_name, schema_owner
FROM information_schema.schemata
WHERE schema_name = 'app_schemas';


--  \d information_schema.schemata   provides details of columns in the schema 


-- Grant USAGE on the schema (allows access but not creation)
GRANT USAGE ON SCHEMA app_schemas TO regular_user;


REVOKE CREATE ON SCHEMA app_schemas FROM regular_user;


-- CHECKPOINT: Verify schema usage was granted to regular_user
--  \dn+ app_schemas

SELECT
  n.nspname AS schema_name,
  r.rolname AS grantee,
  p.privilege_type
FROM
  pg_namespace AS n,
  aclexplode(n.nspacl) AS p
JOIN pg_roles AS r ON p.grantee = r.oid
WHERE n.nspname = 'app_schemas' AND r.rolname = 'regular_user';


-- ----------------------------------------------------------------------------
-- SECTION 9: TEST SCHEMA ACCESS WITHOUT CREATE PRIVILEGE
-- ----------------------------------------------------------------------------
-- Switch to regular_user
-- In psql, run: \c pagila regular_user

-- Try to create a table in the new schema (SHOULD FAIL - no CREATE privilege)
CREATE TABLE app_schemas.test_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);
DROP TABLE app_schemas.test_table ; 
-- Expected error: permission denied for schema app_schemas

-- ----------------------------------------------------------------------------
-- SECTION 10: GRANT CREATE PRIVILEGE ON SCHEMA (AS SUPERUSER)
-- ----------------------------------------------------------------------------
-- Switch back to postgres superuser
-- In psql, run: \c pagila postgres

-- Grant CREATE privilege on the schema
GRANT CREATE ON SCHEMA app_schemas TO regular_user;

-- CHECKPOINT: Verify schema privileges
--  \dn+ app_schemas


-- ----------------------------------------------------------------------------
-- SECTION 11: TEST TABLE CREATION WITH CREATE PRIVILEGE
-- ----------------------------------------------------------------------------
-- Switch to regular_user
-- In psql, run: \c pagila regular_user

-- Try to create a table again (SHOULD WORK NOW)
CREATE TABLE app_schemas.test_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Verify table was created
SELECT 
    table_schema,
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'app_schemas';

-- or  pg_tables
SELECT * FROM pg_tables
WHERE schemaname = 'app_schemas';


--- or use psql meta-command:  \dt app_schemas.* 

-- Insert some test data
INSERT INTO app_schemas.test_table (name) 
VALUES ('Test Entry 1'), ('Test Entry 2');



-- Query the table
SELECT * FROM app_schemas.test_table;

-- ----------------------------------------------------------------------------
-- SECTION 12: CREATE TASKS TABLE WITH RLS (AS SUPERUSER)
-- ----------------------------------------------------------------------------
-- Switch back to postgres superuser
-- In psql, run: \c pagila postgres

-- Create a tasks table in the app_schemas schema
CREATE TABLE app_schemas.tasks (
    task_id SERIAL PRIMARY KEY,
    task_name VARCHAR(200) NOT NULL,
    task_description TEXT,
    assigned_to VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed BOOLEAN DEFAULT FALSE
);

-- Enable Row-Level Security on the tasks table
ALTER TABLE app_schemas.tasks ENABLE ROW LEVEL SECURITY;

-- CHECKPOINT: Verify RLS is enabled

--  use psql meta-command:  \  app_schemas.tasks

-- or run the SQL query: 

SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables
WHERE tablename = 'tasks';


-- ----------------------------------------------------------------------------
-- SECTION 13: CREATE RLS POLICY FOR REGULAR_USER
-- ----------------------------------------------------------------------------
-- Create a policy that allows users to see only their own tasks
CREATE POLICY user_tasks_policy ON app_schemas.tasks
    FOR ALL
    USING (assigned_to = current_user)

-- CREATE POLICY user_tasks_policy ON app_schemas.tasks: 
--      This creates a new security rule named user_tasks_policy and attaches it to the tasks table.

-- FOR ALL: This means the policy applies to every type of command: 
--      SELECT (viewing), INSERT (adding), UPDATE (editing), and DELETE (removing) data.
--   you could also specify specific commands like FOR SELECT, FOR INSERT, etc., but FOR ALL covers everything.


--  USING (assigned_to = current_user): This is the most important part. 
--      It's the actual rule. It says that for any existing row to be visible or modifiable, the value in its assigned_to column must be equal to the name of the user who is currently logged in (current_user).



-- use psql meta-command:  \d app_schemas.tasks 

-- CHECKPOINT: Verify policy was created
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
FROM pg_policies
WHERE tablename = 'tasks';

-- Grant necessary privileges to regular_user
GRANT SELECT, INSERT, UPDATE, DELETE ON app_schemas.tasks TO regular_user;
GRANT USAGE, SELECT ON SEQUENCE app_schemas.tasks_task_id_seq TO regular_user;

-- ----------------------------------------------------------------------------
-- SECTION 14: CREATE ANOTHER USER FOR RLS TESTING
-- ----------------------------------------------------------------------------
-- Create a second user to test RLS
CREATE USER task_user WITH PASSWORD 'task_pass';

-- Grant necessary privileges to task_user
GRANT CONNECT ON DATABASE pagila TO task_user;
GRANT USAGE ON SCHEMA app_schemas TO task_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON app_schemas.tasks TO task_user;
GRANT USAGE, SELECT ON SEQUENCE app_schemas.tasks_task_id_seq TO task_user;


-- ----------------------------------------------------------------------------
-- SECTION 15: INSERT TEST DATA AS SUPERUSER
-- ----------------------------------------------------------------------------
-- Insert tasks for different users
INSERT INTO app_schemas.tasks (task_name, task_description, assigned_to)
VALUES 
    ('Task 1 for regular_user', 'Complete database security lab', 'regular_user'),
    ('Task 2 for regular_user', 'Review SQL queries', 'regular_user'),
    ('Task 1 for task_user', 'Test RLS policies', 'task_user'),
    ('Task 2 for task_user', 'Document findings', 'task_user');

-- View all tasks as superuser (can see everything)
SELECT * FROM app_schemas.tasks ORDER BY task_id;

-- ----------------------------------------------------------------------------
-- SECTION 16: TEST RLS AS REGULAR_USER
-- ----------------------------------------------------------------------------
-- Switch to regular_user
-- In psql, run: \c pagila regular_user

-- Query tasks (SHOULD ONLY SEE regular_user's tasks)
SELECT * FROM app_schemas.tasks;

-- Try to insert a task for yourself (SHOULD WORK)
INSERT INTO app_schemas.tasks (task_name, task_description, assigned_to)
VALUES ('My New Task', 'This is my task', 'regular_user');

-- Try to insert a task for someone else (SHOULD FAIL)
INSERT INTO app_schemas.tasks (task_name, task_description, assigned_to)
VALUES ('Task for others', 'This should fail', 'task_user');

-- Verify your tasks
SELECT * FROM app_schemas.tasks;

-- ----------------------------------------------------------------------------
-- SECTION 17: TEST RLS AS TASK_USER
-- ----------------------------------------------------------------------------
-- Switch to task_user
-- In psql, run: \c pagila task_user
-- Enter password: task_pass

-- Query tasks (SHOULD ONLY SEE task_user's tasks)
SELECT * FROM app_schemas.tasks;

-- Insert a task for yourself (SHOULD WORK)
INSERT INTO app_schemas.tasks (task_name, task_description, assigned_to)
VALUES ('Task User Task', 'Testing RLS', 'task_user');

-- Verify your tasks
SELECT * FROM app_schemas.tasks;

-- Try to update someone else's task (SHOULD FAIL - won't find the row)
UPDATE app_schemas.tasks 
SET completed = TRUE 
WHERE assigned_to = 'regular_user';
-- Returns 0 rows updated (can't see other users' tasks)

-- The USING (assigned_to = current_user) clause acts like a filter that is silently added to every command. So when you ran your UPDATE, PostgreSQL effectively saw this:

-- UPDATE app_schemas.tasks
-- SET completed = TRUE
-- WHERE assigned_to = 'regular_user' AND assigned_to = current_user; -- This part is added automatically!
-- Since a row can't be assigned to both 'regular_user' and your current user at the same time, the command simply found zero matching rows. Finding nothing isn't an error, so it just reports UPDATE 0.


--- Other options for RLS policies:
--  USING (condition) 🔑: This applies to rows that already exist in the table. It decides which rows you are allowed to see and work with.
--  WITH CHECK (condition) ✅: This applies to rows you are trying to insert or update. It checks if the new or changed data is valid before allowing it.
--  The TO clause lets us get even more specific about who a policy applies to.  By default, if you don't add a TO clause, the policy applies TO PUBLIC, which means every user (or "role" in PostgreSQL terms).


-- ----------------------------------------------------------------------------
-- SECTION 18: CREATE NEW DATABASE (AS SUPERUSER)
-- ----------------------------------------------------------------------------
-- Switch back to postgres superuser
-- In psql, run: \c pagila postgres

-- Create a completely new database

-- from the menu of postgres extension of vscode select posgres database right click and select new query editor

CREATE DATABASE security_demo   WITH
ENCODING = 'UTF8' ;

drop database if exists security_demo;

-- Specifies the character encoding. 'UTF8' is the universal standard and a very safe choice.

-- CHECKPOINT: Verify database was created
SELECT 
    datname,
    datdba::regrole AS owner,
    encoding,
    datcollate,
    datctype
FROM pg_database
WHERE datname = 'security_demo';

-- Grant connection to users
GRANT CONNECT ON DATABASE security_demo TO regular_user;
GRANT CONNECT ON DATABASE security_demo TO task_user;

-- ----------------------------------------------------------------------------
-- SECTION 19: FINAL VERIFICATION QUERIES
-- ----------------------------------------------------------------------------
-- Connect to original database
-- \c pagila postgres

-- Summary of all users created : print roles and their attributes
SELECT 
    rolname,
    rolcanlogin,
    rolcreatedb,
    rolcreaterole,
    rolsuper
FROM pg_roles
WHERE rolname IN ('regular_user', 'task_user', 'view_reader')
ORDER BY rolname;

-- Summary of all role memberships : print which roles have been granted to which users 
SELECT 
    r.rolname AS role_name,
    m.rolname AS member_name,
    a.admin_option
FROM pg_roles r
JOIN pg_auth_members a ON r.oid = a.roleid
JOIN pg_roles m ON a.member = m.oid
WHERE m.rolname IN ('regular_user', 'task_user')
ORDER BY r.rolname, m.rolname;

-- Summary of table privileges : print table privileges for our users
SELECT 
    grantee,
    table_schema,
    table_name,
    privilege_type
FROM information_schema.table_privileges
WHERE grantee IN ('regular_user', 'task_user', 'view_reader')
ORDER BY grantee, table_schema, table_name, privilege_type;

-- Summary of schema privileges : print schema privileges for our users

-- Summary of RLS policies : print all RLS policies on tasks table
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE schemaname = 'app_schemas'
ORDER BY tablename, policyname;

-- ============================================================================
-- LAB COMPLETE!
-- ============================================================================
-- You have successfully:
-- 1. Created users with limited privileges
-- 2. Granted and tested database, table, and view access
-- 3. Created and managed schemas
-- 4. Implemented Row-Level Security (RLS)
-- 5. Created a new database
-- 6. Verified all security settings using pg_catalog queries
-- ============================================================================

-- ============================================================================
-- CLEANUP SCRIPT
-- ============================================================================
-- Run this section to remove all objects created during the lab
-- WARNING: This will delete all users, roles, schemas, and databases created
-- Make sure you're connected as postgres superuser before running cleanup
-- ============================================================================

-- Switch to postgres superuser if not already
-- \c pagila postgres

-- ----------------------------------------------------------------------------
-- Step 1: Disconnect all active connections from users we're about to drop
-- ----------------------------------------------------------------------------
-- Terminate connections for regular_user
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE usename = 'regular_user' AND pid <> pg_backend_pid();

-- Terminate connections for task_user
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE usename = 'task_user' AND pid <> pg_backend_pid();

-- ----------------------------------------------------------------------------
-- Step 2: Drop RLS policies
-- ----------------------------------------------------------------------------
DROP POLICY IF EXISTS user_tasks_policy ON app_schemas.tasks;
DROP POLICY IF EXISTS task_user_policy ON app_schemas.tasks;

-- Verify policies are dropped
SELECT policyname 
FROM pg_policies 
WHERE tablename = 'tasks';

-- ----------------------------------------------------------------------------
-- Step 3: Drop tables and schema
-- ----------------------------------------------------------------------------
-- Drop tables in app_schemas
DROP TABLE IF EXISTS app_schemas.tasks CASCADE;
-- cascade to remove any dependent objects like policies if they still exist

DROP TABLE IF EXISTS app_schemas.test_table CASCADE;

-- Drop the schema
DROP SCHEMA IF EXISTS app_schemas CASCADE;

-- Verify schema is dropped
SELECT schema_name 
FROM information_schema.schemata 
WHERE schema_name = 'app_schemas';

-- ----------------------------------------------------------------------------
-- Step 4: Revoke all privileges before dropping roles/users
-- ----------------------------------------------------------------------------
-- Revoke database privileges
REVOKE ALL PRIVILEGES ON DATABASE pagila FROM regular_user;
REVOKE ALL PRIVILEGES ON DATABASE pagila FROM task_user;
REVOKE ALL PRIVILEGES ON DATABASE security_demo FROM regular_user;
REVOKE ALL PRIVILEGES ON DATABASE security_demo FROM task_user;

-- Revoke table privileges
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM regular_user;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM task_user;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM view_reader;

-- Revoke sequence privileges
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM regular_user;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM task_user;

-- Revoke schema privileges
REVOKE ALL PRIVILEGES ON SCHEMA public FROM regular_user;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM task_user;

-- Revoke view privileges
REVOKE ALL PRIVILEGES ON public.customer_list FROM view_reader;
REVOKE ALL PRIVILEGES ON public.film_list FROM view_reader;
REVOKE ALL PRIVILEGES ON public.nicer_but_slower_film_list FROM view_reader;
REVOKE ALL PRIVILEGES ON public.actor_info FROM view_reader;
REVOKE ALL PRIVILEGES ON public.sales_by_film_category FROM view_reader;
REVOKE ALL PRIVILEGES ON public.staff_list FROM view_reader;
REVOKE ALL PRIVILEGES ON public.sales_by_store FROM view_reader;
REVOKE ALL PRIVILEGES ON public.customer_basic FROM view_reader;
REVOKE ALL PRIVILEGES ON public.film_details FROM view_reader;
REVOKE ALL PRIVILEGES ON public.customer_basic_bis FROM view_reader;
-- ----------------------------------------------------------------------------
-- Step 5: Revoke role memberships
-- ----------------------------------------------------------------------------
REVOKE view_reader FROM regular_user;

-- Verify role memberships are revoked
SELECT r.rolname AS role_name, m.rolname AS member_name
FROM pg_roles r
JOIN pg_auth_members am ON r.oid = am.roleid
JOIN pg_roles m ON am.member = m.oid
WHERE m.rolname IN ('regular_user', 'task_user');

-- ----------------------------------------------------------------------------
-- Step 6: Drop users and roles
-- ----------------------------------------------------------------------------
DROP USER IF EXISTS regular_user;
DROP USER IF EXISTS task_user;
DROP ROLE IF EXISTS view_reader;

-- Verify users/roles are dropped
SELECT rolname 
FROM pg_roles 
WHERE rolname IN ('regular_user', 'task_user', 'view_reader');


-- dependencies must be removed first before dropping a role
SELECT 'REVOKE ALL PRIVILEGES ON public.' || quote_ident(viewname) || ' FROM regular_user;'
FROM pg_views
WHERE schemaname = 'public';

-- copy the output of this query and run the REVOKE statements it generates

-- drop the role after revoking all privileges 
drop role if exists regular_user; 

-- same for task_user 
SELECT 'REVOKE ALL PRIVILEGES ON public.' || quote_ident(viewname) || ' FROM task_user;'
FROM pg_views
WHERE schemaname = 'public';

-- ----------------------------------------------------------------------------
-- Step 7: Drop the security_demo database
-- ----------------------------------------------------------------------------
-- First, disconnect any connections to security_demo
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'security_demo' AND pid <> pg_backend_pid();

-- Drop the database
DROP DATABASE IF EXISTS security_demo;

-- Verify database is dropped
SELECT datname 
FROM pg_database 
WHERE datname = 'security_demo';

-- ----------------------------------------------------------------------------
-- Step 8: Clean up test data from film table (if desired)
-- ----------------------------------------------------------------------------
-- Remove the test movie we inserted during the lab
DELETE FROM film 
WHERE title = 'My Test Movie';

-- Verify deletion
SELECT film_id, title 
FROM film 
WHERE title = 'My Test Movie';

-- ----------------------------------------------------------------------------
-- Step 9: Final verification - Everything should be clean
-- ----------------------------------------------------------------------------
-- Check for any remaining users/roles created in the lab
SELECT rolname, rolcanlogin
FROM pg_roles
WHERE rolname IN ('regular_user', 'task_user', 'view_reader')
ORDER BY rolname;
-- Should return 0 rows

-- Check for any remaining schemas
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name = 'app_schemas';
-- Should return 0 rows

-- Check for any remaining databases
SELECT datname
FROM pg_database
WHERE datname = 'security_demo';
-- Should return 0 rows

-- Check active connections
SELECT usename, COUNT(*)
FROM pg_stat_activity
WHERE usename IN ('regular_user', 'task_user')
GROUP BY usename;
-- Should return 0 rows

-- ============================================================================
-- CLEANUP COMPLETE!
-- ============================================================================
-- All lab objects have been removed:
-- ✓ Users dropped (regular_user, task_user)
-- ✓ Roles dropped (view_reader)
-- ✓ Schema dropped (app_schemas)
-- ✓ Tables dropped (tasks, test_table)
-- ✓ RLS policies dropped
-- ✓ Database dropped (security_demo)
-- ✓ Test data removed from film table
--
-- Your database is now back to its original state before the lab.
-- ============================================================================