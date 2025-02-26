# Running the Project with Docker

This section provides instructions for setting up and running the project using Docker.

## Requirements

- Docker version 20.10 or higher
- Docker Compose version 1.29 or higher

## Environment Variables

- Ensure any required environment variables are defined in a `.env` file or directly in the Docker Compose file. Uncomment the `env_file` line in the Compose file if using a `.env` file.

## Build and Run Instructions

1. Build the Docker image:
   ```bash
   docker-compose build
   ```
2. Start the application:
   ```bash
   docker-compose up
   ```

## Configuration

- The application listens on port `4032`. Ensure this port is available on your host machine.
- Modify the `docker-compose.yml` file to adjust configurations as needed.

## Exposed Ports

- `4032:4032` (application service)

Follow these steps to successfully run the project using Docker. For further details, refer to the provided Dockerfiles and Compose file.