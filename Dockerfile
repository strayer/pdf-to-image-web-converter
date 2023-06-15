FROM node:18.16.1 AS build

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# node-canvas build dependencies for arm64
RUN [ "$(arch)" == "aarch64" ] && apt-get update && \
    apt-get install -y build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev || true

RUN npm install -g pnpm

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install

COPY . .

RUN pnpm run build

# ---

FROM nginx:alpine-slim@sha256:4b66d0cb3c4d314ed566b1d3ba0b95b9cfbb7b811cbbd54dda6e432a8fe0d7e4

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/dist/ /usr/share/nginx/html/
