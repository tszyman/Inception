# User Documentation

## Services provided

The Inception infrastructure provides a complete WordPress web application stack composed of three isolated services:

1. **NGINX Reverse Proxy:** Serves HTTPS traffic securely over port `443` using TLS v1.2/v1.3.
2. **WordPress + PHP-FPM:** Interprets PHP code and delivers the website content.
3. **MariaDB Database:** Manages relational data storage for WordPress.

---

## Starting and Stopping the Project

Run the following commands from the root directory of the repository:

- **Start all services:**

  ```bash
  make
  ```

- **Stop all services:**

  ```bash
  make stop
  ```

- **Restart services:**

  ```bash
  make re
  ```

Other useful make commands:

- [ ]  `make down` stops containers.
- [ ]  `make up` starts containers.
- [ ]  `make clean` stops the stack safely.
- [ ]  `make fclean` removes containers, volumes, and images if required.

---

## Accessing the Website & Admin Panel

- **Main Website:** Open your web browser and navigate to `https://tszymans.42.fr`
- **WordPress Admin Dashboard:** Open `https://tszymans.42.fr/wp-admin`

*Note: Since the website uses a self-signed SSL certificate, your browser will display a security warning.*

---

## Managing Credentials

- **Configuration Variables:** Located in `srcs/.env` (Database name, Domain, Usernames).
- **Passwords & Secrets:** Securely stored in the `secrets/` directory:
  - `secrets/db_root_password.txt`: Database root password.
  - `secrets/db_password.txt`: WordPress database user password.
  - `secrets/wp_admin_password.txt`: WordPress admin user password.

---

## Checking Service Status

To verify that all containers are running properly, execute:

```bash
docker compose -f srcs/docker-compose.yml ps
```

All services (`nginx`, `wordpress`, `mariadb`) should display a status of `Up`.

---

## Troubleshooting

### MariaDB Testing

#### Local Socket

```bash
docker exec -it mariadb mariadb -u root -p
# Enter password from secrets/db_root_password.txt
```

#### TCP (setting port 3306 and localhost)

```bash
docker exec -it mariadb mariadb -h 127.0.0.1 -u root -p
```

### MariaDB-related Commands To Know

```bash
make
make down
make re
docker logs mariadb
docker ps
docker images
docker volume ls
docker network ls
docker compose -f srcs/docker-compose.yml config
```

### MariaDB Tests

- [x]  MariaDB container builds successfully.
- [x]  MariaDB container starts successfully.
- [x]  Database is created. `SHOW DATABASES;`
- [x]  User is created.
- [x]  Passwords are not hardcoded.
- [x]  Data persists after container restart.
- [x]  Container uses named volume.
- [x]  Container does not use bind mount for database data.

### Wordpress testing

#### Wordpress-related Commands To Know

```bash
docker compose -f srcs/docker-compose.yml build wordpress
docker compose -f srcs/docker-compose.yml up wordpress
docker logs wordpress
docker exec -it wordpress sh
```

#### Wordpress Tests

- [x]  WordPress image builds.
- [x]  WordPress container starts.
- [x]  WordPress connects to MariaDB.
- [x]  WordPress database tables are created.
- [x]  WordPress files are stored in the named volume.
- [x]  WordPress has two users.
- [x]  Administrator username is valid.
- [x]  No NGINX exists inside WordPress container.

### NGINX Testing

#### NGINX-related Commands To Know

```bash
docker compose -f srcs/docker-compose.yml build nginx
docker compose -f srcs/docker-compose.yml up nginx
docker logs nginx
curl -k https://tszymans.42.fr
```

#### NGINX Tests

- [x]  NGINX image builds.
- [x]  NGINX container starts.
- [x]  Only port `443` is exposed.
- [x]  TLS works.
- [x]  TLSv1.2 or TLSv1.3 is used.
- [x]  Browser can access WordPress through HTTPS.
- [x]  NGINX forwards PHP requests to WordPress.
- [x]  NGINX is the only public entry point.

## More Feature & Service Verification Tests

The following tests verify that all project requirements function correctly and comply with the evaluation checklist.

### 🐬 1. MariaDB Tests

1. **MariaDB container builds successfully:**
   - **Command:** `docker compose -f srcs/docker-compose.yml build mariadb`
   - **Description:** Builds the MariaDB Docker image from its custom Dockerfile using Debian Bookworm.
2. **MariaDB container starts successfully:**
   - **Command:** `docker compose -f srcs/docker-compose.yml up -d mariadb && docker ps -f name=mariadb`
   - **Description:** Starts the container in detached mode and confirms its status is `Up`.
3. **Database is created (`SHOW DATABASES;`):**
   - **Command:** `docker exec -it mariadb mariadb -u root -p -e "SHOW DATABASES;"`
   - **Description:** Queries the MariaDB server to confirm `wordpress_db` was automatically created on initialization.
4. **User is created:**
   - **Command:** `docker exec -it mariadb mariadb -u root -p -e "SELECT User, Host FROM mysql.user;"`
   - **Description:** Confirms the dedicated database user (`wp_user@'%'`) exists and can connect from any network host.
5. **Passwords are not hardcoded:**
   - **Command:** `grep -rnE "password|MYSQL_ROOT_PASSWORD|MYSQL_PASSWORD" srcs/requirements/mariadb/Dockerfile srcs/requirements/mariadb/conf/`
   - **Description:** Verifies that no plaintext passwords exist in the MariaDB Dockerfile or configuration files.
6. **Data persists after container restart:**
   - **Command:** `docker exec -it mariadb mariadb -u root -p -e "CREATE TABLE wordpress_db.test_persist (id INT);"; make stop; make start; docker exec -it mariadb mariadb -u root -p -e "SHOW TABLES IN wordpress_db;"`
   - **Description:** Creates a test table, stops and restarts the stack, and verifies the table remains intact.
7. **Container uses named volume:**
   - **Command:** `docker volume ls`
   - **Description:** Confirms that `srcs_mariadb_data` is registered and managed by the Docker volume subsystem.
8. **Container does not use bind mount for database data:**
   - **Command:** `docker inspect mariadb --format '{{json .Mounts}}'`
   - **Description:** Inspects container mounts to confirm `"Type": "volume"` is used for `/var/lib/mysql` instead of `"Type": "bind"`.

---

### 📝 2. WordPress + PHP-FPM Tests

1. **WordPress image builds:**
   - **Command:** `docker compose -f srcs/docker-compose.yml build wordpress`
   - **Description:** Builds the WordPress/PHP-FPM image from `srcs/requirements/wordpress/Dockerfile`.
2. **WordPress container starts:**
   - **Command:** `docker compose -f srcs/docker-compose.yml up -d wordpress && docker ps -f name=wordpress`
   - **Description:** Launches the WordPress container and verifies the PHP-FPM process is running in the foreground.
3. **WordPress connects to MariaDB:**
   - **Command:** `docker logs wordpress | grep -i "MariaDB is ready"`
   - **Description:** Checks startup logs to verify the network ping loop successfully connected to MariaDB on port 3306.
4. **WordPress database tables are created:**
   - **Command:** `docker exec -it mariadb mariadb -u wp_user -p -e "SHOW TABLES IN wordpress_db;"`
   - **Description:** Verifies that `wp-cli` populated the database with standard WordPress tables (`wp_posts`, `wp_users`, etc.).
5. **WordPress files are stored in the named volume:**
   - **Command:** `docker inspect wordpress --format '{{json .Mounts}}' && ls -la /home/tszymans/data/wordpress`
   - **Description:** Verifies that the website files volume is of type `"volume"` and persists data at `/home/tszymans/data/wordpress`.
6. **WordPress has two users:**
   - **Command:** `docker exec -it wordpress wp user list --allow-root --path=/var/www/html`
   - **Description:** Lists WordPress users to confirm both the administrator and a regular second user are registered.
7. **Administrator username is valid:**
   - **Command:** `docker exec -it wordpress wp user list --role=administrator --field=user_login --allow-root --path=/var/www/html`
   - **Description:** Verifies that the admin username complies with 42 rules by not containing the words `admin` or `administrator`.
8. **No NGINX exists inside WordPress container:**
   - **Command:** `docker exec -it wordpress which nginx || echo "No NGINX found in WordPress container (Passed)"`
   - **Description:** Confirms that NGINX is not installed inside the WordPress container, ensuring strict separation of concerns.

---

### 🌐 3. NGINX Tests

1. **NGINX image builds:**
   - **Command:** `docker compose -f srcs/docker-compose.yml build nginx`
   - **Description:** Builds the custom NGINX image from `srcs/requirements/nginx/Dockerfile`.
2. **NGINX container starts:**
   - **Command:** `docker compose -f srcs/docker-compose.yml up -d nginx && docker ps -f name=nginx`
   - **Description:** Launches the NGINX container and verifies it runs with `daemon off;` as PID 1.
3. **Only port `443` is exposed:**
   - **Command:** `curl -I http://tszymans.42.fr`
   - **Description:** Confirms that HTTP port 80 connections are refused and only port 443 is published to the host.
4. **TLS works:**
   - **Command:** `curl -k -I https://tszymans.42.fr`
   - **Description:** Sends an HTTPS request and verifies a successful `HTTP/1.1 200 OK` response from the web server.
5. **TLSv1.2 or TLSv1.3 is used:**
   - **Command:** `openssl s_client -connect tszymans.42.fr:443 -tls1_2 < /dev/null && openssl s_client -connect tszymans.42.fr:443 -tls1_3 < /dev/null`
   - **Description:** Verifies that TLS 1.2 and 1.3 handshakes succeed while insecure legacy protocols (TLS 1.0, 1.1) are rejected.
6. **Browser can access WordPress through HTTPS:**
   - **Command:** `curl -k -s https://tszymans.42.fr | grep -i "<title>"`
   - **Description:** Confirms the WordPress HTML page title renders properly through HTTPS.
7. **NGINX forwards PHP requests to WordPress:**
   - **Command:** `docker logs nginx | tail -n 5`
   - **Description:** Inspects NGINX access logs to confirm that requests to `index.php` are proxied to `wordpress:9000` via FastCGI.
8. **NGINX is the only public entry point:**
   - **Command:** `docker ps --format "table {{.Names}}\t{{.Ports}}"`
   - **Description:** Verifies that only the `nginx` container publishes host ports (`443:443`), while database and PHP-FPM ports remain private.
