#!/bin/bash

# Execute sql by root in MariaDB.
mariadb-exec() {
  [ -z "$1" ] && { echo "Usage: mariadb-exec (sql)"; return; }
  mariadb -u root -p"$MARIADB_ROOT_PASSWORD" -e "$1"
}

# Create user in MariaDB.
mariadb-create-user() {
  [ -z "$2" ] && { echo "Usage: mariadb-create-user (user) (password)"; return; }
  mariadb-exec "CREATE USER '$1'@'%' IDENTIFIED BY '$2'"
}

# Create new database in MariaDB.
mariadb-create-db() {
  [ -z "$1" ] && { echo "Usage: mariadb-create-db (db_name)"; return; }
  mariadb-exec "CREATE DATABASE IF NOT EXISTS $1"
}

# Grant all permissions for user for given database.
mariadb-grant-db() {
  [ -z "$2" ] && { echo "Usage: mariadb-grand-db (user) (database)"; return; }
  mariadb-exec "GRANT ALL ON $2.* TO '$1'@'%'"
  mariadb-exec "FLUSH PRIVILEGES"
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

mariadb-create-user "$DB_USER" "$DB_PASS"
mariadb-create-db "$DB_NAME"
mariadb-grant-db "$DB_USER" "$DB_NAME"
