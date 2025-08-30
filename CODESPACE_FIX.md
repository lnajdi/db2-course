# GitHub Codespaces Fix

## Problem
The original setup was trying to use the PostgreSQL container as the development container, which caused the error:
```
Failed to create container.
Error: Command failed: docker compose --project-name db2-course
```

## Solution
The configuration has been updated to use a proper two-container setup:

1. **PostgreSQL Container** (`postgres` service): Runs the database
2. **Development Container** (`devcontainer` service): Provides the development environment

## Changes Made

### 1. Updated `.devcontainer/devcontainer.json`
- Changed `"service": "postgres"` to `"service": "devcontainer"`
- Updated connection host from `localhost` to `postgres`
- Set proper `remoteUser` to `vscode`

### 2. Updated `docker-compose.yml`
- Added new `devcontainer` service with proper development tools
- Used custom Dockerfile for better control over the environment
- Added service dependency to ensure PostgreSQL starts first

### 3. Created `.devcontainer/Dockerfile`
- Based on Microsoft's devcontainer base image
- Includes PostgreSQL client tools
- Proper user setup for VS Code

### 4. Updated `.devcontainer/setup.sh`
- Changed connection host from `localhost` to `postgres`
- Added package installation for PostgreSQL client tools
- Added connection validation test

### 5. Added validation script
- `.devcontainer/test-connection.sh` to verify database connectivity

## How to Test
1. Commit these changes to your repository
2. Create a new GitHub Codespace
3. The setup should now work without errors

## Database Connection
Once the Codespace is running, connect to PostgreSQL using:
- Host: `postgres`
- Port: `5432`
- Database: `pagila`
- Username: `student`
- Password: `password`
