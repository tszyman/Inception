_This project has been created as part of the 42 curriculum by tszymans._

# Inception

## Description

Inception is a system administration project focused on virtualization and containerization using **Docker** and **Docker Compose**. The goal is to set up a small, fully functional, multi-container infrastructure featuring **NGINX** (with TLS v1.2/v1.3), **WordPress** (with PHP-FPM), and **MariaDB**.

Each service runs isolated in its dedicated container built from custom Dockerfiles based on **Debian Bookworm** (penultimate stable version). Communication between containers is managed over a private Docker bridge network, and data persistence is ensured using Docker named volumes mapped to `/home/tszymans/data/`.

---

## Instructions

### Prerequisites

- Operating System: Linux (Debian/Ubuntu) or Windows with WSL2.
- Installed Tools: `docker`, `docker-compose` (or `docker compose`), `make`.
- Local Host Resolution: Add `127.0.0.1 tszymans.42.fr` to your `/etc/hosts` file.

### Usage

- **Build and start all services:**

  ```bash
  make
  ```

- **Stop services:**

  ```bash
  make stop
  ```

- **Tear down containers and networks:**

  ```bash
  make down
  ```

- **Full cleanup (containers, images, volumes, host data):**

  ```bash
  make fclean
  ```

- **Rebuilding everything from scratch:**

  ```bash
  make re
  ```

- **Access website:**
  Open `https://tszymans.42.fr` in your browser. (Accept self-signed certificate or type `thisisunsafe`).

---

## Technical Comparisons & Design Choices

### Virtual Machines vs. Docker Containers

- **Virtual Machines (VMs):** Emulate an entire hardware layer using a Hypervisor. Each VM runs a full guest operating system with its own kernel, resulting in high resource usage, large disk images, and slow boot times.
- **Docker Containers:** Share the host system's Linux kernel and use kernel features like **namespaces** (process/network isolation) and **cgroups** (resource limit enforcement). Containers are lightweight, start in seconds, and consume minimal RAM and CPU.

### Secrets vs. Environment Variables

- **Environment Variables (`.env`):** Used for non-sensitive configuration data (e.g., domain names, database names, usernames). They can be inspected via `docker inspect` or environment listings.
- **Docker Secrets (`secrets/`):** Mount sensitive credentials (passwords, API keys) into containers as secure files at `/run/secrets/`. This prevents credentials from leaking into process environment lists, Dockerfiles, or Git repositories.

### Docker Network vs. Host Network

- **Host Network (`network: host`):** The container shares the host's networking namespace directly, bypassing Docker's network isolation. (Forbidden in this project).
- **Docker Network (Custom Bridge):** Creates an isolated virtual bridge network. Containers communicate securely using service names (e.g., `wordpress:9000`, `mariadb:3306`) resolved by Docker's internal DNS server without exposing internal database or FastCGI ports to the host.

### Docker Volumes vs. Bind Mounts

- **Bind Mounts:** Directly map a specific file or folder on the host filesystem into a container.
- **Docker Named Volumes:** Managed by the Docker daemon lifecycle. In this project, named volumes are configured using local driver options (`driver_opts` with `o: bind`) to securely map container persistence paths directly to `/home/tszymans/data/mariadb` and `/home/tszymans/data/wordpress`.

---

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Specification](https://docs.docker.com/compose/)
- [NGINX Documentation & SSL Setup](https://nginx.org/en/docs/)
- [WordPress CLI Documentation](https://developer.wordpress.org/cli/commands/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)

## AI usage

AI has been used to clarify the goals of the project as well as to explain several issues regarding configuration such as:

- Structuring project documentation and Obsidian study guides.
- Reviewing Dockerfile best practices and PID 1 foreground execution options.
- Verifying FastCGI PHP-FPM configuration parameters and shell script error handling.
