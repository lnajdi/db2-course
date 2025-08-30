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
mkdir -p /workspace/labs/{lab01-views,lab02-materialized-views,lab03-indexes,lab04-tcl,lab05-window-functions,lab06-ctes,lab07-stored-procedures,lab08-intro-plpgsql,lab09-cursors,lab10-triggers,lab11-admin-basics}

# Create placeholder solution files for each lab
for lab in lab01-views lab02-materialized-views lab03-indexes lab04-tcl lab05-window-functions lab06-ctes lab07-stored-procedures lab08-intro-plpgsql lab09-cursors lab10-triggers lab11-admin-basics; do
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
    echo "- lab08-intro-plpgsql: Introduction to PL/pgSQL"
    echo "- lab09-cursors: Cursor operations and processing"
    echo "- lab10-triggers: Database triggers and automation"
    echo "- lab11-admin-basics: PostgreSQL administration basics"
    echo ""
    echo "🔗 Database Connection Details:"
    echo "Host: localhost | Port: 5432 | Database: pagila"
    echo "Username: student | Password: password"
else
    echo "❌ Database setup may have failed. Please check the logs."
fi
