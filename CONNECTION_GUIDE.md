# PostgreSQL Database Connection Guide

This guide explains how to connect to the PostgreSQL database running in Docker for the db2-course lab environment.

## Database Connection Details

- **Host**: `localhost` (or `127.0.0.1`)
- **Port**: `5432`
- **Database**: `pagila`
- **Username**: `student`
- **Password**: `password`

## Prerequisites

1. Make sure Docker is running on your system
2. Navigate to the project directory: `db2-course`
3. Start the PostgreSQL container

## Starting the PostgreSQL Container

### Option 1: Using Docker Compose (Recommended)
```bash
# Navigate to the project directory
cd db2-course

# Start the PostgreSQL container
docker compose up -d

# Check if the container is running
docker compose ps
```

### Option 2: Using Docker directly
```bash
# Start the container (if using docker compose is not available)
docker run -d \
  --name postgres-lab \
  -e POSTGRES_DB=pagila \
  -e POSTGRES_USER=student \
  -e POSTGRES_PASSWORD=password \
  -p 5432:5432 \
  -v postgres_data:/var/lib/postgresql/data \
  postgres:15
```

## Connection Methods

### 1. VS Code PostgreSQL Extension (Recommended for Codespaces)

If you're using the VS Code PostgreSQL extension:

1. Open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`)
2. Type "PostgreSQL: New Connection"
3. Enter the connection details:
   - **Server**: `localhost`
   - **Port**: `5432`
   - **Database**: `pagila`
   - **Username**: `student`
   - **Password**: `password`

Or use the preconfigured connection in the VS Code settings (already set up in devcontainer.json).

### 2. Command Line (psql)

#### From Host Machine
```bash
# Connect using psql (if psql is installed on your host)
psql -h localhost -p 5432 -U student -d pagila

# Or with password inline (not recommended for production)
PGPASSWORD=password psql -h localhost -p 5432 -U student -d pagila
```

#### From Docker Container
```bash
# Execute psql inside the running container
docker exec -it postgres-lab psql -U student -d pagila

# Or using docker compose
docker compose exec postgres psql -U student -d pagila
```

### 3. Database GUI Tools

#### pgAdmin
- **Host**: `localhost`
- **Port**: `5432`
- **Database**: `pagila`
- **Username**: `student`
- **Password**: `password`

#### DBeaver
1. Create new connection → PostgreSQL
2. **Server Host**: `localhost`
3. **Port**: `5432`
4. **Database**: `pagila`
5. **Username**: `student`
6. **Password**: `password`

#### TablePlus
- **Host**: `localhost`
- **Port**: `5432`
- **User**: `student`
- **Password**: `password`
- **Database**: `pagila`

### 4. Programming Languages

#### Python (psycopg2)
```python
import psycopg2

# Connection parameters
conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="pagila",
    user="student",
    password="password"
)

cursor = conn.cursor()
cursor.execute("SELECT version();")
print(cursor.fetchone())
conn.close()
```

#### Node.js (pg)
```javascript
const { Client } = require('pg');

const client = new Client({
  host: 'localhost',
  port: 5432,
  database: 'pagila',
  user: 'student',
  password: 'password',
});

client.connect();

client.query('SELECT NOW()', (err, res) => {
  console.log(err ? err.stack : res.rows[0]);
  client.end();
});
```

#### Java (JDBC)
```java
import java.sql.*;

public class PostgreSQLConnection {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://localhost:5432/pagila";
        String username = "student";
        String password = "password";
        
        try {
            Connection connection = DriverManager.getConnection(url, username, password);
            System.out.println("Connected to PostgreSQL!");
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```

## Connection String Examples

### Standard Connection String
```
postgresql://student:password@localhost:5432/pagila
```

### JDBC URL
```
jdbc:postgresql://localhost:5432/pagila
```

### SQLAlchemy (Python)
```python
from sqlalchemy import create_engine

engine = create_engine('postgresql://student:password@localhost:5432/pagila')
```

## Troubleshooting

### Container Not Running
```bash
# Check if container is running
docker ps

# Start the container if it's stopped
docker compose up -d

# Check container logs
docker compose logs postgres
```

### Connection Refused
1. Ensure the container is running: `docker compose ps`
2. Check if port 5432 is available: `netstat -an | grep 5432`
3. Verify Docker is running
4. Check firewall settings (Windows/macOS)

### Database Not Found
```bash
# Connect to default postgres database first
psql -h localhost -p 5432 -U student -d postgres

# Then list all databases
\l

# If pagila doesn't exist, check if the initialization scripts ran
docker compose logs postgres | grep -i pagila
```

### Permission Denied
- Ensure you're using the correct username: `student`
- Ensure you're using the correct password: `password`
- Check if the container finished initializing

### Container Won't Start
```bash
# Check for port conflicts
docker compose down
netstat -an | grep 5432

# Remove existing containers and volumes (⚠️  This will delete data)
docker compose down -v
docker compose up -d
```

## Verifying the Connection

Once connected, you can verify the setup by running:

```sql
-- Check PostgreSQL version
SELECT version();

-- List all tables in the pagila database
\dt

-- Or using SQL
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- Check sample data
SELECT COUNT(*) FROM film;
SELECT COUNT(*) FROM actor;
```

## Lab Environment

The Pagila database includes:
- **16 tables** with sample movie rental data
- **Films**: Movie information, categories, ratings
- **Actors**: Actor information and film relationships
- **Customers**: Customer data and rental history
- **Stores**: Store and staff information
- **Inventory**: Film inventory and rental tracking

This database is perfect for learning SQL queries, joins, aggregations, and database administration tasks.

## Security Note

⚠️ **Important**: These credentials are for learning purposes only. Never use simple passwords like "password" in production environments.





# chacj after docke 
Main Steps Summary
1. Read Docker Config 📖
Analyzed docker-compose.yml
Identified PostgreSQL 15 + Pagila database setup
2. Navigate to Project 📁
cd "c:\Enseignement\New folder\db2-course"
3. Launch Docker Compose 🚀
docker-compose up -d
✅ Started postgres-lab container
4. Verify Status ✅
docker-compose ps
✅ Container running and healthy
5. Test Connection 🔌
docker exec -it postgres-lab psql -U student -d pagila
✅ Connected to database
🎉 Result:
Database environment fully operational!

PostgreSQL 15 running on localhost:5432
Pagila database ready for lab exercises