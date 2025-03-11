# Running the Project with Docker

This section provides instructions for setting up and running the project using Docker.

## Prerequisites

- Ensure Docker and Docker Compose are installed on your system.
- The project requires the following versions:
  - Node.js: `22.14.0`
  - pnpm: `10.4.1`

## Setup Instructions

1. **Build the Docker Image**

   Run the following command to build the Docker image:

   ```bash
   docker-compose build
   ```

2. **Run the Application**

   Start the application using Docker Compose:

   ```bash
   docker-compose up
   ```

   The application will be accessible at `http://localhost:4032`.

## Configuration

- The application exposes port `4032`.
- If an `.env` file is present, uncomment the `env_file` line in the `docker-compose.yml` file to load environment variables.

## Notes

- The Docker setup uses a multi-stage build process to optimize the image size.
- The `NODE_ENV` is set to `production` in the final image.

For further details, refer to the Dockerfile and `docker-compose.yml` file included in the project.