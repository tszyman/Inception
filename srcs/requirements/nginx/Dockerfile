FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	nginx \
	openssl \
	&& rm -rf /var/lib/apt/lists/*

	COPY conf/nginx.conf /etc/nginx/nginx.conf
	COPY tools/nginx-init.sh /usr/local/bin/nginx-init.sh
	RUN chmod +x /usr/local/bin/nginx-init.sh

	EXPOSE 443

	ENTRYPOINT ["/usr/local/bin/nginx-init.sh"]