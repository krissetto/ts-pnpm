# syntax=docker/dockerfile:1

# Define build arguments for Node.js and pnpm versions
ARG NODE_VERSION=22.14.0
ARG PNPM_VERSION=10.4.1

# Base development image
FROM node:${NODE_VERSION} AS base

# Update Corepack to the latest version
RUN --mount=type=cache,target=/root/.npm \
    npm install --global corepack@latest

# Enable and prepare pnpm
RUN corepack enable && corepack prepare pnpm@${PNPM_VERSION} --activate

# Set working directory
WORKDIR /app

# Builder stage for compiling TypeScript
FROM base AS builder

# Copy package manager files
COPY --link package.json pnpm-lock.yaml ./

# Configure pnpm cache directory
ENV PNPM_HOME=/root/.local/share/pnpm
ENV PATH=$PNPM_HOME:$PATH
ENV PNPM_STORE_DIR=/root/.pnpm-store

# Install dependencies
RUN --mount=type=cache,target=${PNPM_STORE_DIR} \
    pnpm install --frozen-lockfile

# Copy source files
COPY --link tsconfig.json ./
COPY --link src ./src

# Build the TypeScript project
RUN pnpm run build

# Production stage with minimal image
FROM node:${NODE_VERSION}-slim AS final

# Enable and prepare pnpm
RUN corepack enable && corepack prepare pnpm@${PNPM_VERSION} --activate

# Set working directory
WORKDIR /app

# Copy necessary files from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules

# Set environment to production
ENV NODE_ENV=production

# Expose application port
EXPOSE 4032

# Define the command to run the application
CMD ["node", "dist/index.js"]