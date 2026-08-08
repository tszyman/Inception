#!/bin/bash
set -e

# Ensure runtime directories exist with correct permissions
mkdir -p /var/run/mysqld /var/lib/mysql
chown -R mysql:mysql /var/run/mysqld /var/lib/mysql
chmod 777 /var/run/mysqld

# Read secrets
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "Initializing MariaDB system tables..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    echo "Configuring database and users via bootstrap..."
    mariadbd --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    echo "MariaDB initialization complete!"
fi

echo "Starting MariaDB daemon..."
exec mariadbd --user=mysql --console