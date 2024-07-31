# Adminer docker container

![GitHub action workflow status](https://github.com/AgorastisMesaio/docker-img-guacd/actions/workflows/docker-publish.yml/badge.svg)

This repository contains a `Dockerfile` aimed to create a *base image* to provide a dockerized Guacd service. Guacd is a remote desktop gateway component used by the Apache Guacamole project. It is responsible for managing remote desktop connections and translating them into a format that Guacamole clients can use. Guacd acts as a proxy between the Guacamole client and remote desktops, supporting protocols such as RDP, VNC, and SSH.

## Use Cases

When used as a Docker container, Guacd provides several benefits and use cases:

- **Remote Desktop Access**:
  - Allows users to access remote desktops through a web browser without needing client-side software.
  - Supports multiple protocols like RDP, VNC, and SSH, enabling access to a variety of systems.

- **Centralized Management**:
  - Simplifies the management of remote desktop connections by centralizing them in a single gateway.
  - Provides a unified interface for accessing different types of remote systems.

- **Scalability**:
  - Easily scalable by deploying multiple Guacd containers to handle increased loads.
  - Can be integrated with load balancers to distribute connections efficiently.

- **Security**:
  - Isolates remote desktop connections from the client environment, reducing security risks.
  - Supports secure communication protocols to protect data in transit.

- **Integration with Guacamole**:
  - Seamlessly integrates with the Guacamole web application to provide a complete remote desktop solution.
  - Can be used in combination with Guacamole to offer a full-featured remote access platform.

## Sample `docker-compose.yml`

This is an example where I'm running Guacd in a Docker container.

```yaml
### Docker Compose example
volumes:
  # Guacamole
  backend_drive:
    driver: local
  backend_record:
    driver: local
  postgres_data:
    driver: local
  frontend_drive:
    driver: local
  frontend_record:
    driver: local

networks:
  my_network:
    name: my_network
    driver: bridge

services:
  ct_guacd:
    image: ghcr.io/agorastismesaio/docker-img-guacd:main
    hostname: ct_guacd
    container_name: guacd
    restart: always
    ports:
      - 4822:4822
    volumes:
    - backend_drive:/drive
    - backend_record:/var/lib/guacamole/recordings
    networks:
      - my_network

  ct_frontend:
    image: ghcr.io/agorastismesaio/docker-img-guacamole:main
    hostname: guacamole
    container_name: ct_frontend
    restart: always
    environment:
      - GUACD_HOSTNAME=ct_guacd
      - POSTGRESQL_DATABASE=guacamole_db
      - POSTGRESQL_USER=guacamole
      - POSTGRESQL_PASSWORD=password
      - POSTGRESQL_HOSTNAME=postgres
      - POSTGRESQL_AUTO_CREATE_ACCOUNTS=true
    volumes:
    - frontend_drive:/drive
    - frontend_record:/var/lib/guacamole/recordings
    ports:
      - 8884:8080 # Default standard Guacamole frontend port
    networks:
      - my_network
    depends_on:
    - ct_guacd
    - ct_postgres

  ct_postgres:
    image: ghcr.io/agorastismesaio/docker-img-postgres:main
    hostname: postgres
    container_name: ct_postgres
    restart: always
    environment:
      - PGDATA=/var/lib/postgresql/data/guacamole
      - POSTGRES_DB=guacamole_db
      - POSTGRES_USER=guacamole
      - POSTGRES_PASSWORD=password
    networks:
      - my_network
    volumes:
    - ./dockerfiles/guacamole/initdb:/docker-entrypoint-initdb.d:ro
    - postgres_data:/var/lib/postgresql/data

  ct_other_container:
    :
```

- Start your services

```sh
docker compose up --build -d
```

## For developers

If you copy or fork this project to create your own base image.

### Building the Image

To build the Docker image, run the following command in the directory containing the Dockerfile:

```sh
docker build -t your-image/docker-img-guacd:main .
```
