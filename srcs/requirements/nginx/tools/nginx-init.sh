#!/bin/bash
set -e

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
	echo "Generating SSL sefl-signed certificate..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/inception.key \
		-out /etc/nginx/ssl/inception.crt \
		-subj "/C=PL/ST=Mazowieckie/L=Warsaw/O=42Warsaw/OU=Student/CN=${DOMAIN_NAME}"
fi

exec nginx -g "daemon off;"