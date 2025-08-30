# Development Container Configuration

This directory contains the configuration for the GitHub Codespaces development environment.

## Files

- `devcontainer.json` - Main configuration file for the dev container
- `Dockerfile` - Custom image definition with PostgreSQL client tools
- `setup.sh` - Post-creation setup script
- `README.md` - This file

## How it works

1. **Docker Compose**: The setup uses `docker-compose.yml` to orchestrate two services:
   - `postgres`: PostgreSQL database with the Pagila sample database
   - `devcontainer`: Ubuntu-based development environment with PostgreSQL client tools

2. **Database Connection**: The development container connects to the PostgreSQL service using the hostname `postgres` (Docker Compose networking)

3. **Initialization**: The PostgreSQL container automatically loads the Pagila sample database from the `data/pagila/` directory

## Configuration Details

- **Database**: PostgreSQL 15 with Pagila sample database
- **Credentials**: 
  - Host: `postgres`
  - Port: `5432`
  - Database: `pagila`
  - Username: `student`
  - Password: `password`

## Troubleshooting

If the Codespace fails to start:
1. Check that all files in this directory are properly formatted
2. Verify the Docker Compose file syntax
3. Ensure the PostgreSQL client tools are properly installed in the Dockerfile
