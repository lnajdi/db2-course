# PostgreSQL Database Administration Basics Quiz - Structured Content

## Quiz Overview
- **Topic**: PostgreSQL Database Administration and Security
- **Question Count**: 20 questions
- **Difficulty Distribution**: 7 Easy, 8 Medium, 5 Hard
- **Coverage**: User management, security, monitoring, and administration fundamentals

---

## Questions

### 1. What is the difference between a PostgreSQL user and a role? (Easy)
**Question**: What is the primary difference between a USER and a ROLE in PostgreSQL?

**Options**:
A) Users can own objects, roles cannot
B) Users are a type of role that has LOGIN privilege by default
C) Roles are more secure than users
D) Users can be granted to other users, roles cannot

**Correct Answer**: B) Users are a type of role that has LOGIN privilege by default

**Hint**: Think about the relationship between users and roles in terms of login capabilities.

**Explanation**: In PostgreSQL, a USER is essentially a ROLE with the LOGIN privilege. Both are stored in pg_roles, but CREATE USER automatically grants LOGIN privilege while CREATE ROLE does not.

---

### 2. Which command is used to view all roles in a PostgreSQL database? (Easy)
**Question**: How can you display all roles and their attributes in PostgreSQL?

**Options**:
A) SHOW ROLES;
B) SELECT * FROM pg_users;
C) SELECT * FROM pg_roles;
D) LIST ROLES;

**Correct Answer**: C) SELECT * FROM pg_roles;

**Hint**: Think about the system catalog that stores role information.

**Explanation**: The pg_roles system view contains information about all database roles including their privileges like rolsuper, rolcreatedb, and rolcanlogin.

---

### 3. A role can be granted to another role, creating a hierarchy. (Easy)
**Question**: True or False: In PostgreSQL, roles can be granted to other roles to create privilege inheritance.

**Options**:
A) True
B) False

**Correct Answer**: A) True

**Hint**: Consider the concept of role membership and inheritance in PostgreSQL security.

**Explanation**: True. PostgreSQL supports role hierarchy where roles can be granted to other roles, allowing privilege inheritance. This enables flexible access control patterns.

---

### 4. Which privilege level allows a user to connect to a database? (Medium)
**Question**: What database-level privilege must be granted for a user to connect to a specific database?

**Options**:
A) SELECT privilege
B) USAGE privilege
C) CONNECT privilege
D) LOGIN privilege

**Correct Answer**: C) CONNECT privilege

**Hint**: Think about the specific privilege needed just to establish a database connection.

**Explanation**: CONNECT privilege on a database allows users to connect to it. LOGIN is a role attribute, but CONNECT is the database-level privilege required for connection.

---

### 5. What does Row-Level Security (RLS) control? (Medium)
**Question**: What aspect of data access does Row-Level Security (RLS) manage?

**Options**:
A) Which columns a user can see in a table
B) Which tables a user can access in a schema
C) Which rows a user can see or modify in a table
D) Which functions a user can execute

**Correct Answer**: C) Which rows a user can see or modify in a table

**Hint**: Think about the granularity level that RLS operates on.

**Explanation**: RLS provides fine-grained access control at the row level, allowing policies to determine which specific rows a user can access based on conditions.

---

### 6. Which system view shows currently active database connections? (Medium)
**Question**: Which PostgreSQL system view displays information about active database connections?

**Options**:
A) pg_connections
B) pg_stat_activity
C) pg_sessions
D) pg_active_users

**Correct Answer**: B) pg_stat_activity

**Hint**: Think about the statistics-related system views for monitoring activity.

**Explanation**: pg_stat_activity provides information about current database activity, including active connections, running queries, and session details.

---

### 7. What happens when a role is dropped that owns database objects? (Hard)
**Question**: What occurs by default when you try to DROP a role that owns database objects?

**Options**:
A) The objects are automatically transferred to the postgres superuser
B) The objects are deleted along with the role
C) PostgreSQL prevents the role from being dropped and raises an error
D) The objects become unowned and can be accessed by anyone

**Correct Answer**: C) PostgreSQL prevents the role from being dropped and raises an error

**Hint**: Consider PostgreSQL's approach to preventing orphaned objects.

**Explanation**: PostgreSQL prevents dropping roles that own objects to avoid orphaned objects. You must first reassign or drop the owned objects, or use CASCADE to force deletion.

---

### 8. Which command enables Row-Level Security on a table? (Medium)
**Question**: How do you enable Row-Level Security on a specific table?

**Options**:
A) CREATE POLICY ON table_name;
B) ALTER TABLE table_name ENABLE ROW SECURITY;
C) ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;
D) SET row_security = on FOR table_name;

**Correct Answer**: C) ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;

**Hint**: Think about the specific ALTER TABLE syntax for enabling RLS.

**Explanation**: The correct syntax is ALTER TABLE table_name ENABLE ROW LEVEL SECURITY, which must be done before creating policies on the table.

---

### 9. Superusers bypass all Row-Level Security policies by default. (Easy)
**Question**: True or False: Superusers automatically bypass all Row-Level Security policies.

**Options**:
A) True
B) False

**Correct Answer**: A) True

**Hint**: Consider the privileges that superuser status provides.

**Explanation**: True. Superusers bypass RLS policies by default unless explicitly forced to follow them with ALTER TABLE table_name FORCE ROW LEVEL SECURITY.

---

### 10. What is the purpose of ALTER DEFAULT PRIVILEGES? (Medium)
**Question**: What does the ALTER DEFAULT PRIVILEGES command accomplish?

**Options**:
A) Changes privileges on all existing objects
B) Sets privileges that will be automatically granted on future objects
C) Removes all privileges from a role
D) Creates a template for role creation

**Correct Answer**: B) Sets privileges that will be automatically granted on future objects

**Hint**: Think about automating privilege assignment for objects created in the future.

**Explanation**: ALTER DEFAULT PRIVILEGES configures privileges that are automatically granted on objects created by specific roles in specific schemas, reducing manual privilege management.

---

### 11. Which role attribute allows a user to create other roles? (Medium)
**Question**: What role attribute grants the ability to create and manage other database roles?

**Options**:
A) CREATEROLE
B) ROLEADMIN
C) CREATEUSER
D) ADMIN

**Correct Answer**: A) CREATEROLE

**Hint**: Think about the specific attribute name for role creation privileges.

**Explanation**: CREATEROLE attribute allows a role to create, alter, and drop other roles, but not superuser roles unless the role is itself a superuser.

---

### 12. What is the security risk of SECURITY DEFINER functions? (Hard)
**Question**: What is the primary security concern with SECURITY DEFINER functions?

**Options**:
A) They run slower than SECURITY INVOKER functions
B) They execute with the privileges of the function creator, potentially elevating access
C) They cannot access system catalogs
D) They are deprecated and should not be used

**Correct Answer**: B) They execute with the privileges of the function creator, potentially elevating access

**Hint**: Think about whose privileges are used when the function executes.

**Explanation**: SECURITY DEFINER functions run with the privileges of the function owner, not the caller, which can lead to privilege escalation if not carefully managed.

---

### 13. Column-level privileges can be granted on individual columns of a table. (Easy)
**Question**: True or False: PostgreSQL supports granting privileges on specific columns within a table.

**Options**:
A) True
B) False

**Correct Answer**: A) True

**Hint**: Consider the granularity of PostgreSQL's privilege system.

**Explanation**: True. PostgreSQL supports column-level privileges, allowing you to grant SELECT, INSERT, or UPDATE privileges on specific columns rather than the entire table.

---

### 14. In this RLS policy, what determines which rows a user can see?

```sql
CREATE POLICY user_data_policy ON customer_data
FOR SELECT TO app_users
USING (user_id = current_user);
```

**Question**: Based on this RLS policy, which rows can members of app_users role see?

**Options**:
A) All rows in the customer_data table
B) Only rows where user_id matches their username
C) Only the first 10 rows in the table
D) No rows (the policy denies all access)

**Correct Answer**: B) Only rows where user_id matches their username

**Hint**: Look at the USING clause condition in the policy.

**Explanation**: The USING clause specifies that users can only see rows where the user_id column matches their current username (current_user).

---

### 15. What is the primary purpose of the VALID UNTIL clause when creating users? (Hard)
**Question**: What does the VALID UNTIL clause accomplish when creating a PostgreSQL user?

**Options**:
A) Sets the maximum number of concurrent connections
B) Sets a password expiration date for the user account
C) Sets the maximum time a session can remain active
D) Sets the date when the user must change their password

**Correct Answer**: B) Sets a password expiration date for the user account

**Hint**: Think about account lifecycle management and security policies.

**Explanation**: VALID UNTIL sets an expiration date for the user account. After this date, the user cannot log in until their account is renewed by an administrator.

---

### 16. Which command shows table privileges for a specific user? (Medium)
**Question**: How can you view what table privileges have been granted to a specific user?

**Options**:
A) SELECT * FROM pg_user_privileges WHERE user = 'username';
B) SELECT * FROM information_schema.table_privileges WHERE grantee = 'username';
C) SHOW PRIVILEGES FOR username;
D) SELECT * FROM pg_privileges WHERE username = 'user';

**Correct Answer**: B) SELECT * FROM information_schema.table_privileges WHERE grantee = 'username';

**Hint**: Think about the information_schema views that provide privilege information.

**Explanation**: The information_schema.table_privileges view contains information about table-level privileges granted to users and roles.

---

### 17. PostgreSQL roles inherit privileges from all roles granted to them by default. (Easy)
**Question**: True or False: When a role is granted to another role, the receiving role automatically inherits all privileges.

**Options**:
A) True
B) False

**Correct Answer**: A) True

**Hint**: Consider the default behavior of role membership in PostgreSQL.

**Explanation**: True. By default, roles inherit privileges from roles granted to them. This can be controlled with the NOINHERIT role attribute or WITH INHERIT/NOINHERIT clause.

---

### 18. What is the purpose of connection limits (CONNECTION LIMIT) for users? (Medium)
**Question**: What does setting a CONNECTION LIMIT achieve when creating a user?

**Options**:
A) Limits how long each connection can stay active
B) Controls the maximum number of concurrent connections for that user
C) Sets the maximum number of databases the user can connect to
D) Limits the amount of data the user can retrieve per connection

**Correct Answer**: B) Controls the maximum number of concurrent connections for that user

**Hint**: Think about resource management and preventing connection exhaustion.

**Explanation**: CONNECTION LIMIT restricts how many simultaneous database connections a user can have, helping prevent resource exhaustion and managing concurrent access.

---

### 19. Which approach provides the most secure privilege management strategy? (Hard)
**Question**: What is considered the best practice for PostgreSQL privilege management?

**Options**:
A) Grant all users superuser privileges for simplicity
B) Use the principle of least privilege - grant only necessary permissions
C) Grant all privileges to roles and restrict only through application logic
D) Use only database-level privileges and avoid object-level controls

**Correct Answer**: B) Use the principle of least privilege - grant only necessary permissions

**Hint**: Think about fundamental security principles and risk minimization.

**Explanation**: The principle of least privilege minimizes security risk by granting users only the minimum permissions necessary to perform their required tasks.

---

### 20. What information does pg_stat_activity provide for database monitoring? (Medium)
**Question**: Which type of information can you obtain from the pg_stat_activity system view?

**Options**:
A) Historical query performance over time
B) Database size and growth statistics
C) Current active connections and running queries
D) User login and logout events

**Correct Answer**: C) Current active connections and running queries

**Hint**: Think about real-time activity monitoring capabilities.

**Explanation**: pg_stat_activity provides real-time information about database activity including active connections, current queries, session state, and connection details for monitoring purposes.

---

## Quiz Statistics
- **Total Questions**: 20
- **Easy Questions**: 7 (35%)
- **Medium Questions**: 8 (40%)  
- **Hard Questions**: 5 (25%)

## Topics Covered
1. **User and Role Management**: Users vs roles, role creation, and hierarchy
2. **Privilege System**: Database, schema, table, and column-level privileges
3. **Row-Level Security**: RLS policies, implementation, and administration  
4. **Security Administration**: Role attributes, authentication, and access control
5. **Monitoring and Auditing**: System views, connection tracking, and security monitoring
6. **Best Practices**: Security principles, privilege management, and compliance
7. **Administrative Commands**: Essential SQL commands for database administration
8. **Security Features**: Advanced security features and configuration options
