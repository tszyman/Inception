#!/bin/bash
set -e

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	echo "Initializing MariaDB database..."

	mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

	mysql_safe --datadir='/var/lib/mysql' &
	pid="$!"

	until mysqladmin ping --silent; do
		sleep 1
	done

	mysql -e "CREATE DATABASE IF NOT EXIST \`${MYSQL_DATABASE}\`;"
	mysql -e "CREATE USER IF NOT EXIST \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
	mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
	mysql -e "FLUSH PRIVILEGES;"

	mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
	wait "$pid"
	echo "MariaDB setup complete."
fi

exec mariadb --user=mysql --console