#!/bin/bash

# Setup script for PostgreSQL Database Lab Environment
echo "🚀 Setting up PostgreSQL Database Lab Environment..."
echo "📂 Current directory: $(pwd)"
echo "📂 Workspace contents:"
ls -la /workspace/
echo "📂 .devcontainer contents:"
ls -la /workspace/.devcontainer/ || echo "❌ .devcontainer directory not found"

# Install PostgreSQL client tools
echo "📦 Installing PostgreSQL client tools..."
sudo apt-get update && sudo apt-get install -y postgresql-client

# Configure VS Code settings for PostgreSQL
echo "⚙️ Configuring VS Code settings..."
mkdir -p /workspace/.vscode
cat > /workspace/.vscode/settings.json << 'EOF'
{
  "postgresql.connections": [
    {
      "host": "postgres",
      "hostaddr": "postgres", 
      "port": "5432",
      "dbname": "pagila",
      "username": "student",
      "password": "password",
      "connectionName": "Pagila Database"
    }
  ],
  "files.associations": {
    "*.sql": "sql"
  }
}
EOF

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
until pg_isready -h postgres -p 5432 -U student; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

echo "✅ PostgreSQL is ready!"

# The Pagila database should be automatically loaded by docker-entrypoint-initdb.d
# Check if the database is properly loaded
echo "🔍 Verifying database installation..."
TABLE_COUNT=$(PGPASSWORD=password psql -h postgres -U student -d pagila -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null || echo "0")

if [ "$TABLE_COUNT" -gt 10 ]; then
    echo "✅ Database setup complete! Found $TABLE_COUNT tables."
else
    echo "⚠️  Database tables not found. This is normal if running for the first time."
    echo "   The Pagila database will be loaded automatically on first PostgreSQL startup."
fi

echo "🎉 Environment is ready for database labs!"
echo ""
echo "📋 Available Labs:"
echo "- lab01-views: Database views and virtual tables"
echo "- lab02-indexes: Query optimization and indexing"
echo "- lab03-window-functions: Advanced analytical queries"
echo "- lab04-tcl: Transaction Control Language"
echo "- lab05-intro-plpgsql: Introduction to PL/pgSQL"
echo "- lab06-stored-procedures: Functions and procedures"
echo "- lab07-cursors: Cursor operations and processing"
echo "- lab08-triggers: Database triggers and automation"
echo "- lab09-admin-basics: PostgreSQL administration basics"
echo "- lab10-admin-tasks: Advanced administration tasks"
echo ""
echo "🔗 Database Connection Details:"
echo "Host: postgres | Port: 5432 | Database: pagila"
echo "Username: student | Password: password"
echo ""
echo "🧪 Running connection test..."
if [ -f "/workspace/.devcontainer/test-connection.sh" ]; then
    chmod +x /workspace/.devcontainer/test-connection.sh
    bash /workspace/.devcontainer/test-connection.sh
else
    echo "⚠️  Test connection script not found, skipping test"
fi
