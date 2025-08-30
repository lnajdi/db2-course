# VS Code PostgreSQL Extension Setup

## Extension Installation Status
The following extensions should be automatically installed in your Codespace:
- **PostgreSQL** (`ms-ossdata.vscode-postgresql`) - Main database extension
- **YAML** (`redhat.vscode-yaml`) - For YAML file editing
- **JSON** (`ms-vscode.vscode-json`) - For JSON file editing  
- **Rainbow CSV** (`mechatroner.rainbow-csv`) - For CSV file viewing

## How to Use the PostgreSQL Extension

### 1. Check Extension Installation
- Open the Extensions panel (Ctrl+Shift+X)
- Search for "PostgreSQL" to verify it's installed
- If not installed, click "Install" on the PostgreSQL extension

### 2. Connect to Database
The database connection should be automatically configured with these details:
- **Host:** postgres
- **Port:** 5432
- **Database:** pagila
- **Username:** student
- **Password:** password

### 3. Access the Database
1. **Command Palette Method:**
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
   - Type "PostgreSQL: New Query"
   - Select the Pagila database connection

2. **Explorer Panel Method:**
   - Look for "PostgreSQL Explorer" in the left sidebar
   - Expand the connection to browse tables

3. **Manual Connection:**
   - If automatic connection doesn't work, click the PostgreSQL icon in the sidebar
   - Add a new connection with the details above

### 4. Test the Connection
Try running this query to test:
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

### 5. Explore the Pagila Database
The Pagila database includes these main tables:
- `customer` - Customer information
- `film` - Movie catalog
- `actor` - Actor information
- `rental` - Rental transactions
- `payment` - Payment records

## Troubleshooting

### Extensions Not Appearing
1. **Rebuild Container:** 
   - Press `Ctrl+Shift+P`
   - Type "Codespaces: Rebuild Container"
   - Wait for rebuild to complete

2. **Manual Installation:**
   - Open Extensions panel
   - Search for "PostgreSQL"
   - Install manually if needed

### Connection Issues
1. **Check PostgreSQL Status:**
   ```bash
   pg_isready -h postgres -p 5432 -U student
   ```

2. **Test Connection:**
   ```bash
   PGPASSWORD=password psql -h postgres -U student -d pagila -c "SELECT version();"
   ```

### Database Not Loading
If tables are missing, restart the PostgreSQL container:
```bash
docker-compose restart postgres
```

## Lab Exercises
Navigate to the `labs/` directory to find database exercises for each topic.
