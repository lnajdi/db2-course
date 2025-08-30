#!/bin/bash

# Test database connectivity and setup
echo "🧪 Testing database connection..."

# Test basic connectivity
if PGPASSWORD=password psql -h postgres -U student -d pagila -c "SELECT version();" > /dev/null 2>&1; then
    echo "✅ Database connection successful"
else
    echo "❌ Database connection failed"
    exit 1
fi

# Test if Pagila tables exist
TABLE_COUNT=$(PGPASSWORD=password psql -h postgres -U student -d pagila -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' ')

if [ "$TABLE_COUNT" -gt 10 ]; then
    echo "✅ Pagila database loaded successfully ($TABLE_COUNT tables found)"
else
    echo "⚠️  Pagila database not fully loaded ($TABLE_COUNT tables found)"
fi

# Test a sample query
echo "🔍 Testing sample query..."
CUSTOMER_COUNT=$(PGPASSWORD=password psql -h postgres -U student -d pagila -t -c "SELECT COUNT(*) FROM customer;" 2>/dev/null | tr -d ' ')

if [ "$CUSTOMER_COUNT" -gt 0 ]; then
    echo "✅ Sample query successful ($CUSTOMER_COUNT customers found)"
else
    echo "❌ Sample query failed"
fi

echo "🎉 Database validation complete!"
