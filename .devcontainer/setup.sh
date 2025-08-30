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
  "pgsql.connections": [
    {
      "id": "pagila-db",
      "profileName": "Pagila Database",
      "server": "postgres",
      "port": "5432",
      "database": "pagila",
      "user": "student",
      "password": "password",
      "groupId": "default"
    }
  ],
  "files.associations": {
    "*.sql": "sql"
  }
}
EOF

# Create a simple connection test script
echo "📝 Creating database connection helper script..."
cat > /workspace/test-db-connection.sh << 'EOF'
#!/bin/bash
echo "🔍 Testing PostgreSQL connection..."
PGPASSWORD=password psql -h postgres -U student -d pagila -c "
SELECT 
    'Connection successful!' as status,
    version() as postgresql_version,
    current_database() as database_name,
    current_user as username;
"
EOF
chmod +x /workspace/test-db-connection.sh

echo "📋 VS Code Extension Information:"
echo "Main PostgreSQL extension ID: ms-ossdata.vscode-pgsql"
echo "If extensions don't auto-install, manually install from Extensions marketplace"

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

echo ""
echo "📋 VS Code Extension Information:"
echo "Main PostgreSQL extension ID: ms-ossdata.vscode-pgsql"
echo "✅ Connection configured: Pagila Database (postgres:5432/pagila)"
echo "💡 If connection doesn't appear automatically, try reloading VS Code window"
echo "   Use Ctrl+Shift+P -> 'Developer: Reload Window'"
