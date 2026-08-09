FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	php8.2-fpm \
	php8.2-mysql \
	php8.2-curl \
	php8.2-gd \
	php8.2-mbstring \
	php8.2-xml \
	php8.2-zip \
	mariadb-client \
	curl \
	wget \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/html /run/php && \
	chown -R www-data:www-data /var/www/html /run/php

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/wp-init.sh /usr/local/bin/wp-init.sh
RUN chmod +x /usr/local/bin/wp-init.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp-init.sh"]