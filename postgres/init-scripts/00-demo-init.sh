#!/bin/bash

# Execute sql by postgres user in PostgreSQL.
postgres-exec() {
  [ -z "$1" ] && { echo "Usage: postgres-exec (sql)"; return; }
  psql -U "$POSTGRES_USER" -c "$1"
}

# Create user in PostgreSQL.
postgres-create-user() {
  [ -z "$2" ] && { echo "Usage: postgres-create-user (user) (password)"; return; }
  postgres-exec "CREATE USER \"$1\" WITH PASSWORD '$2'"
}

# Create new database in PostgreSQL.
postgres-create-db() {
  [ -z "$1" ] && { echo "Usage: postgres-create-db (db_name)"; return; }
  postgres-exec "CREATE DATABASE \"$1\""
}

# Grant all permissions for user for given database.
postgres-grant-db() {
  [ -z "$2" ] && { echo "Usage: postgres-grant-db (user) (database)"; return; }
  postgres-exec "GRANT ALL PRIVILEGES ON DATABASE \"$2\" TO \"$1\""
}

# Leave with error
error() {
  echo "Fatal error: $1" >&2
  exit 1
}

if [ -z "$DB_PASS" ]; then
    error "You should pass 'DB_PASS' environment variable!"
fi

if [ -z "$DB_NAME" ]; then
    error "You should pass 'DB_NAME' environment variable!"
fi

if [ -z "$DB_USER" ]; then
    error "You should pass 'DB_USER' environment variable!"
fi

postgres-create-user "$DB_USER" "$DB_PASS"
postgres-create-db "$DB_NAME"
postgres-grant-db "$DB_USER" "$DB_NAME"