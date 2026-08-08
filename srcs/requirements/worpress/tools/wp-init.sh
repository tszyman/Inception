#!/bin/bash
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password.txt);
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password.txt);

cd /var/www/html

echo "Waiting for MariaDB..."

until mariadb-admin ping -h"mariadb" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
	sleep 2
done

echo "MariaDB is ready."

if [ ! -f wp-config.php ]; then
	echo "Downloading and configuring WordPress..."
	wp core download --allow-root

	wp config create \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${MYSQL_PASSWORD}" \
		--dbhost="mariadb:3306: \
		--allow-root

	echo "Installing WordPress core..."
	wp core install \
		--url="https://${DOMAIN_NAME} \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password= "${WP_ADMIN_PASSWORD}" \
		--admin_email= "${WP_ADMIN_EMAIL}" \
		--skip_email \
		--allow_root

	echo "Creating second WordPress user..."
	wp user create \
		"${WP_USER}" \
		"${WP_USER_EMAIL} \
		--role=author \
		--user_pass="UserPass42!" \
		--allow_root
	
	chown -R www-data:www-data /var/www/html
	echo "WordPress initialization complete."
fi

exec php-fpm8.2 -F
