# Lego Docker

[![Docker Pulls](https://img.shields.io/docker/pulls/tuzelko/lego)](https://hub.docker.com/r/yourusername/lego-docker)
[![License](https://img.shields.io/github/license/tuzelko/lego-docker)](LICENSE)

A Docker solution for managing [Let's Encrypt](https://letsencrypt.org/) SSL/TLS certificates using the [Lego](https://github.com/go-acme/lego) client. Designed to run as a background service with automatic renewal and minimal configuration.

## Why Lego Docker?

- 🚀 **Zero-downtime renewals** – Certificates are renewed in the background without interrupting your services.
- 🔌 **Pluggable DNS providers** – Supports 100+ DNS providers (Cloudflare, Route53, Gandi, etc.) for wildcard certificates.
- 📦 **Containerised** – Run it anywhere Docker runs, with consistent behavior across environments.
- 🔁 **Automatic renewal loop** – Checks for expiration daily and renews certificates when needed.

## Prerequisites

- Docker (≥ 20.10)
- Docker Compose (≥ 2.0) or Docker Engine with `docker compose` plugin

## Quick Start

### 1. Configure the Service

Download the [`docker-compose.yml`](examples/docker-compose.yml) file and place it in a convenient location on your disk.

Edit the file to set the required environment variables:

- `LEGO_ADMIN_EMAIL` – Your email address (used for Let's Encrypt account registration and expiry notifications).
- `LEGO_DNS_PROVIDER` – Your DNS provider (e.g., `cloudflare`, `route53`, `gandi`).

You must also provide credentials for your chosen DNS provider. These are passed as environment variables – refer to the [Lego DNS provider documentation](https://go-acme.github.io/lego/dns/index.html) for details (e.g., `CLOUDFLARE_EMAIL`, `CLOUDFLARE_API_KEY`).

### 2. Start the Service

```bash
docker compose up -d
```

### 3. Obtain a Certificate

```bash
docker compose exec app certctl new --domain="example.com" --domain="*.example.com"
```

### 4. Stop the Service

```bash
docker compose down
```

### 5. Stop and Remove Certificates

```bash
docker compose down -v
```

This deletes the Docker volume containing certificates and keys – use with caution.

## Configuration Reference

| Variable | Description |
|----------|-------------|
| `LEGO_ADMIN_EMAIL` | Email for Let's Encrypt registration (required). |
| `LEGO_DNS_PROVIDER` | DNS provider name (required). |
| `LEGO_ACCEPT_TOS` | Automatically accept Let's Encrypt terms of service (required) – set to `true`. |

DNS provider credentials are passed as separate environment variables according to Lego’s requirements (e.g., `CLOUDFLARE_EMAIL`, `CLOUDFLARE_API_KEY`).

## Advanced Usage

### Using with Nginx / Traefik

Mount the certificate volume to your reverse proxy container. Example snippet for Nginx:

```yaml
volumes:
  lego-certs:
    name: "certs_global_storage" # or set your...
    driver: local

services:
  nginx:
    image: nginx:alpine
    volumes:
      - lego-certs:/etc/nginx/certs:ro
```

### Debugging

Run the container in foreground mode to see live logs:

```bash
docker compose up
```

Or check logs of the running container:

```bash
docker compose logs -f
```

## Development & Debugging

A `Makefile` is included for developers. It simplifies building and managing the container.

### Available Make Commands

- `make init` – Prepare the environment.
- `make clean` – Remove unused Docker resources.
- `make pull` – Pull base images.
- `make build` – Build the Lego Docker image.
- `make push` – Push the built image to a registry.
- `make up` – Start the service.
- `make down` – Stop the service.
- `make down-with-volumes` – Stop the service and delete volumes.
- `make restart` – Restart the service.

## License

This project is licensed under [MIT license](LICENSE).

---

**Maintainer**: [Eugene Frost](https://github.com/tuzelko)
**Repository**: [GitHub](https://github.com/tuzelko/lego-docker)
**Registry**: [Docker HUB](https://hub.docker.com/r/tuzelko/lego)

♥️ Issues and pull requests are welcome!