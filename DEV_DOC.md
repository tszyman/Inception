# Developer Documentation - Inception

## System Requirements & Prerequisites

- Linux OS (Debian/Ubuntu) or Windows WSL2.
- Docker Engine & Docker Compose V2 installed.
- OpenSSL and GNU Make installed on the host.

---

## Environment Setup from Scratch

1. **Clone Repository & Setup Secret Files:**
   Ensure secret password files exist in `secrets/`:

   ```bash
   mkdir -p secrets
   echo "rootpass123" > secrets/db_root_password.txt
   echo "userpass123" > secrets/db_password.txt
   echo "adminpass123" > secrets/wp_admin_password.txt
   ```

2. **Configure Local Host Resolution:**
   Add domain mapping to `/etc/hosts` on your host machine:

   ```text
   127.0.0.1   tszymans.42.fr
   ```

3. **Verify Environment Variables File (`srcs/.env`):**
   Check that `srcs/.env` specifies your domain name (`tszymans.42.fr`) and database parameters.

---

## Building and Launching

Build container images from custom Dockerfiles and launch containers in detached mode:

```bash
make
```

To stop containers and remove volumes/networks:

```bash
make clean
```

For a full purge of images, volumes, and host data directories:

```bash
make fclean
```

---

## Developer Useful Commands

- **Inspect Container Logs:**

  ```bash
  docker compose -f srcs/docker-compose.yml logs -f [nginx|wordpress|mariadb]

  docker logs [mariadb|wordpress|nginx]
  ```

- **Interactive Shell in Container:**

  ```bash
  docker exec -it wordpress bash
  ```

- **Inspect Database Contents:**

  ```bash
  docker exec -it mariadb mysql -u root -p
  ```

- **Inspect Named Volumes:**

  ```bash
  docker volume inspect srcs_wordpress_files
  docker volume inspect srcs_mariadb_data
  ```

---

## Data Persistence & Storage Architecture

Data persistence is implemented via **Docker Named Volumes** mapped to host paths using local bind-mount options:

- MariaDB Database files: `/home/tszymans/data/mariadb` $\rightarrow$ Container `/var/lib/mysql`
- WordPress Website files: `/home/tszymans/data/wordpress` $\rightarrow$ Container `/var/www/html`
