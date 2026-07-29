# Setup and Connection Guide

This guide will walk you through setting up the PostgreSQL database using Docker and connecting to it using `psql`.

## Prerequisites

*   Docker and Docker Compose must be installed on your system.
*   `psql` client must be installed on your system.

## 1. Start the Database

Navigate to the `demos/setup` directory in your terminal and run the following command to start the PostgreSQL container:

```bash
docker-compose up -d
```

This command will start a PostgreSQL container in detached mode. The database will be named `pagila`, and the schema and data from the `data/pagila` directory will be automatically imported.

## 2. Connect to the Database

Once the container is running, you can connect to the `pagila` database using `psql` with the following command:

```bash
psql -h localhost -p 5432 -U postgres -d pagila
```

You will be prompted for the password. The password is `password`, as defined in the `docker-compose.yml` file.

## 3. Stop the Database

To stop the PostgreSQL container, run the following command from the `demos/setup` directory:

```bash
docker-compose down
```
