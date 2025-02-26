# syntax=docker/dockerfile:1

# Define build arguments for Node.js and pnpm versions
ARG NODE_VERSION=22.14.0
ARG PNPM_VERSION=10.4.1

# Base development image
FROM node:${NODE_VERSION} AS base
RUN --mount=type=cache,target=/root/.npm     npm install --global corepack@latest
RUN corepack enable && corepack prepare pnpm@${PNPM_VERSION} --activate
WORKDIR /app

# Builder stage for compiling TypeScript
FROM base AS builder
WORKDIR /app
COPY --link package.json pnpm-lock.yaml ./
ENV PNPM_HOME=/root/.local/share/pnpm
ENV PATH=$PNPM_HOME:$PATH
ENV PNPM_STORE_DIR=/root/.pnpm-store
RUN --mount=type=cache,target=${PNPM_STORE_DIR}     pnpm install --frozen-lockfile
COPY --link tsconfig.json ./
COPY --link src ./src
RUN pnpm run build

# Production stage with minimal image
FROM node:${NODE_VERSION}-slim AS final
RUN --mount=type=cache,target=/root/.npm     npm install --global corepack@latest
RUN corepack enable && corepack prepare pnpm@${PNPM_VERSION} --activate
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 4032
CMD ["node", "dist/index.js"]